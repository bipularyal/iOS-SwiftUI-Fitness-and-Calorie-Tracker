//
//  Button.swift
//  fitnessTracker
//
//  Created by Bipul Aryal on 11/12/24.
//

import SwiftUI

import SwiftUI

enum ButtonType {
    case primary
    case secondary
}

struct CustomizableButton: View {
    let text: String
    let buttonType: ButtonType
    var action: () -> Void
    let height :    CGFloat
    private let maxWidth: CGFloat = .infinity
    //    private let controlSize: ControlSize = .large
    
    init(text: String, buttonType: ButtonType = .primary, action: @escaping () -> Void,height: CGFloat = 50) {
        self.text = text
        self.buttonType = buttonType
        self.action = action
        self.height = height
    }
    
    private var backgroundColor: Color {
        switch buttonType {
        case .primary:
            return Color("c_buttonPrimaryBack") // Custom primary button background color
        case .secondary:
            return Color("c_buttonSecBack") // Custom secondary button background color
        }
    }
    
    private var textColor: Color {
        switch buttonType {
        case .primary:
            return Color("c_buttonPrimaryText") // Custom primary button text color
        case .secondary:
            return Color("c_buttonSecText") // Custom secondary button text color
        }
    }
    
    private var cornerRadius: CGFloat = 10
    
    var body: some View {
        
        Button(action:action) {
            Text(text)
                .frame(maxWidth: maxWidth, minHeight: height)
                .background(backgroundColor)
                .foregroundColor(textColor)
                .cornerRadius(cornerRadius)
        }
    }
}


//#Preview {
//    Button()
//}
