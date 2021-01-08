//
//  Tile.swift
//  ColorClash
//
//  Created by user922914 on 11/25/20.
//

import Foundation
import UIKit

class Tile: UIImageView {
    var type: String
    var value: Int
    var xCoord: Int
    var yCoord: Int
    var xPos: CGFloat
    var yPos: CGFloat
    var width: CGFloat
    var height: CGFloat
    
    init(type:String, value: Int, xCoord: Int, yCoord: Int, xPos: CGFloat, yPos: CGFloat, width: CGFloat, height: CGFloat) {
        self.type = type
        self.value = value
        self.xCoord = xCoord
        self.yCoord = yCoord
        self.xPos = xPos
        self.yPos = yPos
        self.width = width
        self.height = height

        super.init(frame: CGRect(x: xPos, y: yPos, width: width, height: height))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getTypeByValue(value: Int) -> String {
        if value == -1 {
            return "Wall"
        } else if value >= 0 && value < 3 {
            return "Primary"
        } else if value >= 3 && value < 6 {
            return "Secondary"
        } else {
            return "Error -> Unknown Type"
        }
    }
    
    //called when two secondary colors are matched together
    func pointScored() {
        UIView.animate(withDuration: 0.2, animations: {
            //explode colors
            self.layer.setAffineTransform(CGAffineTransform(scaleX: 2.5, y: 2.5))
            self.alpha = 0.1
        }) { (finished) in
            //completely fade away
            UIView.animate(withDuration: 0.1, animations: {
                self.alpha = 0.0
            }) { (finished) in
                self.removeFromSuperview()
            }
        }
    }
    
    func growAndAppearTile() {
        alpha = 0.0
        UIView.animate(withDuration: 0.18, delay: 0.05, options: UIView.AnimationOptions(), animations: {
            self.layer.setAffineTransform(CGAffineTransform(scaleX: 1.2, y: 1.2))
            self.alpha = 1.0
        }) { (finished) in
            UIView.animate(withDuration: 0.08, animations: { () -> Void in
                self.layer.setAffineTransform(CGAffineTransform.identity)
            })
        }
    }
    
    func moveTile(oldCoords: [CGFloat], newCoords: [CGFloat], tileSize: CGFloat, isCombined: Bool, newColor: Tile, newImage: UIImage) {
        let finalFrame = CGRect(x: newCoords[0], y: newCoords[1], width: tileSize, height: tileSize)
        
        UIView.animate(withDuration: 0.12, delay: 0.0, options: UIView.AnimationOptions.beginFromCurrentState, animations: {
            if isCombined {
                self.alpha = 0.0
                newColor.alpha = 0.0
            }
            self.frame = finalFrame
        }) { (finished: Bool) in
            if isCombined {
                self.removeFromSuperview()
                newColor.image = newImage
                newColor.layer.setAffineTransform(CGAffineTransform(scaleX: 0.1, y: 0.1))
                
                UIView.animate(withDuration: 0.08, animations: {
                    newColor.alpha = 1.0
                    newColor.layer.setAffineTransform(CGAffineTransform(scaleX: 1.2, y: 1.2))
                }) { (finished) in
                    UIView.animate(withDuration: 0.08, animations: {
                        newColor.layer.setAffineTransform(CGAffineTransform.identity)
                    })
                }
                
            }
        }
    }
}
