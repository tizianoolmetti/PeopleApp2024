//
//  PeopleViewUITests.swift
//  PeopleAppUITests
//
//  Created by Tom Olmetti on 18/6/2024.
//

import XCTest

final class PeopleViewUITests: XCTestCase {
    
    private var app: XCUIApplication!
    
    override func setUp() {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = [UiTestingIdentifier.uiTesting.rawValue]
    }
    
    override func tearDown() {
        app = nil
    }
    
    func test_whenViewIsLoaded_shouldDisplayPeopleGridView() {
        
        app.launchEnvironment = [UiTestingIdentifier.peopleNetworkingSuccess.rawValue : "true"]
        app.launch()
        
        let gridView = app.otherElements["people_grid_view"]
        XCTAssertTrue(gridView.waitForExistence(timeout: 5), "People grid view should be displayed")
        
        let predicate = NSPredicate(format: "identifier CONTAINS 'item_'")
        let items = gridView.buttons.containing(predicate)
        XCTAssertEqual(items.count, 6, "The grid view should contain 6 cells")
        
        for i in 0..<items.count {
            let expectedUsers = ["Tom Olmetti", "Janet Weaver", "Emma Wong", "Eve Holt", "Charles Morris", "Tracey Ramos"]
            let cell = items.element(boundBy: i)
            XCTAssertTrue(cell.exists, "Cell \(i) should exist")
            
            // Verify the content of each cell
            let pill = cell.staticTexts["#\(i+1)"]
            XCTAssertTrue(pill.exists, "Name label for cell \(i) should exist")
            XCTAssertEqual(cell.label, "#\(i+1), \(expectedUsers[i])")
        }
    }
    
    func test_whenViewIsLoadedWithAnError_shouldDisplayAnAlert() {
        
        app.launchEnvironment = [UiTestingIdentifier.peopleNetworkingSuccess.rawValue : "false"]
        app.launch()
        
        let alert = app.alerts.firstMatch
        XCTAssertTrue(alert.waitForExistence(timeout: 5), "Alert should be displayed")
        
        let message = alert.staticTexts["An error occurred: Invalid Status Code: 301"]
        XCTAssertTrue(message.exists, "Alert message should be displayed")
        
        let retryButton = alert.buttons["Retry"]
        XCTAssertTrue(retryButton.exists, "Retry button should be displayed")
        
        let cancelButton = alert.buttons["Cancel"]
        XCTAssertTrue(cancelButton.exists, "Cancel button should be displayed")
    }
}
