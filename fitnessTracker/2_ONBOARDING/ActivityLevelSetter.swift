//
//  ActivityLevelSetter.swift
//  fitnessTracker
//
//  Created by Bipul Aryal on 11/17/24.
//

import SwiftUI

import SwiftUI

struct ActivityLevelSetterView: View {
    @Binding var activityLevel: ActivityLevel
    let buttonPressAction: () -> Void
    
    var body: some View {
        VStack(spacing: 15) {
            Spacer()

            VStack(spacing: 15) {
                Text("Select Your Activity Level")
                    .font(.system(size: 20, weight: .semibold))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 15)

                ForEach(ActivityLevel.allCases, id: \.self) { level in
                    Button(action: {
                        activityLevel = level
                    }, label: {
                        HStack(spacing: 25) {
                            Rectangle()
                                .fill(activityLevel == level ? Color("c_appPrimary") : Color("c_greyPrimary"))
                                .frame(width: 20, height: 20)
                                .cornerRadius(10)

                            Text("\(level.rawValue) (\(level.workoutHours.description))")
                                .font(.system(size: 15))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundColor(Color("c_textPrimary"))
                        }
                    })
                    .padding(.horizontal, 20)
                }

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
            Spacer()
        }
    }
}

//#Preview {
//    ActivityLevelSetter()
//}
