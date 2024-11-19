//
//  MainPageView.swift
//  fitnessTracker
//
//  Created by Bipul Aryal on 10/29/24.
//

import SwiftUI

struct MainPageView: View {
    @State var selectedTab: Int = 0  // Bind the selected tab
    init() {
        let appearance = UITabBarAppearance()
        appearance.stackedItemPositioning = .centered
        appearance.stackedLayoutAppearance.normal.badgeTitlePositionAdjustment = UIOffset(horizontal: 0, vertical: 20)
        appearance.stackedLayoutAppearance.selected.iconColor = .blue
        UITabBar.appearance().standardAppearance = appearance
    }
    
    var body: some View {
        
       
        TabView(selection: $selectedTab) {
            CalorieTrackerView()
                .tabItem {
                    Label("Calories", systemImage: "fork.knife.circle.fill")
                }
                .tag(1)

            FitnessTrackerView()
                .tabItem {
                    Label("Workouts", systemImage: "dumbbell.fill")
                }
                .tag(3)
            
            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "list.bullet.clipboard")
                }
                .tag(0)  // Assign a tag to each tab

            
            AccountView()
                .tabItem {
                    Label("Account", systemImage: "person.crop.square.fill")
                }
                .tag(4)
        }
    }
}

//#Preview {
//    MainPageView()
//}
