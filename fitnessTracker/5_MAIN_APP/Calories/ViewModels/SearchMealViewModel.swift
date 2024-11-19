//
//  SearchMealViewModel.swift
//  fitnessTracker
//
//  Created by Bipul Aryal on 12/10/24.
//

import Foundation

struct USDAFoodItem: Codable {
    let fdcId: Int?
    let description: String?
    let brandName: String?
    let brandOwner: String?
    let servingSize: Double?
    let servingSizeUnit: String?
    let householdServingFullText: String?
    let foodNutrients: [USDAFoodNutrient]?
}

struct USDAFoodNutrient: Codable {
    let nutrientName: String?
    let value: Double?
    let nutrientNumber: String?
}

struct USDAResponse: Codable {
    let foods: [USDAFoodItem]?
}

// MARK: - ViewModel Networking Example
extension SearchMealViewModel {
    
    // Assuming we have the USDAFoodItem and USDAFoodNutrient structs from the previous code

    func createFoodModel(from item: USDAFoodItem) -> FoodModel? {
        guard
            let fdcId = item.fdcId,
            let name = item.description,
            let servingSize = item.servingSize,                 // e.g. 71.0 g
            let servingSizeUnit = item.servingSizeUnit,         // e.g. "g"
            let nutrients = item.foodNutrients,
            servingSize > 0
        else {
            // Missing essential data
            return nil
        }
        print(item)
        // Find the main nutrients by their nutrientNumber
        let proteinNutrient = nutrients.first(where: { $0.nutrientNumber == "203" })?.value ?? 0.0
        let fatNutrient = nutrients.first(where: { $0.nutrientNumber == "204" })?.value ?? 0.0
        let carbsNutrient = nutrients.first(where: { $0.nutrientNumber == "205" })?.value ?? 0.0
        let caloriesNutrient = nutrients.first(where: { $0.nutrientNumber == "208" })?.value ?? 0.0

        // The USDA data is often provided per 100g.
        // To get per-serving values, scale by (servingSize / 100).
        let modifier = servingSize / 100.0
        
        let servingProtein = proteinNutrient * modifier  // grams of protein per serving
        let servingFat = fatNutrient * modifier          // grams of fat per serving
        let servingCarbs = carbsNutrient * modifier      // grams of carbs per serving
        let servingCalories = caloriesNutrient * modifier // calories per serving
        // Now we have total values per serving.
        // We want per-unit values, i.e. per gram if servingSizeUnit is "g".
        // caloriesPerUnit = total calories / servingSize
        // proteinPerUnit, fatPerUnit, carbsPerUnit similarly.
        let unitType: ServingUnitType
            switch servingSizeUnit.lowercased() {
            case "g", "gram", "grams":
                unitType = .gram
            case "ml", "milliliter", "milliliters":
                unitType = .milliliter
            case "oz", "ounce", "ounces":
                unitType = .ounce
            // If there's a unit like "tray" or something else, it might just be a piece.
            case "cup":
                unitType = .cup
            case "pack", "piece":
                unitType = .piece
            case "tray":
                unitType = .tray
            default:
                // If we can't parse the unit, default to gram
                unitType = .gram
            }
        
        
        let caloriesPerUnit = servingCalories / servingSize
        let proteinPerUnit = servingProtein / servingSize
        let fatPerUnit = servingFat / servingSize
        let carbsPerUnit = servingCarbs / servingSize


        // Create a ServingOptionModel with the computed per-unit values
        let servingOption = ServingOptionModel(
            id: UUID(),
            unitName: servingSizeUnit,
            unitType: unitType,
            caloriesPerUnit: caloriesPerUnit,
            proteinPerUnit: proteinPerUnit,
            fatPerUnit: fatPerUnit,
            carbsPerUnit: carbsPerUnit
        )

        // Create the FoodModel
        let food = FoodModel(
            id: "\(String(describing: item.fdcId))",
            name: name,
            imageURL: nil,
            servingOptions:servingOption,
            brandName: item.brandName ?? nil,
            brandOwner: item.brandOwner ?? nil,
            defaultCalories: servingCalories,
            defaultServingSize: item.servingSize ?? 1,
            lastUsedAt: nil
        )
        return food
    }

    
    func triggerSearch() async {
        guard !searchText.isEmpty else {
            // If no search text, do nothing or clear results
            await MainActor.run {
                self.searchResults = []
            }
            return
        }
        
        do {
            // Construct URL request
            var components = URLComponents(string: "https://api.nal.usda.gov/fdc/v1/foods/search")!
            components.queryItems = [
                URLQueryItem(name: "query", value: searchText),
                URLQueryItem(name: "dataType", value: "Branded"),
                URLQueryItem(name: "pageSize", value: "10"),
                URLQueryItem(name: "pageNumber", value: "1"),
                URLQueryItem(name: "sortBy", value: "dataType.keyword"),
                URLQueryItem(name: "sortOrder", value: "asc"),
                URLQueryItem(name: "api_key", value: "E9gjWGCQ8fwrLF9uuvHMlkReQ18H43dGncowKrDR")
            ]
            
            var request = URLRequest(url: components.url!)
            request.httpMethod = "GET"
            
            // Perform the request
            let (data, response) = try await URLSession.shared.data(for: request)
            
            // Check response status
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                print("Non-200 status code")
                await MainActor.run {
                    self.searchResults = []
                }
                return
            }
        
            // Decode JSON
            let decoder = JSONDecoder()
            let usdaResponse = try decoder.decode(USDAResponse.self, from: data)
            print(usdaResponse)
            // Transform USDAFoodItem -> FoodModel
            let foodModels = usdaResponse.foods?.compactMap { item -> FoodModel? in
                guard let _ = item.fdcId,
                      let name = item.description
                else {
                    return nil
                }
                
                let food = createFoodModel(from: item)
                
                return food
            } ?? []
            // Update UI on main thread
            await MainActor.run {
                self.searchResults = foodModels
            }
            
        } catch {
            // Handle error (network, decoding, etc.)
            print("Error performing search: \(error)")
            await MainActor.run {
                self.searchResults = []
            }
        }
    }
}


class SearchMealViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var searchResults: [FoodModel] = []
    @Published var isSearching: Bool = false
}

