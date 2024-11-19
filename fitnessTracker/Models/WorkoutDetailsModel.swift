//
//  FitnessData.swift
//  fitnessTracker
//
//  Created by Bipul Aryal on 12/11/24.
//

import Foundation
import SwiftData

@Model
class WorkoutEntity {
    var id: String
    var name: String
    var force: String?    // "static", "pull", "push", or nil
    var level: String     // "beginner", "intermediate", "expert"
    var mechanic: String? // "isolation", "compound", or nil
    var equipment: String?
    var primaryMuscles: [String]
    var secondaryMuscles: [String]
    var instructions: [String]
    var category: String  // "powerlifting", "strength", etc.
    var images: [String]     // store as URLs or Strings

    init(id: String, name: String, force: String?, level: String, mechanic: String?, equipment: String?, primaryMuscles: [String], secondaryMuscles: [String], instructions: [String], category: String, images: [String]) {
        self.id = id
        self.name = name
        self.force = force
        self.level = level
        self.mechanic = mechanic
        self.equipment = equipment
        self.primaryMuscles = primaryMuscles
        self.secondaryMuscles = secondaryMuscles
        self.instructions = instructions
        self.category = category
        self.images = images
    }
}


struct WorkoutJSON: Decodable {
    let id: String
    let name: String
    let force: String?         // Optional: "static", "pull", "push"
    let level: String          // "beginner", "intermediate", "expert"
    let mechanic: String?      // Optional: "isolation", "compound"
    let equipment: String?     // Optional: "dumbbell", "barbell", etc.
    let primaryMuscles: [String]
    let secondaryMuscles: [String]
    let instructions: [String]
    let category: String       // "powerlifting", "strength", etc.
    let images: [String]       // Paths or URLs
}
