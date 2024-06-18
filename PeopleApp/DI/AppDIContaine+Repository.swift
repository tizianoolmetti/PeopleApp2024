//
//  AppDIContaine+Repository.swift
//  MyPersonalWallt
//
//  Created by Tom Olmetti on 16/1/2023.
//

import Foundation

extension AppDIContainer {
    
    //MARK: - People Repository
    func makePeopleRepository() -> PeopleRepository {
        return PeopleRepositoryImpl(dataSource: makePeopleDataSource())
    }
}
