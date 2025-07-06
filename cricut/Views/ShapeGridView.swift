//
//  ShapeGridView.swift
//  cricut
//
//  Created by Zhen Wang on 7/3/25.
//

import SwiftUI
import SwiftData

struct ShapeGridView: View {
  var shapesViewModel: ShapesViewModel

  var body: some View {
    ScrollView {
      LazyVGrid(columns: Array(repeating: GridItem(.flexible(minimum: 100)), count: 3), spacing: 16) {
        ForEach(shapesViewModel.shapes) { shape in
          Image(systemName: shape.path + ".fill")
            .resizable()
            .foregroundStyle(.blue)
            .frame(width: 100, height: 100).accessibilityIdentifier("gridShapeItems")
        }
      }
    }
    .onAppear() {
      Task {
        await shapesViewModel.getShapes()
      }
    }
  }
}

#Preview {
  let shapesViewModel = ShapesViewModel(circuitBreaker:
                                          getCircuitBreaker())
  ShapeGridView(shapesViewModel:shapesViewModel)
}
