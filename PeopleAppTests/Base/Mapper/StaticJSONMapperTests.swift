
//  StaticJSONMapperTests.swift
//  PeopleAppTests
//
//  Created by Tom Olmetti on 15/6/2024.
//

import Foundation
import XCTest

@testable import PeopleApp

class StaticJSONMapperTests: XCTestCase {
    
    func test_decode_whenFileFound_thenDecode() {
        // Arrange
        let validFileName = JSONOptionType.users
        // Act
        let result = try? StaticJSONMapper.decode(from: validFileName.rawValue, type: UserResponse.self)
        // Assert
        XCTAssertNoThrow(try? StaticJSONMapper.decode(from: validFileName.rawValue, type: UserResponse.self), "Should not throw error")
        XCTAssertEqual(result?.data.count, 6)
        XCTAssertEqual(result?.data.first?.id, 1)
        XCTAssertEqual(result?.data.first?.firstName, "George")
        XCTAssertEqual(result?.data.first?.lastName, "Bluth")
        XCTAssertEqual(result?.data.first?.avatar, "https://reqres.in/img/faces/1-image.jpg")
        XCTAssertEqual(result?.data.last?.id, 6)
        XCTAssertEqual(result?.data.last?.firstName, "Tracey")
        XCTAssertEqual(result?.data.last?.lastName, "Ramos")
        XCTAssertEqual(result?.data.last?.avatar, "https://reqres.in/img/faces/6-image.jpg")
        
    }
    
    func test_decode_whenFileNotFound_thenThrowFileNotFoundError() {
        // Arrange
        let invalidFileName = "invalidFileName"
        // Act and Assert
        XCTAssertThrowsError(try StaticJSONMapper.decode(from: invalidFileName, type: UserResponse.self)) {
            error in
            XCTAssertEqual(error as? StaticJSONMapperError, StaticJSONMapperError.fileNotFound)
        }
    }
    
    func test_decode_whenDecodingError_thenThrowDecodingError() {
        // Arrange
        let validFileName = JSONOptionType.users
        let invalidDecodingType = [User].self
        // Act and Assert
        XCTAssertThrowsError(try StaticJSONMapper.decode(from: validFileName.rawValue, type: invalidDecodingType)) {
            error in
            XCTAssertEqual(error as? StaticJSONMapperError, StaticJSONMapperError.decodingError)
        }
    }
}
