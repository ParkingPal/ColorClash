//
//  CustomTableCell.swift
//  ColorClash
//
//  Created by ParkingPal on 1/10/21.
//

import Foundation
import UIKit

class CustomTableCell: UITableViewCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel!.frame = textLabel!.frame.inset(by: UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0))
    }
    
    func fontToFitHeight() -> UIFont {
        var minFontSize: CGFloat = 20
        var maxFontSize: CGFloat = 200
        var fontSizeAverage: CGFloat = 0
        var textAndLabelHeightDiff: CGFloat = 0
        
        while (minFontSize <= maxFontSize) {
            
            fontSizeAverage = minFontSize + (maxFontSize - minFontSize) / 2
            
            // Abort if text happens to be nil
            guard self.textLabel!.text?.count ?? 0 > 0 else {
                break
            }
            
            if let labelText: NSString = self.textLabel!.text as NSString? {
                let labelHeight = frame.size.height - 20
                print(frame.size.height)
                
                let testStringHeight = labelText.size(
                    withAttributes: [NSAttributedString.Key.font: self.textLabel!.font.withSize(fontSizeAverage)]
                ).height
                
                textAndLabelHeightDiff = labelHeight - testStringHeight
                
                if (fontSizeAverage == minFontSize || fontSizeAverage == maxFontSize) {
                    if (textAndLabelHeightDiff < 0) {
                        return self.textLabel!.font.withSize(fontSizeAverage - 1)
                    }
                    return self.textLabel!.font.withSize(fontSizeAverage)
                }
                
                if (textAndLabelHeightDiff < 0) {
                    maxFontSize = fontSizeAverage - 1
                    
                } else if (textAndLabelHeightDiff > 0) {
                    minFontSize = fontSizeAverage + 1
                    
                } else {
                    return self.textLabel!.font.withSize(fontSizeAverage)
                }
            }
        }
        return self.textLabel!.font.withSize(fontSizeAverage)
    }
    
}
