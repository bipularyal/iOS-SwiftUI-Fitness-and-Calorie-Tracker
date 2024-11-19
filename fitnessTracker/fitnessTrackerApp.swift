//
//  fitnessTrackerApp.swift
//  fitnessTracker
//
//  Created by Bipul Aryal on 10/16/24.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
    }
    
    func application(_ app: UIApplication,
             open url: URL,
             options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
    return GIDSignIn.sharedInstance.handle(url)
    }
}

@main
struct fitnessTrackerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var authProvider = AuthenticationProvider()

    
    var body: some Scene {
        WindowGroup {
            if authProvider.userSession == nil {
                AuthenticationView()
                    .environmentObject(authProvider)
            }
            else{
                let userId = authProvider.userId!
                NavigationView {
                    ContentView(userId: userId)
                        .environmentObject(authProvider)
                }
            }
        }
    }
}
