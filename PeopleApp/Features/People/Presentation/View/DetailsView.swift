//
//  DetailsView.swift
//  PeopleApp
//
//  Created by Tom Olmetti on 13/6/2024.
//

import SwiftUI

struct DetailsView: View {
    
    // MARK: - State Object
    @StateObject private var vm: DetailsViewModel
    
    // MARK: - Properties
    let userId: Int
    
    // MARK: - Initializer
    init(VM: DetailsViewModel, userId: Int) {
        _vm = StateObject(wrappedValue: VM)
        self.userId = userId
    }
    
    // MARK: - Body
    var body: some View {
        ZStack {
            background
            
            switch vm.dataModel.viewState {
            case .loaded:
                contentView
            case .loading:
                ProgressView()
            default:
                EmptyView()
            }
        }
        .ignoresSafeArea(edges: .bottom)
        .navigationTitle("Details")
        .task {
             await vm.loadData(userId: userId )
        }
        .errorAlert(
            isPresented: vm.hasError,
            errorMessage: vm.dataModel.networkingError?.localizedDescription,
            retryAction: {
                Task { await vm.loadData(userId: userId) }
            },
            cancelAction: {
                vm.hasError.wrappedValue = false
            })
    }
}

private extension DetailsView {
    @ViewBuilder
    var background: some View {
        Theme.background
            .ignoresSafeArea(edges: .top)
    }
    
    @ViewBuilder
    var avatar: some View {
        if let avatarAbsoluteString = vm.dataModel.userInfo?.data.avatar,
           let avatarUrl = URL(string: avatarAbsoluteString) {
            
            AsyncImage(url: avatarUrl) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 250)
                    .clipped()
                    .accessibilityIdentifier("user_image")
            } placeholder: {
                ProgressView()
                    .frame(height: 250)
                    .frame(maxWidth: .infinity)
            }
            .clipShape(RoundedRectangle(cornerRadius: 16,
                                        style: .continuous))
            
        }
    }
    
    @ViewBuilder
    var link: some View {
        
        if let supportAbsoluteString = vm.dataModel.userInfo?.support.url,
           let supportUrl = URL(string: supportAbsoluteString),
           let supportTxt = vm.dataModel.userInfo?.support.text {
            
            Link(destination: supportUrl) {
                
                VStack(alignment: .leading,
                       spacing: 8) {
                    
                    Text(supportTxt)
                        .foregroundColor(Theme.text)
                        .font(
                            .system(.body, design: .rounded)
                            .weight(.semibold)
                        )
                        .multilineTextAlignment(.leading)
                    
                    Text(supportAbsoluteString)
                }
                
                Spacer()
                
                Symbols
                    .link
                    .font(.system(.title3, design: .rounded))
                
            }
            
        }
    }
    
    @ViewBuilder
    var contentView: some View {
        ScrollView {
            VStack(alignment: .leading,
                   spacing: 18) {
                
                avatar
                
                Group {
                    general
                    link
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 18)
                .background(Theme.detailBackground, in: RoundedRectangle(cornerRadius: 16,
                                                                         style: .continuous))
                
            }
                   .padding()
                   .padding(.bottom, 48)
        }
    }
}

private extension DetailsView {
    
    var general: some View {
        VStack(alignment: .leading,
               spacing: 8) {
            
            PillView(id: vm.dataModel.userInfo?.data.id ?? 0)
            
            Group {
                firstname
                lastname
                email
            }
            .foregroundColor(Theme.text)
        }
    }
    
    @ViewBuilder
    var firstname: some View {
        Text("First Name")
            .font(
                .system(.body, design: .rounded)
                .weight(.semibold)
            )
        
        Text( vm.dataModel.userInfo?.data.firstName ?? "-")
            .font(
                .system(.subheadline, design: .rounded)
            )
        
        Divider()
    }
    
    @ViewBuilder
    var lastname: some View {
        Text("Last Name")
            .font(
                .system(.body, design: .rounded)
                .weight(.semibold)
            )
        
        Text( vm.dataModel.userInfo?.data.lastName ?? "-")
            .font(
                .system(.subheadline, design: .rounded)
            )
        
        Divider()
    }
    
    @ViewBuilder
    var email: some View {
        Text("Email")
            .font(
                .system(.body, design: .rounded)
                .weight(.semibold)
            )
        
        Text(vm.dataModel.userInfo?.data.email ?? "-")
            .font(
                .system(.subheadline, design: .rounded)
            )
    }
}

#Preview {
    DetailsView(VM: AppDIContainer.shared.makeDetailsViewModel(), userId: 1)
}
