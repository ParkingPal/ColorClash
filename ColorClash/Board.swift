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
    var score = 0
    
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
        
        let colorInfo = pickRandomTileColor()
        
        let tile = Color(color: colorInfo.0, colorString: colorInfo.1, colorType: "Primary", occupied: true, xCoord: randomX, yCoord: randomY, xPos: tileX, yPos: tileY, width: tileWidth, height: tileHeight)
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
                        newXCoord = j + spaces
                        newYCoord = i
                    } else if (direction == .left) {
                        newXCoord = j - spaces
                        newYCoord = i
                    }
                    
                    moveTile(tile: tile, newXCoord: newXCoord, newYCoord: newYCoord, tileCoordsWithPositions: tileCoordsWithPositions, tileSize: tileSize, direction: direction, spaces: spaces)
                }
                
                let canCombine = tilesCanCombine(direction: direction, tile: tile)
                if canCombine.0 {
                    if canCombine.1 == .up {
                        combineTiles(newTile: board[tile.xCoord][tile.yCoord - 1]!, oldTile: tile, oldXCoord: tile.xCoord, oldYCoord: tile.yCoord, tileCoordsWithPositions: tileCoordsWithPositions, tileSize: tileSize)
                    } else if canCombine.1 == .down {
                        combineTiles(newTile: board[tile.xCoord][tile.yCoord + 1]!, oldTile: tile, oldXCoord: tile.xCoord, oldYCoord: tile.yCoord, tileCoordsWithPositions: tileCoordsWithPositions, tileSize: tileSize)
                    } else if canCombine.1 == .right {
                        combineTiles(newTile: board[tile.xCoord + 1][tile.yCoord]!, oldTile: tile, oldXCoord: tile.xCoord, oldYCoord: tile.yCoord, tileCoordsWithPositions: tileCoordsWithPositions, tileSize: tileSize)
                    } else if canCombine.1 == .left {
                        combineTiles(newTile: board[tile.xCoord - 1][tile.yCoord]!, oldTile: tile, oldXCoord: tile.xCoord, oldYCoord: tile.yCoord, tileCoordsWithPositions: tileCoordsWithPositions, tileSize: tileSize)
                    }
                }
            }
        }
    }
    
    func tilesCanCombine(direction: UISwipeGestureRecognizer.Direction, tile: Tile) -> (Bool, UISwipeGestureRecognizer.Direction) {
        
        if direction == .up && tile.yCoord > 0 && /*primary color condition*/((((board[tile.xCoord][tile.yCoord] as! Color).colorString != (board[tile.xCoord][tile.yCoord - 1] as! Color).colorString && (board[tile.xCoord][tile.yCoord] as! Color).colorType == (board[tile.xCoord][tile.yCoord - 1] as! Color).colorType) && (board[tile.xCoord][tile.yCoord] as! Color).colorType == "Primary") || /*secondary color condidition*/ (board[tile.xCoord][tile.yCoord] as! Color).colorString == (board[tile.xCoord][tile.yCoord - 1] as! Color).colorString && (board[tile.xCoord][tile.yCoord] as! Color).colorType == "Secondary"){
            return (true, .up)
        } else if direction == .down && tile.yCoord < yMax && ((((board[tile.xCoord][tile.yCoord] as! Color).colorString != (board[tile.xCoord][tile.yCoord + 1] as! Color).colorString && (board[tile.xCoord][tile.yCoord] as! Color).colorType == (board[tile.xCoord][tile.yCoord + 1] as! Color).colorType)  && (board[tile.xCoord][tile.yCoord] as! Color).colorType == "Primary") || (board[tile.xCoord][tile.yCoord] as! Color).colorString == (board[tile.xCoord][tile.yCoord + 1] as! Color).colorString && (board[tile.xCoord][tile.yCoord] as! Color).colorType == "Secondary"){
            return (true, .down)
        } else if direction == .right && tile.xCoord < xMax && ((((board[tile.xCoord][tile.yCoord] as! Color).colorString != (board[tile.xCoord + 1][tile.yCoord] as! Color).colorString && (board[tile.xCoord][tile.yCoord] as! Color).colorType == (board[tile.xCoord + 1][tile.yCoord] as! Color).colorType) && (board[tile.xCoord][tile.yCoord] as! Color).colorType == "Primary") || (board[tile.xCoord][tile.yCoord] as! Color).colorString == (board[tile.xCoord + 1][tile.yCoord] as! Color).colorString && (board[tile.xCoord][tile.yCoord] as! Color).colorType == "Secondary"){
            return (true, .right)
        } else if direction == .left && tile.xCoord > 0 && ((((board[tile.xCoord][tile.yCoord] as! Color).colorString != (board[tile.xCoord - 1][tile.yCoord] as! Color).colorString && (board[tile.xCoord][tile.yCoord] as! Color).colorType == (board[tile.xCoord - 1][tile.yCoord] as! Color).colorType) && (board[tile.xCoord][tile.yCoord] as! Color).colorType == "Primary") || (board[tile.xCoord][tile.yCoord] as! Color).colorString == (board[tile.xCoord - 1][tile.yCoord] as! Color).colorString && (board[tile.xCoord][tile.yCoord] as! Color).colorType == "Secondary"){
            return (true, .left)
        }
        
        return (false, .up)
    }
    
    func combineTiles(newTile: Tile, oldTile: Tile, oldXCoord: Int, oldYCoord: Int, tileCoordsWithPositions: [[Int]:[CGFloat]], tileSize: CGFloat) {
        let newColor = newTile as! Color
        let oldColor = oldTile as! Color
        var newImage = UIImage()
        /*UIView.animate(withDuration: 0.2) {
            newColor.alpha = 0.0
        }*/
        
        if newColor.colorString == "Red" {
            if oldColor.colorString == "Blue" {
                newColor.colorString = "Purple"
                newImage = UIImage(named: "PurpleTileBevel")!
                newColor.colorType = "Secondary"
            } else if oldColor.colorString == "Yellow" {
                newColor.colorString = "Orange"
                newImage = UIImage(named: "OrangeTileBevel")!
                newColor.colorType = "Secondary"
            }
        } else if newColor.colorString == "Blue" {
            if oldColor.colorString == "Red" {
                newColor.colorString = "Purple"
                newImage = UIImage(named: "PurpleTileBevel")!
                newColor.colorType = "Secondary"
            } else if oldColor.colorString == "Yellow" {
                newColor.colorString = "Green"
                newImage = UIImage(named: "GreenTileBevel")!
                newColor.colorType = "Secondary"
            }
        } else if newColor.colorString == "Yellow" {
            if oldColor.colorString == "Red" {
                newColor.colorString = "Orange"
                newImage = UIImage(named: "OrangeTileBevel")!
                newColor.colorType = "Secondary"
            } else if oldColor.colorString == "Blue" {
                newColor.colorString = "Green"
                newImage = UIImage(named: "GreenTileBevel")!
                newColor.colorType = "Secondary"
            }
        } else if newColor.colorString == oldColor.colorString && newColor.colorType == "Secondary" {
            removeTile(xPos: oldColor.xCoord, yPos: oldColor.yCoord)
            removeTile(xPos: newColor.xCoord, yPos: newColor.yCoord)
            oldColor.pointScored()
            newColor.pointScored()
            score += 1
        }
        oldColor.moveTile(oldCoords: tileCoordsWithPositions[[oldXCoord, oldYCoord]]!, newCoords: tileCoordsWithPositions[[newColor.xCoord, newColor.yCoord]]!, tileSize: tileSize, isCombined: true)
        newColor.combineTiles(newImage: newImage)
        let musicPlayer = MusicPlayer.shared
        musicPlayer.playSoundEffect(fileName: "Click2", fileType: "wav")
        removeTile(xPos: oldColor.xCoord, yPos: oldColor.yCoord)
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
    
    func moveTile(tile: Tile, newXCoord: Int, newYCoord: Int, tileCoordsWithPositions: [[Int]:[CGFloat]], tileSize: CGFloat, direction: UISwipeGestureRecognizer.Direction, spaces: Int) {
        let color = tile as! Color
        let oldXCoord = tile.xCoord
        let oldYCoord = tile.yCoord
        removeTile(xPos: color.xCoord, yPos: color.yCoord)
        color.xCoord = newXCoord
        color.yCoord = newYCoord
        addTile(tile: color, xPos: color.xCoord, yPos: color.yCoord)
        color.moveTile(oldCoords: [color.xPos, color.yPos], newCoords: tileCoordsWithPositions[[color.xCoord, color.yCoord]]!, tileSize: tileSize, isCombined: false)
        color.xPos = tileCoordsWithPositions[[color.xCoord, color.yCoord]]![0]
        color.yPos = tileCoordsWithPositions[[color.xCoord, color.yCoord]]![1]
        
        if tileCanMove(direction: direction, tile: tile) {
            var newestXCoord = -1
            var newestYCoord = -1
            
            if direction == .up {
                newestXCoord = newXCoord
                newestYCoord = newYCoord - 1
            } else if direction == .down {
                newestXCoord = newXCoord
                newestYCoord = newYCoord + 1
            } else if direction == .right {
                newestXCoord = newXCoord + 1
                newestYCoord = newYCoord
            } else if direction == .left {
                newestXCoord = newXCoord - 1
                newestYCoord = newYCoord
            }
            moveTile(tile: tile, newXCoord: newestXCoord, newYCoord: newestYCoord, tileCoordsWithPositions: tileCoordsWithPositions, tileSize: tileSize, direction: direction, spaces: spaces)
        }
    }
}
