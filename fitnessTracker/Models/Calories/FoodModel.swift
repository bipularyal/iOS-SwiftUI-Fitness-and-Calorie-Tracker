//
//  FoodModel.swift
//  fitnessTracker
//
//  Created by Bipul Aryal on 12/10/24.
//

import Foundation
import SwiftData

struct ServingOptionModel {
    let id: UUID
    let unitName: String        // e.g., "gram", "ml", "piece"
    let unitType: ServingUnitType
    let caloriesPerUnit: Double
    let proteinPerUnit: Double
    let fatPerUnit: Double
    let carbsPerUnit: Double
}

struct FoodModel {
    let id: String
    let name: String
    let imageURL: URL?
    var servingOptions: ServingOptionModel
    let brandName: String?
    let brandOwner: String?
    let defaultCalories: Double?
    let defaultServingSize: Double
    var lastUsedAt: Date?
}

enum ServingUnitType:  String, Codable {
    case serving
    case gram
    case milliliter
    case liter
    case piece
    case tray
    case cup
    case ounce
    // Add more as needed
}

@Model
class ServingOptionEntity {
    var id: UUID
    var unitName: String        // e.g., "gram", "ml", "piece"
    var unitType: ServingUnitType
    var caloriesPerUnit: Double
    var proteinPerUnit: Double
    var fatPerUnit: Double
    var carbsPerUnit: Double
    
    init(id: UUID = UUID(), unitName: String, unitType: ServingUnitType, caloriesPerUnit: Double,
             proteinPerUnit: Double, fatPerUnit: Double, carbsPerUnit: Double) {
            self.id = id
            self.unitName = unitName
            self.unitType = unitType
            self.caloriesPerUnit = caloriesPerUnit
            self.proteinPerUnit = proteinPerUnit
            self.fatPerUnit = fatPerUnit
            self.carbsPerUnit = carbsPerUnit
        }
}

@Model
class FoodEntity {
    var id: String
    var name: String
    var imageURL: URL?
    var servingOptions: ServingOptionEntity
    var brandName: String?
    var brandOwner: String?
    var defaultCalories: Double?
    var defaultServingSize: Double
    var lastUsedAt: Date?
    
    init(id: String, name: String, imageURL: URL? = nil, servingOptions: ServingOptionEntity,
             brandName: String? = nil, brandOwner: String? = nil, defaultCalories: Double? = nil,
             defaultServingSize: Double, lastUsedAt: Date? = nil) {
            self.id = id
            self.name = name
            self.imageURL = imageURL
            self.servingOptions = servingOptions
            self.brandName = brandName
            self.brandOwner = brandOwner
            self.defaultCalories = defaultCalories
            self.defaultServingSize = defaultServingSize
            self.lastUsedAt = lastUsedAt
        }
}
