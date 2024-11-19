//
//  EditProfileView.swift
//  fitnessTracker
//
//  Created by Bipul Aryal on 11/16/24.
//

import SwiftUI

struct EditProfileView: View {
    @Binding var user: UserModel // Binding to update user data directly
    let okayClicked: () -> Void
    let cancelClicked: () -> Void
    @Environment(\.dismiss) var dismiss // For dismissing the sheet
    @State var gender = "Male"
    @State var age = 0
    @State var feet =  0
    @State var inches = 0
    @State var weight = 0
    @State var name = ""
    @State var inMainSheet = true
    @State private var navigationPath = NavigationPath()

    var body: some View {
        // Save and Cancel Buttons
        VStack{
            NavigationStack(path: $navigationPath) {
                VStack(spacing: 20) {
                    HStack {
                                    Button("Cancel") {
                                        cancelClicked()
                                    }.foregroundStyle(.red)
                                    Spacer()
                                    Button("Done")  {
                                        user = UserModel(
                                            userId: user.userId,
                                            email: user.email,
                                            phoneNumber: user.phoneNumber,
                                            age: age,
                                            sex: gender,
                                            height: HeightModel(feet: feet, inches: inches),
                                            name: name,
                                            profilePic: user.profilePic
                                        )
                                        dismiss()
                                        okayClicked()
                                    }
                                }
                                .padding()
                                
                    // Profile Photo and Name
                    Spacer()
                    VStack{
                        VStack {
                            if let profilePicURL = user.profilePic{
                                AsyncImage(url: profilePicURL) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView() // Loading state
                                            .frame(width: 50, height: 50)
                                            .clipShape(Circle())
                                            .overlay(Circle().stroke(Color("c_appSecondary"), lineWidth: 1))
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 50, height: 50)
                                            .clipShape(Circle())
                                            .overlay(Circle().stroke(Color("c_appSecondary"), lineWidth: 1))
                                            .foregroundColor(Color("c_appSecondary"))
                                    case .failure:
                                        Image(systemName: "person.fill")
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 50, height: 50)
                                            .clipShape(Circle())
                                            .overlay(Circle().stroke(Color("c_appSecondary"), lineWidth: 1))
                                            .foregroundColor(Color("c_appSecondary"))
                                    @unknown default:
                                        EmptyView()
                                    }
                                }
                            } else {
                                Image(systemName: "person.fill") // Fallback for missing URL
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color("c_appSecondary"), lineWidth: 1))
                                    .foregroundColor(Color("c_appSecondary"))
                            }
                        }
                        .padding()
                        
                        // About You Section
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Your Info")
                                .font(.headline)
                                .foregroundColor(Color("c_textSecondary"))
                                .padding(.bottom, 5)
                            
                            NavigationLink(destination: NameSetterView(name: $name, buttonPressAction: {navigationPath = NavigationPath()})) {
                                EditRow(title: "Name", value: name)
                            }
                            
                            // Gender Row
                            NavigationLink(destination: GenderSetterView(gender: $gender, buttonPressAction: {navigationPath = NavigationPath() })) {
                                EditRow(title: "Gender", value: gender)
                            }
                            
                            // Birthday Row
                            NavigationLink(destination: AgeSetterView(age: $age, buttonPressAction: {navigationPath = NavigationPath()})) {
                                EditRow(title: "Age", value:"\(age)")
                            }
                            
                            NavigationLink(destination: HeightSetterView(feet:$feet, inches: $inches, buttonPressAction: {navigationPath = NavigationPath()})) {
                                EditRow(title: "Height", value: "\(feet) Feet, \(inches) Inches")
                            }
                        }
                    }
                    .background(Color("c_greySecondary"))
                    .cornerRadius(12)
                    .padding()
                    Spacer()
                    Spacer()
                    Spacer()
                    
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color(.gray)
                .opacity(0.2))
            .padding()
        }
        .onAppear {
                   // Initialize the states with the current user data
                   gender = user.sex
                   age = user.age
                   feet = user.height.feet
                   inches = user.height.inches
                   name = user.name
               }
    }
    }

    struct EditRow: View {
        var title: String
        var value: String
        
        var body: some View {
            HStack {
                Text(title)
                    .font(.system(size: 14))
                    .foregroundColor(Color("c_textPrimary"))
                
                Spacer()
                
                Text(value)
                    .font(.system(size: 14))
                    .foregroundColor(Color("c_textSecondary"))
                
                Image(systemName: "chevron.right")
                    .foregroundColor(Color("c_greyPrimary"))
            }
            .padding(.vertical, 10)
        }
    }





//#Preview {
//    @State var isEditing: Bool = false
//    EditProfileView(user: UserModel(
//        userId: "UUID()",
//        email: "john.doe@example.com",
//        phoneNumber: "+1234567890",
//        age: 30,
//        sex: "Male",
//        height: HeightModel(feet: 5, inches: 11),
//        name: "John Doe"
//    ))
//}
