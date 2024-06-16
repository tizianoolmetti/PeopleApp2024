//
//  AddDIContainer+UseCase.swift
//  MyPersonalWallt
//
//  Created by Tom Olmetti on 16/1/2023.
//

import Foundation

extension AppDIContainer {
    
    //MARK: - People
    func makeFetchPeopleUseCase() -> FetchPeopleUseCase {
        return FetchPeopleUseCaseImpl(repository: makePeopleRepository())
    }
    
    func makeFetchUserDetailsUseCase() -> FetchUserDetailsUseCase {
        return FetchUserDetailsUseCaseImpl(repository: makePeopleRepository())
    }
    
    func makeCreateUserUseCase() -> CreateUserUseCase {
        return CreateUserUseCaseImpl(repository: makePeopleRepository())
    }
}
