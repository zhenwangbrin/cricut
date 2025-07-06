//
//  ShapeButtonDataBaseProvider.swift
//  cricut
//
//  Created by Zhen Wang on 7/3/25.
//

import Foundation

class ShapeButtonDataBaseProvider: ShapeButtonBaseProvider {
  var buttons: [Button] = []
  var error: Error?

  var serviceErrorCode : ShapeButtonServiceError = .unknown

  // for testability we allow direct setting of json
  func decodeButtons(jsonData: Data) {
    let decoder = JSONDecoder()
    print(String(decoding: jsonData, as: UTF8.self))
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    do {
      let result = try decoder.decode(Buttons.self, from: jsonData)
      DispatchQueue.main.async {
        self.buttons = result.buttons
      }
    }
    catch {
      updateButtonStatus(buttonStatus: .failed)
      self.serviceErrorCode = .decodingFailed
      self.error = error
    }
  }

  func readData() async throws {
  }

  func fetchButtonsAsync() async {
    await MainActor.run {
      if self.buttonStatus == .new {
        updateButtonStatus(buttonStatus: .downloading)
      }
    }

    do {
      // set url, guard used incase future change of url string.
      if buttonStatus != .downloaded {
        try await readData()
      }
    } catch {
      // set status to failed and return early
      updateButtonStatus(buttonStatus: .failed)
      self.serviceErrorCode = .networkError
      self.error = error
      return
    }

    await MainActor.run {
      updateButtonStatus(buttonStatus: .downloaded)
    }
  }
}
