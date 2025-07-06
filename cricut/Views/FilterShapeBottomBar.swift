//
//  FilterShapeBottomBar.swift
//  cricut
//
//  Created by Zhen Wang on 7/3/25.
//

import SwiftUI
import SwiftData

struct FilterShapeBottomBar: View {
  var shapesViewModel: ShapesViewModel
  var buttonsViewModel: ButtonsViewModel
  var body : some View {
    HStack {
      Text("Delete All")
        .foregroundStyle(.blue)
        .padding(2)
        .frame(width: 100)
        .onTapGesture {
          Task {
            await shapesViewModel.clearAll()
          }
        }
      Text("Add").foregroundStyle(.blue).padding(2).frame(width: 100)
        .onTapGesture {
          Task {
            addShape()
          }
        }
      Text("Remove last").foregroundStyle(.blue).padding(2).frame(width: 100)
        .onTapGesture {
          Task {
            await shapesViewModel.removeLast()
          }
        }
    }
  }
  
  func addShape() {
    Task {
      let shape = buttonsViewModel.getShapeOfName(name: shapesViewModel.selectedShapeName!)
      if shape != nil {
        await shapesViewModel
          .add(
            shape: shape!
          )
      }
    }
  }
  
  func removeShape() {
    
  }
}

#Preview {
  let circuitBreaker = getCircuitBreaker()
  FilterShapeBottomBar(shapesViewModel:
                        ShapesViewModel(circuitBreaker: circuitBreaker),
                       buttonsViewModel: ButtonsViewModel(circuitBreaker: circuitBreaker))
}
