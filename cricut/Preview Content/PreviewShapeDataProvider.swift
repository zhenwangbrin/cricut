//
//  PreviewShapes.swift
//  cricut
//
//  Created by Zhen Wang on 7/3/25.
//

import Foundation
import SwiftData

final class PreviewShapeDataProvider: ShapeDataProvider {
  override class func retries() -> Int {
    return 1
  }

  override class func getProviderName() -> String {
    return "ShapeButtonProvider"
  }

  override func fetch(input: ProviderInput) async throws -> ProviderOutput {
    let shapeName = input.shape?.name
    let shapes = [
      Shape(name: "Circle", path: "circle"),
      Shape(name: "Square", path: "square"),
      Shape(name: "Triangle", path: "triangle"),
      Shape(name: "Oval", path: "oval"),
      Shape(name: "Star", path: "star"),
      Shape(name: "Circle", path: "circle"),
      Shape(name: "Circle", path: "circle")
    ].filter {
      shapeName == nil || $0.name == shapeName
    }
    return ProviderOutput(shapes: shapes, success: true)
  }

  override func add(shape: Shape) throws -> ProviderOutput {
    return ProviderOutput(success: true)
  }

  override func deleteAll(shape: Shape?) throws -> ProviderOutput  {
    return ProviderOutput(success: true)
  }

  override func delete(shape: Shape) throws -> ProviderOutput {
    return ProviderOutput(success: true)
  }
}
