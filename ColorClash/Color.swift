//
//  Color.swift
//  ColorClash
//
//  Created by user922914 on 11/24/20.
//

import Foundation
import UIKit

class Color: Tile {
    var color: UIColor
    
    init(color: UIColor, occupied: Bool, xCoord: Int, yCoord: Int, xPos: CGFloat, yPos: CGFloat, width: CGFloat, height: CGFloat) {
        super.init(type:"Color", occupied:occupied, xCoord:xCoord, yCoord:yCoord, xPos:xPos, yPos:yPos, width:width, height:height)
        self.color = color                
        self.backgroundColor = color
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
