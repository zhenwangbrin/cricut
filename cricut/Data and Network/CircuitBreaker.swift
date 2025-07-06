//
//  ShapeCircuitBreaker.swift
//  cricut
//
//  Created by Zhen Wang on 7/3/25.
//

import SwiftData
import Foundation

let CACHE_LIVE_TIME = 2
let RETRY_TIMEOUT = 3

class CircuitBreaker {
  private var context: ModelContext

  private var buttonProviders: [Providable] = []
  private var shapeProviders: [Providable] = []

  private var isPreview: Bool = false

  init(context: ModelContext, isPreview: Bool = false) {
    self.isPreview = isPreview
    self.context = context
    try? self.createShapeProviders()
    try? self.createShapeButtonProviders()
  }

  // TODO: convert to provider factorys
  // create button and shape providers
  func createShapeButtonProviders() throws {
    buttonProviders.append(ShapeButtonCacheProvider(context: context))
    buttonProviders.append(ShapeButtonNetworkDataProvider(context: context))
    buttonProviders.append(PreviewShapeButtonDataProvider())
  }

  func createShapeProviders() throws {
    shapeProviders.append(ShapeDataProvider(context: context))
    shapeProviders.append(PreviewShapeDataProvider(context: context))
  }

  // go through each provider in order and circuit breaks based on current provider's info saved.
  // we will not advance if there are more retry left on the current provider

  // buttons
  func fetchButtons() async throws -> [Button]? {
    return try await executeDataAction(providers: buttonProviders,
                               input:ProviderInput(action:.fetch)).buttons
  }

  // shapes
  func fetchShapes(shapeName: String?) async throws -> [Shape]? {
    return try await executeDataAction(providers: shapeProviders,
                                       input:ProviderInput(action:.fetch,
                                                           shape: shapeName == nil ? nil : Shape(name: shapeName!, path: ""))).shapes
  }

  func addShape(shape: Shape) async throws -> Bool {
    return try await executeDataAction(providers:shapeProviders,
                                       input: ProviderInput(action: .add, shape: shape)).success
  }

  func deleteAllShapes(shapeName: String?) async throws -> Bool {
    return try await executeDataAction(providers:shapeProviders,
                                       input: ProviderInput(action: .deleteAll,
                                                            shape: shapeName == nil ? nil : Shape(name: shapeName!, path: ""))).success
  }

  func deleteShape(shape: Shape) async throws -> Bool {
    return try await executeDataAction(providers:shapeProviders,
                                       input: ProviderInput(action: .delete,
                                                            shape: shape)).success
  }

  func executeDataAction(providers: [Providable],
                         input: ProviderInput) async throws -> ProviderOutput {
    var output = ProviderOutput()
    var providerIndex = 0
    while providerIndex < providers.count {
      // check if we should use this provider
      // we always try to use the cache provider first, we will use cache only if:
      // 1. cache is not empty
      // 2. first success time, in context of cache is the cache entry date, is not more earlier than the timeout length from now.
      // 3. not corrupt and able to be used by the consumer
      // 4. we are not in preview
      // then we try to use network provider
      // 1. we are able to get data from network
      // 2. we will not advance if there are still more retries on the provider info and we failed. once success or third try was
      //    reached, we will reset retries, either return data or advance to next provider.
      // 3. we are not in preview
      // then we try to use json preview data
      // 1. this should always end up in success, we will fail and deny entry to the app if this critical provider fails to load.
      //
      // these boil down to:
      // 1. if we in preview mode, pass through if we are not looking at preview provider, if we are preview, try to get data
      //    return success or fail and end
      // 2. check we are able to get data, if success return and reset retries.
      // 3. if failed check if there no retries left once we are out of retries, we will reset retries and advances
      let provider = providers[providerIndex]
      // check for preview
      if ((isPreview || provider.isDataDirty()) && providerIndex < providers.count - 1)  {
        providerIndex += 1
        continue;
      }

      // trying to get data use provider
      // TODO: simpler way to keep track of caching is to try to add a version key on the backend json return.
      //  example: {buttons: [], version: 2.0.1}  if version mismatch the local version, it will try a fresh copy from network.
      // currently it's dumping network data every 2 minutes saved for buttons
      // TODO: make retry loop for a single launch instead of falling back to preview data on fails and retry on next launch.
      let retries = type(of: provider).retries()

      // check retry
      for retry in 0..<retries {
        // get data
        output = try await provider.executeProviderAction(input: input)
        // if we successful got the data return
        if output.success {
          return output
        }
        // if fail, retry if we have more after a timeout
        if (retry < retries - 1) {
          try? await Task.sleep(for: .seconds(RETRY_TIMEOUT))
        }
      }
      
      providerIndex += 1
    }
    return output
  }
}
