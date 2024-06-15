//
//  AlertModifier.swift
//  PeopleApp
//
//  Created by Tom Olmetti on 14/6/2024.
//

import SwiftUI

struct AlertModifier: ViewModifier {
    @Binding var isPresented: Bool
    var errorMessage: String?
    var retryAction: () -> Void
    var cancelAction: () -> Void

    func body(content: Content) -> some View {
        content
            .alert("Error", isPresented: $isPresented) {
                Button("Retry", role: .cancel, action: retryAction)
                Button("Cancel", role: .destructive, action: cancelAction)
            } message: {
                Text("An error occurred: \(errorMessage ?? "Unknown error")")
            }
            .onAppear{
                haptic(.error)
            }
    }
}

extension View {
    func errorAlert(isPresented: Binding<Bool>, errorMessage: String?, retryAction: @escaping () -> Void, cancelAction: @escaping () -> Void) -> some View {
        self.modifier(AlertModifier(isPresented: isPresented, errorMessage: errorMessage, retryAction: retryAction, cancelAction: cancelAction))
    }
}

