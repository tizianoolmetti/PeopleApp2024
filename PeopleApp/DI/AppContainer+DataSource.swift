//
//  AppContainer+DataSource.swift
//  MyPersonalWallt
//
//  Created by Tom Olmetti on 16/1/2023.
//

import Foundation
extension AppDIContainer {
    //MARK: - People Data Source
    func makePeopleDataSource() -> PeopleDataSource {
        return PeopleDataSourceImpl()
    }
}
