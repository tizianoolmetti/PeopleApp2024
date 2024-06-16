//
//  PeopleView.swift
//  iOSTakeHomeProject
//
//  Created by Tunde Adegoroye on 25/06/2022.
//

import SwiftUI

struct PeopleView: View {
    
    // MARK: - StateObject
    @StateObject private var vm: PeopleViewModel
    
    // MARK: - Initializer
    init(vm: PeopleViewModel) { _vm = StateObject(wrappedValue: vm)}
    
    // MARK: - State
    @State private var showCheckmarkView = false
    
    // MARK: - Properties
    let columns = Array(repeating: GridItem(.flexible()), count: 2)
    
    // MARK: - Body
    var body: some View {
        ZStack {
            background
            contentView
        }
        .navigationTitle("People")
        .toolbar {
            ToolbarItem(placement: .primaryAction) { create }
        }
        .sheet(isPresented: vm.shouldShowCreate) {
            vm.navigateToCreate {
                haptic(.success)
                withAnimation(.spring().delay(0.25)) {
                    showCheckmarkView.toggle()
                }
            }
        }
        .onFirstAppear {
            Task {
                await vm.loadData()
            }
        }
        .errorAlert(
            isPresented: vm.hasError,
            errorMessage: vm.dataModel.networkingError?.localizedDescription,
            retryAction:  {
                Task {
                    await vm.loadData()
                }
            },
            cancelAction: { vm.hasError.wrappedValue = false }
        )
        .overlay{
            if showCheckmarkView {
                CheckmarkPopoverView()
                    .transition(.scale.combined(with: .opacity))
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            withAnimation(.spring().delay(2)) {
                                self.showCheckmarkView.toggle()
                            }
                        }
                    }
            }
        }
        .embedInNavigation()
    }
}

// MARK: - Views
private extension PeopleView {
    @ViewBuilder
    var background: some View {
        Theme.background
            .ignoresSafeArea(edges: .top)
    }
    
    @ViewBuilder
    var create: some View {
        Button {
            vm.showCreate()
        } label: {
            Symbols.plus
                .font(
                    .system(.headline, design: .rounded)
                    .bold()
                )
        }
        .disabled(vm.isLoading)
        .accessibilityIdentifier("createBtn")
    }
    
    @ViewBuilder
    var gridView: some View {
        ScrollView {
            LazyVGrid(columns: columns,
                      spacing: 16) {
                ForEach(vm.dataModel.users, id: \.id) { user in
                    NavigationLink {
                        vm.navigateToDetails(id: user.id)
                    } label: {
                        PersonItemView(user: user)
                            .accessibilityIdentifier("item_\(user.id)")
                            .task {
                                if vm.hasReachedEndOfList(user) && !vm.isFetching{
                                    await vm.loadNextPage()
                                }
                            }
                    }
                }
            }
                      .padding()
        }
        .refreshable { await vm.loadData() }
        .overlay(alignment:.bottom) {
            if vm.isFetching {
                ProgressView()
            }
        }
    }
    
    
    @ViewBuilder
    var contentView: some View {
        if vm.isLoading {
            ProgressView()
        } else {
            gridView
        }
    }
}

// MARK: - Preview
struct PeopleView_Previews: PreviewProvider {
    static var previews: some View {
        PeopleView(vm: AppDIContainer.shared.makePeopleViewModel())
    }
}
