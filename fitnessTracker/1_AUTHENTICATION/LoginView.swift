//
//  LoginView.swift
//  fitnessTracker
//
//  Created by Bipul Aryal on 10/29/24.
//

import SwiftUI
import GoogleSignInSwift
import GoogleSignIn

struct LoginView: View {
    @Binding var isLoginPage: Bool
    @EnvironmentObject var authProvider: AuthenticationProvider
    @Environment(\.colorScheme) var colorScheme
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var warning : String = ""
    private let titleFont = Font.custom("HelveticaNeue-Regular", size: 14)
    
    var body: some View {

            
            VStack{
                Image("trackmyProgressLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: .widthPer(per: 0.3) )
                
                Spacer()
                VStack {
                    Text("Sign In with your email and password")
                        .foregroundColor(Color("c_appSecondary")) // Adjusted for your color set
                        .padding(.bottom, 10)
                    // Email Text Field
                    Section{
                        Text("Email")
                            .font(titleFont)
                            .foregroundColor(Color("c_textPrimary"))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.bottom, 4)
                        CustomTextField(
                            text: $email,
                            keyboardType: .emailAddress
                        )
                    }
                    Section{
                        Text("Password")
                            .font(titleFont)
                            .foregroundColor(Color("c_textPrimary"))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        // Password Text Field
                        CustomTextField(
                            text: $password,
                            keyboardType: .default,
                            isPassword: true
                        )
                    }
                    CustomizableButton(
                        text: "Log In",
                        action: {
                            
                            if (password.count == 0 ||  email.count == 0 ){
                                if password.count == 0  {
                                    warning = "Password length can't be 0."
                                } else if email.count < 8 {
                                    warning = "Email length can't be 0."
                                }
                                return
                            }
                            Task {
                                do {
                                    try await authProvider.signInWithEmailPassword(email: email, password: password)
                                } catch {
                                    warning = "Error: \(error.localizedDescription)"
                                    print(warning)
                                    throw error
                                }
                            }
                        }
                    )
                }.padding()
                Spacer()
                VStack{
                    Text("Other Sign in Options")
                        .foregroundColor(Color("c_appSecondary")) // Adjusted for your color set
                    
                    GoogleSignInButton(viewModel: GoogleSignInButtonViewModel(scheme:colorScheme == .light ? .dark : .light, style:.wide, state:.normal))
                    {
                        Task{
                            do{
                                try await authProvider.googleSignIn()
                            }catch{
                                warning = "Error: \(error.localizedDescription)"
                                print(error)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 5)
                    
                    CustomizableButton(
                        text: "Sign Up instead",
                        buttonType: .secondary,
                        action: {
                            isLoginPage = false
                        }
                    ).padding()
                    Spacer()
                    if warning.count != 0{
                        Text(warning)
                            .foregroundColor(.red)
                    }
                }
                
                Spacer()
            }
        }
    
}
    //#Preview {
    //    LoginView( isLoginPage = true )
    //}

