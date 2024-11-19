//
//  MainDataModel.swift
//  fitnessTracker
//
//  Created by Bipul Aryal on 11/17/24.
//

import SwiftUI
import Combine

enum DataLoadingStatus: String, Codable {
    case inProgress
    case notStarted
    case success
    case failure
}
enum DataNotFoundError: Error {
    case dataNotFound
}

final class MainDataModel: ObservableObject {
    @Published var userProfile: UserModel? = nil
    @Published var calorieProfile: CalorieModel? = nil
    @Published var fitnessProfile: FitnessModel? = nil
    @Published var isDataLoaded:DataLoadingStatus = .notStarted // To manage loading state

    private let dataHandler = DataHandler()
    private let userId: String

    init(userId: String) {
        self.userId = userId
        print(self.isDataLoaded,self.userProfile, self.calorieProfile, self.fitnessProfile, "already there")
    }

    /// Load all required user data
    func loadUserData() {
        isDataLoaded = .inProgress
        Task {
            do {
                let user = try dataHandler.fetchUserData(userId: self.userId)
                let calorie = try dataHandler.fetchCalorieData(userId: self.userId)
                let fitness = try dataHandler.fetchFitnessData(userId: self.userId)
                DispatchQueue.main.async {
                    self.userProfile = user
                    self.calorieProfile = calorie
                    self.fitnessProfile = fitness
                    if self.userProfile != nil && self.calorieProfile != nil && self.fitnessProfile != nil{
                        self.isDataLoaded = .success
                    } else{
                        self.isDataLoaded = .failure
                    }
                    print(self.isDataLoaded,self.userProfile, self.calorieProfile, self.fitnessProfile, " loaded")
                }
            } catch {
                print("Error loading user data: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.isDataLoaded = DataLoadingStatus.failure
                }
            }
        }
    }
    
    

    /// Save updated user data
    func saveUserData(user: UserModel) {
        Task {
            do {
                try dataHandler.saveOrUpdateUserData(user: user)
                DispatchQueue.main.async {
                    self.userProfile = user
                    if self.userProfile != nil && self.calorieProfile != nil && self.fitnessProfile != nil{
                        self.isDataLoaded = .success
                    }
                    print("User data saved successfully \(user)")
                }
            } catch {
                print("Error saving user data: \(error.localizedDescription)")
            }
        }
    }

    /// Save updated calorie data
    func saveCalorieData(calorie: CalorieModel) {
        Task {
            do {
                try dataHandler.saveOrUpdateCalorieData(calorie: calorie)
                DispatchQueue.main.async {
                    self.calorieProfile = calorie
                    if self.userProfile != nil && self.calorieProfile != nil && self.fitnessProfile != nil{
                        self.isDataLoaded = .success
                    }
                    print("Calorie data saved successfully \(calorie)")
                }
            } catch {
                print("Error saving calorie data: \(error.localizedDescription)")
            }
        }
    }

    /// Save updated fitness data
    func saveFitnessData(fitness: FitnessModel) {
        Task {
            do {
                try dataHandler.saveOrUpdateFitnessData(fitness: fitness)
                DispatchQueue.main.async {
                    self.fitnessProfile = fitness
                    if self.userProfile != nil && self.calorieProfile != nil && self.fitnessProfile != nil{
                        self.isDataLoaded = .success
                    }
                    print("fitness data saved successfully \(fitness)")
                }
            } catch {
                print("Error saving fitness data: \(error.localizedDescription)")
            }
        }
    }
}
