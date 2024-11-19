//
//  HeightSetterView.swift
//  fitnessTracker
//
//  Created by Bipul Aryal on 11/16/24.
//

import SwiftUI

struct AgeSetterView: View {
    @Binding var age: Int // Binding for age
    let buttonPressAction: () -> Void

    var body: some View {
        VStack {
            Spacer()

            VStack() {
                Text("Select Your Age")
                    .font(.system(size: 20, weight: .semibold))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 8)

                Picker("", selection: $age) {
                    ForEach(1 ... 120, id: \.self) { number in
                        Text("\(number)")
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
            Spacer()
        }
    }
}

//#Preview {
//    @State var age:Int = 0
//    AgeSetterView(age:$age)
//}
