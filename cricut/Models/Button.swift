//
//  Buttons.swift
//  cricut
//
//  Created by Zhen Wang on 7/3/25.
//
import SwiftData
import Foundation

/**
 {
    "buttons":[
       {
          "name":"Circle",
          "draw_path":"circle",
       },
       {
          "name":"Square",
          "draw_path":"square",
       },
       {
          "name":"Triangle",
          "draw_path":"triangle",
       },
    ]
 }
 */

class Button: Codable {
  enum CodingKeys: String, CodingKey {
    case name = "name"
    case drawPath = "drawPath"
  }

  @Attribute(.unique) var name: String
  var drawPath: String

  init(name: String, drawPath: String) {
    self.name = name
    self.drawPath = drawPath
  }

  required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.name = try container.decode(String.self, forKey: .name)
    self.drawPath = try container.decode(String.self, forKey: .drawPath)
  }

  func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(name, forKey: .name)
    try container.encode(drawPath, forKey: .drawPath)
  }
}

class Buttons: Codable {
  enum CodingKeys: String, CodingKey {
    case buttons = "buttons"
  }

  var buttons: [Button]

  init(buttons: [Button]) {
    self.buttons = buttons
  }

  required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.buttons = try container.decode([Button].self, forKey: .buttons)
  }

  func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(buttons, forKey: .buttons)
  }
}

extension Button: Identifiable {
  public var id: String { name }
}

// switchdata doesn't allow us to use and share decodable object that we used in jsonDecoder due to unknown conflicts
@Model
class CacheButton {
  @Attribute(.unique) var name: String
  var path: String

  init(name: String, path: String) {
    self.name = name
    self.path = path
  }
}
