//
//  +View.swift
//  fitnessTracker
//
//  Created by Bipul Aryal on 10/29/24.
//

import SwiftUI

final class Utilities {
    static let shared = Utilities()
    private init() {}
    
    @MainActor
    func getRootViewController() -> UIViewController? {
        guard let screen = UIApplication.shared.connectedScenes
            .first as? UIWindowScene  else {
            return .init()
        }
        // 2
        guard let rootViewController = screen.windows.first?.rootViewController else {
            return .init()
        }
        return rootViewController
    }
    
    
}
