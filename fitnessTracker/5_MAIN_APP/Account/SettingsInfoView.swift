//
//  SettingsInfoView.swift
//  fitnessTracker
//
//  Created by Bipul Aryal on 11/17/24.
//

import SwiftUI

struct SettingsInfoView: View {
    let title: String
       let value: String
       let action: () -> Void // Action for "Edit" button
    var body: some View {
        
               HStack {
                   VStack(alignment: .leading, spacing: 4) {
                           let words = title.split(separator: " ")
                        if words.count >= 2 {
                            let firstLine = words.prefix(words.count / 2).joined(separator: " ")
                            let secondLine = words.suffix(words.count - words.count / 2).joined(separator: " ")
                            
                            Text(firstLine)
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(Color("c_textPrimary"))
                            
                            Text(secondLine)
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(Color("c_textPrimary"))
                        } else{
                            Text(title)
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(Color("c_textPrimary"))
                        }
                       }
                   Spacer()
                   Text(value)
                       .font(.system(size: 17, weight: .semibold))
                       .foregroundColor(Color("c_textSecondary"))
                   Spacer()
                   Spacer()
                   Button(action: action) {
                       Text("Edit")
                           .font(.system(size: 15, weight: .medium))
                           .foregroundColor(Color("c_appSecondary"))
                           
                   }
                   
               }
               .background(Color("c_greySecondary"))
               .cornerRadius(5)
               .padding(.horizontal)
               .padding(.bottom)
           }
}

#Preview {
    SettingsInfoView(title: "Title", value: "Value", action: {})
}
