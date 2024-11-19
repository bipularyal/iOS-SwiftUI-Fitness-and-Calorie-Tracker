//
//  WorkoutDetailView.swift
//  fitnessTracker
//
//  Created by Bipul Aryal on 12/11/24.
//

import SwiftUI

struct WorkoutDetailView: View {
    let workout: WorkoutEntity
    private let imageBaseURL = "https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/"
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Images Carousel
                if !workout.images.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(workout.images, id: \.self) { imagePath in
                                let imageURL = URL(string: imageBaseURL + imagePath)!
                                AsyncImage(url: imageURL) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: UIScreen.main.bounds.width * 0.8, height: 200)
                                        .cornerRadius(10)
                                        .shadow(radius: 5)
                                } placeholder: {
                                    ProgressView()
                                        .frame(width: UIScreen.main.bounds.width * 0.8, height: 200)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }

                // Workout Name
                Text(workout.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 5)

                // Force and Level
                VStack(alignment: .leading, spacing: 10) {
                    if let force = workout.force {
                        DetailRowForWorkouts(title: "Force", value: force.capitalized)
                    }
                    DetailRowForWorkouts(title: "Level", value: workout.level.capitalized)
                    if let mechanic = workout.mechanic {
                        DetailRowForWorkouts(title: "Mechanic", value: mechanic.capitalized)
                    }
                    if let equipment = workout.equipment {
                        DetailRowForWorkouts(title: "Equipment", value: equipment.capitalized)
                    }
                    DetailRowForWorkouts(title: "Category", value: workout.category.capitalized)
                }

                // Muscles
                if !workout.primaryMuscles.isEmpty {
                    SectionHeader(title: "Primary Muscles")
                    Text(workout.primaryMuscles.joined(separator: ", "))
                        .font(.body)
                    
                        .foregroundColor(.primary)
                        .padding(.bottom, 10)
                }

                if !workout.secondaryMuscles.isEmpty {
                    SectionHeader(title: "Secondary Muscles")
                    Text(workout.secondaryMuscles.joined(separator: ", "))
                        .font(.body)
                        .foregroundColor(.secondary)
                        .padding(.bottom, 10)
                }

                // Instructions
                if !workout.instructions.isEmpty {
                    SectionHeader(title: "Instructions")
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(workout.instructions, id: \.self) { instruction in
                            Text("• \(instruction)")
                                .font(.body)
                                .foregroundColor(.primary)
                        }
                    }
                }

                Spacer()
            }
            .padding()
        }
        .navigationTitle(workout.name)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: {print("\(workout.images)")})
    }
}

// MARK: - DetailRow
struct DetailRowForWorkouts: View {
    let title: String
    let value: String

    var body: some View {
        HStack {
            Text("\(title):")
                .font(.headline)
                .foregroundColor(.secondary)
            Text(value)
                .font(.body)
                .fontWeight(.semibold)
        }
    }
}

// MARK: - SectionHeader
struct SectionHeader: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.title2)
            .fontWeight(.bold)
            .foregroundColor(.accentColor)
            .padding(.vertical, 5)
    }
}



//#Preview {
//    WorkoutDetailView()
//}
