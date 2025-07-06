//
//  ContentView.swift
//  cricut
//
//  Created by Zhen Wang on 7/3/25.
//

import SwiftUI
import SwiftData

let CIRCLE_NAME = "Circle"

//TODO: add accessbility
//TODO: localization for UI
struct ContentView: View {
  @Environment(\.modelContext) private var modelContext
  @State var path = NavigationPath()
  
  private var buttonsViewModel: ButtonsViewModel
  private let shapesViewModel: ShapesViewModel

  init(circuitBreaker: CircuitBreaker) {
    self.buttonsViewModel = ButtonsViewModel(circuitBreaker: circuitBreaker)
    self.shapesViewModel = ShapesViewModel(circuitBreaker: circuitBreaker)
  }
  
  var body: some View {
    NavigationStack(path: $path) {
      if buttonsViewModel.dataStatus == .downloaded
      {
        ZStack {
          // main view container
          VStack {
            ShapeGridView(shapesViewModel: shapesViewModel)
              .padding(.top)
            
            ButtonBar(
              buttonsViewModel: buttonsViewModel)
            { shape in
              addShape(shape: shape)
            }.accessibilityIdentifier("ButtonBar")
          }
        }.toolbar {
          // top bar
          ToolbarItem (placement: .topBarLeading) {
            Text("Clear All").onTapGesture {
              ClearAll()
            }.foregroundStyle(.link)
            .accessibilityIdentifier("clearAll")
          }
          
          ToolbarItem (placement: .topBarTrailing) {
            VStack{
              Text("Edit Circles").foregroundStyle(.link)
              Image(systemName: "circle.fill").foregroundStyle(.blue).shadow(color: .blue.opacity(0.4), radius: 0, x: 8, y: 2)
            }.onTapGesture {
              goToCirclesView()
            }
          }
        }
        .navigationTitle(Text("Shapes"))
        .navigationDestination(for: String.self) { destinationPath in
          if destinationPath == CIRCLE_NAME {
            FilteredShapeView(shapesViewModel: ShapesViewModel(selectedShapeName: CIRCLE_NAME, circuitBreaker: shapesViewModel.circuitBreaker),
                              buttonsViewModel: self.buttonsViewModel)
          }
        }
      }
      // loading view full screen for initial button
      // loadingj
      else {
        LoadingView(buttonsViewModel: buttonsViewModel)
      }
    }.modelContainer(for: [Shape.self,
                           ProviderInfo.self,
                           CacheButton.self])
  }
  
  private func ClearAll() {
    Task {
      await shapesViewModel.clearAll()
    }
  }
  
  private func addShape(shape: Shape) {
    Task {
      await shapesViewModel.add(shape: shape)
    }
  }
  
  private func goToCirclesView() {
    self.path.append(CIRCLE_NAME)
  }
}

#Preview {
  let circuitBreaker = getCircuitBreaker()
  ContentView(circuitBreaker: circuitBreaker)
}
