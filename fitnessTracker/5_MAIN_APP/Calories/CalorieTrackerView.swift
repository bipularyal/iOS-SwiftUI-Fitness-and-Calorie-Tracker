//
//  CalorieTrackerView.swift
//  fitnessTracker
//
//  Created by Bipul Aryal on 10/29/24.
//

import SwiftUI
import SwiftData

struct CalorieTrackerView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var mainDataModel: MainDataModel

    @StateObject private var viewModel: CalorieTrackerViewModel

    
    @State private var currentDate: Date = .init()
    @State private var currentWeekIndex: Int = 1
    @State private var addMealSheetShowing: Bool = false
    @State private var selectedMealType: MealType?
    
    init() {
        _viewModel = StateObject(wrappedValue: CalorieTrackerViewModel())
    }
    
    func addFoodToDataFoodLog(_ food: FoodEntryModel) {
        viewModel.addFoodToDateFoodLog(foodModel: food, mealType:selectedMealType ?? .breakfast)
    }
    
    func showAddMealSheet(for mealType: MealType) {
        selectedMealType = mealType
        addMealSheetShowing = true
    }
    
    var body: some View {
        VStack {
            DatePickerView(currentDate: viewModel.currentDate, currentWeekIndex: $currentWeekIndex, changeDate: viewModel.setNewDate)
            if let dailyLog = viewModel.selectedDateFoodLog {
                
                GeometryReader {
                    let size = $0.size
                    ScrollView(.vertical) {
                            VStack {
                            /// Tasks View
                            CurrentCalorieIntakeView(
                                selectedDatFoodLog:  dailyLog,
                                goalCalories: Double(mainDataModel.calorieProfile?.dailyCalorieTarget ?? 0)
                            )
                            ForEach(MealType.allCases, id: \.self) { mealType in
                                if let meal = dailyLog.meals.first(where: { $0.mealType == mealType }) {
                                    MealStorageView(
                                        mealType: mealType,
                                        typeMealsForDay: MealModel(entity: meal),
                                        addMeals: showAddMealSheet
                                    )
                                } else {
                                    
                                }
                            }
                        }
                            .hSpacing(.center)
                            .vSpacing(.center)
                    }
                    .scrollIndicators(.hidden)
                }
                .fullScreenCover(isPresented: $addMealSheetShowing) {
                    SearchMealView(isPresented: $addMealSheetShowing, onDone: addFoodToDataFoodLog)
                }
            } else {
                LoadingView()
            }
        }
        .vSpacing(.top)
        .onAppear {
            self.viewModel.setModelContext(self.modelContext)
        }
    }
    
    

    let selectedDatFoodLog = DailyFoodLogModel(
        id: UUID(),
        userId: "testUser123",
        date: Date(),
        meals: [
            MealModel(
                id: UUID(),
                mealType: .breakfast,
                foodEntries: [
                    FoodEntryModel(
                        id: UUID(),
                        food: FoodModel(
                            id: UUID().uuidString,
                            name: "Apple",
                            imageURL: nil,
                            servingOptions: ServingOptionModel(
                                id: UUID(),
                                unitName: "grams",
                                unitType: .gram,
                                caloriesPerUnit: 0.52, // matches totalCalories = 104 at 200g
                                proteinPerUnit: 0.03,  // 200g * 0.03 = 6g protein
                                fatPerUnit: 0.01,      // 200g * 0.01 = 2g fat
                                carbsPerUnit: 0.14     // 200g * 0.14 = 28g carbs
                            ),
                            brandName: nil,
                            brandOwner: nil,
                            defaultCalories: nil,
                            defaultServingSize: 1.0,
                            lastUsedAt: nil
                        ),
                        quantity: 200, // grams
                        servingUnit: .gram,
                        totalCalories: 104, // 0.52*200=104
                        totalProtein: 6,    // 0.03*200=6
                        totalFat: 2,        // 0.01*200=2
                        totalCarbs: 28      // 0.14*200=28
                    ),
                    FoodEntryModel(
                        id: UUID(),
                        food: FoodModel(
                            id: UUID().uuidString,
                            name: "Chicken Breast",
                            imageURL: nil,
                            servingOptions: ServingOptionModel(
                                id: UUID(),
                                unitName: "grams",
                                unitType: .gram,
                                caloriesPerUnit: 3.5,   // to get 350 total calories from 100g: 3.5 *100=350
                                proteinPerUnit: 0.08,   // 100g *0.08=8g protein
                                fatPerUnit: 0.02,       // 100g *0.02=2g fat
                                carbsPerUnit: 0.79      // 100g *0.79=79g carbs
                            ),
                            brandName: nil,
                            brandOwner: nil,
                            defaultCalories: nil,
                            defaultServingSize: 1.0,
                            lastUsedAt: nil
                        ),
                        quantity: 100, // grams
                        servingUnit: .gram,
                        totalCalories: 350, // matches 3.5 *100
                        totalProtein: 8,    // 0.08*100=8
                        totalFat: 2,        // 0.02*100=2
                        totalCarbs: 79      // 0.79*100=79
                    )
                ]
            ),
            MealModel(
                id: UUID(),
                mealType: .lunch,
                foodEntries: [
                    FoodEntryModel(
                        id: UUID(),
                        food: FoodModel(
                            id: UUID().uuidString,
                            name: "Chicken Breast",
                            imageURL: nil,
                            servingOptions: ServingOptionModel(
                                id: UUID(),
                                unitName: "grams",
                                unitType: .gram,
                                caloriesPerUnit: 1.65,   // For lunch entry: totalCals=248 for 150g
                                                         // 1.65*150=247.5 ~248 (close enough)
                                proteinPerUnit: 0.31,    // 150*0.31=46.5 protein
                                fatPerUnit: 0.03,        // 150*0.03=4.5 fat
                                carbsPerUnit: 0.0        // no carbs
                            ),
                            brandName: nil,
                            brandOwner: nil,
                            defaultCalories: nil,
                            defaultServingSize: 1.0,
                            lastUsedAt: nil
                        ),
                        quantity: 150, // grams
                        servingUnit: .gram,
                        totalCalories: 248, // ~1.65*150=247.5
                        totalProtein: 46.5, // 0.31*150=46.5
                        totalFat: 4.5,      // 0.03*150=4.5
                        totalCarbs: 0       // 0*150=0
                    )
                ]
            )
        ]
    )
}
//
//#Preview {
//    CalorieTrackerView()
//}
