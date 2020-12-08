//
//  CustomLabel.swift
//  ColorClash
//
//  Created by ParkingPal on 12/7/20.
//

import Foundation
import UIKit

class CustomLabel: UILabel {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        font = fontToFitHeight()
    }
    
    func fontToFitHeight() -> UIFont {
        var minFontSize: CGFloat = 20
        var maxFontSize: CGFloat = 200
        var fontSizeAverage: CGFloat = 0
        var textAndLabelHeightDiff: CGFloat = 0
        
        while (minFontSize <= maxFontSize) {
            
            fontSizeAverage = minFontSize + (maxFontSize - minFontSize) / 2
            
            // Abort if text happens to be nil
            guard text?.count ?? 0 > 0 else {
                break
            }
            
            if let labelText: NSString = text as NSString? {
                let labelHeight = frame.size.height
                
                let testStringHeight = labelText.size(
                    withAttributes: [NSAttributedString.Key.font: font.withSize(fontSizeAverage)]
                ).height
                
                textAndLabelHeightDiff = labelHeight - testStringHeight
                
                if (fontSizeAverage == minFontSize || fontSizeAverage == maxFontSize) {
                    if (textAndLabelHeightDiff < 0) {
                        return font.withSize(fontSizeAverage - 1)
                    }
                    return font.withSize(fontSizeAverage)
                }
                
                if (textAndLabelHeightDiff < 0) {
                    maxFontSize = fontSizeAverage - 1
                    
                } else if (textAndLabelHeightDiff > 0) {
                    minFontSize = fontSizeAverage + 1
                    
                } else {
                    return font.withSize(fontSizeAverage)
                }
            }
        }
        return font.withSize(fontSizeAverage)
    }
    
    func setupLabel(font: String, size: CGFloat, shadowOpacity: Float, shadowRadius: CGFloat, shadowColor: CGFloat) {
        self.font = UIFont(name: font, size: size)
        self.adjustsFontSizeToFitWidth = true
        self.layer.masksToBounds = false
        self.layer.shadowColor = CGColor(srgbRed: shadowColor/255, green: shadowColor/255, blue: shadowColor/255, alpha: 1.0)
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.layer.shadowRadius = shadowRadius
    }
}
