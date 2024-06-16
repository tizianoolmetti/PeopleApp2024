//
//  CreateView.swift
//  iOSTakeHomeProject
//
//  Created by Tunde Adegoroye on 02/07/2022.
//

import SwiftUI

struct CreateView: View {
    
    // MARK: - Emvironment
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - StateObject
    @StateObject private var vm: CreateViewModel
    
    // MARK: - FocusState
    @FocusState private var focusedField: Field?
    
    // MARK: - Properties
    let successHandler: () -> Void?
    
    // MARK: - Initializer
    
    init(vm: CreateViewModel,
         successHandler: @escaping () -> Void = {}
    ) {
        _vm = StateObject(wrappedValue: vm)
        self.successHandler = successHandler
    }
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            Form {
                Section{
                    firstNameTextField
                    lastNameTextField
                    jobTextField
                } footer: {
                    if case .validation(let err) = vm.dataModel.formError,
                         let errorDesc = err.errorDescription {
                          Text(errorDesc)
                              .foregroundStyle(.red)
                      }
                }
               
                submitButton
            }
            .disabled(vm.isLoading)
            .navigationTitle("Create")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) { doneButton }
            }
            .onChange(of: vm.dataModel.viewState ) { oldViewState, newViewState in
                if newViewState == .loaded {
                    dismiss()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        successHandler()
                    }
                }
            }
            .errorAlert(
                isPresented: vm.hasError,
                errorMessage: vm.dataModel.formError?.localizedDescription,
                retryAction: { Task { await vm.create() } },
                cancelAction: { vm.hasError.wrappedValue = false }
            )
        }
    }
}

// MARK: - Views
private extension CreateView {
    @ViewBuilder
    var firstNameTextField: some View {
        TextField("First Name", text: vm.firstName)
            .focused($focusedField, equals: .firstName)
    }
    
    @ViewBuilder
    var lastNameTextField: some View {
        TextField("Last Name", text: vm.lastName)
            .focused($focusedField, equals: .lastName)
    }
    
    @ViewBuilder
    var jobTextField: some View {
        TextField("Job", text: vm.job)
            .focused($focusedField, equals: .job)
    }
    
    @ViewBuilder
    var submitButton: some View {
        Section {
            Button {
                Task { await vm.create() }
            } label: {
                if vm.isLoading {
                    ProgressView()
                } else {
                    Text("Submit")
                }
            }
            .disabled(vm.isLoading)
        }
    }
    
    @ViewBuilder
    var doneButton: some View {
        Button {
            dismiss()
        } label: {
            Text("Done")
        }
        .disabled(vm.isLoading)
    }
}

// MARK: - Preview
struct CreateView_Previews: PreviewProvider {
    static var previews: some View {
        CreateView(
            vm: AppDIContainer.shared.makeCreateViewModel(),
            successHandler: {}
        )
    }
}

extension CreateView {
    enum Field: Hashable {
        case firstName
        case lastName
        case job
    }
}
