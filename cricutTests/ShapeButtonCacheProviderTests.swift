//
//  ShapeButtonCacheProviderTest.swift
//  cricut
//
//  Created by Zhen Wang on 7/5/25.
//

import XCTest
import SwiftData

class ShapeButtonCacheProviderTests: XCTestCase  {

  @MainActor
  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    let container = try ModelContainer(for: CacheButton.self)
    try container.mainContext.delete(model: CacheButton.self)
  }

  @MainActor
  override func tearDownWithError() throws {
      // Put teardown code here. This method is called after the invocation of each test method in the class.
    let container = try ModelContainer(for: CacheButton.self)
    try container.mainContext.delete(model: CacheButton.self)
  }

  @MainActor
  func testDirtyCheck() async throws {
    let container = try ModelContainer(for: CacheButton.self)
    let provider = ShapeButtonCacheProvider(context: container.mainContext)

    // No cached info test
    XCTAssertTrue(provider.isDataDirty())

    // expire cached info test
    let providerInfoProvider = MockProviderInfoProvider(context: container.mainContext)
    let now = Date()
    var minutesBefore = Calendar.current.date(byAdding: .minute, value: -CACHE_EXPIRE_TIME - 1, to: now)!
    var provideInfo = ProviderInfo(name: type(of: provider).getProviderName(), successTime: minutesBefore)
    providerInfoProvider.mockProviderInfo = provideInfo
    provider.providerInfoProvider = providerInfoProvider
    XCTAssertTrue(provider.isDataDirty())

    // check clean cache info test
    minutesBefore = Calendar.current.date(byAdding: .minute, value: -CACHE_EXPIRE_TIME+1, to: now)!
    provideInfo = ProviderInfo(name: type(of: provider).getProviderName(), successTime: minutesBefore)
    providerInfoProvider.mockProviderInfo = provideInfo
    XCTAssertFalse(provider.isDataDirty())
  }

  @MainActor
  func testFetchData() async throws {
    // test empty
    let container = try ModelContainer(for: CacheButton.self)
    let provider = ShapeButtonCacheProvider(context: container.mainContext)
    var output = try await provider.fetchData(input: ProviderInput(action: .fetch))
    XCTAssertEqual(output.buttons?.count, 0)

    // test inserted 3
    container.mainContext.insert(CacheButton(name: "Cirle", path: "circle"))
    container.mainContext.insert(CacheButton(name: "Square", path: "square"))
    container.mainContext.insert(CacheButton(name: "Star", path: "star"))
    try container.mainContext.save()
    output = try await provider.fetchData(input: ProviderInput(action: .fetch))
    XCTAssertEqual(output.buttons?.count, 3)
  }
}
