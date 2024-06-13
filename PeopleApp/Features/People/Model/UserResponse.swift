//
//  UserResponse.swift
//  PeopleApp
//
//  Created by Tom Olmetti on 13/6/2024.
//
import Foundation

// MARK: - UserResponse
struct UserResponse: Codable {
    let page, perPage, total, totalPages: Int
    let data: [User]
    let support: Support
}
