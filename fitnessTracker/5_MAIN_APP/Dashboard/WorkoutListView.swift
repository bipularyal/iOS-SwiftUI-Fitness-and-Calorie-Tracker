import SwiftUI
import SwiftData

struct WorkoutListView: View {
    @Environment(\.modelContext) var modelContext
    let filterType: CategoryType
    let filterValue: String

    @State private var workouts: [WorkoutEntity] = []

    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    private let imageBaseURL = "https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/"

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(workouts, id: \.id) { workout in
                    NavigationLink(destination: WorkoutDetailView(workout: workout)) {
                        WorkoutCardView(workout: workout)
                    }
                }
            }
            .padding(.horizontal)
            .onAppear {
                loadWorkouts()
            }
        }
        .navigationTitle(filterValue.capitalized)
        .navigationBarTitleDisplayMode(.inline)
    }

    func loadWorkouts() {
        let fetch = FetchDescriptor<WorkoutEntity>()
        if let allWorkouts = try? modelContext.fetch(fetch) {
            // Filter based on categoryType and filterValue
            workouts = allWorkouts.filter { w in
                switch filterType {
                case .force:
                    return w.force == filterValue
                case .level:
                    return w.level == filterValue
                case .mechanic:
                    return w.mechanic == filterValue
                case .equipment:
                    return w.equipment == filterValue
                case .primaryMuscles:
                    return w.primaryMuscles.contains(filterValue)
                case .secondaryMuscles:
                    return w.secondaryMuscles.contains(filterValue)
                case .category:
                    return w.category == filterValue
                }
            }
        }
    }
}

// MARK: - WorkoutCard

struct WorkoutCardView: View {
    let workout: WorkoutEntity
    private let imageBaseURL = "https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/"

    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            // Workout Image
            if let firstImage = workout.images.first {
                let imageURL = URL(string: imageBaseURL + firstImage)!
                AsyncImage(url: imageURL) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 150, height: 150)
                        .clipped()
                        .cornerRadius(8)
                } placeholder: {
                    ProgressView()
                        .frame(width: 150, height: 150)
                }
            }

            // Workout Name
            Text(workout.name.capitalized)
                .font(.headline)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .foregroundColor(.primary)
        }
        .frame(width: UIScreen.main.bounds.width / 2 - 24)
        .background(Color(UIColor.systemBackground))
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}
