//
//  UIColor+Extension.swift
//  RESTchallenge
//
//  Created by Kraig Wastlund on 6/1/19.
//  Copyright © 2019 Kraig Wastlund. All rights reserved.
//

import UIKit
import DBC

extension UIColor {
    
    static func fromHexString(hex: String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        guard cString.count == 6 else {
            requireFailure("hex string must be `hex` dummy.")
            return UIColor()
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
