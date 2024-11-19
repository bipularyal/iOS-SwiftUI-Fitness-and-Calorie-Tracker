//
//  WorkoutDetailsView.swift
//  fitnessTracker
//
//  Created by Bipul Aryal on 12/11/24.
//

import SwiftUI

struct WorkoutDetailsView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink(destination: CategoryListView(categoryType: .force)) {
                    CategoryRow(title: "Force", iconName: "arrow.triangle.2.circlepath")
                }
                NavigationLink(destination: CategoryListView(categoryType: .level)) {
                    CategoryRow(title: "Level", iconName: "star.fill")
                }
                NavigationLink(destination: CategoryListView(categoryType: .mechanic)) {
                    CategoryRow(title: "Mechanic", iconName: "gearshape.fill")
                }
                NavigationLink(destination: CategoryListView(categoryType: .equipment)) {
                    CategoryRow(title: "Equipment", iconName: "hammer.fill")
                }
                NavigationLink(destination: CategoryListView(categoryType: .primaryMuscles)) {
                    CategoryRow(title: "Primary Muscles", iconName: "figure.strengthtraining.traditional")
                }
                NavigationLink(destination: CategoryListView(categoryType: .secondaryMuscles)) {
                    CategoryRow(title: "Secondary Muscles", iconName: "figure.cooldown")
                }
                NavigationLink(destination: CategoryListView(categoryType: .category)) {
                    CategoryRow(title: "Category", iconName: "chart.bar.fill")
                }
            }
            .navigationTitle("Workout Details")
        }
    }
}

struct CategoryRow: View {
    let title: String
    let iconName: String // SF Symbol or custom asset name

    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .foregroundColor(.accentColor)

            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
        }
    }
}

#Preview {
    WorkoutDetailsView()
}
