//
//  ShapeGridView.swift
//  cricut
//
//  Created by Zhen Wang on 7/3/25.
//

import SwiftUI
import SwiftData

struct FilteredShapeView: View {
  var shapesViewModel: ShapesViewModel
  var buttonsViewModel: ButtonsViewModel

  init(shapesViewModel: ShapesViewModel, buttonsViewModel: ButtonsViewModel) {
    self.shapesViewModel = shapesViewModel
    self.buttonsViewModel = buttonsViewModel
  }

  var body: some View {
    VStack {
      ShapeGridView(shapesViewModel: shapesViewModel)
      FilterShapeBottomBar(shapesViewModel: shapesViewModel,
                           buttonsViewModel: buttonsViewModel)
    }
    .onAppear() {
      Task {
        await self.shapesViewModel.getShapes()
      }
    }
    .navigationTitle(self.shapesViewModel.selectedShapeName!)
  }
}

#Preview {
  let circuitBreaker = getCircuitBreaker()
  let shapesViewModel =
  ShapesViewModel(selectedShapeName: CIRCLE_NAME, circuitBreaker: circuitBreaker)
  let buttonsViewModel = ButtonsViewModel(circuitBreaker: circuitBreaker)
  FilteredShapeView(shapesViewModel: shapesViewModel,
                    buttonsViewModel: buttonsViewModel)
}
