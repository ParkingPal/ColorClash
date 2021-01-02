//
//  CustomButton.swift
//  ColorClash
//
//  Created by ParkingPal on 12/7/20.
//

import Foundation
import UIKit

class CustomButton: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if titleLabel?.font != nil {
            titleLabel!.font = fontToFitHeight()
        }
    }
    
    func setupButton(font: String, size: CGFloat, horizontalInsets: CGFloat, verticalInsets: CGFloat, shadowOpacity: Float, shadowRadius: CGFloat, shadowColor: CGFloat) {
        imageView?.contentMode = .scaleAspectFit
        titleLabel?.font = UIFont(name: font, size: size)
        titleLabel?.adjustsFontSizeToFitWidth = true
        contentEdgeInsets = UIEdgeInsets(top: verticalInsets, left: horizontalInsets, bottom: verticalInsets, right: horizontalInsets)
        layer.masksToBounds = false
        layer.shadowColor = CGColor(srgbRed: shadowColor/255, green: shadowColor/255, blue: shadowColor/255, alpha: 1.0)
        layer.shadowOpacity = shadowOpacity
        layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        layer.shadowRadius = shadowRadius
    }
    
    func fontToFitHeight() -> UIFont {
        var minFontSize: CGFloat = 20
        var maxFontSize: CGFloat = 200
        var fontSizeAverage: CGFloat = 0
        var textAndLabelHeightDiff: CGFloat = 0
        
        while (minFontSize <= maxFontSize) {
            
            fontSizeAverage = minFontSize + (maxFontSize - minFontSize) / 2
            
            // Abort if text happens to be nil
            guard titleLabel?.text?.count ?? 0 > 0 else {
                break
            }
            
            guard titleLabel?.font != nil else {
                break
            }
            
            if let labelText: NSString = titleLabel?.text as NSString? {
                let labelHeight = frame.size.height
                
                let testStringHeight = labelText.size(
                    withAttributes: [NSAttributedString.Key.font: titleLabel!.font.withSize(fontSizeAverage)]
                ).height
                
                textAndLabelHeightDiff = labelHeight - testStringHeight
                
                if (fontSizeAverage == minFontSize || fontSizeAverage == maxFontSize) {
                    if (textAndLabelHeightDiff < 0) {
                        return titleLabel!.font.withSize(fontSizeAverage - 1)
                    }
                    return titleLabel!.font.withSize(fontSizeAverage)
                }
                
                if (textAndLabelHeightDiff < 0) {
                    maxFontSize = fontSizeAverage - 1
                    
                } else if (textAndLabelHeightDiff > 0) {
                    minFontSize = fontSizeAverage + 1
                    
                } else {
                    return titleLabel!.font.withSize(fontSizeAverage)
                }
            }
        }
        return titleLabel!.font.withSize(fontSizeAverage)
    }
}
