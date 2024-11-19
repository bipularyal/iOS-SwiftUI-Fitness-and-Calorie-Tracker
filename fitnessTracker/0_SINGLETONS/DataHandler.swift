//
//  UserDataHandler.swift
//  fitnessTracker
//
//  Created by Bipul Aryal on 11/17/24.
//

import Foundation
import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "FitnessDataModel")
        container.loadPersistentStores { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
}


final class DataHandler {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.context = context
    }
    
    // MARK: - Fetch Data Functions
    func fetchUserData(userId: String) throws -> UserModel? {
        try context.performAndWait {
            let request: NSFetchRequest<UserProfileData> = UserProfileData.fetchRequest()
            request.predicate = NSPredicate(format: "userId == %@", userId  as CVarArg)
            
            let results = try context.fetch(request)
            guard let userEntity = results.first else { return nil }
            
            return UserModel(
                userId: userEntity.userId!,
                email: userEntity.email ?? "",
                phoneNumber: userEntity.phoneNumber,
                age: Int(userEntity.age),
                sex: userEntity.sex ?? "",
                height: HeightModel(feet: Int(userEntity.height?.feet ?? 0), inches: Int(userEntity.height?.inches ?? 0)),
                name: userEntity.name ?? "",
                profilePic: userEntity.profilePicLink
            )
        }
    }
    
    func fetchCalorieData(userId: String) throws -> CalorieModel? {
        try context.performAndWait {
            let request: NSFetchRequest<UserCalorieData> = UserCalorieData.fetchRequest()
            request.predicate = NSPredicate(format: "user.userId == %@", userId  as CVarArg)
            
            let results = try context.fetch(request)
            guard let calorieEntity = results.first else { return nil }
            
            return CalorieModel(
                userId: userId,
                goalWeight: calorieEntity.goalWeight,
                currentWeight: calorieEntity.currentWeight,
                dailyCalorieTarget: Int(calorieEntity.dailyCalorieTarget),
                maintainenceCalorieTarget: Int(calorieEntity.maintainenceCalorieTarget),
                weightGoalType: calorieEntity.weightGoalType == "gain" ? .gain : .lose,
                activityLevel: ActivityLevel(rawValue: calorieEntity.activityLevel ?? "") ?? .sedentary,
                weightChangePerWeek: calorieEntity.weightChangePerWeek
            )
        }
    }
    
    func fetchFitnessData(userId: String) throws -> FitnessModel? {
        try context.performAndWait {
            
            let request: NSFetchRequest<UserFitnessData> = UserFitnessData.fetchRequest()
            request.predicate = NSPredicate(format: "user.userId == %@", userId  as CVarArg)
            
            let results = try context.fetch(request)
            guard let fitnessEntity = results.first else { return nil }
            print(fitnessEntity)
            return FitnessModel(
                userId: userId,
                fitnessLevel: FitnessLevel(rawValue: fitnessEntity.fitnessLevel ?? "") ?? .beginner,
                weeklyWorkoutGoal: Int(fitnessEntity.weelkyWorkoutGoal)
            )
        }
    }
    
    // MARK: - Save or Update Data Functions
    func saveOrUpdateUserData(user: UserModel) throws {
        try context.performAndWait {
            let request: NSFetchRequest<UserProfileData> = UserProfileData.fetchRequest()
            request.predicate = NSPredicate(format: "userId == %@", user.userId as CVarArg)
            
            let results = try context.fetch(request)
            let userEntity = results.first ?? UserProfileData(context: context)
            
            // Update or Create User
            userEntity.userId = user.userId
            userEntity.email = user.email
            userEntity.phoneNumber = user.phoneNumber
            userEntity.age = Int16(user.age)
            userEntity.sex = user.sex
            userEntity.name = user.name
            userEntity.profilePicLink = user.profilePic
            
            // Height relationship
            if userEntity.height == nil {
                userEntity.height = Height(context: context)
            }
            
            if let height = userEntity.height {
                height.feet = Int32(user.height.feet)
                height.inches = Int32(user.height.inches)
            }
            try context.save()
        }
        
    }
    
    func saveOrUpdateCalorieData(calorie: CalorieModel) throws {
        try context.performAndWait{
            let request: NSFetchRequest<UserCalorieData> = UserCalorieData.fetchRequest()
            request.predicate = NSPredicate(format: "user.userId == %@", calorie.userId as CVarArg )
            
            let results = try context.fetch(request)
            let calorieEntity = results.first ?? UserCalorieData(context: context)
            
            // Update or Create Calorie
            calorieEntity.goalWeight = calorie.goalWeight
            calorieEntity.currentWeight = calorie.currentWeight
            calorieEntity.dailyCalorieTarget = Int32(calorie.dailyCalorieTarget)
            calorieEntity.maintainenceCalorieTarget = Int32(calorie.maintainenceCalorieTarget)
            calorieEntity.weightGoalType = calorie.weightGoalType == .gain ? "gain" : "lose"
            calorieEntity.activityLevel = calorie.activityLevel.rawValue
            calorieEntity.weightChangePerWeek = calorie.weightChangePerWeek
            
            // Set relationship to User
            if calorieEntity.user == nil {
                let userRequest: NSFetchRequest<UserProfileData> = UserProfileData.fetchRequest()
                userRequest.predicate = NSPredicate(format: "userId == %@", calorie.userId as CVarArg)
                if let userEntity = try context.fetch(userRequest).first {
                    calorieEntity.user = userEntity
                }
            }
            try context.save()
        }
    }
    
    func saveOrUpdateFitnessData(fitness: FitnessModel) throws {
        try context.performAndWait{
            let request: NSFetchRequest<UserFitnessData> = UserFitnessData.fetchRequest()
            request.predicate = NSPredicate(format: "user.userId == %@", fitness.userId as CVarArg)
            
            let results = try context.fetch(request)
            let fitnessEntity = results.first ?? UserFitnessData(context: context)
            
            // Update or Create Fitness
            fitnessEntity.fitnessLevel = fitness.fitnessLevel.rawValue
            fitnessEntity.weelkyWorkoutGoal = Int16(fitness.weeklyWorkoutGoal)
            
            // Set relationship to User
            if fitnessEntity.user == nil {
                let userRequest: NSFetchRequest<UserProfileData> = UserProfileData.fetchRequest()
                userRequest.predicate = NSPredicate(format: "userId == %@", fitness.userId as CVarArg)
                if let userEntity = try context.fetch(userRequest).first {
                    fitnessEntity.user = userEntity
                }
            }
            try context.save()
        }
    }
}

