//
//  ShapeButtoneCacheProvider.swift
//  cricut
//
//  Created by Zhen Wang on 7/3/25.
//
import SwiftData
import Foundation

// minutes
let CACHE_EXPIRE_TIME = 2

class ShapeButtonCacheProvider: ShapeButtonBaseProvider {
  var context: ModelContext
  var providerInfoProvider: ProviderInfoProvider

  init(context: ModelContext) {
    self.context = context
    self.providerInfoProvider = ProviderInfoProvider(context: context)
  }

  override func fetchData(input: ProviderInput) async throws -> ProviderOutput {
    updateButtonStatus(buttonStatus: .downloading)
    var buttons: [Button] = []
    do {
      let cacheButtons = try context.fetch(FetchDescriptor<CacheButton>())
      for cacheButton in cacheButtons {
        buttons.append(Button(name: cacheButton.name, drawPath: cacheButton.path))
      }
    } catch {
      updateButtonStatus(buttonStatus: .failed)
      throw error
    }
    updateButtonStatus(buttonStatus: .downloaded)
    return ProviderOutput(buttons: buttons, success: true)
  }

  override func isDataDirty() -> Bool {
    do {
      let providerInfo = try providerInfoProvider.getProviderInfo(type(of: self).getProviderName())
      if providerInfo == nil {
        return true
      }
      let successTime = providerInfo!.successTime
      let twoMinutesLater = Calendar.current.date(byAdding: .minute, value: CACHE_EXPIRE_TIME, to: successTime)!
      if Date() < twoMinutesLater {
        return false
      }
      return true
    }
    catch {
      return true
    }
  }
}
