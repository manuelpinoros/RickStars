//
//  RickStarUITests.swift
//  RickStarUITests
//
//  Created by Manuel Pino Ros on 27/5/25.
//

import XCTest

final class RickStarUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it's important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
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
    }

    @MainActor
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }

    @MainActor
    func testSearchBarFunctionality() throws {
        // Launch the app
        let app = XCUIApplication()
        app.launch()
        
        // Wait for the initial list to load with a longer timeout
        let list = app.collectionViews["CharactersList"]
        let listExists = list.waitForExistence(timeout: 10)
        XCTAssertTrue(listExists, "List should be visible after 10 seconds")
        
        // Print debug information about what elements are available
        print("Available elements:")
        print(app.debugDescription)
        
        // Wait a bit more to ensure the list is fully loaded
        Thread.sleep(forTimeInterval: 2)
        
        // Find the search bar
        let searchBar = app.textFields["Search"]
        let searchBarExists = searchBar.waitForExistence(timeout: 5)
        XCTAssertTrue(searchBarExists, "Search bar should be visible")
        
        // Enter search text
        searchBar.tap()
        searchBar.typeText("Abadango")
        
        // Wait a bit more to ensure the search results are loaded
        Thread.sleep(forTimeInterval: 5)
        
        // Verify we have some results
        let cells = list.cells.count
        XCTAssertGreaterThan(cells, 0, "Should have search results")
        
        // Clear search
        searchBar.tap()
        searchBar.typeText("Rick")
        
        // Wait for the list to update with all results
        let listAfterClear = list.waitForExistence(timeout: 10)
        XCTAssertTrue(listAfterClear, "List should be visible after clearing search")
        
        // Wait a bit more to ensure the full list is loaded
        Thread.sleep(forTimeInterval: 2)
        
        // Verify we have more results after clearing
        let allCells = list.cells
        XCTAssertGreaterThan(allCells.count, cells, "Should have more results after clearing search")
    }


    @MainActor
    func testTapSecondItemAndBack() throws {
        let app = XCUIApplication()
        app.launch()

        // Ensure the character list is present.
        let list = app.collectionViews["CharactersList"]
        XCTAssertTrue(list.waitForExistence(timeout: 10), "Characters list should appear")

        // Make sure there are at least two items.
        XCTAssertGreaterThan(list.cells.count, 1, "Need at least two cells to test navigation")

        // Tap the second cell (index 1).
        let secondCell = list.cells.element(boundBy: 1)
        secondCell.tap()

        // Wait for detail screen to load (look for Back button).
        let backButton = app.buttons["Back"]
        XCTAssertTrue(backButton.waitForExistence(timeout: 5), "Back button should appear on detail view")

        // Pause briefly to simulate the user reading content.
        sleep(2)

        // Navigate back to the list.
        backButton.tap()

        // Verify we are back on the list.
        XCTAssertTrue(list.waitForExistence(timeout: 5), "Characters list should reappear after navigating back")
    }
}
