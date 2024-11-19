
import SwiftUI

struct DoneView: View {
    let name: String
    let email: String
    let gender: String
    let age: Int
    let weight: Double
    let goalWeight: Double
    let heightFeet: Int
    let heightInches: Int
    let maintainenceCalorieTarget: Double
    let goalCalorieTarget: Double
    let activityLevel: ActivityLevel
    let weeklyWeightChangeGoal: Double
    let weeklyWorkoutGoal: Int
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Section Header
                Text("Your Profile Summary")
                    .font(.system(size: 24, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .foregroundColor(Color("c_textPrimary"))

                InfoCard(title: "Name", value: "\(name)")
                InfoCard(title: "Email", value: "\(email)")
                InfoCard(title: "Gender", value: "\(gender)")
                // Age Section
                InfoCard(title: "Age", value: "\(age) years")
                InfoCard(title: "Height", value: "\(heightFeet) feet \(heightInches)inches")

                // Weight Section
                InfoCard(title: "Current Weight", value: "\(String(format: "%.2f", weight)) lbs")
                InfoCard(title: "Goal Weight", value: "\(String(format: "%.2f", goalWeight)) lbs")

                // Activity Level Section
                InfoCard(title: "Activity Level", value: activityLevel.rawValue)
                InfoCard(title: "Weekly Workouts", value: "\(weeklyWorkoutGoal) times/week")
                
                // Weekly Weight Change Goal
                InfoCard(title: "Weekly Weight Change Goal", value: "\(String(format: "%.2f", weeklyWeightChangeGoal)) lbs")
                
                // Weight Section
                InfoCard(title: "Current Weight", value: "\(String(format: "%.2f", weight)) lbs")
                InfoCard(title: "Goal Weight", value: "\(String(format: "%.2f", goalWeight)) lbs")
                
                //Calorie Section
                InfoCard(title: "Your Maintainence Calories", value: "\(String(Int(maintainenceCalorieTarget)))")
                InfoCard(title: "Your Goal Calories", value: "\(String(Int(goalCalorieTarget)))")
            }
            .padding()
        }
        .background(Color("c_greySecondary").edgesIgnoringSafeArea(.all))
    }
}

// MARK: - InfoCard View
struct InfoCard: View {
    let title: String
    let value: String

    var body: some View {
        HStack(spacing: 8) {
            Text(title)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Color("c_textPrimary"))
            Spacer()
            Text(value)
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(Color("c_textSecondary"))
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color("c_greyPrimary").opacity(0.3))
        .cornerRadius(15)
        .shadow(radius: 3)
    }
}

// MARK: - Preview
//#Preview {
////    DoneView(
////        name: "John Doe",
////        email: "john@doe.com",
////        gender: "person",
////        age: 25,
////        weight: 150.0,
////        goalWeight: 140.0,
////        activityLevel: .moderatelyActive,
////        weeklyWeightChangeGoal: 0.75,
////        weeklyWorkoutGoal: 4
////    )
//}
