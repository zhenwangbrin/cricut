//
//  ProviderProtocol.swift
//  cricut
//
//  Created by Zhen Wang on 7/4/25.
//
enum ProviderAction {
  case fetch
  case add
  case delete
  case deleteAll
}

struct ProviderInput {
  var action: ProviderAction
  var shape: Shape?
}

struct ProviderOutput {
  var shapes: [Shape]?
  var buttons: [Button]?
  var success: Bool = false
}

protocol Providable {
  static func getProviderName() -> String
  static func retries() -> Int
  func isDataDirty() -> Bool
  func executeProviderAction(input: ProviderInput) async throws -> ProviderOutput
}
