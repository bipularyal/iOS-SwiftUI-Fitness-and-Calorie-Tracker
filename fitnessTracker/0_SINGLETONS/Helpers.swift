//
//  Helpers.swift
//  fitnessTracker
//
//  Created by Bipul Aryal on 12/10/24.
//

import SwiftUI

struct OffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
