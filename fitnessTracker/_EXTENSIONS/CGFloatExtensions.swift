//
//
//
import Foundation
import SwiftUI
extension CGFloat {
    static var screenWidth: Double {
        return UIScreen.main.bounds.size.width
    }
    
    static var screenHeight: Double {
        return UIScreen.main.bounds.size.height
    }
    
    static func widthPer(per: Double) -> Double {
        return screenWidth * per;
        //375 * 0.5  // 50 % width return
    }
    
    static func heightPer(per: Double) -> Double {
        return screenHeight * per;
        //375 * 0.5  // 50 % width return
    }
    
    static var topInsets: Double {
        if let keyWindow = UIApplication.shared.keyWindow {
            return keyWindow.safeAreaInsets.top
        }
        return 0.0
    }
    
    static var bottomInsets: Double {
        if let keyWindow = UIApplication.shared.keyWindow {
            return keyWindow.safeAreaInsets.bottom
        }
        return 0.0
    }
    
    static var horizontalnsets: Double {
        if let keyWindow = UIApplication.shared.keyWindow {
            return keyWindow.safeAreaInsets.left  + keyWindow.safeAreaInsets.right
        }
        return 0.0
    }
    
    static var verticallnsets: Double {
        if let keyWindow = UIApplication.shared.keyWindow {
            return keyWindow.safeAreaInsets.top  + keyWindow.safeAreaInsets.bottom
        }
        return 0.0
    }
}
