//
//  ExtensionInitializers.swift
//  fitnessTracker
//
//  Created by Bipul Aryal on 12/10/24.
//

import Foundation

extension ServingOptionEntity {
    convenience init(model: ServingOptionModel) {
        self.init(
            id: model.id,
            unitName: model.unitName,
            unitType: model.unitType,
            caloriesPerUnit: model.caloriesPerUnit,
            proteinPerUnit: model.proteinPerUnit,
            fatPerUnit: model.fatPerUnit,
            carbsPerUnit: model.carbsPerUnit
        )
    }
}

extension FoodEntity {
    convenience init(model: FoodModel) {
        self.init(
            id: model.id,
            name: model.name,
            imageURL: model.imageURL,
            servingOptions: ServingOptionEntity(model: model.servingOptions),
            brandName: model.brandName,
            brandOwner: model.brandOwner,
            defaultCalories: model.defaultCalories,
            defaultServingSize: model.defaultServingSize,
            lastUsedAt: model.lastUsedAt
        )
    }
}

extension MealEntity {
    convenience init(model: MealModel) {
        self.init(
            id: model.id,
            mealType: model.mealType,
            foodEntries: model.foodEntries.map { FoodEntryEntity(model: $0) }
        )
    }
}

extension DailyFoodLogEntity {
    convenience init(model: DailyFoodLogModel) {
        self.init(
            id: model.id,
            userId: model.userId,
            date: model.date,
            meals: model.meals.map { MealEntity(model: $0) }
        )
    }
}

// Assuming `FoodEntryEntity` and `FoodEntryModel` also exist, here is an initializer for them:
extension FoodEntryEntity {
    convenience init(model: FoodEntryModel) {
        self.init(
            id: model.id,
            food: FoodEntity(model: model.food),
            quantity: model.quantity,
            servingUnit: model.servingUnit,
            totalCalories: model.totalCalories,
            totalProtein: model.totalProtein,
            totalFat: model.totalFat,
            totalCarbs: model.totalCarbs
        )
    }
}

extension ServingOptionModel {
    init(entity: ServingOptionEntity) {
        self.init(
            id: entity.id,
            unitName: entity.unitName,
            unitType: entity.unitType,
            caloriesPerUnit: entity.caloriesPerUnit,
            proteinPerUnit: entity.proteinPerUnit,
            fatPerUnit: entity.fatPerUnit,
            carbsPerUnit: entity.carbsPerUnit
        )
    }
}

extension FoodModel {
    init(entity: FoodEntity) {
        self.init(
            id: entity.id,
            name: entity.name,
            imageURL: entity.imageURL,
            servingOptions: ServingOptionModel(entity: entity.servingOptions),
            brandName: entity.brandName,
            brandOwner: entity.brandOwner,
            defaultCalories: entity.defaultCalories,
            defaultServingSize: entity.defaultServingSize,
            lastUsedAt: entity.lastUsedAt
        )
    }
}

extension FoodEntryModel {
    init(entity: FoodEntryEntity) {
        self.init(
            id: entity.id,
            food: FoodModel(entity: entity.food),
            quantity: entity.quantity,
            servingUnit: entity.servingUnit,
            totalCalories: entity.totalCalories,
            totalProtein: entity.totalProtein,
            totalFat: entity.totalFat,
            totalCarbs: entity.totalCarbs
        )
    }
}

extension MealModel {
    init(entity: MealEntity) {
        self.init(
            id: entity.id,
            mealType: entity.mealType,
            foodEntries: entity.foodEntries.map { FoodEntryModel(entity: $0) }
        )
    }
}

extension DailyFoodLogModel {
    init(entity: DailyFoodLogEntity) {
        self.init(
            id: entity.id,
            userId: entity.userId,
            date: entity.date,
            meals: entity.meals.map { MealModel(entity: $0) }
        )
    }
}
