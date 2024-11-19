//
//  WeeklyWeightChangeGoal.swift
//  fitnessTracker
//
//  Created by Bipul Aryal on 11/17/24.
//

import SwiftUI

import SwiftUI

struct WeeklyWeightChangeGoalView: View {
    let weightChangeGoalType: WeightGoalType
    @Binding var weightChangeGoal: Double
    let buttonPressAction: () -> Void

    let options = [0.5, 0.75, 1.0, 1.5, 1.75]

    var body: some View {
        VStack(spacing: 15) {
            Spacer()

            VStack(spacing: 15) {
                Text("Select Your Weekly Weight\(weightChangeGoalType == WeightGoalType.lose ? " Loss" : " Gain") Goal")
                    .font(.system(size: 20, weight: .semibold))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 15)

                ForEach(options, id: \.self) { option in
                    Button(action: {
                        weightChangeGoal = option
                    }, label: {
                        HStack(spacing: 25) {
                            Rectangle()
                                .fill(weightChangeGoal == option ? Color("c_appPrimary") : Color("c_greyPrimary"))
                                .frame(width: 20, height: 20)
                                .cornerRadius(10)

                            Text("\(option) lbs/week")
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
        }
    }
}

//#Preview {
//    WeeklyWeightChangeGoal()
//}
