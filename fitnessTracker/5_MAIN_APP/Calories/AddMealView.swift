//
//  AddMealView.swift
//  fitnessTracker
//
//  Created by Bipul Aryal on 12/10/24.
//

import SwiftUI

// MARK: - SearchMealView
struct SearchMealView: View {
    @Binding var isPresented: Bool
    let onDone: (FoodEntryModel) -> Void
    
    @StateObject private var viewModel = SearchMealViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                // Search bar at top
                HStack {
                    TextField("Search for a meal...", text: $viewModel.searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.leading)
                        .onSubmit { // Trigger search when return is pressed
                                            viewModel.isSearching = true
                            Task {
                                await viewModel.triggerSearch()
                                }
                                        }
                    
                    Button(action: {
                        viewModel.isSearching = true
                        Task {
                            await viewModel.triggerSearch()
                            }
                    }) {
                        Text("Search")
                            .padding(.trailing)
                    }
                }
                .padding(.vertical)
                
                if !viewModel.searchText.isEmpty && !viewModel.isSearching{
                    Button(action: {
                        viewModel.isSearching = true
                        Task {
                            await viewModel.triggerSearch()
                            }
                    }) {
                        Text("Search for \(viewModel.searchText)")
                    }
                }
                
                if viewModel.searchResults.isEmpty {
                
                    Spacer()
                    Text("No results yet. Try searching!")
                        .foregroundColor(.secondary)
                    Spacer()
                } else {
                    List(viewModel.searchResults, id: \.id) { food in
                           NavigationLink(destination: FoodQuantityAdjustView(
                               isPresented: $isPresented,
                               food: food,
                               onDone: { entry in
                                   onDone(entry)
                                   isPresented = false
                               })) {
                                   HStack {
                                       VStack(alignment: .leading) {
                                           Text(food.name).font(.caption)
                                           Text("Serving: \(Int(food.defaultServingSize)) \(food.servingOptions.unitName)")
                                               .font(.caption2)
                                           HStack{
                                               Text("\(Int(food.servingOptions.fatPerUnit * food.defaultServingSize))g fat")
                                               Text("\(Int(food.servingOptions.proteinPerUnit * food.defaultServingSize))g protein")
                                               Text("\(Int(food.servingOptions.carbsPerUnit * food.defaultServingSize))g carbs")
                                           }.font(.caption2)
                                           
                                           // Since we don't have per-serving macros defined in FoodModel yet,
                                           // just show the defaultCalories if available
                                           
                                       }
                                       Spacer()
                                       if let defaultCalories = food.defaultCalories {
                                           Text("\(Int(defaultCalories)) calories")
                                       }
                                   }
                                   .padding()
                               }
                       }
                }
            }
            .navigationBarTitle("Search Meal", displayMode: .inline)
            .navigationBarItems(leading: Button("Cancel") {
                isPresented = false
            })
        }
    }
}
