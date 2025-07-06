//
//  ShapeDataProvider.swift
//  cricut
//
//  Created by Zhen Wang on 7/3/25.
//
import SwiftData
import Foundation

class ShapeDataProvider: Providable {
  func executeProviderAction(input: ProviderInput) async throws -> ProviderOutput {
    switch input.action {
    case .fetch:
      return try await fetch(input: input)
    case .add:
      if input.shape == nil {
        fatalError("Shape must not be nil")
      }
      return try add(shape: input.shape!)
    case .delete:
      if input.shape == nil {
        fatalError("Shape must not be nil")
      }
      return try delete(shape: input.shape!)
    case .deleteAll:
      return try deleteAll(shape: input.shape)
    }
  }

  class func retries() -> Int {
    return 1
  }
  
  class func getProviderName() -> String {
    return "ShapeDataProvider"
  }
  
  private var context: ModelContext

  init(context: ModelContext) {
    self.context = context
  }

  private func getFilter(_ shapeName: String?) -> FetchDescriptor<Shape> {
    // if not circle only return empty descriptor
    if shapeName == nil {
      return FetchDescriptor<Shape>()
    }

    let circleFilter = FetchDescriptor<Shape>(
      predicate: #Predicate {
        shapeName == nil || $0.name == shapeName!
      }
    )
    return circleFilter
  }

  func fetch(input: ProviderInput) async throws -> ProviderOutput {
    do {
      let shapes = try context.fetch(getFilter(input.shape?.name))
      return ProviderOutput(shapes: shapes, success: true)
    }
    catch {
      return ProviderOutput(success: false)
    }
  }

  func add(shape: Shape) throws -> ProviderOutput {
    try noReturnWrapper {
      context.insert(shape)
      try context.save()
    }
  }

  func deleteAll(shape: Shape?) throws -> ProviderOutput {
    try noReturnWrapper {
      if shape == nil {
        try context.delete(model: Shape.self)
      }
      else {
        let name = shape!.name
        try context.delete(model: Shape.self, where: #Predicate { $0.name == name })
      }
    }
  }

  func delete(shape: Shape) throws -> ProviderOutput {
    try noReturnWrapper {
      context.delete(shape)
      try context.save()
    }
  }

  func noReturnWrapper(action: () throws -> Void) throws -> ProviderOutput {
    do {
      try action()
      return ProviderOutput(success: true)
    } catch {
      return ProviderOutput(success: false)
    }
  }

  func isDataDirty() -> Bool {
    return false
  }
}
