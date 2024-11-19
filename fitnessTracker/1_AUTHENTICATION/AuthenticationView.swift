//
//  AuthenticationView.swift
//  fitnessTracker
//
//  Created by Bipul Aryal on 11/12/24.
//

import SwiftUI

public struct AuthenticationView:View {
    @State private var isLoginPage = true // Tracks which page to show
        
        public var body: some View {
            VStack {
                if isLoginPage {
                    LoginView(isLoginPage: $isLoginPage)
                } else {
                    SignupView(isLoginPage: $isLoginPage)
                }
            }
        }
}
