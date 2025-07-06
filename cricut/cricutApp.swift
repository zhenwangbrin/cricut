//
//  cricutApp.swift
//  cricut
//
//  Created by Zhen Wang on 7/3/25.
//

import SwiftUI
import SwiftData

@main
struct cricutApp: App {
  var shapeModelContainer: ModelContainer = {
    let schema = Schema([
      Shape.self,
      ProviderInfo.self,
      CacheButton.self
    ])
    let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

    // TODO: create UI feedback for model critical error
    guard let modelContainer = try? ModelContainer(for: schema, configurations: [modelConfiguration]) else {
      fatalError("Could not create ModelContainer")
    }
    return modelContainer
  }()

  var body: some Scene {
    WindowGroup {
      ContentView(circuitBreaker: CircuitBreaker(context: shapeModelContainer.mainContext))
    }
  }
}
