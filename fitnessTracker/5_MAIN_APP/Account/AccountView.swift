//
//  AccountView.swift
//  fitnessTracker
//
//  Created by Bipul Aryal on 10/29/24.
//

import SwiftUI

struct AccountView: View {
    @EnvironmentObject var mainDataModel: MainDataModel
    @State private var activeSheet: ActiveSheet? // Track the active sheet
        
        enum ActiveSheet: Identifiable {
            case weight, goalWeight, activityLevel, weeklyWeightChange, userProfile, workoutGoal
            
            var id: Int {
                hashValue
            }
        }
    @State var weight: Double = 150
    @State var goalWeight: Double =  170
    @State var activityLevel : ActivityLevel = .sedentary
    @State var weeklyWeightChange: Double = 0.0
    @State var workoutGoal: Int = 0
    @State private var tempCalorieProfile: CalorieModel?
    @State private var tempFitnessProfile: FitnessModel?
    @State private var tempUserProfile: UserModel?
    
    func updateCalories(){
        
        let someCalorieModel = CalorieModel(
                userId: mainDataModel.calorieProfile!.userId,
               goalWeight: goalWeight,
               currentWeight: weight,
               height: Double(mainDataModel.userProfile!.height.feet * 12 + mainDataModel.userProfile!.height.inches), // Convert height to inches
               age: mainDataModel.userProfile!.age,
               gender: mainDataModel.userProfile!.sex,
               activityLevel: activityLevel,
               weightChangePerWeek: weeklyWeightChange,
               weightGoalType: goalWeight > weight ? .gain : .lose
           )
        mainDataModel.saveCalorieData(calorie: someCalorieModel)
    }
    func updateProfile(){
        mainDataModel.saveUserData(user: tempUserProfile!)
    }
    
    func updateFitness(){
        let someFitnessModel = FitnessModel(
            userId:mainDataModel.fitnessProfile?.userId ?? ""
            , fitnessLevel: mainDataModel.fitnessProfile?.fitnessLevel ?? .advanced,
            weeklyWorkoutGoal: workoutGoal
        )
        mainDataModel.saveFitnessData(fitness: someFitnessModel)
    }
    
