//
//  WeightTrackerView.swift
//  fitnessTracker
//
//  Created by Bipul Aryal on 10/29/24.
//

import SwiftUI

struct DashboardView: View {
    var body: some View {
            TabView {
                WorkoutDetailsView()
                    .tabItem {
                        Label("Workout Details", systemImage: "list.bullet")
                    }

                YourProgressView()
                    .tabItem {
                        Label("Your Progress", systemImage: "chart.bar.fill")
                    }
            }
        }
}

#Preview {
    DashboardView()
}
