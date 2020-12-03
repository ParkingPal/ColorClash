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
    var xCoord: Int
    var yCoord: Int
    var xPos: CGFloat
    var yPos: CGFloat
    var width: CGFloat
    var height: CGFloat
    init(type:String, xCoord: Int, yCoord: Int, xPos: CGFloat, yPos: CGFloat, width: CGFloat, height: CGFloat) {
        self.type = type
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
}
