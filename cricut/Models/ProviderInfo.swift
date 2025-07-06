//
//  ProviderInfo.swift
//  cricut
//
//  Created by Zhen Wang on 7/3/25.
//

import Foundation
import SwiftData

// provider info usage:
// name: used as unique key
// lastTryTime: used for throttle fetch
// lastSuccessTime:
// firstSuccessTime: data expire time caculation
// retries: the number of try before passing on to next provider
@Model
final public class ProviderInfo: Sendable {
  @Attribute(.unique) var name: String
  var successTime: Date

  init(name: String,
       successTime: Date) {
    self.name = name
    self.successTime = successTime
  }
}
