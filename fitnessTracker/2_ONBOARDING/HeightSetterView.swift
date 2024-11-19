//
//  HeightSetterView.swift
//  fitnessTracker
//
//  Created by Bipul Aryal on 11/16/24.
//

import SwiftUI

struct HeightSetterView: View {
    @Binding var feet: Int
    @Binding var inches: Int
    let buttonPressAction: () -> Void
    var body: some View {
        VStack(spacing: 15) {
            Spacer()
            VStack {
                Text("Select Your Height")
                    .font(.system(size: 20, weight: .semibold))
                    .frame(maxWidth: .infinity)
                    .padding(.top, 15)
                
                HStack(spacing: 15) {
                    Picker("", selection: $feet) {
                        ForEach(1 ... 10, id: \.self) { number in
                            Text("\(number) Ft")
                        }
                    }
                    .pickerStyle(.wheel)
                    
                    Picker("", selection: $inches) {
                        ForEach(0 ... 11, id: \.self) { number in
                            Text("\(number) In")
                        }
                    }
                    .pickerStyle(.wheel)
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
//    @State var feet = 6
//    @State var inches = 2
//    HeightSetterView(feet: $feet, inches: $inches)
//}
