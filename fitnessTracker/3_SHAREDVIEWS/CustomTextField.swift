//
//  RoundedTextArea.swift
//  fitnessTracker
//
//  Created by Bipul Aryal on 11/12/24.
//

import SwiftUI

struct CustomTextField: View {
    // MARK: - Configurable Parameters
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    var isPassword: Bool = false

    // MARK: - Design Constants
    private let textColor = Color("c_textPrimary")
    private let borderColor = Color("c_greyPrimary")
    private let cornerRadius: CGFloat = 12
    private let fieldHeight: CGFloat = 48
    private let padding: CGFloat = 4

    var body: some View {
        VStack(alignment: .leading) {


            if isPassword {
                SecureField("", text: $text)
                    .padding(padding)
                    .frame(height: fieldHeight)
                    .keyboardType(keyboardType)
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(borderColor, lineWidth: 1)
                    )
                    .cornerRadius(cornerRadius)
                    .foregroundColor(textColor)
            } else {
                TextField("", text: $text)
                    .padding(padding)
                    .keyboardType(keyboardType)
                    .frame(height: fieldHeight)
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(borderColor, lineWidth: 1)
                    )
                    .cornerRadius(cornerRadius)
                    .foregroundColor(textColor)
            }
        }
    }
}
