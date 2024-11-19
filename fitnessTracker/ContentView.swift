//
//  ContentView.swift
//  fitnessTracker
//
//  Created by Bipul Aryal on 10/16/24.
//

import SwiftUI
import Firebase
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    
    
    func importWorkoutsIfNeeded(modelContext: ModelContext) {
//        do {
//            try modelContext.delete(model: WorkoutEntity.self)
//        } catch {
//            print("Failed to clear all Country and City data.")
//        }
        let fetch = FetchDescriptor<WorkoutEntity>()
        if let count = try? modelContext.fetch(fetch).count, count > 0 {
            return // already imported
        }

        guard let url = Bundle.main.url(forResource: "WorkoutData", withExtension: "json") else { return }
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let workoutsFromJSON = try decoder.decode([WorkoutJSON].self, from: data)
           
            for w in workoutsFromJSON {
                let entity = WorkoutEntity(
                    id: w.id,
                    name: w.name,
                    force: w.force,
                    level: w.level,
                    mechanic: w.mechanic,
                    equipment: w.equipment,
                    primaryMuscles: w.primaryMuscles,
                    secondaryMuscles: w.secondaryMuscles,
                    instructions: w.instructions,
                    category: w.category,
                    images: w.images
                )
                modelContext.insert(entity)
                print(w.images)
            }

            try modelContext.save()
        } catch {
            print("Error importing workouts: \(error)")
        }
    }
    
    
    let userId : String
    @EnvironmentObject var authProvider: AuthenticationProvider
    @StateObject var mainDataModel:MainDataModel
    
    
    init(userId: String) {
            self.userId = userId
            _mainDataModel = StateObject(wrappedValue: MainDataModel(userId: userId))
        }
    
    var body: some View {
        ZStack {
                    switch mainDataModel.isDataLoaded {
                        case .notStarted, .inProgress:
                            LoadingView() // Show loading spinner or placeholder
                                .onAppear {
                                    if mainDataModel.isDataLoaded == .notStarted {
                                        mainDataModel.loadUserData()
                                    }
                                }
                        case .success:
                            MainPageView()
                                .environmentObject(mainDataModel)
                                
                        case .failure:
                            WelcomeView()
                                .environmentObject(mainDataModel)
                        }
        }.onAppear(
            perform: {importWorkoutsIfNeeded(modelContext: modelContext)}
        )
            }
        }

#Preview {
    ContentView(userId: "UUID()")
}
