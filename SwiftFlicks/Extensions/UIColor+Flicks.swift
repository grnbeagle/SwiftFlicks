//
//  UIColor+Flicks.swift
//  SwiftFlicks
//
//  Created by Amie Kweon on 4/19/15.
//  Copyright (c) 2015 Rdio. All rights reserved.
//

import Foundation

extension UIColor {
    class func flicksDarkRedColor() -> UIColor {
        return UIColor(red: 128/255, green: 21/255, blue: 21/255, alpha: 1)
    }

    class func flicksSeparatorColor() -> UIColor {
        return UIColor(red: 170/255, green: 57/255, blue: 57/255, alpha: 1)
    }

    class func flicksDarkGrayColor() -> UIColor {
        return UIColor(red: 44/255, green: 51/255, blue: 61/255, alpha: 1)
    }

    class func flicksLightGrayColor() -> UIColor {
        return UIColor(red: 222/255, green: 223/255, blue: 225/255, alpha: 1)
    }

    class func flicksMediumGrayColor() -> UIColor {
        return UIColor(red: 210/255, green: 209/255, blue: 209/255, alpha: 1)
    }
}