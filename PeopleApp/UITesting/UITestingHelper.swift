//
//  UITestingHelper.swift
//  PeopleApp
//
//  Created by Tom Olmetti on 18/6/2024.
//
#if DEBUG

import Foundation

enum UiTestingIdentifier: String {
    case uiTesting = "-UI-Testing"
    case peopleNetworkingSuccess = "-People-Networking-success"
    case detailsNetworkingSuccess = "-Details-Networking-success"
}

struct UITestingHelper {
    
    static var isUITesting: Bool {
        return ProcessInfo.processInfo.arguments.contains(UiTestingIdentifier.uiTesting.rawValue)
    }
    
    static var isPeopleNetworkingSuccess: Bool {
        return ProcessInfo.processInfo.environment[UiTestingIdentifier.peopleNetworkingSuccess.rawValue] == "true"
    }
    
    static var isDetailsNetworkingSuccess: Bool {
        return ProcessInfo.processInfo.environment[UiTestingIdentifier.detailsNetworkingSuccess.rawValue] == "true"
    }
}

#endif
