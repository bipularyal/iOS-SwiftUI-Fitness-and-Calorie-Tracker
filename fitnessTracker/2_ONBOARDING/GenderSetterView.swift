//
//  GenderSetterView.swift
//  fitnessTracker
//
//  Created by Bipul Aryal on 11/16/24.
//

import SwiftUI

struct GenderSetterView: View {
    @Binding var gender: String // Binding to selected gender
    let buttonPressAction: () -> Void
    var body: some View {
        VStack(spacing: 15) {
            Spacer()

            VStack(spacing: 15) {
                Text("Select Your Gender")
                    .font(.system(size: 20, weight: .semibold))
                    .frame(maxWidth: .infinity)
                    .padding(.top, 15)

                ForEach(["Male", "Female", "Non-Binary", "Skip For Now"], id: \.self) { option in
                    Button(action: {
                        gender = option
                    }, label: {
                        HStack(spacing: 25) {
                            Rectangle()
                                .fill(gender == option ? Color("c_appPrimary") : Color("c_greyPrimary"))
                                .frame(width: 20, height: 20)
                                .cornerRadius(10)

                            Text(option)
                                .font(.system(size: 20))
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
//    @State var gender = "Male"
//    GenderSetterView(gender: $gender)
//}
