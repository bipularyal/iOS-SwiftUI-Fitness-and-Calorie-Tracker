//
//  SignupView.swift
//  fitnessTracker
//
//  Created by Bipul Aryal on 11/12/24.
//

import SwiftUI
import GoogleSignInSwift
import GoogleSignIn

struct SignupView: View {
    @Binding var isLoginPage: Bool
    @EnvironmentObject var authProvider: AuthenticationProvider
    @Environment(\.colorScheme) var colorScheme
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var reEnteredPassword: String = ""
    @State private var name: String = ""
    let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}$"
    private var isEmailValid: Bool {
            NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
        }
    let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[!@#$&*]).{8,}$"
    private var isPasswordValid: Bool {
            NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
        }
    @State private var warning: String = ""
    private let titleFont = Font.custom("HelveticaNeue-Regular", size: 14)
    var body: some View {
            
            VStack{
                Image("trackmyProgressLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: .widthPer(per: 0.3) )
                
                Spacer()
                VStack {
                    Text("Sign Up with your email and password")
                        .foregroundColor(Color("c_appSecondary")) // Adjusted for your color set
                        .padding(.bottom, 10)
                    // Email Text Field
                    Section{
                        Text("Name")
                            .font(titleFont)
                            .foregroundColor(Color("c_textPrimary"))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.bottom, 4)
                        CustomTextField(
                            text: $name,
                            keyboardType: .emailAddress
                        )
                    }
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
                    Section{
                        Text("Re enter password")
                            .font(titleFont)
                            .foregroundColor( password != reEnteredPassword ? .red :Color("c_textPrimary"))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        // Password Text Field
                        CustomTextField(
                            text: $reEnteredPassword,
                            keyboardType: .default,
                            isPassword: true
                        )
                    }
                    
                    CustomizableButton(
                        text: "Sign Up",
                        action: {
                            if (password != reEnteredPassword || password.count < 8 || reEnteredPassword.count < 8 || !isEmailValid || !isPasswordValid ){
                                if password != reEnteredPassword {
                                    warning = "Passwords do not match."
                                    } else if password.count < 8 || reEnteredPassword.count < 8 {
                                        warning = "Password must be at least 8 characters long."
                                    } else if !isEmailValid {
                                        warning = "Please enter a valid email address."
                                    } else if !isPasswordValid {
                                        warning = "Password must contain at least one uppercase letter, one lowercase letter, one number, and one special character."
                                    }
                                return
                            }
                            Task {
                                do {
                                    try await authProvider.signUpWithEmailPassword(email: email, password: password, name: name)
                                } catch {
                                    warning = "Error: \(error)"
                                    print(error)
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
                                warning = "Error: \(error)"
                                print(error)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 5)
                    
                    CustomizableButton(
                        text: "I have an account",
                        buttonType:.secondary,
                        action: {
                            isLoginPage = true
                        }
                    ).padding(.horizontal)
                    if warning.count != 0{
                        Text(warning)
                            .foregroundColor(.red)
                    }
                    Spacer()
                }
                Spacer()
            }
        }
}

//#Preview {
//    SignupView()
//}
