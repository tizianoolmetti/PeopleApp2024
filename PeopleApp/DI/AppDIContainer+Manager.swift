//
//  AppDIContainer+Manager.swift
//  PeopleApp
//
//  Created by Tom Olmetti on 18/6/2024.
//

import Foundation

extension AppDIContainer {
    
    // MARK: - People Manager
    func makeCreateValidator() -> CreateValidator {
        return CreateValidatorImpl()
    }
}
//snfkjs
