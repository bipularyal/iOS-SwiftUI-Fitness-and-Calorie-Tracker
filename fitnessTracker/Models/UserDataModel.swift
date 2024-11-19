//
//  AuthDataModel.swift
//  fitnessTracker
//
//  Created by Bipul Aryal on 10/29/24.
//
import FirebaseAuth

struct UserDataModel{
    let uid: String
    let email: String?
    let name: String?
    let photoURL: String?
    
    init(user:User){
        self.email = user.email
        self.uid = user.uid
        self.name = user.displayName
        self.photoURL = user.photoURL?.absoluteString
    }
}

struct HeightModel{
    let feet: Int
    let inches: Int
}


struct UserModel {
    let userId: String // Unique ID
    let email: String
    var phoneNumber: String? // Optional, can be null
    var age: Int
    var sex: String // e.g., "Male", "Female", or "Other"
    var height: HeightModel // Height in cm
    var name: String // User's name
    var profilePic: URL?
}
