//
//  DetailsViewUITests.swift
//  PeopleAppUITests
//
//  Created by Tom Olmetti on 18/6/2024.
//

import XCTest

final class DetailsViewUITests: XCTestCase {
    
    private var app: XCUIApplication!
    
    override func setUp() {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = [UiTestingIdentifier.uiTesting.rawValue]
    }
    
    override func tearDown() {
        app = nil
    }
    
    func test_whenPeopleItemViewIsTapped_shouldNavigateToDetailsViewAndPresentRightComponents() {
        app.launchEnvironment = [
            UiTestingIdentifier.peopleNetworkingSuccess.rawValue : "true",
            UiTestingIdentifier.detailsNetworkingSuccess.rawValue : "true"
        ]
        app.launch()
        
        let gridView = app.otherElements["people_grid_view"]
        XCTAssertTrue(gridView.waitForExistence(timeout: 5), "People grid view should be displayed")
        
        let predicate = NSPredicate(format: "identifier CONTAINS 'item_'")
        let items = gridView.buttons.containing(predicate)
        
        items.firstMatch.tap()
        
        let header = app.staticTexts["Details"]
        let pill = app.staticTexts["#1"]
        let firstNameLabel = app.staticTexts["First Name"]
        let lastNameLabel = app.staticTexts["Last Name"]
        let jobLabel = app.staticTexts["Email"]
        let nameExpected = app.staticTexts["Tom"]
        let lastNameExpected = app.staticTexts["Olmetti"]
        let emailExpected = app.staticTexts["george.bluth@reqres.in"]
        let supportTitle = app.staticTexts["To keep ReqRes free, contributions towards server costs are appreciated!"]
        let supportButton = app.staticTexts["https://reqres.in/#support-heading"]
        
        XCTAssertTrue(header.waitForExistence(timeout: 5), "Details header should be displayed")
        XCTAssertTrue(pill.waitForExistence(timeout: 5), "Pill should be displayed")
        XCTAssertTrue(firstNameLabel.waitForExistence(timeout: 5), "First Name label should be displayed")
        XCTAssertTrue(lastNameLabel.waitForExistence(timeout: 5), "Last Name label should be displayed")
        XCTAssertTrue(jobLabel.waitForExistence(timeout: 5), "Email label should be displayed")
        XCTAssertTrue(nameExpected.waitForExistence(timeout: 5), "First Name should be displayed")
        XCTAssertTrue(lastNameExpected.waitForExistence(timeout: 5), "Last Name should be displayed")
        XCTAssertTrue(emailExpected.waitForExistence(timeout: 5), "Email should be displayed")
        XCTAssertTrue(supportTitle.waitForExistence(timeout: 5), "Support title should be displayed")
        XCTAssertTrue(supportButton.waitForExistence(timeout: 5), "Support button should be displayed")
        
    }
    
    func test_whenPeopleItemViewIsTappedAndDetailsNetworkingFails_shouldDisplayAnAlert() {
        app.launchEnvironment = [
            UiTestingIdentifier.peopleNetworkingSuccess.rawValue : "true",
            UiTestingIdentifier.detailsNetworkingSuccess.rawValue : "false"
        ]
        app.launch()
        
        let gridView = app.otherElements["people_grid_view"]
        XCTAssertTrue(gridView.waitForExistence(timeout: 5), "People grid view should be displayed")
        
        let predicate = NSPredicate(format: "identifier CONTAINS 'item_'")
        let items = gridView.buttons.containing(predicate)
        
        items.firstMatch.tap()
        
        let alert = app.alerts.firstMatch
        XCTAssertTrue(alert.waitForExistence(timeout: 5), "Alert should be displayed")
        
        let message = alert.staticTexts["An error occurred: Invalid Status Code: 301"]
        XCTAssertTrue(message.exists, "Alert message should be displayed")
        
        let retryButton = alert.buttons["Retry"]
        XCTAssertTrue(retryButton.exists, "Retry button should be displayed")
    }
    
    func test_whenSupportButtonIsTapped_shoulOpenWebview() {
        app.launchEnvironment = [
            UiTestingIdentifier.peopleNetworkingSuccess.rawValue : "true",
            UiTestingIdentifier.detailsNetworkingSuccess.rawValue : "true"
        ]
        app.launch()
        
        let gridView = app.otherElements["people_grid_view"]
        XCTAssertTrue(gridView.waitForExistence(timeout: 5), "People grid view should be displayed")
        
        let predicate = NSPredicate(format: "identifier CONTAINS 'item_'")
        let items = gridView.buttons.containing(predicate)
        
        items.firstMatch.tap()
        
        let supportButton = app.staticTexts["https://reqres.in/#support-heading"]
        XCTAssertTrue(supportButton.waitForExistence(timeout: 5), "Support button should be displayed")
        
        supportButton.tap()
        
        let safari = XCUIApplication(bundleIdentifier: "com.apple.mobilesafari")
        guard safari.wait(for: .runningForeground, timeout: 10) else {
            XCTFail("could not open Safari")
            return
        }
        // we use CONTAINS because at first, only the base URL is displayed inside the text field. For example, if the URL is https://myapp.com/something, the value of the address bar would be 'myapp.com'
        let pred = NSPredicate(format: "value CONTAINS[cd] %@", "reqres.in")
        let addressBar = safari.textFields.element(matching: pred)
        // tap is needed to reveal the full URL string inside the address bar
        addressBar.tap()
        
        let textField = safari.textFields.element(matching: pred)
        XCTAssertEqual(textField.value as? String, "https://reqres.in/#support-heading")
    }
    
    func test_whenBackButtonIsTapped_shouldNavigateBackToPeopleView() {
        app.launchEnvironment = [
            UiTestingIdentifier.peopleNetworkingSuccess.rawValue : "true",
            UiTestingIdentifier.detailsNetworkingSuccess.rawValue : "true"
        ]
        app.launch()
        
        let gridView = app.otherElements["people_grid_view"]
        XCTAssertTrue(gridView.waitForExistence(timeout: 5), "People grid view should be displayed")
        
        let predicate = NSPredicate(format: "identifier CONTAINS 'item_'")
        let items = gridView.buttons.containing(predicate)
        
        items.firstMatch.tap()
        
        let backButton = app.navigationBars.buttons.element(boundBy: 0)
        XCTAssertTrue(backButton.waitForExistence(timeout: 5), "Back button should be displayed")
        
        backButton.tap()
        
        XCTAssertTrue(gridView.waitForExistence(timeout: 5), "People grid view should be displayed")
    }
}
