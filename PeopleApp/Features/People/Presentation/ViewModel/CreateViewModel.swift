//
//  CreateViewModel.swift
//  iOSTakeHomeProject
//
//  Created by Tunde Adegoroye on 17/07/2022.
//

import SwiftUI

struct CreateViewDataModel {
    var newPerson: NewPerson = NewPerson()
    var formError: FormError? = nil
    var viewState: ViewState = .none
}

final class CreateViewModel: ObservableObject {
    
    // MARK: - Published
    @Published private(set) var dataModel = CreateViewDataModel()
    
    // MARK: - Properties
    private let createUserUseCase: CreateUserUseCase
    private let validator = CreateValidatorImpl()
    
    init(createUserUseCase: CreateUserUseCase){
        self.createUserUseCase = createUserUseCase
    }
    
    // MARK: - Computed Properties
    var firstName: Binding<String> {
        Binding {
            self.dataModel.newPerson.firstName
        } set: { newValue in
            self.dataModel.newPerson.firstName = newValue
        }
    }
    
    var lastName: Binding<String> {
        Binding {
            self.dataModel.newPerson.lastName
        } set: { newValue in
            self.dataModel.newPerson.lastName = newValue
        }
    }
    
    var job: Binding<String> {
        Binding {
            self.dataModel.newPerson.job
        } set: { newValue in
            self.dataModel.newPerson.job = newValue
        }
    }
    
    var hasError: Binding<Bool> {
        Binding {
            self.dataModel.formError != nil
        } set: { newValue in
            if newValue == false {
                self.dataModel.formError = nil
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
    
    // MARK: - Create Person
    
    // MARK: - Async/Await
    @MainActor
    func create() async {
        do {
            try validator.validate(dataModel.newPerson)
            
            dataModel.viewState = .loading
            let encoder = JSONEncoder()
            let data = try? encoder.encode(dataModel.newPerson)
            
            do {
                try await createUserUseCase.createUser(data: data)
                self.dataModel.viewState = .loaded
            } catch {
                self.dataModel.viewState = .loadedWithError
                if let unwrappedError = error as? HTTPClientError {
                    self.dataModel.formError = .networking(error: unwrappedError)
                }
            }
        } catch {
            self.dataModel.viewState = .loadedWithError
            switch error {
            case is HTTPClientError:
                self.dataModel.formError = .networking(error: error as! HTTPClientError)
            case is CreateValidatorError:
                self.dataModel.formError = .validation(error: error as! CreateValidatorError)
                haptic(.warning)
            default:
                self.dataModel.formError = .system(error: error)
            }
        }
    }
    
    // MARK: - Completion Handler
    @MainActor
    func create() {
        do {
            try validator.validate(dataModel.newPerson)
            
            dataModel.viewState = .loading
            let encoder = JSONEncoder()
            let data = try? encoder.encode(dataModel.newPerson)
            
            HTTPClient.shared.request(endpoint: .create(data: data) ) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success():
                        self?.dataModel.viewState = .loaded
                    case .failure(let error):
                        self?.dataModel.viewState = .loadedWithError
                        if let unwrappedError = error as? HTTPClientError {
                            self?.dataModel.formError = .networking(error: unwrappedError)
                        }
                    }
                }
            }
        } catch {
            self.dataModel.viewState = .loadedWithError
            switch error {
            case is HTTPClientError:
                self.dataModel.formError = .networking(error: error as! HTTPClientError)
            case is CreateValidatorError:
                self.dataModel.formError = .validation(error: error as! CreateValidatorError)
                haptic(.warning)
            default:
                self.dataModel.formError = .system(error: error)
            }
        }
    }
}

// MARK: - Form Error
enum FormError: LocalizedError {
    case networking(error: LocalizedError)
    case validation(error: LocalizedError)
    case system(error: Error)
    
    var errorDescription: String? {
        switch self {
        case .networking(let error),
                .validation(let error):
            return error.errorDescription
        case .system(let error):
            return error.localizedDescription
        }
    }
}

