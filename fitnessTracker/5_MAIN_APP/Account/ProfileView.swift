//
//  ProfileView.swift
//  fitnessTracker
//
//  Created by Bipul Aryal on 11/16/24.
//

import SwiftUI

struct ProfileView: View {
    let user: UserModel
    let editProfileAction: () -> Void
    var body: some View {
        VStack() {
            VStack{
                HStack() {
                    // Profile Picture
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
                    Spacer()
                    Button(action: {
                        editProfileAction()
                    }) {
                        Text("Edit")
                            .foregroundColor(Color("c_appSecondary"))
                    }
                }
                .padding(.horizontal)
                    Text(user.name) // Fallback if name is nil
                        .font(.headline)
                        .foregroundColor(Color("c_textPrimary"))
                    
                    Text(user.email)
                        .font(.subheadline)
                        .foregroundColor(Color("c_textPrimary"))
            }
            .padding(.horizontal)
            .padding(.top)
            VStack(alignment: .leading) {
                HStack {
                    Text("Sex")
                        .font(.subheadline)
                        .foregroundColor(Color("c_textPrimary"))
                    Spacer()
                    Text(user.sex)
                        .font(.subheadline)
                        .foregroundColor(Color("c_textPrimary"))
                    Spacer()
                    Spacer()
                }
                .padding(.horizontal)
                
                // Age
                HStack {
                    Text("Age")
                        .font(.subheadline)
                        .foregroundColor(Color("c_textPrimary"))
                    Spacer()
                    Text("\(user.age)")
                        .font(.subheadline)
                        .foregroundColor(Color("c_textPrimary"))
                    Spacer()
                    Spacer()
                }
                .padding(.horizontal)
                
                // Height
                HStack {
                    Text("Height")
                        .font(.subheadline)
                        .foregroundColor(Color("c_textPrimary"))
                    Spacer()
                    Text("\(user.height.feet) ft \(user.height.inches) in")
                        .font(.subheadline)
                        .foregroundColor(Color("c_textPrimary"))
                    Spacer()
                    Spacer()
                }
                .padding(.horizontal)
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .background(Color("c_greySecondary"))
        .cornerRadius(10)
        .shadow(radius: 3)
        .padding()
    }
}

#Preview {
    ProfileView(user: UserModel(
        userId: "UUID()",
        email: "john.doe@example.com",
        phoneNumber: "+1234567890",
        age: 30,
        sex: "Male",
        height: HeightModel(feet: 5, inches: 11),
        name: "John Doe"
    ),editProfileAction: {})
}
