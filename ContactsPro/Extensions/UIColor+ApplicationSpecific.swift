/*
    Copyright (C) 2014 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    
                Application-specific color convenience methods.
            
*/

import UIKit

extension UIColor {
    class func applicationGreenColor() -> UIColor {
        return UIColor(red: 0.553, green: 1.000, blue: 0.055, alpha: 1.000)
    }

    class func applicationYellowColor() -> UIColor {
        return UIColor(red: 0.941, green: 0.859, blue: 0.063, alpha: 1.000)
    }

    class func applicationRedColor() -> UIColor {
        return UIColor(red: 0.937, green: 0.008, blue: 0.055, alpha: 1.000)
    }
    
    class func applicationBlueColor() -> UIColor {
        return UIColor(red: 0.125, green: 0.494, blue: 1.000, alpha: 1.000)
    }
    
    class func applicationGrayColor() -> UIColor {
        return UIColor(red: 0.514, green: 0.506, blue: 0.518, alpha: 1.000)
    }
    
    class func applicationBlackColor() -> UIColor {
        return UIColor(red: 0.196, green: 0.208, blue: 0.216, alpha: 1.000)
    }
}
