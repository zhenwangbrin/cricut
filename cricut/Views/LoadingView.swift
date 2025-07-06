//
//  LoadingView.swift
//  cricut
//
//  Created by Zhen Wang on 7/3/25.
//

import SwiftUI
import SwiftData

struct LoadingView: View {
  @ObservedObject var buttonsViewModel: ButtonsViewModel
  var body: some View {
    ProgressView()
    // display different text base on the current status
    switch buttonsViewModel.dataStatus {
    case .downloading:
      Text("Downloading data...")
    case .downloaded:
      Text("Downloaded!")
    case .failed:
      Text("Failed!")
    case .new:
      // start downloading once initial starting status is shown.
      Text("Starting...").task {
        buttonsViewModel.fetchButtons()
      }
    }
  }
}

#Preview {
  LoadingView(buttonsViewModel: ButtonsViewModel(circuitBreaker: getCircuitBreaker()))
}
