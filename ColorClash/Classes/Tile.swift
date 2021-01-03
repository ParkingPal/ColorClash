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
        } else if value < 6 {
            return "Secondary"
        } else {
            return "Error -> Unknown Type"
        }
    }
}
