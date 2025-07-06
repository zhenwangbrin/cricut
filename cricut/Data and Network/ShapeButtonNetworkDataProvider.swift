//
//  ShapeButtonService.swift
//  cricut
//
//  Created by Zhen Wang on 7/3/25.
//
import Foundation
import SwiftData

final class ShapeButtonNetworkDataProvider: ShapeButtonDataBaseProvider {
  private var context: ModelContext
  private let providerInfoProvider: ProviderInfoProvider

  init(context: ModelContext) {
    self.context = context
    self.providerInfoProvider = ProviderInfoProvider(context: context)
  }

  override func readData() async throws {
    guard let url = URL(string: "https://staticcontent.cricut.com/static/test/shapes_001.json") else {
      updateButtonStatus(buttonStatus: .failed)
      self.serviceErrorCode = .invalidURL
      self.error = NSError(domain: "Invalid URL", code: 0, userInfo: nil)
      return
    }

    // fetch and decode data
    do {
      let (data, _) = try await URLSession.shared.data(from: url)
      decodeButtons(jsonData: data)

      // caching the buttons
      for button in buttons {
        context.insert(CacheButton(name: button.name, path: button.drawPath))
      }
      try context.save()
    }
    catch {
      updateButtonStatus(buttonStatus: .failed)
      self.serviceErrorCode = .networkError
      self.error = error as NSError
    }
  }

  override func fetchData(input: ProviderInput) async throws -> ProviderOutput {
    if self.buttonStatus == .new {
      let providerInfo = ProviderInfo(name: ShapeButtonNetworkDataProvider.getProviderName(), successTime: Date())
      await self.fetchButtonsAsync()
      try providerInfoProvider.addProviderInfo(providerInfo)
      return  ProviderOutput(buttons:self.buttons, success:true)
    }
    return ProviderOutput(buttons: nil, success: false)
  }
}
