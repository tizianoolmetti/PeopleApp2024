//
//  User.swift
//  PeopleApp
//
//  Created by Tom Olmetti on 13/6/2024.
//

import Foundation

// MARK: - User
struct User: Codable, Equatable {
    let id: Int
    let email, firstName, lastName: String
    let avatar: String
}
