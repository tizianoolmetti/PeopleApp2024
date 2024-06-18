//
//  DetailsViewModel.swift
//  PeopleApp
//
//  Created by Tom Olmetti on 13/6/2024.
//

import SwiftUI

struct DetailsViewDataModel {
    var userInfo: UserDetailsResponse?
    var networkingError: HTTPClientError? = nil
    var viewState: ViewState = .none
}

final class DetailsViewModel: ObservableObject {
    
    // MARK: - Published
    @Published var dataModel = DetailsViewDataModel()
    
    // MARK: - Properties
    private let fetchUserDetailsUseCase: FetchUserDetailsUseCase
    
    // MARK: - Init
    init(fetchUserDetailsUseCase: FetchUserDetailsUseCase){
        self.fetchUserDetailsUseCase = fetchUserDetailsUseCase
    }
    
    // MARK: - Computed Properties
    var hasError: Binding<Bool> {
        Binding {
            self.dataModel.networkingError != nil
        } set: { newValue in
            if newValue == false {
                self.dataModel.networkingError = nil
            }
        }
    }
    
    // MARK: - View State
    var isLoading: Bool {
        dataModel.viewState == .loading
    }
    
    var isLoaded: Bool {
        dataModel.viewState == .loaded
    }
    
    var isLoadedWithError: Bool {
        dataModel.viewState == .loadedWithError
    }
    
    // MARK: - Functions
    
    // MARK: - Async/Await
    @MainActor
    func loadData(userId: Int) async {
        dataModel.viewState = .loading
        
        //Mock data
        //var userInfo: UserDetailsResponse?
        //userInfo = try? StaticJSONMapper.decode(from: JSONOptionType.singleUser.rawValue, type: UserDetailsResponse.self)
        
        do {
            let response: UserDetailsResponse = try await fetchUserDetailsUseCase.fetchUserDetails(userId: userId)
            dataModel.userInfo = response
            dataModel.viewState = .loaded
        } catch {
            dataModel.networkingError = error as? HTTPClientError
            dataModel.viewState = .loadedWithError
        }
    }
    
    // MARK: - Completion Handler
//    @MainActor
//    func loadData(userId: Int) {
//        dataModel.viewState = .loading
//        
//        //Mock data
//        //var userInfo: UserDetailsResponse?
//        //userInfo = try? StaticJSONMapper.decode(from: JSONOptionType.singleUser.rawValue, type: UserDetailsResponse.self)
//        
//        HTTPClient.shared.request(endpoint: .details(id: userId), type: UserDetailsResponse.self) { [weak self] result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let response):
//                    self?.dataModel.userInfo = response
//                    self?.dataModel.viewState = .loaded
//                case .failure(let error):
//                    self?.dataModel.networkingError = error as? HTTPClientError
//                    self?.dataModel.viewState = .loadedWithError
//                }
//            }
//        }
//    }
}
