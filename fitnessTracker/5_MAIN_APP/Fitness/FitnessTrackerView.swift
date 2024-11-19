//
//  PlanView.swift
//  fitnessTracker
//
//  Created by Bipul Aryal on 10/24/24.
//

import SwiftUI

struct FitnessTrackerView: View {
    @EnvironmentObject var authProvider: AuthenticationProvider
    @State var calories: CGFloat = 100
    @State var activeTime: CGFloat = 40
    @State var standTime: CGFloat = 6
    var body: some View {
        ScrollView {
            VStack{
                Text("Welcome Bipul").font(.largeTitle)
                    .padding()
                HStack{
                    Spacer()
                    Button(action: {
                        Task {
                            try await authProvider.signOut()
                        }
                    }
                        ,label: {
                            Image(systemName: "logout")
                        Text("Sign Out")
                        })
                    
                    VStack{
                        VStack{
                            Text(" Calories").font(.callout).bold().foregroundColor(.red)
                            Text("1000").bold()
                        }.padding(.bottom)
                        VStack{
                            Text(" ActivityTime").font(.callout).bold().foregroundColor(.green)
                            Text("1000 mins").bold()
                        }.padding(.bottom)
                        VStack{
                            Text("Stand Time").font(.callout).bold().foregroundColor(.blue)
                            Text("4 hours").bold()
                        }
                    }
                    Spacer()
                    ZStack{
                        ProgressCircleView(progress: $calories, color: .red, lineWidth: 20, goal: CGFloat(500.0))
                        ProgressCircleView(progress: $activeTime, color: .green, lineWidth: 20, goal: CGFloat(60)).padding(20)
                        ProgressCircleView(progress: $standTime, color: .blue, lineWidth: 20, goal: CGFloat(4)).padding(40)
                        Spacer()
                    }.padding()
                    Spacer()
                }
                LazyVGrid(columns:Array(repeating:GridItem(spacing:10), count:2)){
//                    ActivitySectionCardView(activity: Activity(
//                        id: 1,
//                        activityType: "Steps",
//                        goal: "10000",
//                        iconName: "figure.walk",
//                        progressAmount: "6,121",
//                        color: Color(uiColor: .systemGray6)
//                    ))
//                    ActivitySectionCardView(activity: Activity(
//                        id: 1,
//                        activityType: "Steps",
//                        goal: "10000",
//                        iconName: "figure.walk",
//                        progressAmount: "6,121",
//                        color: Color(uiColor: .systemGray6)
//                    ))
//                    ActivitySectionCardView(activity: Activity(
//                        id: 1,
//                        activityType: "Steps",
//                        goal: "10000",
//                        iconName: "figure.walk",
//                        progressAmount: "6,121",
//                        color: Color(uiColor: .systemGray6)
//                    ))
//                    ActivitySectionCardView(activity: Activity(
//                        id: 1,
//                        activityType: "Steps",
//                        goal: "10000",
//                        iconName: "figure.walk",
//                        progressAmount: "6,121",
//                        color: Color(uiColor: .systemGray6)
//                    ))
                }.padding(.horizontal)
            }
        }
    }
}

#Preview {
    FitnessTrackerView()
}
