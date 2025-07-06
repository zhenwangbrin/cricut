//
//  ButtonViewModel.swift
//  cricut
//
//  Created by Zhen Wang on 7/3/25.
//

import Foundation
import SwiftData

enum DataStatus {
  case new
  case downloading
  case downloaded
  case failed
}

@Observable
final class ButtonsViewModel:ObservableObject {
  private let circuitBreaker: CircuitBreaker
  var dataStatus: DataStatus

  var buttons: [Button]

  init(circuitBreaker: CircuitBreaker) {
    self.buttons = []
    self.circuitBreaker = circuitBreaker
    self.dataStatus = .new
  }

  func getShapeOfName(name: String) -> Shape? {
    for button in buttons {
      if button.name == name {
        return Shape(name: button.name, path: button.drawPath)
      }
    }
    return nil
  }

  func fetchButtons() {
    self.dataStatus = .downloading
    Task {
      do {
        self.buttons = try await circuitBreaker.fetchButtons() ?? []
        self.dataStatus = .downloaded
      }
      catch {
        // TODO: handle error and return feedback to UI
        print("failed to fetch shapes: \(error)")
        self.buttons = []
        self.dataStatus = .failed
      }
    }
  }
}
