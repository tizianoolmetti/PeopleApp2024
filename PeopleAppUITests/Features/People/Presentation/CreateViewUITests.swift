//
//  CreateViewUITests.swift
//  PeopleAppUITests
//
//  Created by Tom Olmetti on 19/6/2024.
//

import XCTest

final class CreateViewUITests: XCTestCase {

    private var app: XCUIApplication!
    
    // MARK: - functions
    
    func navigateToCreateView(networkingSuccess: String = "true") {
        app.launchEnvironment = [
            UiTestingIdentifier.peopleNetworkingSuccess.rawValue : "true",
            UiTestingIdentifier.createNetworkingSuccess.rawValue : networkingSuccess
        ]
        app.launch()
        
        let createButton = app.buttons["create_button"]
        XCTAssertTrue(createButton.waitForExistence(timeout: 5), "Create button should be displayed")
        
        createButton.tap()
    }
    
    
    // MARK: - Setup & Teardown
    override func setUp() {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = [UiTestingIdentifier.uiTesting.rawValue]
    }
    
    override func tearDown() {
        app = nil
    }
    
    // MARK: - Tests
    
    func test_whenCreateButtonIsTapped_shouldNavigateToCreateViewAndPresentRightComponents() {
        navigateToCreateView()
        
        let header = app.navigationBars["Create"]
        let firstNameTextfield = app.textFields["first_name_text_field"]
        let lastNameTextfield = app.textFields["last_name_text_field"]
        let jobTextfield = app.textFields["job_text_field"]
        let submitButton = app.buttons["submit_button"]
        let doneButton = app.buttons["done_button"]
        
        XCTAssertTrue(header.waitForExistence(timeout: 5), "Create header should be displayed")
        XCTAssertTrue(firstNameTextfield.waitForExistence(timeout: 5), "First Name label should be displayed")
        XCTAssertTrue(lastNameTextfield.waitForExistence(timeout: 5), "Last Name label should be displayed")
        XCTAssertTrue(jobTextfield.waitForExistence(timeout: 5), "Job label should be displayed")
        XCTAssertTrue(submitButton.waitForExistence(timeout: 5), "Submit button should be displayed")
        XCTAssertTrue(doneButton.waitForExistence(timeout: 5), "Done button should be displayed")
    }
    
    func test_whenDoneIsTapped_createViewShouldDismiss() {
        
        navigateToCreateView()
        
        let doneButton = app.buttons["done_button"]
        XCTAssertTrue(doneButton.waitForExistence(timeout: 5), "Done button should be displayed")
        
        doneButton.tap()
        
        let peopleViewHeader = app.navigationBars["People"]
        XCTAssertTrue(peopleViewHeader.waitForExistence(timeout: 5), "People header should be displayed")
    }
    
    // MARK: - Texfields section validation
    
    //First name Textfield
    func test_whenTextfieldsAreEmptyAndSubmitButtonIsTapped_shouldDisplayErrorAndAlert () {
        navigateToCreateView()
        
        let submitButton = app.buttons["submit_button"]
        XCTAssertTrue(submitButton.waitForExistence(timeout: 5), "Submit button should be displayed")
        
        submitButton.tap()
        
        
        let alert = app.alerts.firstMatch
        XCTAssertTrue(alert.waitForExistence(timeout: 5), "Alert should be displayed")
        
        let alertMessage = alert.staticTexts["An error occurred: First name can't be empty"]
        XCTAssertTrue(alertMessage.waitForExistence(timeout: 5), "Alert message should be displayed")
        let retryButton = alert.buttons["Retry"]
        XCTAssertTrue(retryButton.waitForExistence(timeout: 5), "Retry button should be displayed")
        let cancelButton = alert.buttons["Cancel"]
        XCTAssertTrue(cancelButton.waitForExistence(timeout: 5), "Cancel button should be displayed")
        let texfieldsErroView = app.staticTexts["First name can't be empty"]
        XCTAssertTrue(texfieldsErroView.waitForExistence(timeout: 5), "Textfields error view should be displayed")
        
        cancelButton.tap()
        
        XCTAssertEqual(app.alerts.count, 0, "Shoud not be alert on the screen")
    }
    
