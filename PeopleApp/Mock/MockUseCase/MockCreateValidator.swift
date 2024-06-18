//
//  MockCreateValidator.swift
//  PeopleApp
//
//  Created by Tom Olmetti on 18/6/2024.
//

import Foundation

final class MockCreateValidator: CreateValidator {
    
    var result: Result<Void, CreateValidatorError>?
    
    func validate(_ person: NewPerson) throws {
        switch result {
            case .success:
                break
            case .failure(let error):
                throw error
            case .none:
                fatalError("Result not set")
        }
    }
}

