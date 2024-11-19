import SwiftUI

struct WorkoutAddView: View {
    /// For dismissing the view
    @Environment(\.dismiss) private var dismiss
    
    /// Passed-in closure that will be called when user taps Save.
    /// It provides the workoutName and the sets array.
    let onSave: (String, [SetData]) -> Void
    
    @State private var workoutName: String = ""
    @State private var numberOfSets: Int = 1
    @State private var sets: [SetData] = [SetData(reps: 1, weight: 0.0)]
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 15) {
                
                // Close button in navigation bar
                HStack {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title)
                            .tint(.red)
                    })
                    Spacer()
                }
                
                // Workout Name
                VStack(alignment: .leading, spacing: 8) {
                    Text("Workout Name")
                        .font(.caption)
                        .foregroundStyle(.gray)
                    
                    TextField("e.g. Biceps Curl", text: $workoutName)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 15)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white)
                                .shadow(color: .black.opacity(0.25), radius: 2)
                        )
                }

                // Stepper for numberOfSets
                VStack(alignment: .leading, spacing: 8) {
                    Text("Number of Sets")
                        .font(.caption)
                        .foregroundStyle(.gray)
                    
                    Stepper(value: $numberOfSets, in: 1...20, step: 1, onEditingChanged: { _ in
                        adjustSetsArray()
                    }) {
                        Text("\(numberOfSets) \(numberOfSets == 1 ? "Set" : "Sets")")
                    }
                }
                
                // Table of sets
                if !sets.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Sets Detail")
                            .font(.caption)
                            .foregroundStyle(.gray)
                        
                        // Table headers
                        HStack {
                            Text("Weight")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                            Text("Reps")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                        }
                        
                        ForEach($sets) { $set in
                            HStack {
                                TextField("Weight", value: $set.weight, format: .number)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .keyboardType(.decimalPad)
                                    .frame(maxWidth: .infinity)
                                
                                TextField("Reps", value: $set.reps, format: .number)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .keyboardType(.numberPad)
                                    .frame(maxWidth: .infinity)
                            }
                        }
                    }
                }
                
                Spacer()
                
                // Save button
                Button(action: {
                    // Call onSave with current data
                    onSave(workoutName, sets)
                    dismiss()
                }, label: {
                    Text("Save Workout")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 10).fill(workoutName.isEmpty ? Color.gray : Color.blue)
                        )
                })
                .disabled(workoutName.isEmpty)
                
            }
            .padding(15)
            .navigationTitle("Add Workout")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    /// Adjust the sets array based on the numberOfSets
    private func adjustSetsArray() {
        let currentCount = sets.count
        if numberOfSets > currentCount {
            // Add more sets
            for _ in currentCount..<numberOfSets {
                sets.append(SetData(reps: 1, weight: 0.0))
            }
        } else if numberOfSets < currentCount {
            // Remove extra sets
            sets.removeLast(currentCount - numberOfSets)
        }
    }
}

struct SetData: Identifiable {
    let id = UUID()
    var reps: Int
    var weight: Double
}
