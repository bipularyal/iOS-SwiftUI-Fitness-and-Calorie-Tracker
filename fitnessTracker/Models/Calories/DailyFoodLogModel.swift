//
//  DailyLogModel.swift
//  fitnessTracker
//
//  Created by Bipul Aryal on 12/10/24.
//

import Foundation
import SwiftData

struct DailyFoodLogModel:Identifiable {
    var id: UUID
    var userId: String
    var date: Date
    var meals: [MealModel]
    
    var totalCalories: Double {
        meals.reduce(0) { $0 + $1.totalCalories }
    }
    var totalProtein: Double {
        meals.reduce(0) { $0 + $1.totalProtein }
    }
    var totalFat: Double {
        meals.reduce(0) { $0 + $1.totalFat }
    }
    var totalCarbs: Double {
        meals.reduce(0) { $0 + $1.totalCarbs }
    }
}

@Model
class DailyFoodLogEntity {
    var id: UUID
    var userId: String
    var date: Date
    var meals: [MealEntity] = []
    
    var totalCalories: Double {
        meals.reduce(0) { $0 + $1.totalCalories }
    }
    var totalProtein: Double {
        meals.reduce(0) { $0 + $1.totalProtein }
    }
    var totalFat: Double {
        meals.reduce(0) { $0 + $1.totalFat }
    }
    var totalCarbs: Double {
        meals.reduce(0) { $0 + $1.totalCarbs }
    }
    init(id: UUID = UUID(), userId: String, date: Date, meals: [MealEntity] = []) {
            self.id = id
            self.userId = userId
            self.date = date
            self.meals = meals
    }
}
