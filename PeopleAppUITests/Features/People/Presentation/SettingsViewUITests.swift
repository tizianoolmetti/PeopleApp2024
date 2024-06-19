//
//  SettingsViewUITests.swift
//  PeopleAppUITests
//
//  Created by Tom Olmetti on 19/6/2024.
//

import XCTest

final class SettingsViewUITests: XCTestCase {

    private var app: XCUIApplication!
    
    // MARK: - Setup & Teardown
    override func setUp() {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDown() {
        app = nil
    }
    
    func test_settingsView_whenTappingOnSettingsButton_shouldNavigateToSettingsView() {
        app.buttons["Settings"].tap()
        
        let settingNavBarTitle = app.navigationBars["Settings"]
        XCTAssertTrue(settingNavBarTitle.exists, "The settings view should be visible")
        
        let toogle = app.switches["haptics_toggle"]
        XCTAssertTrue(toogle.exists, "The haptics toggle should be visible")
        
        let hapticsLabel = app.staticTexts["Enable Haptics"]
        XCTAssertTrue(hapticsLabel.exists, "The haptics label should be visible")
        
        // Check if the toggle switch is on or off
        let isToggleOn = toogle.value as! String == "1"
        XCTAssertTrue(isToggleOn, "The haptics toggle should be on")
        
        toogle.tap()
        
        // Check if the toggle switch is on or off
        let isToggleOff = toogle.value as! String == "0"
        XCTAssertFalse(isToggleOff, "The haptics toggle should be off")
        
        toogle.tap()
        
        // Check if the toggle switch is on or off
        let isToggleOnAgain = toogle.value as! String == "1"
        XCTAssertTrue(isToggleOnAgain, "The haptics toggle should be on")
    }
}
