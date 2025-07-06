//
//  ShapeButtonBaseProvider.swift
//  cricut
//
//  Created by Zhen Wang on 7/4/25.
//

import Foundation
import SwiftData

enum ShapeButtonServiceError {
  case invalidURL
  case decodingFailed
  case networkError
  case unknown
}

let SHAPE_BUTTON_PROVIDER_NAME = "ShapeButtonProvider"

class ShapeButtonBaseProvider: Providable {
  var buttonViewModelObservers: [any ButtonViewModelObserver]?

  var buttonStatus: ShapeButtonServiceStatus = .new

  init() {
    buttonViewModelObservers = [ButtonViewModelObserver]()
  }

  /// The subscription management methods for updating button status between the
  /// provider and the viewmodels
  func attach(_ observer: ButtonViewModelObserver) {
    buttonViewModelObservers?.append(observer)
  }

  func detach(_ observer: ButtonViewModelObserver) {
    if let idx = buttonViewModelObservers?.firstIndex(where: { $0 === observer }) {
      buttonViewModelObservers?.remove(at: idx)
    }
  }

  func updateButtonStatus(buttonStatus: ShapeButtonServiceStatus) {
    self.buttonStatus = buttonStatus
    buttonViewModelObservers?.forEach({ $0.buttonStatusDidChange(buttonStatus)})
  }

  func fetchData(input: ProviderInput) async throws -> ProviderOutput {
    return ProviderOutput(success: true)
  }

  func executeProviderAction(input: ProviderInput) async throws -> ProviderOutput {
      var output = ProviderOutput()
      switch input.action {
      case .fetch:
        return try await fetchData(input: input)
      default:
        output.success = true
      }
      return output
  }

  func isDataDirty() -> Bool {
    return false
  }

  class func getProviderName() -> String {
    return SHAPE_BUTTON_PROVIDER_NAME
  }

  class func retries() -> Int {
    return 1
  }
}
