//
//  Color.swift
//  ColorClash
//
//  Created by user922914 on 11/24/20.
//

import Foundation
import UIKit
import TheAnimation

class Color: Tile {
    var color: UIImage
    var colorString: String
    
    init(color: UIImage, colorString: String, colorType: String, value: Int, xCoord: Int, yCoord: Int, xPos: CGFloat, yPos: CGFloat, width: CGFloat, height: CGFloat) {
        self.color = color
        self.colorString = colorString
        super.init(type:"Color", value: value, xCoord:xCoord, yCoord:yCoord, xPos:xPos, yPos:yPos, width:width, height:height)
        self.image = color
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func pointScored() {
        let fade = BasicAnimation(keyPath: .opacity)
        fade.duration = 1.0
        fade.fromValue = 1
        fade.toValue = 0
        fade.fillMode = .forwards
        fade.timingFunction = .easeOut
        fade.isRemovedOnCompletion = false
        fade.beginTime = CACurrentMediaTime()
        
        let grow = CASpringAnimation(keyPath: "transform.scale")
        grow.duration = 1.0
        grow.fromValue = 1.0
        grow.toValue = 3.0
        grow.autoreverses = false
        grow.repeatCount = 0
        grow.initialVelocity = 0.5
        grow.damping = 100.0
        
        layer.add(grow, forKey: nil)
        fade.animate(in: layer)
    }
    
    func growAndAppearTile() {
        self.alpha = 1.0
        let grow = CASpringAnimation(keyPath: "transform.scale")
        grow.duration = 1.5
        grow.fromValue = 0.1
        grow.toValue = 1.0
        grow.autoreverses = false
        grow.repeatCount = 0
        grow.initialVelocity = 0.3
        grow.damping = 8.0
        
        layer.add(grow, forKey: nil)
    }
    
    func combineTiles(newImage: UIImage) {
        self.image = newImage
        
        let grow = CASpringAnimation(keyPath: "transform.scale")
        grow.duration = 2.0
        grow.fromValue = 0.1
        grow.toValue = 1.0
        grow.autoreverses = false
        grow.repeatCount = 0
        grow.initialVelocity = 0.6
        grow.damping = 5.0
        
        layer.add(grow, forKey: nil)
    }
    
    func moveTile(oldCoords: [CGFloat], newCoords: [CGFloat], tileSize: CGFloat, isCombined: Bool) {
        let move = BasicAnimation(keyPath: .position)
        let fade = BasicAnimation(keyPath: .opacity)
        move.fromValue = CGPoint(x: oldCoords[0] + (tileSize/2), y: oldCoords[1] + (tileSize/2))
        fade.fromValue = 1
        move.toValue = CGPoint(x: newCoords[0] + (tileSize/2), y: newCoords[1] + (tileSize/2))
        fade.toValue = 0
        move.timingFunction = .easeOut
        move.duration = 0.3
        fade.duration = 0.3
        move.fillMode = .forwards
        fade.fillMode = .forwards
        move.isRemovedOnCompletion = false
        fade.isRemovedOnCompletion = false
        move.beginTime = CACurrentMediaTime()
        fade.beginTime = CACurrentMediaTime()
        move.setAnimationDidStop { finished in
            if isCombined {
                self.removeFromSuperview()
            }
        }
        move.animate(in: layer)
        if isCombined {
            fade.animate(in: layer)
        }
    }
}
