//
//  NameSetterView.swift
//  fitnessTracker
//
//  Created by Bipul Aryal on 11/16/24.
//

import SwiftUI

struct NameSetterView: View {
    @Binding var name: String
    let buttonPressAction: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            VStack(alignment: .leading) {
                
                Text("Enter Your Name")
                    .font(.system(size: 20, weight: .semibold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 15)
                
                TextField("e.g., Jane Doe", text: $name)
                    .padding(.horizontal, 20)
                    .frame(height: 50)
                    .foregroundColor(Color("c_textPrimary"))
                    .background(Color("c_greySecondary"))
                    .overlay(
                        RoundedRectangle(cornerRadius: 25.0)
                            .stroke(Color("c_greyPrimary"), lineWidth: 1)
                    )
                    .padding(.bottom, 15)
                
                Button(action: {
                    buttonPressAction()
                               }, label: {
                                   Text("Done")
                                       .font(.system(size: 18, weight: .bold))
                                       .frame(maxWidth: .infinity, alignment: .center)
                               })
                               .foregroundColor(Color("c_appPrimary"))

            }
            .padding()
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
//    @State var name = ""
//    NameSetterView(name: $name)
//}
