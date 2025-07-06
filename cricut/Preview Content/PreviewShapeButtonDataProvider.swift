//
//  PreviewShapeService.swift
//  cricut
//
//  Created by Zhen Wang on 7/3/25.
//
import Foundation

final class PreviewShapeButtonDataProvider: ShapeButtonDataBaseProvider {
  // read json from file
  override func readData() async throws {
    // incase we are calling this from debug when we don't want to fetch from network
    updateButtonStatus(buttonStatus: .downloading)


    let jsonUrl = Bundle.main.url(forResource: "sampleJSON", withExtension: "json")!
    do {
      let data = try Data(contentsOf: jsonUrl)
      decodeButtons(jsonData: data)
    } catch {
      self.error = error
      updateButtonStatus(buttonStatus: .failed)
      self.serviceErrorCode = .networkError
    }

    updateButtonStatus(buttonStatus: .downloaded)
  }

  override func fetchData(input: ProviderInput) async throws -> ProviderOutput {
      await self.fetchButtonsAsync()
      return  ProviderOutput(buttons:self.buttons, success:true)
  }
}
