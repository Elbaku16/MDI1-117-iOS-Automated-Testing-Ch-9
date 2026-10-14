//
//  TaskFlow_Ch9UITests.swift
//  TaskFlow-Ch9UITests
//
//  Created by Andres de la Cruz on 9/30/26.
//

import XCTest

final class TaskFlow_Ch9UITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor
    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // XCUIAutomation Documentation
        // https://developer.apple.com/documentation/xcuiautomation
    }

    // MARK: Assignment 1 - UI & Integration Tests

    /// helper pa escribir la tarea y darle Add
    @MainActor
    private func addTask(_ title: String, in app: XCUIApplication) {
        let addTaskField = app.textFields["Add Task"]
        XCTAssertTrue(addTaskField.waitForExistence(timeout: 5.0), "The text field should exist on the main screen")
        addTaskField.tap()
        addTaskField.typeText(title)
        app.buttons["Add"].tap()
    }

    /// Assignment 1 - UI test: completar una tarea
    @MainActor
    func testMarkTaskCompleted() throws {
        let app = XCUIApplication()
        app.launch()

        // primero agrego una tarea
        addTask("Finish homework", in: app)

        // le pico al boton Complete de la primera
        let taskCell = app.cells.element(boundBy: 0)
        XCTAssertTrue(taskCell.waitForExistence(timeout: 2.0), "The task cell should appear")
        let completeButton = taskCell.buttons["Complete"]
        XCTAssertFalse(completeButton.isSelected, "A new task starts incomplete")
        completeButton.tap()

        // checo que quede marcada y el contador cambie
        XCTAssertTrue(completeButton.isSelected)
        XCTAssertTrue(app.staticTexts["Completed: 1/1"].exists)
    }

    /// Assignment 1 - Integration test: agregar y ver la tarea en la lista
    @MainActor
    func testAddingAndDisplayingTasks() throws {
        let app = XCUIApplication()
        app.launch()

        addTask("Walk the Dog", in: app)

        XCTAssertTrue(app.cells.staticTexts["Walk the Dog"].waitForExistence(timeout: 2.0))
    }

    /// Extra - con el campo vacio el boton Add no jala
    @MainActor
    func testAddButtonDisabledWhenFieldIsEmpty() throws {
        let app = XCUIApplication()
        app.launch()

        let addButton = app.buttons["Add"]
        XCTAssertTrue(addButton.waitForExistence(timeout: 5.0))
        XCTAssertFalse(addButton.isEnabled, "Add should be disabled with an empty title")
        XCTAssertEqual(app.cells.count, 0)
    }

    // MARK: Assignment 2 - TDD Priority (UI)

    /// elijo High al agregar y checo que salga la etiqueta
    @MainActor
    func testAddTaskWithHighPriority_showsHighLabel() throws {
        let app = XCUIApplication()
        app.launch()

        let highSegment = app.segmentedControls["priority_picker"].buttons["High"]
        XCTAssertTrue(highSegment.waitForExistence(timeout: 5.0), "Should have a priority picker")
        highSegment.tap()

        addTask("Study for exam", in: app)

        let cell = app.cells.element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 2.0))
        XCTAssertTrue(cell.staticTexts["High"].exists, "The task should show its priority")
    }

    // MARK: Assignment 3 - XCUITest + CI

    /// test del assignment 3: agregar "Complete Assignment" y que salga en la lista
    @MainActor
    func testAddingTask() throws {
        let app = XCUIApplication()
        app.launch()

        let addTaskField = app.textFields["Add Task"]
        XCTAssertTrue(addTaskField.waitForExistence(timeout: 5.0))
        addTaskField.tap()
        addTaskField.typeText("Complete Assignment")

        let addButton = app.buttons["Add"]
        addButton.tap()

        // en SwiftUI la lista no es table, por eso app.cells
        XCTAssertTrue(app.cells.staticTexts["Complete Assignment"].waitForExistence(timeout: 2.0))
    }

    @MainActor
    func testLaunchPerformance() throws {
        // This measures how long it takes to launch your application.
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
