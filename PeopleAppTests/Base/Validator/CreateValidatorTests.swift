//
//  CreateValidatorTests.swift
//  PeopleAppTests
//
//  Created by Tom Olmetti on 15/6/2024.
//

import Foundation
import XCTest

@testable import PeopleApp

class CreateValidatorTests: XCTestCase {
    
    var sut: CreateValidator!
    
    override func setUp() {
        sut = CreateValidatorImpl()
    }
    
    override func tearDown() {
        sut = nil
    }
    
    func test_validate_whenFirstNameIsEmpty_shouldThrowInvalidFirstNameError() {
        let newPerson = NewPerson(firstName: "", lastName: "Doe", job: "Developer")
        
        XCTAssertThrowsError(try sut.validate(newPerson)) { error in
            XCTAssertEqual(error as? CreateValidatorError, CreateValidatorError.invalidFirstName)
        }
    }
    
    func test_validate_whenLastNameIsEmpty_shouldThrowInvalidLastNameError() {
        let newPerson = NewPerson(firstName: "John", lastName: "", job: "Developer")
        
        XCTAssertThrowsError(try sut.validate(newPerson)) { error in
            XCTAssertEqual(error as? CreateValidatorError, CreateValidatorError.invalidLastName)
        }
    }
    
    func test_validate_whenJobIsEmpty_shouldThrowInvalidJobError() {
        let newPerson = NewPerson(firstName: "John", lastName: "Doe", job: "")
        
        XCTAssertThrowsError(try sut.validate(newPerson)) { error in
            XCTAssertEqual(error as? CreateValidatorError, CreateValidatorError.invalidJob)
        }
    }
    
    func test_validate_whenAllFieldsAreNotEmpty_shouldNotThrowError() {
        let newPerson = NewPerson(firstName: "John", lastName: "Doe", job: "Developer")
        
        XCTAssertNoThrow(try sut.validate(newPerson))
    }
    
}
