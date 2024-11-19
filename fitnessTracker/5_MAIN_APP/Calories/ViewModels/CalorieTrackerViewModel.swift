import Foundation
import SwiftData

class CalorieTrackerViewModel: ObservableObject {
    private var modelContext: ModelContext?
    
    @Published var currentDate: Date
    @Published var selectedDateFoodLog: DailyFoodLogEntity?
    @Published var currentWeekIndex: Int
    
    init(modelContext: ModelContext? = nil, currentDate: Date = Date(),currentWeekIndex: Int = 1 ) {
        self.modelContext = modelContext
        self.currentDate = currentDate
        self.currentWeekIndex = currentWeekIndex
    }
    
    func setModelContext(_ modelContext: ModelContext) {
        self.modelContext = modelContext
        loadDailyLog(for: currentDate)
    }
    
    func setNewDate(_ date: Date) {
        self.currentDate = date
        self.currentWeekIndex = 1
        loadDailyLog(for: date)
    }
    
    private func loadDailyLog(for date: Date) {
        // Perform a fetch using modelContext directly
        // Example:
        if let modelContext = modelContext {
            
            let startOfDay = Calendar.current.startOfDay(for: date)
            let fetchDescriptor = FetchDescriptor<DailyFoodLogEntity>(
                predicate: #Predicate { $0.date == startOfDay }
            )
            
            do {
                let logs = try modelContext.fetch(fetchDescriptor)
                if let log = logs.first {
                    self.selectedDateFoodLog = log
                } else {
                    // Create a new one if not found
                    let newLog = DailyFoodLogEntity(userId: "currentUserId", date: startOfDay)
                    // Add default meals if desired
                    newLog.meals = [
                        MealEntity(mealType: .breakfast),
                        MealEntity(mealType: .lunch),
                        MealEntity(mealType: .dinner),
                        MealEntity(mealType: .other)
                    ]
                    modelContext.insert(newLog)
                    try? modelContext.save()
                    self.selectedDateFoodLog = newLog
                }
            } catch {
                print("Error fetching daily logs: \(error)")
            }
        } else{
            return
        }
    }
    
    func addFoodToDateFoodLog(foodModel: FoodEntryModel, mealType: MealType) {
        guard let log = selectedDateFoodLog else { return }
        // Find or create the meal
        let meal = log.meals.first { $0.mealType == mealType }
            ?? {
                let newMeal = MealEntity(mealType: mealType)
                log.meals.append(newMeal)
                return newMeal
            }()
        
        // Create and append the FoodEntryEntity
        let newEntry = FoodEntryEntity(model: foodModel)
        
        meal.foodEntries.append(newEntry)
        if let modelContext = modelContext {
            try? modelContext.save()
        }
    }
}
