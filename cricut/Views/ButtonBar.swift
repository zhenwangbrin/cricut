//
//  ButtonBar.swift
//  cricut
//
//  Created by Zhen Wang on 7/3/25.
//

import SwiftUI
import SwiftData

struct ButtonBar: View {
  @ObservedObject var buttonsViewModel : ButtonsViewModel
  var buttonAction: (_ shape: Shape) -> Void
  
  var body : some View {
    ScrollView(.horizontal) {
      HStack {
        ForEach(getButtons()) {
          button in
          VStack {
            Text(button.name).foregroundStyle(.blue).padding(2)
            Image(systemName: button.drawPath + ".fill").foregroundStyle(.blue)
          }
          .frame(width: 100)
          .onTapGesture {
              self.buttonAction(
                Shape(name: button.name,
                      path:button.drawPath))
            }
          .accessibilityIdentifier(button.drawPath+"Action")
        }
      }
    }.defaultScrollAnchor(.center)
  }
  
  func getButtons() -> [Button] {
    return buttonsViewModel.buttons
  }
}

#Preview {
  ButtonBar(buttonsViewModel: ButtonsViewModel(circuitBreaker: getCircuitBreaker())) { _ in
  }
}
