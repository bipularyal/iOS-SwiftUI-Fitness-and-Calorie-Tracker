//
//  WelcomeView.swift
//  fitnessTracker
//
//  Created by Bipul Aryal on 11/17/24.
//

import SwiftUI

struct WelcomeView: View {
    @State private var currentStep = 0
    @EnvironmentObject var authProvider: AuthenticationProvider
    @EnvironmentObject var mainDataModel: MainDataModel
    // Data Bindings
    @State private var age: Int = 25
    @State private var weight: Double = 150.0
    @State private var goalWeight: Double = 140.0
    @State private var activityLevel: ActivityLevel = .lightlyActive
    @State private var weeklyWeightChangeGoal: Double = 0.75
    @State private var weeklyWorkoutGoal: Int = 3
    @State private var gender: String = "Male"
    @State private var heightFeet: Int = 5
    @State private var heightInches: Int = 10
    // Steps Enum
    enum Step: Int, CaseIterable {
        case age
        case gender
        case height
        case weight
        case goalWeight
        case activityLevel
        case weightChangeGoal
        case workoutGoal
        case done
    }

    
    @ViewBuilder
       private func currentView(for step: Step) -> some View {
           switch step {
               
           case .age:
               AgeSetterView(age: $age) {
                   handleDoneOrNextButtonClick() // Call incrementCounter for this step
               }
           case .gender:
               GenderSetterView(gender:$gender) {
                   handleDoneOrNextButtonClick() // Call incrementCounter for this step
               }
           case .height:
               HeightSetterView(feet: $heightFeet, inches: $heightInches) {
                   handleDoneOrNextButtonClick() // Call incrementCounter for this step
               }
           case .weight:
               WeightSetterView(displayText: "Enter your current weight", weight: $weight) {
                   handleDoneOrNextButtonClick() // Call incrementCounter for this step
               }
           
           case .goalWeight:
               WeightSetterView(displayText: "Enter your goal weight", weight: $goalWeight) {
                   handleDoneOrNextButtonClick() // Call incrementCounter for this step
               }
           case .activityLevel:
               ActivityLevelSetterView(activityLevel: $activityLevel) {
                   handleDoneOrNextButtonClick() // Call incrementCounter for this step
               }
           case .weightChangeGoal:
               WeeklyWeightChangeGoalView(
                   weightChangeGoalType: weight < goalWeight ? .gain : .lose,
                   weightChangeGoal: $weeklyWeightChangeGoal
               ) {
                   handleDoneOrNextButtonClick() // Call incrementCounter for this step
               }
           case .workoutGoal:
               WeeklyWorkoutGoalView(weeklyWorkoutGoal: $weeklyWorkoutGoal) {
                   handleDoneOrNextButtonClick() // Call incrementCounter for this step
               }
           case .done:
               
               DoneView(
                name: authProvider.userSession?.displayName ?? "John Doe",
                email: authProvider.userSession?.email ?? "randomEmail@gmail.com",
                gender: gender,
                age: age,
                weight: weight,
                goalWeight: goalWeight,
                heightFeet: heightFeet,
                heightInches: heightInches,
                maintainenceCalorieTarget: calculateMaintenanceCalories(weight: weight, height: Double(((heightFeet * 12) + heightInches)), age: age, gender: gender, activityLevel: activityLevel),
                goalCalorieTarget: calculateDailyCalorieTarget(weightChangePerWeek: weeklyWeightChangeGoal, maintainenceCalorieTarget:calculateMaintenanceCalories(weight: weight, height: Double(((heightFeet * 12) + heightInches)), age: age, gender: gender, activityLevel: activityLevel), weightGoalType:  weight < goalWeight ? .gain : .lose),
                activityLevel: activityLevel,
                weeklyWeightChangeGoal: weeklyWeightChangeGoal,
                weeklyWorkoutGoal: weeklyWorkoutGoal
               )
           }
       }

    
    private func calculateMaintenanceCalories(weight: Double, height: Double, age: Int, gender: String, activityLevel: ActivityLevel) -> Double {
        var bmr = 0.0
        if gender.lowercased() == "male" {
            bmr = 66.47 + (6.24 * weight) + (12.7 * height) - (6.76 * Double(age))
        } else if gender.lowercased() == "female" {
            bmr = 65.51 + (4.34 * weight) + (4.7 * height) - (4.7 * Double(age))
        } else {
            // Average of male and female BMR formulas
            bmr = (66.47 + (6.24 * weight) + (12.7 * height) - (6.76 * Double(age))
                 + 65.51 + (4.34 * weight) + (4.7 * height) - (4.7 * Double(age))) / 2
        }
        return bmr * activityLevel.activityMultiplier
    }

