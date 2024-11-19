//
//  GoogleAuthenticationViewModel.swift
//  fitnessTracker
//
//  Created by Bipul Aryal on 10/29/24.
//

import FirebaseCore
import FirebaseAuth
import GoogleSignIn


enum AuthenticationErrors: Error {
    case googleClientIdNotFound
    case rootViewControllerNotFound
    case googleSignInTokenNotFound
    case appleSignInTokenNotFound
}

enum AuthenticationState{
    case authenticationSucceeded
    case authenticationFailed
    case authenticationPending
    case authenticationStarted
    
}

final class AuthenticationProvider: ObservableObject {
    
    private(set) var userId: String?
    @Published
    private(set) var userSession: User?
    private(set) var authenticationState = AuthenticationState.authenticationPending

    init() {
        // Check current auth state on app launch
        self.authenticationState = AuthenticationState.authenticationPending
        Task {
            self.userSession = Auth.auth().currentUser
            self.userId = self.userSession?.uid
            
        }
    }
    
    
    @MainActor
    func signOut() async throws{
        try Auth.auth().signOut()
        self.userSession = nil
        self.userId = nil
    }
    
    
    @MainActor
    func signInWith(credential:AuthCredential) async throws{
        let authResult = try await Auth.auth().signIn(with: credential)
        //        if authResult {
        self.userSession = authResult.user
        self.userId = self.userSession?.uid
        print(userId, userSession, " pritned something")

        //        }
    }
    
    @MainActor
    func googleSignIn()  async throws{
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            throw AuthenticationErrors.googleClientIdNotFound
        }
        
        guard let rootViewController = Utilities.shared.getRootViewController() else { throw AuthenticationErrors.rootViewControllerNotFound }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        // Start the sign in flow!
        let googleSignInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting:rootViewController)
        
        
        let user = googleSignInResult.user
        guard let idToken = user.idToken?.tokenString else {
            throw AuthenticationErrors.googleSignInTokenNotFound
        }
        let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                       accessToken: user.accessToken.tokenString)
        
        try await signInWith(credential: credential)
    }
    
    @MainActor
    func appleSignIn() async throws -> UserDataModel? {
        throw AuthenticationErrors.appleSignInTokenNotFound
    }
    
    @MainActor
    func signUpWithEmailPassword(email: String, password: String, name:String) async throws {
        
        let response = try await Auth.auth().createUser(withEmail: email, password: password)

        let user = response.user

        let changeRequest = user.createProfileChangeRequest()
        changeRequest.displayName = name
        try await changeRequest.commitChanges()
        self.userSession = user
        self.userId = self.userSession?.uid
    }
    
    @MainActor
    func signInWithEmailPassword(email: String, password: String) async throws {

            let response = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = response.user
            self.userId = self.userSession?.uid

    }
}

