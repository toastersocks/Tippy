//
//  TippyUITests.swift
//  TippyUITests
//
//  Created by James Pamplona on 6/15/16.
//  Copyright © 2016 James Pamplona. All rights reserved.
//

import XCTest

class Screenshots: XCTestCase {
        
    override func setUp() {
        super.setUp()
        let app = XCUIApplication()
        app.launchEnvironment = ["UITest" : "1", "TakingScreenshots" : "1"]

        setupSnapshot(app)
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testFirstScreen() {
        
        let app = XCUIApplication()
        
        app.textFields["total"].tap()
        app.typeText("125")
        
        app.buttons["addWorker"].tap()
        
        let tablesQuery = app.tables
        
        tablesQuery.textFields["nameField"].tap()
//        tablesQuery.textFields["nameField"]
        app.typeText("Joanna")
        
        let percentfieldTextField = tablesQuery.textFields["percentField"]
        percentfieldTextField.tap()
        tablesQuery.textFields["percentField"].typeText("20")
        
        let addworkerButton = tablesQuery.buttons["addWorker"]
        addworkerButton.tap()
        
        let worker1Cell = tablesQuery.cells["worker1"]
        worker1Cell.textFields["nameField"].tap()
        worker1Cell.textFields["nameField"].typeText("Ken")
        
        let hoursfieldTextField = worker1Cell.textFields["hoursField"]

        hoursfieldTextField.tap()
        worker1Cell.textFields["hoursField"].typeText("3")
        
        addworkerButton.tap()
        
        let worker2Cell = tablesQuery.cells["worker2"]
        let namefieldTextField = worker2Cell.textFields["nameField"]
        namefieldTextField.tap()
        namefieldTextField.typeText("Saundra")
        worker2Cell.textFields["hoursField"].tap()
        worker2Cell.textFields["hoursField"].typeText("1")
        
        addworkerButton.tap()
        
        let worker3Cell = tablesQuery.cells["worker3"]
        worker3Cell.textFields["nameField"].tap()
        worker3Cell.textFields["nameField"].typeText("Roberto")
        worker3Cell.textFields["amountField"].tap()
        worker3Cell.textFields["amountField"].typeText("12")
        worker3Cell.textFields["amountField"].typeText("\n")
        
        snapshot("0firstScreen")
        
        
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testSplitScreen() {
        
        let app = XCUIApplication()
        app.textFields["total"].tap()
        app.textFields["total"].typeText("427")
        
        let splitButton = app.buttons["split"]
        splitButton.tap()
        app.buttons["Cancelar"].tap()
        splitButton.tap()
        app.buttons["Percentagem"].tap()
        app.textFields["Percentagem"]
        app.tables["Lista vazia"].buttons["addWorker"].tap()
        
    }
}
