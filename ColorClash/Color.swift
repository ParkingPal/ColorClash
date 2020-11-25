//
//  Color.swift
//  ColorClash
//
//  Created by user922914 on 11/24/20.
//

import Foundation
import UIKit

class Color: UIView {

    var color: UIColor
    var occupied: Bool
    var xCoord: Int
    var yCoord: Int
    var xPos: CGFloat
    var yPos: CGFloat
    var width: CGFloat
    var height: CGFloat
    
    init(color: UIColor, occupied: Bool, xCoord: Int, yCoord: Int, xPos: CGFloat, yPos: CGFloat, width: CGFloat, height: CGFloat) {
        self.color = color
        self.occupied = occupied
        self.xCoord = xCoord
        self.yCoord = yCoord
        self.xPos = xPos
        self.yPos = yPos
        self.width = width
        self.height = height
        super.init(frame: CGRect(x: xPos, y: yPos, width: width, height: height))
        self.backgroundColor = color
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
