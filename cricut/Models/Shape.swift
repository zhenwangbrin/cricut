//
//  Shape.swift
//  cricut
//
//  Created by Zhen Wang on 7/3/25.
//

import SwiftData
import Foundation

@Model
class Shape {
  var id: UUID
  var name: String
  var path: String

  init(name: String, path: String) {
    self.id = UUID()
    self.name = name
    self.path = path
  }
}
