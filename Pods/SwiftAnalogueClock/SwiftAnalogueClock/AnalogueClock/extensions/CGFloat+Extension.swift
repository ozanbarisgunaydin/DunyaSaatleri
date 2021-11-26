//
//  CGFloat+.swift
//  AnalogueClock
//
//  Created by Priyesh on 16/01/21.
//

import UIKit

extension CGFloat {
    var degreesToRadians: CGFloat {
        return self * .pi / 180
    }
    var radiansToDegrees: CGFloat {
        return self * 180 / .pi
    }
}
