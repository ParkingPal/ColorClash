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
        for x in 0...xMax {
            for y in 0...yMax {
                if board[x][y] == nil {
                    continue
                }
                let tile = board[x][y]!
                if tileCanMove(direction: direction, tile: tile) {
                    moveTileVertically(tile: tile, direction: direction, tileCoordsWithPositions: tileCoordsWithPositions, tileSize: tileSize)
                }
            }
        }
    }
    
    func tileCanMove(direction: UISwipeGestureRecognizer.Direction, tile: Tile) -> Bool {
        if direction == .up && tile.yCoord > 0 {
            return true
        } else if direction == .down && tile.yCoord < yMax {
            return true
        }
        
        return false
    }
    
    func moveTileVertically(tile: Tile, direction: UISwipeGestureRecognizer.Direction, tileCoordsWithPositions: [[Int]:[CGFloat]], tileSize: CGFloat) {
        let newYIndex = checkColumn(tile: tile, direction: direction)
        let color = tile as! Color
        removeTile(xPos: tile.xCoord, yPos: tile.yCoord)
        tile.yCoord = newYIndex
        addTile(tile: tile, xPos: tile.xCoord, yPos: tile.yCoord)
        color.moveTile(oldCoords: [tile.xPos, tile.yPos], newCoords: tileCoordsWithPositions[[tile.xCoord, newYIndex]]!, tileSize: tileSize)
    }
    
    func checkColumn(tile: Tile, direction: UISwipeGestureRecognizer.Direction) -> Int {
        if direction == .up {
            var newYIndex = 0
            
            for index in 0...tile.yCoord - 1 {
                if board[tile.xCoord][index] != nil {
                    newYIndex = index + 1
                }
            }
            
            return newYIndex
            
        } else {
            var newYIndex = 3
            
            for index in 0...tile.yCoord {
                if board[tile.xCoord][newYIndex] != nil {
                    newYIndex -= 1
                }
            }
            
            return newYIndex
        }
    }
}
