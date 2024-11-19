//
//  CalorieProfileView.swift
//  fitnessTracker
//
//  Created by Bipul Aryal on 11/17/24.
//

import SwiftUI

struct CalorieProfileView: View {
    let calorieDetails: CalorieModel
    let editWeightAction: () -> Void
    let editGoalWeightAction: () -> Void
    let editActivityLevelAction: () -> Void
    let editWeeklyWeightChangeAction: () -> Void

       var body: some View {
           VStack(alignment: .leading) {
               HStack {
                   Text("Calories and Weights")
                       .font(.headline)
                       .foregroundColor(Color("c_textPrimary"))
                   
                   Spacer()
                   
                   Image(systemName: "fork.knife") // Food logo
                       .resizable()
                       .scaledToFit()
                       .frame(width: 20, height: 20)
                       .foregroundColor(Color("c_appSecondary"))
               }
               .padding()
               
               // Settings Rows
               SettingsInfoView(
                   title: "Weight",
                   value: "\(calorieDetails.currentWeight) lbs",
                   action: editWeightAction
               )
               
               SettingsInfoView(
                   title: "Goal Weight",
                   value: "\(calorieDetails.goalWeight) lbs",
                   action: editGoalWeightAction
               )
               
               SettingsInfoView(
                   title: "Activity Level",
                   value: "\(calorieDetails.activityLevel.rawValue)",
                   action: editActivityLevelAction
               )
               
               SettingsInfoView(
                title: "Weekly Weight Change",
                value: "\(String(format: "%.2f", calorieDetails.weightChangePerWeek)) lbs",
                action: editWeeklyWeightChangeAction
               )
           }
           .background(Color("c_greySecondary"))
           .cornerRadius(10)
           .shadow(radius: 3)
           .padding()
       }
}

//#Preview {
//    CalorieProfileView(
////        calorieDetails: CalorieModel(
////            userId: "UUID()",
////            goalWeight: 75.0,
////            currentWeight: 80.0,
////            dailyCalorieTarget: 2000,
////            maintainenceCalorieTarget: 2500,
////            weightGoalType: .lose,
////            activityLevel: .moderatelyActive,
////            weightChangePerWeek: 0.5
////        ),
//        editWeightAction: { print("Edit Weight Action Triggered") },
//        editGoalWeightAction: { print("Edit Goal Weight Action Triggered") },
////        editCalorieTargetAction: { print("Edit Calorie Target Action Triggered") },
//        editActivityLevelAction: { print("Edit Activity Level Action Triggered") },
//        editWeightGoalTypeAction: { print("Edit Weight Goal Type Action Triggered")},
//        editWeeklyWeightChangeAction: { print("Edit Calorie Target Action Triggered") }
//    )
//}
