//
//  Board.swift
//  ColorClash
//
//  Created by user922914 on 11/25/20.
//

import Foundation
import UIKit

class Board {
    var board = [[Tile?]]()   //2d array of Tiles
    var xMax: Int
    var yMax: Int
    
    init(xMax: Int, yMax: Int) {
        self.xMax = xMax
        self.yMax = yMax
        self.board = Array(repeating: Array(repeating: nil, count: xMax + 1), count: yMax + 1)
    }
    
    func addTileRandomly(tileCoordsWithPositions: [[Int]:[CGFloat]], tileWidth: CGFloat, tileHeight: CGFloat) -> Color {
        var randomX: Int
        var randomY: Int
        repeat {
            randomX = Int.random(in: 0...xMax)
            randomY = Int.random(in: 0...yMax)
        } while isTileOccupied(xPos: randomX, yPos: randomY)
        
        //TODO: Figure out what is going on here
        var tileX: CGFloat = 0.0
        var tileY: CGFloat = 0.0
        
        for (key, value) in tileCoordsWithPositions {
            if key == [randomX, randomY] {
                tileX = value[0]
                tileY = value[1]
            }
        }
        
        let tile = Color(color: pickRandomTileColor().0, colorString: pickRandomTileColor().1, colorType: "Primary", occupied: true, xCoord: randomX, yCoord: randomY, xPos: tileX, yPos: tileY, width: tileWidth, height: tileHeight)
        addTile(tile:tile, xPos:randomX, yPos:randomY)
        return tile
    }
    
    func isTileOccupied(xPos: Int, yPos: Int) -> Bool {
        if (board[xPos][yPos] == nil){
            return false
        } else {
            return true
        }
    }
    
    func pickRandomTileColor() -> (UIImage, String) {
        let randomColorInt = Int.random(in: 1...3)
        
        if randomColorInt == 1 {
            return (UIImage(named: "BlueTileBevel.png")!, "Blue")
        } else if randomColorInt == 2 {
            return (UIImage(named: "RedTileBevel.png")!, "Red")
        } else {
            return (UIImage(named: "YellowTileBevel.png")!, "Yellow")
        }
    }
    
    func addTile(tile: Tile, xPos: Int, yPos: Int) {
        board[xPos][yPos] = tile
    }
    
    func removeTile(xPos: Int, yPos: Int) {
        board[xPos][yPos] = nil
    }
    
    func moveTiles(direction: UISwipeGestureRecognizer.Direction, tileCoordsWithPositions: [[Int]:[CGFloat]], tileSize: CGFloat) {
        var loopIfrom = 0
        var loopIthrough = xMax
        var loopByI = 1
        var loopJfrom = 0
        var loopJthrough = yMax
        var loopByJ = 1
        
        if (direction == .up) {
            loopIfrom = 0
            loopIthrough = xMax
            loopByI = 1
            loopJfrom = 0
            loopJthrough = yMax
            loopByJ = 1
        } else if (direction == .down) {
            loopIfrom = 0
            loopIthrough = xMax
            loopByI = 1
            loopJfrom = yMax
            loopJthrough = 0
            loopByJ = -1
        } else if (direction == .right) {
            loopIfrom = 0
            loopIthrough = yMax
            loopByI = 1
            loopJfrom = xMax
            loopJthrough = 0
            loopByJ = -1
        } else if (direction == .left) {
            loopIfrom = 0
            loopIthrough = yMax
            loopByI = 1
            loopJfrom = 0
            loopJthrough = xMax
            loopByJ = 1
        }
        
        for i in stride(from: loopIfrom, through: loopIthrough, by: loopByI) {
            var spaces = 0
            for j in stride(from: loopJfrom, through: loopJthrough, by: loopByJ) {
                if (direction == .up || direction == .down) && board[i][j] == nil {
                    spaces += 1
                    continue
                } else if (direction == .right || direction == .left) && board[j][i] == nil {
                    spaces += 1
                    continue
                }
                var tile: Tile
                if (direction == .up || direction == .down) {
                    tile = board[i][j]!
                } else {
                    tile = board[j][i]!
                }
                if tileCanMove(direction: direction, tile: tile) {
                    var newXCoord = -1
                    var newYCoord = -1
                    
                    if (direction == .up) {
                        newXCoord = i
                        newYCoord = j - spaces
                    } else if (direction == .down) {
                        newXCoord = i
                        newYCoord = j + spaces
                    } else if (direction == .right) {
                        newXCoord = i + spaces
                        newYCoord = j
                    } else if (direction == .left) {
                        newXCoord = i - spaces
                        newYCoord = j
                    }
                    
                    moveTile(tile: tile, newXCoord: newXCoord, newYCoord: newYCoord, tileCoordsWithPositions: tileCoordsWithPositions, tileSize: tileSize)
                }
            }
        }
    }
    
    func tileCanMove(direction: UISwipeGestureRecognizer.Direction, tile: Tile) -> Bool {
        if direction == .up && tile.yCoord > 0 && board[tile.xCoord][tile.yCoord - 1] == nil{
            return true
        } else if direction == .down && tile.yCoord < yMax && board[tile.xCoord][tile.yCoord + 1] == nil{
            return true
        } else if direction == .right && tile.xCoord < xMax && board[tile.xCoord + 1][tile.yCoord] == nil{
            return true
        } else if direction == .left && tile.xCoord > 0 && board[tile.xCoord - 1][tile.yCoord] == nil{
            return true
        }
        
        return false
    }
    
    func moveTile(tile: Tile, newXCoord: Int, newYCoord: Int, tileCoordsWithPositions: [[Int]:[CGFloat]], tileSize: CGFloat) {
        let color = tile as! Color
        removeTile(xPos: tile.xCoord, yPos: tile.yCoord)
        tile.yCoord = newYCoord
        addTile(tile: tile, xPos: tile.xCoord, yPos: tile.yCoord)
        color.moveTile(oldCoords: [tile.xPos, tile.yPos], newCoords: tileCoordsWithPositions[[tile.xCoord, newYCoord]]!, tileSize: tileSize)
    }
}
