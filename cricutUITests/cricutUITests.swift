//
//  cricutUITests.swift
//  cricutUITests
//
//  Created by Zhen Wang on 7/3/25.
//

import XCTest
import Foundation

class XCUITest: XCTestCase {

  override func setUp() {
    super.setUp()
    continueAfterFailure = false
    XCUIApplication().launch()
  }

  override func tearDown() {
    super.tearDown()
  }

  func testCheckAdd() {
    let app = XCUIApplication()
    sleep(2)
    var children = app.descendants(matching: .any).matching(identifier: "clearAll")
    children.firstMatch.tap()
    children = app.descendants(matching: .any).matching(identifier: "circleAction")
    children.firstMatch.tap()
    children = app.descendants(matching: .any).matching(identifier: "squareAction")
    children.firstMatch.tap()
    children = app.descendants(matching: .any).matching(identifier: "triangleAction")
    children.firstMatch.tap()
    XCTAssertEqual(app.descendants(matching: .any).matching(identifier: "gridShapeItems").count, 3)
  }
}
