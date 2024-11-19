//
//  FitnessProfileView.swift
//  fitnessTracker
//
//  Created by Bipul Aryal on 11/17/24.
//

import SwiftUI

import SwiftUI

struct FitnessProfileView: View {
    let fitnessDetails: FitnessModel
    let editWeeklyWorkoutGoalAction: () -> Void

    var body: some View {
        VStack(alignment: .leading) {
            // Header
            HStack {
                Text("Fitness and Goals")
                    .font(.headline)
                    .foregroundColor(Color("c_textPrimary"))
                
                Spacer()
                
                Image(systemName: "figure.walk") // Fitness icon
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor(Color("c_appSecondary"))
            }
            .padding()
            
            SettingsInfoView(
                title: "Weekly Workout Goal",
                value: "\(fitnessDetails.weeklyWorkoutGoal) workouts/week",
                action: editWeeklyWorkoutGoalAction
            )
        }
        .background(Color("c_greySecondary"))
        .cornerRadius(10)
        .shadow(radius: 3)
        .padding()
    }
}

#Preview {
    FitnessProfileView(
        fitnessDetails: FitnessModel(
            userId: "UUID()",
            fitnessLevel: .intermediate,
            weeklyWorkoutGoal: 4
        ),
        editWeeklyWorkoutGoalAction: { print("Edit Weekly Workout Goal Action Triggered") }
    )
}
