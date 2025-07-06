//
//  ShapesViewModel.swift
//  cricut
//
//  Created by Zhen Wang on 7/3/25.
//

import Foundation
import SwiftData

@Observable
final class ShapesViewModel {
  var selectedShapeName: String?
  var circuitBreaker: CircuitBreaker

  var shapes: [Shape]

  init(selectedShapeName: String? = nil,
       circuitBreaker: CircuitBreaker) {
    self.selectedShapeName = selectedShapeName
    self.circuitBreaker = circuitBreaker
    self.shapes = []
  }

  func getShapes() async {
    do {
      self.shapes = try await circuitBreaker.fetchShapes(shapeName: selectedShapeName) ?? []
    }
    catch {
      // TODO: handle error and return feedback to UI
      print("failed to fetch shapes: \(error)")
      self.shapes = []
    }
  }

  func add(shape: Shape) async {
    do {
      let success = try await circuitBreaker.addShape(shape: shape)
      if !success { return }
      shapes.append(shape)
    }
    catch {
      // TODO: handle error and return feedback to UI
      print("failed to add shape: \(error)")
    }
  }

  func setSelectedShapeName(_ name: String?) {
    // don't do anything is query is the same
    if name == self.selectedShapeName { return }
    self.selectedShapeName = name
    Task {
      await self.getShapes()
    }
  }

  func clearAll() async {
      do {
        let success = try await circuitBreaker.deleteAllShapes(shapeName: selectedShapeName)
        if success {
          shapes = []
        }
      }
      catch {
        // TODO: display error on ui
        print("failed to delete all shapes: \(error)")
      }
  }

  func removeLast() async {
    do {
      let success = try await circuitBreaker.deleteShape(shape: shapes.last!)
      if success {
        shapes.removeLast()
      }
    }
    catch {
      print("failed to delete shape: \(error)")
    }
  }
}
