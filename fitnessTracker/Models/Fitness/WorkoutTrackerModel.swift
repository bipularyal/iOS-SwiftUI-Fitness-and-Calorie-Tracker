//
//  WorkoutTrackerModel.swift
//  fitnessTracker
//
//  Created by Bipul Aryal on 12/10/24.
//

import Foundation
import SwiftData


// MARK: - Model <-> Entity Conversions for DailyWorkoutLog and WorkoutCompleted

extension DailyWorkoutLogEntity {
    convenience init(model: DailyWorkoutLogModel) {
        self.init(
            id: model.id,
            date: model.date,
            workoutsCompleted: model.workoutsCompleted.map { WorkoutCompletedEntity(model: $0) }
        )
    }
}

extension WorkoutCompletedEntity {
    convenience init(model: WorkoutCompletedModel) {
        self.init(
            id: model.id,
            date: model.date,
            name: model.name,
            setsCompleted: model.setsCompleted.map { SetEntity(model: $0) }
        )
    }
}

extension DailyWorkoutLogModel {
    init(entity: DailyWorkoutLogEntity) {
        self.init(
            id: entity.id,
            date: entity.date,
            workoutsCompleted: entity.workoutsCompleted.map { WorkoutCompletedModel(entity: $0) }
        )
    }
}

extension WorkoutCompletedModel {
    init(entity: WorkoutCompletedEntity) {
        self.init(
            id: entity.id,
            date: entity.date,
            name: entity.name,
            setsCompleted: entity.setsCompleted.map { SetModel(entity: $0) }
        )
    }
}

extension SetModel {
    init(entity: SetEntity) {
        self.init(
            id: entity.id,
            weight: entity.weight,
            reps: entity.reps
        )
    }
}

extension SetEntity {
    convenience init(model: SetModel) {
        self.init(
            id: model.id,
            weight: model.weight,
            reps: model.reps
        )
    }
}

// MARK: - Models
struct DailyWorkoutLogModel {
    let id: String
    let date: Date
    var workoutsCompleted: [WorkoutCompletedModel]

    var totalWorkouts: Int {
        workoutsCompleted.count
    }
}

struct SetModel {
    let id: UUID
    let weight: Double
    let reps: Int
}

struct WorkoutCompletedModel {
    let id: String
    let date: Date
    let name: String
    var setsCompleted: [SetModel]
}

// MARK: - Entities
import SwiftData

@Model
class DailyWorkoutLogEntity {
    var id: String
    var date: Date
    var workoutsCompleted: [WorkoutCompletedEntity] = []

    init(id: String, date: Date, workoutsCompleted: [WorkoutCompletedEntity] = []) {
        self.id = id
        self.date = date
        self.workoutsCompleted = workoutsCompleted
    }
}

@Model
class SetEntity: Identifiable, Hashable {
    var id: UUID
    var weight: Double
    var reps: Int

    init(id: UUID = UUID(), weight: Double, reps: Int) {
        self.id = id
        self.weight = weight
        self.reps = reps
    }

    static func == (lhs: SetEntity, rhs: SetEntity) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

@Model
class WorkoutCompletedEntity {
    var id: String
    var date: Date
    var name: String
    var setsCompleted: [SetEntity] = []

    init(id: String, date: Date, name: String, setsCompleted: [SetEntity] = []) {
        self.id = id
        self.date = date
        self.name = name
        self.setsCompleted = setsCompleted
    }
}

