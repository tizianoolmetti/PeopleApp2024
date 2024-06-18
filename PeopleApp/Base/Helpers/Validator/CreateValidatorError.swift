//
//  CreateValidatorError.swift
//  PeopleApp
//
//  Created by Tom Olmetti on 17/6/2024.
//

import Foundation

enum  CreateValidatorError: LocalizedError {
    case invalidFirstName
    case invalidLastName
    case invalidJob
    
    var errorDescription: String? {
        switch self {
        case .invalidFirstName:
            return "First name can't be empty"
        case .invalidLastName:
            return "Last name can't be empty"
        case .invalidJob:
            return "Job can't be empty"
        }
    }
}

