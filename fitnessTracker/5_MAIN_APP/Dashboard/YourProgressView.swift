//
//  YourProgressView.swift
//  fitnessTracker
//
//  Created by Bipul Aryal on 12/11/24.
//

import SwiftUI
import SwiftData
import Charts


struct YourProgressView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var logs: [DailyFoodLogModel] = []
    @State private var startDate: Date = Calendar.current.date(byAdding: .month, value: -1, to: Date())!
    @State private var endDate: Date = Date()
    @State private var selectedNutrient: NutrientType = .calories

    var body: some View {
        VStack {
            // Nutrient Picker
            Picker("", selection: $selectedNutrient) {
                Text("Calories").tag(NutrientType.calories)
                Text("Protein").tag(NutrientType.protein)
                Text("Carbs").tag(NutrientType.carbs)
                Text("Fat").tag(NutrientType.fat)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            // Date Range Pickers
            VStack {
                DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                    .datePickerStyle(CompactDatePickerStyle())
                    .onChange(of: startDate) { _ in fetchLogs() }

                DatePicker("End Date", selection: $endDate, displayedComponents: .date)
                    .datePickerStyle(CompactDatePickerStyle())
                    .onChange(of: endDate) { _ in fetchLogs() }
            }
            .padding()

            // Chart
            Chart(logs) { log in
                BarMark(
                    x: .value("Date", log.date, unit: .day),
                    y: .value(selectedNutrient.rawValue, valueForNutrient(log, nutrient: selectedNutrient))
                )
                .foregroundStyle(colorForNutrient(selectedNutrient))
            }
            .frame(height: 300)
            .onAppear {
                fetchLogs()
            }
        }
        .padding()
    }

    func fetchLogs() {
        let fetch = FetchDescriptor<DailyFoodLogEntity>()
        if let allLogs = try? modelContext.fetch(fetch) {
            logs = allLogs
                .filter { log in
                    log.date >= startDate && log.date <= endDate
                }
                .map { DailyFoodLogModel(entity: $0) }

            logs = fillMissingDates(logs: logs, startDate: startDate, endDate: endDate)
        }
    }

    func fillMissingDates(logs: [DailyFoodLogModel], startDate: Date, endDate: Date) -> [DailyFoodLogModel] {
        let calendar = Calendar.current
        var date = startDate
        var completeLogs: [DailyFoodLogModel] = []

        while date <= endDate {
            if let log = logs.first(where: { calendar.isDate($0.date, inSameDayAs: date) }) {
                completeLogs.append(log)
            } else {
                completeLogs.append(
                    DailyFoodLogModel(
                        id: UUID(),
                        userId: "placeholder",
                        date: date,
                        meals: []
                    )
                )
            }
            date = calendar.date(byAdding: .day, value: 1, to: date)!
        }

        return completeLogs
    }

    func valueForNutrient(_ log: DailyFoodLogModel, nutrient: NutrientType) -> Double {
        switch nutrient {
        case .calories:
            return log.totalCalories
        case .protein:
            return log.totalProtein
        case .carbs:
            return log.totalCarbs
        case .fat:
            return log.totalFat
        }
    }

    func colorForNutrient(_ nutrient: NutrientType) -> Color {
        switch nutrient {
        case .calories:
            return .blue
        case .protein:
            return .green
        case .carbs:
            return .orange
        case .fat:
            return .red
        }
    }
}

// MARK: - NutrientType Enum
enum NutrientType: String {
    case calories = "Calories"
    case protein = "Protein"
    case carbs = "Carbs"
    case fat = "Fat"
}
