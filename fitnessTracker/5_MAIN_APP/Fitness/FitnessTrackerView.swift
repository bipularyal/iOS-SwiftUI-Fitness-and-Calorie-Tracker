import SwiftUI

struct WorkoutTrackerView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var mainDataModel: MainDataModel

    @StateObject private var viewModel: WorkoutTrackerViewModel

    @State private var currentWeekIndex: Int = 1
    @State private var showWorkoutAdd = false

    init() {
        _viewModel = StateObject(wrappedValue: WorkoutTrackerViewModel())
    }

    func addWorkoutToData(_ workoutName: String, _ sets: [(weight: Double, reps: Int)]) {
        viewModel.addWorkoutToDateWorkoutLog(name: workoutName, sets: sets)
    }

    var body: some View {
        VStack {
            // Date Picker View
            DatePickerView(
                currentDate: viewModel.currentDate,
                currentWeekIndex: $currentWeekIndex,
                changeDate: viewModel.setNewDate
            )
            .padding(.bottom, 10)

            // Main Content
            if let dailyLog = viewModel.selectedDateWorkoutLog {
                if dailyLog.workoutsCompleted.isEmpty {
                    // Show Add Workout Button if no workouts
                    Button(action: {
                        showWorkoutAdd = true
                    }) {
                        Text("Add Workout")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue.cornerRadius(10))
                    }
                    .padding(.horizontal)
                } else {
                    // Show list of workouts
                    ScrollView {
                        VStack(spacing: 15) {
                            ForEach(dailyLog.workoutsCompleted, id: \.id) { workout in
                                WorkoutRowView(workout: workout)
                            }

                            Button(action: {
                                showWorkoutAdd = true
                            }) {
                                Text("Add Another Workout")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.blue.cornerRadius(10))
                            }
                            .padding(.horizontal)
                        }
                        .padding(.top)
                    }
                }
            } else {
                LoadingView() // Show loading state if no daily log is loaded
            }
        }
        .onAppear {
            self.viewModel.setModelContext(self.modelContext)
        }
        .sheet(isPresented: $showWorkoutAdd) {
            WorkoutAddView { workoutName, sets in
                addWorkoutToData(workoutName, sets.map { ($0.weight, $0.reps) })
            }
        }
    }
}

// MARK: - WorkoutRowView

struct WorkoutRowView: View {
    let workout: WorkoutCompletedEntity

    var body: some View {
        VStack(alignment: .leading) {
            Text(workout.name) // Replace with a workout name lookup if needed
                .font(.headline)
            
            ForEach(workout.setsCompleted, id: \.self) { set in
                HStack {
                    Text("Weight: \(set.weight, specifier: "%.1f") lbs")
                    Spacer()
                    Text("Reps: \(set.reps)")
                }
                .font(.subheadline)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.2).cornerRadius(8))
    }
}
