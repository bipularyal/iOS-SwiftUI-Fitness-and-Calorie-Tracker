//
//  Fitness.swift
//  fitnessTracker
//
//  Created by Bipul Aryal on 11/16/24.
//

import Foundation
enum FitnessLevel: String, CaseIterable {
    case beginner = "Beginner"
    case intermediate = "Intermediate"
    case advanced = "Advanced"
    
    // Description for each level
    var description: String {
        switch self {
        case .beginner:
            return "Suitable for those new to working out"
        case .intermediate:
            return "For individuals with moderate fitness experience"
        case .advanced:
            return "Designed for experienced fitness enthusiasts"
        }
    }
}

struct FitnessModel {
    let userId: String // Link to the User
    var fitnessLevel: FitnessLevel // e.g., "Beginner", "Intermediate", "Advanced"
    var weeklyWorkoutGoal: Int // Workouts per week
}
