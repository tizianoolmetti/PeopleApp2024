//
//  CreateValidator.swift
//  PeopleApp
//
//  Created by Tom Olmetti on 15/6/2024.
//

import Foundation

protocol CreateValidator {
    func validate(_ person: NewPerson) throws
}

struct CreateValidatorImpl: CreateValidator {
    func validate(_ person: NewPerson) throws {
        
        guard !person.firstName.isEmpty else {
            throw CreateValidatorError.invalidFirstName
        }
        
        guard !person.lastName.isEmpty else {
            throw CreateValidatorError.invalidLastName
        }
        
        guard !person.job.isEmpty else {
            throw CreateValidatorError.invalidJob
        }
    }
    
}

// MARK: - Create Validator Error

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
