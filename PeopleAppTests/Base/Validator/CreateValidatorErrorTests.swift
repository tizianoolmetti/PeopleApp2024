//
//  CreateValidatorErrorTests.swift
//  PeopleAppTests
//
//  Created by Tom Olmetti on 17/6/2024.
//

import Foundation

import XCTest

@testable import PeopleApp

final class CreateValidatorErrorTests: XCTestCase {
    
    func testInvalidFirstNameErrorDescription() {
          let error = CreateValidatorError.invalidFirstName
          XCTAssertEqual(error.errorDescription, "First name can't be empty")
      }

      func testInvalidLastNameErrorDescription() {
          let error = CreateValidatorError.invalidLastName
          XCTAssertEqual(error.errorDescription, "Last name can't be empty")
      }

      func testInvalidJobErrorDescription() {
          let error = CreateValidatorError.invalidJob
          XCTAssertEqual(error.errorDescription, "Job can't be empty")
      }
    
}
