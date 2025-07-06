//
//  Shape.swift
//  cricut
//
//  Created by Zhen Wang on 7/3/25.
//
enum ShapeButtonServiceStatus {
  case downloading
  case downloaded
  case failed
  case new
}

protocol ButtonViewModelObserver: AnyObject {
  func buttonStatusDidChange(_ status: ShapeButtonServiceStatus)
}

protocol ShapeButtonProvidable {
  var buttonViewModelObservers: [ButtonViewModelObserver]? { get set }

  var buttonStatus: ShapeButtonServiceStatus { get set }

  // return nil if failed
  func attach(_ observer: ButtonViewModelObserver)
  func detach(_ observer: ButtonViewModelObserver)
  func updateButtonStatus(buttonStatus: ShapeButtonServiceStatus)
}
