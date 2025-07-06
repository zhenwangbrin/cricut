//
//  ProviderInfoProvider.swift
//  cricut
//
//  Created by Zhen Wang on 7/4/25.
//

import Foundation
import SwiftData

public class ProviderInfoProvider {
  private var context: ModelContext
  private var providerInfoCache = [String: ProviderInfo]()

  init(context: ModelContext) {
    self.context = context
    try? initProviderInfos()
  }

  func getProviderInfo(_ providerName: String) throws -> ProviderInfo? {
    return providerInfoCache[providerName]
  }

  func updateProviderInfo(_ providerInfo: ProviderInfo) throws {
    self.context.insert(providerInfo)
    providerInfoCache[providerInfo.name] = providerInfo
    try context.save()
  }

  func addProviderInfo(_ providerInfo: ProviderInfo) throws {
    self.context.insert(providerInfo)
    try self.context.save()
  }

  func initProviderInfos() throws {
    let providerInfos = try context.fetch(FetchDescriptor<ProviderInfo>())
    for providerInfo in providerInfos {
      providerInfoCache[providerInfo.name] = providerInfo
    }
  }

  func clearProviderInfos(_ providerName: String) throws {
    try self.context.delete(model: ProviderInfo.self, where: #Predicate { $0.name == providerName})
  }
}