    func revertTempData(){
        tempCalorieProfile = CalorieModel(
            userId: mainDataModel.calorieProfile?.userId ?? "",
            goalWeight: mainDataModel.calorieProfile?.goalWeight ?? 0.0,
            currentWeight: mainDataModel.calorieProfile?.currentWeight ?? 0.0,
            dailyCalorieTarget: mainDataModel.calorieProfile?.dailyCalorieTarget ?? 0,
            maintainenceCalorieTarget: mainDataModel.calorieProfile?.maintainenceCalorieTarget ?? 0,
            weightGoalType: mainDataModel.calorieProfile?.weightGoalType ?? .gain,
            activityLevel: mainDataModel.calorieProfile?.activityLevel ?? .sedentary,
            weightChangePerWeek: mainDataModel.calorieProfile?.weightChangePerWeek ?? 0.0
        )
        tempFitnessProfile = FitnessModel(
            userId: mainDataModel.fitnessProfile?.userId ?? "",
            fitnessLevel: mainDataModel.fitnessProfile?.fitnessLevel ?? .beginner,
            weeklyWorkoutGoal: mainDataModel.fitnessProfile?.weeklyWorkoutGoal ?? 0
        )
        tempUserProfile = mainDataModel.userProfile ?? UserModel(
            userId: mainDataModel.userProfile?.userId ?? "",
            email: mainDataModel.userProfile?.email ?? "",
            phoneNumber: nil,
            age: mainDataModel.userProfile?.age ?? 50,
            sex: mainDataModel.userProfile?.sex ?? "Male",
            height: mainDataModel.userProfile?.height ?? HeightModel(feet: 5, inches: 5),
            name: mainDataModel.userProfile?.userId ?? "",
            profilePic: nil
        )
    }

    
    var body: some View {
        VStack{
            ScrollView{
                VStack{
                    
                    
                    ProfileView(user: mainDataModel.userProfile!, editProfileAction: {
                        activeSheet = .userProfile
                    }
                    )
                    CalorieProfileView(
                        calorieDetails: mainDataModel.calorieProfile!,
                        editWeightAction: { activeSheet = .weight },
                        editGoalWeightAction: { activeSheet = .goalWeight},
                        editActivityLevelAction: { activeSheet = .activityLevel },
                        editWeeklyWeightChangeAction: {activeSheet = .weeklyWeightChange }
                    )
                    
                    FitnessProfileView(
                        fitnessDetails: mainDataModel.fitnessProfile!,
                        //                    editFitnessLevelAction: { print("Edit Fitness Level Action Triggered") },
                        editWeeklyWorkoutGoalAction: { activeSheet = .workoutGoal}
                    )
                                    .sheet(item: $activeSheet) { item in
                                        switch item {
                                        case .weight:
                                            WeightSetterView(
                                                displayText: "Edit your weight",
                                                weight: $weight,
                                                buttonPressAction: {
                                                    activeSheet = nil
                                                    updateCalories()
                                                }
                                            )
                                        case .goalWeight:
                                            WeightSetterView(displayText: "Edit your goal weight",
                                                             weight: $goalWeight,
                                                             buttonPressAction: {
                                                activeSheet = nil
                                                updateCalories()
                                            }
                                            )
                                        case .activityLevel:
                                            ActivityLevelSetterView(activityLevel: $activityLevel, buttonPressAction: {
                                                updateCalories()
                                                activeSheet = nil
                                            })
                                        case .weeklyWeightChange:
                                            WeeklyWeightChangeGoalView(weightChangeGoalType:mainDataModel.calorieProfile?.weightGoalType ?? .lose, weightChangeGoal: $weeklyWeightChange,
                                                                       buttonPressAction: {
                                                updateCalories()
                                                activeSheet = nil
                    
                                            })
                                        case .userProfile:
                                            EditProfileView( user: Binding(
                                                get: { tempUserProfile ?? UserModel(
                                                    userId: "",
                                                    email: "",
                                                    phoneNumber: nil,
                                                    age: 0,
                                                    sex: "",
                                                    height: HeightModel(feet: 0, inches: 0),
                                                    name: "",
                                                    profilePic: nil
                                                ) },
                                                set: { tempUserProfile = $0 }
                                            ),
                                            okayClicked: {
                                                activeSheet = nil
                                                updateProfile()
                                                
                                            },
                                            cancelClicked: {
                                                revertTempData()
                                                activeSheet = nil
                                            }
                                            )
                                        case .workoutGoal:
                                            WeeklyWorkoutGoalView(weeklyWorkoutGoal: $workoutGoal, buttonPressAction: {
                                                activeSheet = nil
                                                updateFitness()
                                            })
                                        }
                                    }
                                    .onDisappear{
                                        if activeSheet != nil{
                                            revertTempData()
                                            activeSheet = nil
                                        }
                                    }

                }
               
            }
            .onAppear {
                // Initialize temporary state objects with existing data
                weight = mainDataModel.calorieProfile?.currentWeight ?? 120
                goalWeight =  mainDataModel.calorieProfile?.goalWeight ?? 150
                activityLevel  = mainDataModel.calorieProfile?.activityLevel ?? .sedentary
                weeklyWeightChange = mainDataModel.calorieProfile?.weightChangePerWeek ??  0.75
                workoutGoal = mainDataModel.fitnessProfile?.weeklyWorkoutGoal ?? 4
                tempCalorieProfile = CalorieModel(
                    userId: mainDataModel.calorieProfile?.userId ?? "",
                    goalWeight: mainDataModel.calorieProfile?.goalWeight ?? 0.0,
                    currentWeight: mainDataModel.calorieProfile?.currentWeight ?? 0.0,
                    dailyCalorieTarget: mainDataModel.calorieProfile?.dailyCalorieTarget ?? 0,
                    maintainenceCalorieTarget: mainDataModel.calorieProfile?.maintainenceCalorieTarget ?? 0,
                    weightGoalType: mainDataModel.calorieProfile?.weightGoalType ?? .lose,
                    activityLevel: mainDataModel.calorieProfile?.activityLevel ?? .sedentary,
                    weightChangePerWeek: mainDataModel.calorieProfile?.weightChangePerWeek ?? 0.0
                )
                tempFitnessProfile = FitnessModel(
                    userId: mainDataModel.fitnessProfile?.userId ?? "",
                    fitnessLevel: mainDataModel.fitnessProfile?.fitnessLevel ?? .beginner,
                    weeklyWorkoutGoal: mainDataModel.fitnessProfile?.weeklyWorkoutGoal ?? 0
                )
                tempUserProfile = mainDataModel.userProfile ?? UserModel(
                    userId: UUID().uuidString,
                    email: "",
                    phoneNumber: nil,
                    age: 0,
                    sex: "",
                    height: HeightModel(feet: 0, inches: 0),
                    name: "",
                    profilePic: nil
                )
            }
            
        }
    }
}
//
//#Preview {
////    AccountView()
//}
