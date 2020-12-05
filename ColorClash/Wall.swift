//
//  Wall.swift
//  ColorClash
//
//  Created by user922914 on 12/5/20.
//

import Foundation
import UIKit

class Wall: Tile {
    var wall: UIImage
    
    init(wall: UIImage, xCoord: Int, yCoord: Int, xPos: CGFloat, yPos: CGFloat, width: CGFloat, height: CGFloat) {
        self.wall = wall
        super.init(type:"Wall", value: -1, xCoord:xCoord, yCoord:yCoord, xPos:xPos, yPos:yPos, width:width, height:height)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