    private func calculateDailyCalorieTarget(weightChangePerWeek: Double, maintainenceCalorieTarget: Double, weightGoalType: WeightGoalType) -> Double {
        let weeklyCalorieAdjustment = weightChangePerWeek * 3500
        let dailyAdjustment = weeklyCalorieAdjustment / 7.0

        return weightGoalType == .gain
            ? maintainenceCalorieTarget + dailyAdjustment
            : maintainenceCalorieTarget - dailyAdjustment
    }
    
    private func handleDoneOrNextButtonClick() {
        
            if currentStep < Step.allCases.count - 1 {
                currentStep += 1
            } else {
                let calorieModel = CalorieModel(
                    userId: authProvider.userSession?.uid ?? "",
                    goalWeight: goalWeight,
                    currentWeight: weight,
                    height: Double(heightFeet * 12 + heightInches), // Height in inches
                    age: age,
                    gender: gender,
                    activityLevel: activityLevel,
                    weightChangePerWeek: weeklyWeightChangeGoal,
                    weightGoalType: goalWeight > weight ? .gain : .lose
                )

                // Initialize FitnessModel
                let fitnessModel = FitnessModel(
                    userId: authProvider.userSession?.uid ?? "",
                    fitnessLevel: .intermediate, // Placeholder: Add logic to set this based on user input
                    weeklyWorkoutGoal: weeklyWorkoutGoal
                )

                // Initialize UserModel
                let userModel = UserModel(
                    userId: authProvider.userSession?.uid ?? "",
                    email: authProvider.userSession?.email ?? "randomEmail@gmail.com",
                    phoneNumber: nil, // Placeholder: Update if the phone number is captured later
                    age: age,
                    sex: gender,
                    height: HeightModel(feet: heightFeet, inches: heightInches),
                    name: authProvider.userSession?.displayName ?? "John Doe",
                    profilePic: authProvider.userSession?.photoURL ?? nil
                )
                print(userModel, fitnessModel, calorieModel)
                Task {
                        DispatchQueue.main.async {
                            mainDataModel.saveUserData(user: userModel)
                           mainDataModel.saveCalorieData(calorie: calorieModel)
                           mainDataModel.saveFitnessData(fitness: fitnessModel)
                        }
                }
               
                
            }
        }
    
    private func decrementCounter() {
        if currentStep > 0 {
            currentStep -= 1
        }
    }

    var body: some View {
        VStack {
            // Current View
            currentView(for: Step.allCases[currentStep])
                .frame(maxHeight: .infinity)
            // Navigation Buttons
            HStack {
                // Back Button
                Button(action: {
                    decrementCounter()
                }) {
                    Text("Back")
                        .padding()
                        .foregroundColor(currentStep > 0 ? Color("c_appPrimary") : Color.gray)
                }
                .disabled(currentStep == 0)

                Spacer()

                // Next/Done Button
                Button(action: {
                    handleDoneOrNextButtonClick()
                }) {
                    Text(currentStep < Step.allCases.count - 1 ? "Next" : "Done")
                        .padding()
                        .foregroundColor(Color("c_appPrimary"))
                }
            }
            .padding(.horizontal)
            
        }
        .animation(.easeInOut, value: currentStep)
    }
}
