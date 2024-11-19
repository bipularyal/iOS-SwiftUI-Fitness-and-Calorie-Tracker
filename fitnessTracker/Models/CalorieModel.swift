import Foundation

enum WeightGoalType {
    case gain
    case lose
}

enum ActivityLevel: String, CaseIterable {
    case sedentary = "Sedentary"
    case lightlyActive = "Lightly Active"
    case moderatelyActive = "Moderately Active"
    case veryActive = "Very Active"
    case extremelyActive = "Extremely Active"

    // Description or workout hours for each level
    var workoutHours: (description: String, weeklyHours: Int) {
        switch self {
        case .sedentary:
            return ("Little or no exercise", 0)
        case .lightlyActive:
            return ("Light exercise/sports 1-3 days a week", 1)
        case .moderatelyActive:
            return ("Moderate exercise/sports 3-5 days a week", 3)
        case .veryActive:
            return ("Hard exercise/sports 6-7 days a week", 6)
        case .extremelyActive:
            return ("Very hard exercise/physical job & exercise 7 days a week", 10)
        }
    }
    // Description or workout hours for each level
    var activityMultiplier: Double {
        switch self {
        case .sedentary:
            return 1.1
        case .lightlyActive:
            return 1.22
        case .moderatelyActive:
            return 1.43
        case .veryActive:
            return 1.77
        case .extremelyActive:
            return 2.12
        }
    }
}

struct CalorieModel {

    let userId: String // Link to the User
    var goalWeight: Double // Goal weight in kg
    var currentWeight: Double // Current weight in kg
    var dailyCalorieTarget: Int // Calories per day
    var maintainenceCalorieTarget: Int
    var weightGoalType: WeightGoalType // Weight gain or weight loss
    var activityLevel: ActivityLevel
    var weightChangePerWeek: Double // Target kg to gain/lose per week
    
        init(userId: String, goalWeight: Double, currentWeight: Double, dailyCalorieTarget: Int, maintainenceCalorieTarget: Int, weightGoalType: WeightGoalType, activityLevel: ActivityLevel, weightChangePerWeek: Double) {
            self.userId = userId
            self.goalWeight = goalWeight
            self.currentWeight = currentWeight
            self.dailyCalorieTarget = dailyCalorieTarget
            self.maintainenceCalorieTarget = maintainenceCalorieTarget
            self.weightGoalType = weightGoalType
            self.activityLevel = activityLevel
            self.weightChangePerWeek = weightChangePerWeek
        }

    // Initializer with calculations
    init(userId: String, goalWeight: Double, currentWeight: Double, height: Double, age: Int, gender: String, activityLevel: ActivityLevel, weightChangePerWeek: Double, weightGoalType: WeightGoalType) {
        self.userId = userId
        self.goalWeight = goalWeight
        self.currentWeight = currentWeight
        self.activityLevel = activityLevel
        self.weightChangePerWeek = weightChangePerWeek
        self.weightGoalType = currentWeight < goalWeight ? .gain: .lose

        // Calculate maintenance calories
        let maintenanceCalories = CalorieModel.calculateMaintenanceCalories(
            weight: currentWeight,
            height: height,
            age: age,
            gender: gender,
            activityLevel: activityLevel
        )
        self.maintainenceCalorieTarget = Int(maintenanceCalories)

        // Calculate daily calorie target
        let dailyCalories = CalorieModel.calculateDailyCalorieTarget(
            weightChangePerWeek: weightChangePerWeek,
            maintainenceCalorieTarget: maintenanceCalories,
            weightGoalType: weightGoalType
        )
        self.dailyCalorieTarget = Int(dailyCalories)
    }

    // Maintenance Calories Calculation
    static private func calculateMaintenanceCalories(weight: Double, height: Double, age: Int, gender: String, activityLevel: ActivityLevel) -> Double {
        var bmr = 0.0
        if gender.lowercased() == "male" {
            bmr = 66.47 + (6.24 * weight) + (12.7 * height) - (6.76 * Double(age))
        } else if gender.lowercased() == "female" {
            bmr = 65.51 + (4.34 * weight) + (4.7 * height) - (4.7 * Double(age))
        } else {
            // Average of male and female BMR formulas
            bmr = (66.47 + (6.24 * weight) + (12.7 * height) - (6.76 * Double(age))
                 + 65.51 + (4.34 * weight) + (4.7 * height) - (4.7 * Double(age))) / 2
        }
        return bmr * activityLevel.activityMultiplier
    }

    static private func calculateDailyCalorieTarget(weightChangePerWeek: Double, maintainenceCalorieTarget: Double, weightGoalType: WeightGoalType) -> Double {
        let weeklyCalorieAdjustment = weightChangePerWeek * 3500
        let dailyAdjustment = weeklyCalorieAdjustment / 7.0

        return weightGoalType == .gain
            ? maintainenceCalorieTarget + dailyAdjustment
            : maintainenceCalorieTarget - dailyAdjustment
    }
}
