//
//  MockProviderInfoProvider.swift
//  cricut
//
//  Created by Zhen Wang on 7/5/25.
//
import Foundation
import SwiftData

class MockProviderInfoProvider: ProviderInfoProvider {
  var mockProviderInfo: ProviderInfo?

  override func getProviderInfo(_ providerName: String) throws -> ProviderInfo? {
    return mockProviderInfo
  }
}
