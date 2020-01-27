//
//  iOSProjectUITests.swift
//  iOSProjectUITests
//
//  Created by SINCY on 28/01/20.
//  Copyright © 2020 SINCY. All rights reserved.
//

import XCTest

class iOSProjectUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testIfFactsTableExists() {
        let factsTable = app.tables["factsTableView"]
        XCTAssertTrue(factsTable.exists, "The Facts tableview exists")
        
    }
    
    func testIfFactsTableCaellExists() {
        _ = self.expectation(
            for: NSPredicate(format: "self.count = 1"),
            evaluatedWith: XCUIApplication().tables,
            handler: nil)
        self.waitForExpectations(timeout: 5.0, handler: nil)
        
        let cell = XCUIApplication().tables.cells.element(boundBy: 0)
        XCTAssertTrue(cell.exists)
        
    }
    
    func testIfNavigationBarTitleExists() {
        _ = self.expectation(
            for: NSPredicate(format: "self.count = 1"),
            evaluatedWith: XCUIApplication().tables,
            handler: nil)
        self.waitForExpectations(timeout: 5.0, handler: nil)
        
        let navBarTitle = XCUIApplication().navigationBars["About Canada"].staticTexts.element
        XCTAssertTrue(navBarTitle.exists)
    }
    
    func testIfFactsTableCellTitleExists() {
        _ = self.expectation(
            for: NSPredicate(format: "self.count = 1"),
            evaluatedWith: XCUIApplication().tables,
            handler: nil)
        self.waitForExpectations(timeout: 5.0, handler: nil)
        
        let cell = XCUIApplication().tables.cells.element(boundBy: 0)
        XCTAssertTrue(cell.exists)
        
        let indexedText = cell.staticTexts.element
        XCTAssertTrue(indexedText.exists)
    }
    
    func testIfFactsTableCellImageExists() {
        _ = self.expectation(
            for: NSPredicate(format: "self.count = 1"),
            evaluatedWith: XCUIApplication().tables,
            handler: nil)
        self.waitForExpectations(timeout: 5.0, handler: nil)
        
        let cell = XCUIApplication().tables.cells.element(boundBy: 0)
        XCTAssertTrue(cell.exists)
        
        let image = cell.images.element
        XCTAssertTrue(image.exists)
    }
    
    func testIfReloadButtonExistsAndIsClickable() {
        _ = self.expectation(
            for: NSPredicate(format: "self.count = 1"),
            evaluatedWith: XCUIApplication().tables,
            handler: nil)
        self.waitForExpectations(timeout: 5.0, handler: nil)
        
        let navBarButton = XCUIApplication().navigationBars["About Canada"].buttons.element
        XCTAssertTrue(navBarButton.exists)
        XCTAssertTrue(navBarButton.isEnabled)
    }
}
