//
//  Tile.swift
//  ColorClash
//
//  Created by user922914 on 11/25/20.
//

import Foundation
import UIKit

class Tile: UIView {
    var type: String
    var occupied: Bool
    var xCoord: Int
    var yCoord: Int
    var xPos: CGFloat
    var yPos: CGFloat
    var width: CGFloat
    var height: CGFloat
    init(type:String, occupied: Bool, xCoord: Int, yCoord: Int, xPos: CGFloat, yPos: CGFloat, width: CGFloat, height: CGFloat) {
        self.type = type
        self.occupied = occupied
        self.xCoord = xCoord
        self.yCoord = yCoord
        self.xPos = xPos
        self.yPos = yPos
        self.width = width
        self.height = height

        super.init(frame: CGRect(x: xPos, y: yPos, width: width, height: height))
    }
}
