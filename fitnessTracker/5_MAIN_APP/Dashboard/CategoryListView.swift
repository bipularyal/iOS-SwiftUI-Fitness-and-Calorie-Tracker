import SwiftUI
import SwiftData

enum CategoryType {
    case force, level, mechanic, equipment, primaryMuscles, secondaryMuscles, category
}

struct CategoryListView: View {
    @Environment(\.modelContext) var modelContext
    let categoryType: CategoryType

    @State private var categories: [String] = []

    var body: some View {
        List(categories, id: \.self) { cat in
            NavigationLink(destination: WorkoutListView(filterType: categoryType, filterValue: cat)) {
                CategoryValueRow(title: cat, iconName: iconForCategoryValue(categoryType, value: cat))
            }
        }
        .navigationTitle(titleForCategory(categoryType))
        .onAppear {
            loadCategories()
        }
    }

    func loadCategories() {
        let workouts = try? modelContext.fetch(FetchDescriptor<WorkoutEntity>())
        guard let workouts = workouts else { return }

        var values: [String] = []
        for w in workouts {
            switch categoryType {
            case .force:
                if let val = w.force { values.append(val) }
            case .level:
                values.append(w.level)
            case .mechanic:
                if let val = w.mechanic { values.append(val) }
            case .equipment:
                if let val = w.equipment { values.append(val) }
            case .primaryMuscles:
                values.append(contentsOf: w.primaryMuscles)
            case .secondaryMuscles:
                values.append(contentsOf: w.secondaryMuscles)
            case .category:
                values.append(w.category)
            }
        }

        categories = Array(Set(values)).sorted()
    }

    func titleForCategory(_ type: CategoryType) -> String {
        switch type {
        case .force: return "Force"
        case .level: return "Level"
        case .mechanic: return "Mechanic"
        case .equipment: return "Equipment"
        case .primaryMuscles: return "Primary Muscles"
        case .secondaryMuscles: return "Secondary Muscles"
        case .category: return "Category"
        }
    }

    func iconForCategoryValue(_ type: CategoryType, value: String) -> String {
        switch type {
        case .force:
            return value == "pull" ? "arrow.up.right" : value == "push" ? "arrow.down.left" : "pause.circle.fill"
        case .level:
            return "star.fill" // Adjust based on level
        case .mechanic:
            return value == "compound" ? "gearshape.2.fill" : "gearshape.fill"
        case .equipment:
            return "hammer.fill" // Replace with specific equipment icons
        case .primaryMuscles, .secondaryMuscles:
            return "figure.strengthtraining.traditional" // Replace with muscle images
        case .category:
            return "chart.bar.fill"
        }
    }
}

// MARK: - CategoryValueRow
struct CategoryValueRow: View {
    let title: String
    let iconName: String

    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .foregroundColor(.accentColor)

            Text(title.capitalized)
                .font(.body)
                .foregroundColor(.primary)
        }
    }
}
