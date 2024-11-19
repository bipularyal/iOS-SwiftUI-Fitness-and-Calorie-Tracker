import Foundation
import SwiftData

class WorkoutTrackerViewModel: ObservableObject {
    private var modelContext: ModelContext?
    
    @Published var currentDate: Date
    @Published var selectedDateWorkoutLog: DailyWorkoutLogEntity?
    @Published var currentWeekIndex: Int
    
    init(modelContext: ModelContext? = nil, currentDate: Date = Date(), currentWeekIndex: Int = 1) {
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
        guard let modelContext = modelContext else { return }
        
        let startOfDay = Calendar.current.startOfDay(for: date)
        let fetchDescriptor = FetchDescriptor<DailyWorkoutLogEntity>(
            predicate: #Predicate { $0.date == startOfDay }
        )
        
        do {
            let logs = try modelContext.fetch(fetchDescriptor)
            if let log = logs.first {
                self.selectedDateWorkoutLog = log
            } else {
                // Create a new one if not found
                let newLog = DailyWorkoutLogEntity(id: UUID().uuidString, date: startOfDay)
                // If you want default empty arrays or other defaults, set them here
                // e.g., newLog.workoutsCompleted = []
                modelContext.insert(newLog)
                try? modelContext.save()
                self.selectedDateWorkoutLog = newLog
            }
        } catch {
            print("Error fetching daily workout logs: \(error)")
        }
    }
    
    func addWorkoutToDateWorkoutLog(name: String, sets: [(weight: Double, reps: Int)]) {
        guard let log = selectedDateWorkoutLog else { return }

        // Create a new WorkoutCompletedEntity
        let setsCompleted = sets.map { SetEntity(weight: $0.weight, reps: $0.reps) }
        
        // Assign a unique ID for the workout and a workoutId, or fetch/create a WorkoutEntity if needed.
        // For simplicity, let's just generate IDs here:
        let workout = WorkoutCompletedEntity(
            id: UUID().uuidString,
            date: currentDate,
            name: name,
            setsCompleted: setsCompleted
        )
        
        log.workoutsCompleted.append(workout)
        
        if let modelContext = modelContext {
            try? modelContext.save()
        }
    }
}
