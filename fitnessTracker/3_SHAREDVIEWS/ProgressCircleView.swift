//
//  ProgressCircle.swift
//  fitnessTracker
//
//  Created by Bipul Aryal on 10/27/24.
//

import SwiftUI

struct ProgressCircleView: View {
    @Binding var progress: CGFloat
    var color: Color
    var lineWidth: CGFloat
    var goal : CGFloat
    
    var body: some View {
        ZStack {
            Circle()
                .trim(from:0, to:0.9)
                .stroke(color.opacity(0.4), style: StrokeStyle( lineWidth: lineWidth,  lineCap: .round))
                .rotationEffect(.degrees(108))
            Circle()
                .trim(from:0, to:(0.1+(progress/goal)*0.8))
                .stroke(color, style: StrokeStyle( lineWidth: lineWidth,  lineCap: .round))
                .rotationEffect(.degrees(108))
        }
    }
}

#Preview {
    let progress: CGFloat = 250
    ProgressCircleView(progress: .constant(progress), color: .red, lineWidth: 20, goal: 360.0)
}
