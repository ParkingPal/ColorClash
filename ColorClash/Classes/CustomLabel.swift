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
    
    func fontToFitWidth() -> UIFont {
        var minFontSize: CGFloat = 20
        var maxFontSize: CGFloat = 200
        var fontSizeAverage: CGFloat = 0
        var textAndLabelWidthDiff: CGFloat = 0
        
        while (minFontSize <= maxFontSize) {
            fontSizeAverage = minFontSize + (maxFontSize - minFontSize) / 2
            
            guard text?.count ?? 0 > 0 else {
                break
            }
            
            if let labelText: NSString = text as NSString? {
                let labelWidth = frame.size.width
                
                let testStringWidth = labelText.size(withAttributes: [NSAttributedString.Key.font: font.withSize(fontSizeAverage)]).width
                textAndLabelWidthDiff = labelWidth - testStringWidth
                
                if (fontSizeAverage == minFontSize || fontSizeAverage == maxFontSize) {
                    if (textAndLabelWidthDiff < 0) {
                        return font.withSize(fontSizeAverage - 1)
                    }
                    return font.withSize(fontSizeAverage)
                }
                
                if (textAndLabelWidthDiff < 0) {
                    maxFontSize = fontSizeAverage - 1
                } else if (textAndLabelWidthDiff > 0) {
                    minFontSize = fontSizeAverage + 1
                } else {
                    return font.withSize(fontSizeAverage)
                }
            }
        }
        return font.withSize(fontSizeAverage)
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
        adjustsFontSizeToFitWidth = true
        layer.masksToBounds = false
        layer.shadowColor = CGColor(srgbRed: shadowColor/255, green: shadowColor/255, blue: shadowColor/255, alpha: 1.0)
        layer.shadowOpacity = shadowOpacity
        layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        layer.shadowRadius = shadowRadius
    }
}
