//
//  WeightSetterView.swift
//  fitnessTracker
//
//  Created by Bipul Aryal on 11/17/24.
//

import SwiftUI

struct WeightSetterView: View {
    let displayText: String
    @Binding var weight: Double // Binding for weight in lbs
    let buttonPressAction: () -> Void
    
    var body: some View {
        VStack {
            Spacer()

            VStack {
                Text(displayText)
                    .font(.system(size: 20, weight: .semibold))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 8)

                Picker(" lbs", selection: $weight) {
                    ForEach(50...550, id: \.self) { number in
                        Text("\(number) lbs")
                            .tag(Double(number))
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
            Spacer()
        }
    }
}

//#Preview {
//    WeightSetterView()
//}
