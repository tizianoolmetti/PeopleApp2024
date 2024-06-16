//
//  UserDetailsResponse.swift
//  PeopleApp
//
//  Created by Tom Olmetti on 13/6/2024.
//

import Foundation

// MARK: - UserDetailsResponse
struct UserDetailsResponse: Codable {
    let data: User
    let support: Support
}
