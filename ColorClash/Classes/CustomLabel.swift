//
//  CustomLabel.swift
//  ColorClash
//
//  Created by ParkingPal on 12/7/20.
//

import Foundation
import UIKit

class CustomLabel: UILabel {
    
    func setupLabel(font: String, size: CGFloat, shadowOpacity: Float, shadowRadius: CGFloat) {
        self.font = UIFont(name: font, size: size)
        self.adjustsFontSizeToFitWidth = true
        self.layer.masksToBounds = false
        self.layer.shadowColor = CGColor(srgbRed: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.layer.shadowRadius = shadowRadius
    }
}
