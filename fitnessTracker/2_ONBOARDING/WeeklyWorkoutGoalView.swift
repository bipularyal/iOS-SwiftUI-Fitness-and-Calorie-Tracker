//
//  WeeklyWorkoutGoalView.swift
//  fitnessTracker
//
//  Created by Bipul Aryal on 11/17/24.
//

import SwiftUI

import SwiftUI

struct WeeklyWorkoutGoalView: View {
    @Binding var weeklyWorkoutGoal: Int
    let buttonPressAction: () -> Void
    
    var body: some View {
        VStack {
            Spacer()

            VStack {
                Text("Set Your Weekly Workout Goal")
                    .font(.system(size: 20, weight: .semibold))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 8)

                Picker("", selection: $weeklyWorkoutGoal) {
                    ForEach(1...7, id: \.self) { number in
                        Text("\(number) workouts/week")
                            .tag(number)
                    }
                }
                .pickerStyle(.wheel)

                Button(action: {
                    buttonPressAction()
                }, label: {
                    Text("Done")
                        .font(.system(size: 18, weight: .bold))
                        .frame(maxWidth: .infinity, alignment: .center)
                })
                .foregroundColor(Color("c_appPrimary"))
            }
            .padding(.vertical)
            .background(Color("c_greySecondary"))
            .cornerRadius(25)
            .shadow(radius: 10)
            .padding()

            Spacer()
            Spacer()
        }
    }
}