    func test_whenFirsNameTextIsEmptyAndOtherTextfieldAreFilled_shouldDisplayErrorAndAlert () {
        navigateToCreateView()
        
        let lastNameTextfield = app.textFields["last_name_text_field"]
        let jobTextfield = app.textFields["job_text_field"]
        
        lastNameTextfield.tap()
        lastNameTextfield.typeText("Doe")
        
        jobTextfield.tap()
        jobTextfield.typeText("Developer")
        
        let submitButton = app.buttons["submit_button"]
        XCTAssertTrue(submitButton.waitForExistence(timeout: 5), "Submit button should be displayed")
        
        submitButton.tap()
        
        let alert = app.alerts.firstMatch
        XCTAssertTrue(alert.waitForExistence(timeout: 5), "Alert should be displayed")
        
        let alertMessage = alert.staticTexts["An error occurred: First name can't be empty"]
        XCTAssertTrue(alertMessage.waitForExistence(timeout: 5), "Alert message should be displayed")
        let retryButton = alert.buttons["Retry"]
        XCTAssertTrue(retryButton.waitForExistence(timeout: 5), "Retry button should be displayed")
        let cancelButton = alert.buttons["Cancel"]
        XCTAssertTrue(cancelButton.waitForExistence(timeout: 5), "Cancel button should be displayed")
        let texfieldsErroView = app.staticTexts["First name can't be empty"]
        XCTAssertTrue(texfieldsErroView.waitForExistence(timeout: 5), "Textfields error view should be displayed")
        
        cancelButton.tap()
        
        XCTAssertEqual(app.alerts.count, 0, "Shoud not be alert on the screen")
    }
    
    //Last name Textfield
    func test_whenLastNameTextIsEmptyAndOtherTextfieldAreFilled_shouldDisplayErrorAndAlert () {
        navigateToCreateView()
        
        let firstNameTextfield = app.textFields["first_name_text_field"]
        let jobTextfield = app.textFields["job_text_field"]
        
        firstNameTextfield.tap()
        firstNameTextfield.typeText("John")
        
        jobTextfield.tap()
        jobTextfield.typeText("Developer")
        
        let submitButton = app.buttons["submit_button"]
        XCTAssertTrue(submitButton.waitForExistence(timeout: 5), "Submit button should be displayed")
        
        submitButton.tap()
        
        let alert = app.alerts.firstMatch
        XCTAssertTrue(alert.waitForExistence(timeout: 5), "Alert should be displayed")
        
        let alertMessage = alert.staticTexts["An error occurred: Last name can't be empty"]
        XCTAssertTrue(alertMessage.waitForExistence(timeout: 5), "Alert message should be displayed")
        let retryButton = alert.buttons["Retry"]
        XCTAssertTrue(retryButton.waitForExistence(timeout: 5), "Retry button should be displayed")
        let cancelButton = alert.buttons["Cancel"]
        XCTAssertTrue(cancelButton.waitForExistence(timeout: 5), "Cancel button should be displayed")
        let texfieldsErroView = app.staticTexts["Last name can't be empty"]
        XCTAssertTrue(texfieldsErroView.waitForExistence(timeout: 5), "Textfields error view should be displayed")
        
        cancelButton.tap()
        
        XCTAssertEqual(app.alerts.count, 0, "Shoud not be alert on the screen")
    }
    
