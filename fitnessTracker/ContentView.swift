//
//  ContentView.swift
//  fitnessTracker
//
//  Created by Bipul Aryal on 10/16/24.
//

import SwiftUI
import Firebase


struct ContentView: View {
    let userId : String
    @EnvironmentObject var authProvider: AuthenticationProvider
    @StateObject var mainDataModel:MainDataModel
    
    
    init(userId: String) {
            self.userId = userId
            _mainDataModel = StateObject(wrappedValue: MainDataModel(userId: userId))
        }
    
    var body: some View {
        ZStack {
                    switch mainDataModel.isDataLoaded {
                        case .notStarted, .inProgress:
                            LoadingView() // Show loading spinner or placeholder
                                .onAppear {
                                    if mainDataModel.isDataLoaded == .notStarted {
                                        mainDataModel.loadUserData()
                                    }
                                }
                        case .success:
                            MainPageView()
                                .environmentObject(mainDataModel)
                        case .failure:
                            WelcomeView()
                                .environmentObject(mainDataModel)
                        }
                }
            }
        }

#Preview {
    ContentView(userId: "UUID()")
}
