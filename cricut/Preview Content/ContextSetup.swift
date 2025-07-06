//
//  CircuitBreaker.swift
//  cricut
//
//  Created by Zhen Wang on 7/5/25.
//

import SwiftData

@MainActor func getContainer() -> ModelContainer {
  let schema = Schema([
    Shape.self,
    CacheButton.self
  ])
  let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

  return try! ModelContainer(for: schema, configurations: [modelConfiguration])
}

@MainActor func getCircuitBreaker() -> CircuitBreaker {
  let container = getContainer()
  let circuitBreaker = CircuitBreaker(context: container.mainContext,
                                      isPreview: true)
  return circuitBreaker
}
