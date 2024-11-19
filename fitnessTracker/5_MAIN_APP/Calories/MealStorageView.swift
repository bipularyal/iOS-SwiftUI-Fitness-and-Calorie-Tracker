//
//  MealStorageView.swift
//  fitnessTracker
//
//  Created by Bipul Aryal on 12/10/24.
//
import SwiftUI

struct MealStorageView: View {
    let mealType: MealType
    let typeMealsForDay: MealModel
    let addMeals: (_ for: MealType) -> Void
    @State private var isExpanded: Bool = true

    var body: some View {
        VStack() {
            // Header
            HStack {
                Spacer()
                Text("\(mealType.rawValue.capitalized)")
                    .font(.callout)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
                // Calorie Summary
                Text("\(Int(typeMealsForDay.totalCalories)) Calories")
                    .font(.callout)
                    .fontWeight(.semibold)
                    .foregroundColor(.green)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
                Button(action: {
                    isExpanded.toggle()
                }) {
                    Image(systemName: isExpanded ? "chevron.down.circle" : "chevron.right.circle")
                        .foregroundColor(.black)
                }
            }
            if isExpanded{
                VStack(spacing: 8) {
                    ForEach(typeMealsForDay.foodEntries, id: \.id) { entry in
                        MealDetailRow(foodEntry: entry)
                    }
                }
            }
            Button(action:{addMeals(mealType)}) {
                        HStack {
                            Image(systemName: "plus").frame(width: 10, height: 10)
                            Text("Add \(mealType.rawValue.capitalized)")
                        }
                        .padding(.vertical,10)
                        .padding(.horizontal)
                        .background(Color("c_appSecondary"))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(color: .gray.opacity(0.4), radius: 4, x: 2, y: 2)
                    }
        }
            
        .padding()
        .background(Color(UIColor.systemGroupedBackground))
        .cornerRadius(12)
        .padding(.horizontal)
        .padding(.bottom)
    }
}

struct MealDetailRow: View {
    let foodEntry: FoodEntryModel

    var body: some View {
        HStack() {
            VStack(alignment: .leading, spacing: 4) {
                Text("\((foodEntry.food.name.capitalized)): \(Int(foodEntry.quantity)) \(foodEntry.servingUnit)")
                    .font(.headline)
                Text("\(Int(foodEntry.totalProtein))g Protein, \(Int(foodEntry.totalFat))g Fat, \(Int(foodEntry.totalCarbs))g Carbs")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
            Text("\(Int(foodEntry.totalCalories)) cal")
                .font(.headline)
                .fontWeight(.bold)
        }
        .padding(.vertical)
    }
}
