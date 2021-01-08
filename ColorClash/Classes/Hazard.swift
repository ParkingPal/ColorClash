//
//  Hazard.swift
//  ColorClash
//
//  Created by ParkingPal on 1/7/21.
//

import Foundation
import UIKit

class Hazard: Tile {
    init(xCoord: Int, yCoord: Int, xPos: CGFloat, yPos: CGFloat, width: CGFloat, height: CGFloat) {
        super.init(type:"Hazard", value: -2, xCoord:xCoord, yCoord:yCoord, xPos:xPos, yPos:yPos, width:width, height:height)
        //super.image = UIImage(named: "BrownTileBevel.png")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