    //Job Textfield
    func test_whenJobTextIsEmptyAndOtherTextfieldAreFilled_shouldDisplayErrorAndAlert () {
        navigateToCreateView()
        
        let firstNameTextfield = app.textFields["first_name_text_field"]
        let lastNameTextfield = app.textFields["last_name_text_field"]
        
        firstNameTextfield.tap()
        firstNameTextfield.typeText("John")
        
        lastNameTextfield.tap()
        lastNameTextfield.typeText("Doe")
        
        let submitButton = app.buttons["submit_button"]
        XCTAssertTrue(submitButton.waitForExistence(timeout: 5), "Submit button should be displayed")
        
        submitButton.tap()
        
        let alert = app.alerts.firstMatch
        XCTAssertTrue(alert.waitForExistence(timeout: 5), "Alert should be displayed")
        
        let alertMessage = alert.staticTexts["An error occurred: Job can't be empty"]
        XCTAssertTrue(alertMessage.waitForExistence(timeout: 5), "Alert message should be displayed")
        let retryButton = alert.buttons["Retry"]
        XCTAssertTrue(retryButton.waitForExistence(timeout: 5), "Retry button should be displayed")
        let cancelButton = alert.buttons["Cancel"]
        XCTAssertTrue(cancelButton.waitForExistence(timeout: 5), "Cancel button should be displayed")
        let texfieldsErroView = app.staticTexts["Job can't be empty"]
        XCTAssertTrue(texfieldsErroView.waitForExistence(timeout: 5), "Textfields error view should be displayed")
        
        cancelButton.tap()
        
        XCTAssertEqual(app.alerts.count, 0, "Shoud not be alert on the screen")
    }
    
    // MARK: - Submit state successful
    func test_whenAllTextfieldsAreFilledAndnetworkCallSucceeds_shouldDismissTheView() {
        navigateToCreateView()
        
        let firstNameTextfield = app.textFields["first_name_text_field"]
        let lastNameTextfield = app.textFields["last_name_text_field"]
        let jobTextfield = app.textFields["job_text_field"]
        
        firstNameTextfield.tap()
        firstNameTextfield.typeText("John")
        
        lastNameTextfield.tap()
        lastNameTextfield.typeText("Doe")
        
        jobTextfield.tap()
        jobTextfield.typeText("Developer")
        
        let submitButton = app.buttons["submit_button"]
        XCTAssertTrue(submitButton.waitForExistence(timeout: 5), "Submit button should be displayed")
        
        submitButton.tap()
        
        let peopleViewHeader = app.navigationBars["People"]
        XCTAssertTrue(peopleViewHeader.waitForExistence(timeout: 5), "People header should be displayed")
    }
    
    // MARK: - Submit state unsuccessful
    func test_whenAllTextfieldsAreFilledAndnetworkCallFails_shouldPresentErrorAlert() {
        navigateToCreateView(networkingSuccess: "false")
        
        let firstNameTextfield = app.textFields["first_name_text_field"]
        let lastNameTextfield = app.textFields["last_name_text_field"]
        let jobTextfield = app.textFields["job_text_field"]
        
        firstNameTextfield.tap()
        firstNameTextfield.typeText("John")
        
        lastNameTextfield.tap()
        lastNameTextfield.typeText("Doe")
        
        jobTextfield.tap()
        jobTextfield.typeText("Developer")
        
        let submitButton = app.buttons["submit_button"]
        XCTAssertTrue(submitButton.waitForExistence(timeout: 5), "Submit button should be displayed")
        
        submitButton.tap()
        
        let alert = app.alerts.firstMatch
        XCTAssertTrue(alert.waitForExistence(timeout: 5), "Alert should be displayed")
        
        let alertMessage = alert.staticTexts["An error occurred: Invalid Status Code: 301"]
        XCTAssertTrue(alertMessage.waitForExistence(timeout: 5), "Alert message should be displayed")
        let retryButton = alert.buttons["Retry"]
        XCTAssertTrue(retryButton.waitForExistence(timeout: 5), "Retry button should be displayed")
        let cancelButton = alert.buttons["Cancel"]
        XCTAssertTrue(cancelButton.waitForExistence(timeout: 5), "Cancel button should be displayed")
        
        cancelButton.tap()
        
        XCTAssertEqual(app.alerts.count, 0, "Shoud not be alert on the screen")
    }
}
