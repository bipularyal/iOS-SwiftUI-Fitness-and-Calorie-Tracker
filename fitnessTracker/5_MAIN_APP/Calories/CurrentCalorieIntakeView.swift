//
//  DailyCalorieTrackerView.swift
//  fitnessTracker
//
//  Created by Bipul Aryal on 12/10/24.
//

import SwiftUI

struct CurrentCalorieIntakeView: View {
    let selectedDatFoodLog: DailyFoodLogEntity
    let goalCalories: Double // Pass the user's calorie goal here
    @State private var isExpanded: Bool = false


    var calorieTextColor: Color {
        selectedDatFoodLog.totalCalories > goalCalories ? .red : .green
    }

    var body: some View {
        VStack() {
            // Header
            HStack {
                Spacer()
                Text("Calories")
                    .font(.callout)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
                // Calorie Summary
                Text("\(goalCalories - selectedDatFoodLog.totalCalories >= 0 ? "\(Int(goalCalories - selectedDatFoodLog.totalCalories)) calories left" : "\(Int(abs(selectedDatFoodLog.totalCalories - goalCalories))) calories over")")
                    .font(.callout)
                    .fontWeight(.semibold)
                    .foregroundColor(calorieTextColor)
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
                HStack{
                    VStack(spacing: 8) {
                        DetailRow(label: "Calories", value: selectedDatFoodLog.totalCalories, unit: "g")
                        DetailRow(label: "Protein", value: selectedDatFoodLog.totalProtein, unit: "g")
                        DetailRow(label: "Carbs", value: selectedDatFoodLog.totalCarbs, unit: "g")
                        DetailRow(label: "Fat", value: selectedDatFoodLog.totalFat, unit: "g")
                    }
                    .padding()
                    .background(Color(UIColor.systemGroupedBackground))
                    .cornerRadius(12)
                    
                    ProgressCircleView(progress: selectedDatFoodLog.totalCalories , color: selectedDatFoodLog.totalCalories / goalCalories < 1 ? .green: .red, lineWidth: 15, goal: CGFloat(goalCalories))
                        .frame(width: 100, height: 100)
                        .padding()
            }
            .transition(.move(edge: .top).combined(with: .opacity)) // Add transition animation

            }
        }
        .padding()
        .background(Color(UIColor.systemGroupedBackground))
        .cornerRadius(12)
        .padding(.horizontal)
        .padding(.bottom)
    }
}

struct DetailRow: View {
    let label: String
    let value: Double
    let unit: String

    var body: some View {
        HStack {
            Text(label)
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("\(Int(value)) \(unit)")
                .font(.body)
        }
    }
}
