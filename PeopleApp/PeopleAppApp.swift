//
//  PeopleAppApp.swift
//  PeopleApp
//
//  Created by Tom Olmetti on 13/6/2024.
//

import SwiftUI

@main
struct PeopleAppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            AppDIContainer.shared.rootView()
        }
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate {
    
   func application(_ application: UIApplication,didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
       
       #if DEBUG
       print("👨‍💻 is UI Testing = \(UITestingHelper.isUITesting)")
       #endif
       
       return true
    }
}
