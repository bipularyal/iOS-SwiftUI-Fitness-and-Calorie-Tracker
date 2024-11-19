//
//  FoodQuantityAdjustView.swift
//  fitnessTracker
//
//  Created by Bipul Aryal on 12/10/24.
//

import SwiftUI




struct FoodQuantityAdjustView: View {
    @Binding var isPresented: Bool
    let food: FoodModel
    let onDone: (FoodEntryModel) -> Void
    
    @State private var selectedUnit: ServingUnitType = .serving
    @State private var quantityText: String = "1"
    
    private var quantity: Double {
        Double(quantityText) ?? 0.0
    }
    
    private var baseUnit: ServingUnitType {
        food.servingOptions.unitType
    }
    
    // Allowed units based on base unit
    private var allowedUnits: [ServingUnitType] {
        switch baseUnit {
        case .gram:
            return [.serving, .gram, .ounce]
        case .milliliter:
            return [.serving, .milliliter, .liter]
        case .piece:
            return [.piece, .serving]
        case .tray:
            return [.tray, .serving]
        case .cup:
            return [.cup, .serving]
        case .ounce:
            return [.serving, .gram, .ounce]
        case .serving:
            return [.serving]
        case .liter:
            return [.serving, .milliliter, .liter]
        }
    }
    
    // Convert entered quantity in selectedUnit to the base unit
    private func convertToBaseUnit(quantity: Double, from unit: ServingUnitType) -> Double {
        let defaultSize = food.defaultServingSize
        
        switch baseUnit {
        case .gram:
            // gram is base
            switch unit {
            case .serving:
                // 1 serving = defaultSize grams
                return quantity * defaultSize
            case .gram:
                return quantity
            case .ounce:
                // 1 ounce = 28.3495 grams
                return quantity * 28.3495
            default:
                return quantity
            }
            
        case .milliliter:
            // ml is base
            switch unit {
            case .serving:
                // 1 serving = defaultSize ml
                return quantity * defaultSize
            case .milliliter:
                return quantity
            case .liter:
                // 1 liter = 1000 ml
                return quantity * 1000
            default:
                return quantity
            }
            
        case .piece:
            // piece is base
            switch unit {
            case .piece:
                return quantity
            case .serving:
                // 1 serving = defaultSize pieces
                return quantity * defaultSize
            default:
                return quantity
            }
            
        case .tray:
            // tray is base
            switch unit {
            case .tray:
                return quantity
            case .serving:
                // 1 serving = defaultSize trays
                return quantity * defaultSize
            default:
                return quantity
            }
            
        case .cup:
            // cup is base
            switch unit {
            case .cup:
                return quantity
            case .serving:
                // 1 serving = defaultSize cups
                return quantity * defaultSize
            default:
                return quantity
            }
            
        case .ounce:
            // Not specified as base scenario in final instructions,
            // but if needed:
            // 1 serving = defaultSize ounces
            // gram to ounce conversions if required
            return quantity
            
        case .serving:
            return quantity
        case .liter:
            return quantity
        }
    }
    
    private var convertedQuantityInBaseUnit: Double {
        convertToBaseUnit(quantity: quantity, from: selectedUnit)
    }
    
    private var computedCalories: Double {
        food.servingOptions.caloriesPerUnit * convertedQuantityInBaseUnit
    }
    
    private var computedProtein: Double {
        food.servingOptions.proteinPerUnit * convertedQuantityInBaseUnit
    }
    
    private var computedFat: Double {
        food.servingOptions.fatPerUnit * convertedQuantityInBaseUnit
    }
    
    private var computedCarbs: Double {
        food.servingOptions.carbsPerUnit * convertedQuantityInBaseUnit
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(food.name)
                .font(.largeTitle)
                .padding(.top)
                .padding(.horizontal)
            
            HStack {
                Text("Quantity:")
                TextField("Enter quantity", text: $quantityText)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Picker("Unit", selection: $selectedUnit) {
                    ForEach(allowedUnits, id: \.self) { unit in
                        Text(unit.rawValue.capitalized).tag(unit)
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }
            .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Nutritional Info").font(.headline)
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Calories: \(Int(computedCalories))")
                        Text("Protein: \(String(format: "%.1f", computedProtein)) g")
                        Text("Fat: \(String(format: "%.1f", computedFat)) g")
                        Text("Carbs: \(String(format: "%.1f", computedCarbs)) g")
                    }
                    Spacer()
                }
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(8)
            }
            .padding(.horizontal)
            
            Spacer()
            
            Button(action: {
                let entry = FoodEntryModel(
                    id: UUID(),
                    food: food,
                    quantity: quantity,
                    servingUnit: selectedUnit,
                    totalCalories: computedCalories,
                    totalProtein: computedProtein,
                    totalFat: computedFat,
                    totalCarbs: computedCarbs
                )
                onDone(entry)
                isPresented = false
            }) {
                Text("Done")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(8)
                    .padding(.horizontal)
            }
            .padding(.bottom, 20)
        }
        .onAppear {
            // Default to serving if available
            if allowedUnits.contains(.serving) {
                selectedUnit = .serving
            } else {
                selectedUnit = allowedUnits.first ?? baseUnit
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}
