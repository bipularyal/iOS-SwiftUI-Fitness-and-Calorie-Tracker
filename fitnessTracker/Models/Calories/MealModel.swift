//
//  MealModel.swift
//  fitnessTracker
//
//  Created by Bipul Aryal on 12/10/24.
//

import Foundation
import SwiftData

enum MealType: String, CaseIterable, Codable  {
    case breakfast
    case lunch
    case dinner
    case other
}

@Model
class MealEntity {
    var id: UUID
    var mealType: MealType
    var foodEntries: [FoodEntryEntity] = []

    // Computed or stored aggregate:
    var totalCalories: Double {
        foodEntries.reduce(0) { $0 + $1.totalCalories }
    }
    var totalProtein: Double {
        foodEntries.reduce(0) { $0 + $1.totalProtein }
    }
    var totalFat: Double {
        foodEntries.reduce(0) { $0 + $1.totalFat }
    }
    var totalCarbs: Double {
        foodEntries.reduce(0) { $0 + $1.totalCarbs }
    }
    
    init(id: UUID = UUID(), mealType: MealType, foodEntries: [FoodEntryEntity] = []) {
            self.id = id
            self.mealType = mealType
            self.foodEntries = foodEntries
        }
}

struct MealModel {
    var id: UUID
    var mealType: MealType
    var foodEntries: [FoodEntryModel]

    // Computed or stored aggregate:
    var totalCalories: Double {
        foodEntries.reduce(0) { $0 + $1.totalCalories }
    }
    var totalProtein: Double {
        foodEntries.reduce(0) { $0 + $1.totalProtein }
    }
    var totalFat: Double {
        foodEntries.reduce(0) { $0 + $1.totalFat }
    }
    var totalCarbs: Double {
        foodEntries.reduce(0) { $0 + $1.totalCarbs }
    }
    
}
