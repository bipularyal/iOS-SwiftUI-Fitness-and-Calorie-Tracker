//
//  FoodEntryModel.swift
//  fitnessTracker
//
//  Created by Bipul Aryal on 12/10/24.
//

import Foundation
import SwiftData

struct FoodEntryModel {
    var id: UUID
    var food: FoodModel
    var quantity: Double
    var servingUnit: ServingUnitType
    // Computed properties for convenience
    var totalCalories: Double
    var totalProtein: Double
    var totalFat: Double
    var totalCarbs: Double
}

@Model
class FoodEntryEntity {
    var id: UUID
    var food: FoodEntity
    var quantity: Double
    var servingUnit: ServingUnitType
    // Computed properties for convenience
    var totalCalories: Double
    var totalProtein: Double
    var totalFat: Double
    var totalCarbs: Double
    
    init(id: UUID = UUID(), food: FoodEntity, quantity: Double, servingUnit: ServingUnitType,
             totalCalories: Double, totalProtein: Double, totalFat: Double, totalCarbs: Double) {
            self.id = id
            self.food = food
            self.quantity = quantity
            self.servingUnit = servingUnit
            self.totalCalories = totalCalories
            self.totalProtein = totalProtein
            self.totalFat = totalFat
            self.totalCarbs = totalCarbs
        }
}
