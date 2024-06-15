//
//  PeopleViewModel.swift
//  iOSTakeHomeProject
//
//  Created by Tunde Adegoroye on 02/07/2022.
//

import SwiftUI

// MARK: - PeopleViewDataModel
struct PeopleViewDataModel {
    var users = [User]()
    var shouldShowCreate = false
    var networkingError: HTTPClientError?
    var viewState: ViewState = .none
}

// MARK: - PeopleViewModel
final class PeopleViewModel: ObservableObject {
    
    // MARK: - Published
    @Published private(set) var dataModel = PeopleViewDataModel()
    
    // MARK: - Properties
    private var page: Int = 1
    private var totalPage: Int?
    
    // MARK: - Computed Properties
    var shouldShowCreate: Binding<Bool> {
        Binding {
            self.dataModel.shouldShowCreate
        } set: { newValue in
            self.dataModel.shouldShowCreate = newValue
        }
    }
    
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
    
    var isFetching: Bool {
        dataModel.viewState == .isFetching
    }
    
    // MARK: - Async/Await
    @MainActor
    func loadData() async {
        dataModel.viewState = .loading
        
        //Mock data
//      dataModel.users = try! StaticJSONMapper.decode(from: JSONOptionType.users.rawValue, type: UserResponse.self).data
        
        do {
            let response = try await HTTPClient.shared.request(endpoint: .people(page: page), type: UserResponse.self)
            dataModel.users = response.data
            totalPage = response.totalPages
            dataModel.viewState = .loaded
        } catch {
            dataModel.networkingError = error as? HTTPClientError
            dataModel.viewState = .loadedWithError
        }
    }
    
    // MARK: - Completion Handler
    func load() {
        dataModel.viewState = .loading
        
        //Mock data
//       dataModel.users = try! StaticJSONMapper.decode(from: JSONOptionType.users.rawValue, type: UserResponse.self).data
        
        HTTPClient.shared.request(endpoint: .people(page: page), type: UserResponse.self) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self?.dataModel.users = response.data
                    self?.totalPage = response.totalPages
                    self?.dataModel.viewState = .loaded
                case .failure(let error):
                    self?.dataModel.networkingError = error as? HTTPClientError
                    self?.dataModel.viewState = .loadedWithError
                }
            }
        }
    }
    
    @MainActor
    func loadNextPage() async {
        guard page != totalPage else { return }
        dataModel.viewState = .isFetching
        defer { dataModel.viewState = .loaded }
        page += 1
        
        do {
            let response = try await HTTPClient.shared.request(endpoint: .people(page: page), type: UserResponse.self)
            dataModel.users += response.data
            dataModel.viewState = .loaded
        } catch {
            dataModel.networkingError = error as? HTTPClientError
            dataModel.viewState = .loadedWithError
        }
    }
    
    func showCreate() {
        dataModel.shouldShowCreate = true
    }
    
    
    func hasReachedEndOfList(_ user: User) -> Bool {
        guard let lastuser = dataModel.users.last else { return false }
        return user.id == lastuser.id
    }
}
