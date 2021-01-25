//
//  Board.swift
//  ColorClash
//
//  Created by user922914 on 11/25/20.
//

import Foundation
import UIKit

class Board {
    var colorHelper = ColorHelper()
    var board = [[Tile?]]()   //2d array of Tiles
    var xMax: Int
    var yMax: Int
    var score = 0
    var gameType: String
    var scoreChanged = false
    var movesTotal = 0
    
    init(xMax: Int, yMax: Int, gameType: String) {
        self.xMax = xMax
        self.yMax = yMax
        self.gameType = gameType
        self.board = Array(repeating: Array(repeating: nil, count: xMax + 1), count: yMax + 1)
    }
    
    func addWallsRandomly(numToAdd: Int, gameBoardView: UIView, tileCoordsWithPositions: [[Int]:[CGFloat]], tileWidth: CGFloat, tileHeight: CGFloat) {
        for _ in 0...numToAdd - 1 {
            var randomX: Int
            var randomY: Int
            repeat { // make sure you don't add 2 walls to the same tile
                randomX = Int.random(in: 0...xMax)
                randomY = Int.random(in: 0...yMax)
            } while isTileOccupied(xPos: randomX, yPos: randomY)
            
            let newWall = Wall(xCoord: randomX, yCoord: randomY, xPos: tileCoordsWithPositions[[randomX,randomY]]![0], yPos: tileCoordsWithPositions[[randomX,randomY]]![1], width: tileWidth, height: tileHeight)
            addTile(tile: newWall, xPos: newWall.xCoord, yPos: newWall.yCoord)
            gameBoardView.addSubview(newWall)
        }
    }
    
    func addHazard(moveNumber: Int, gameBoardView: UIView, tileCoordsWithPositions: [[Int]:[CGFloat]], tileWidth: CGFloat, tileHeight: CGFloat) -> Hazard {
        var randomX: Int
        var randomY: Int
        let hazardValue = determineHazardToAdd(moveNumber: moveNumber)
        
        repeat {
            randomX = Int.random(in: 0...xMax)
            randomY = Int.random(in: 0...yMax)
        } while isTileOccupied(xPos: randomX, yPos: randomY)
        
        let newHazard = Hazard(xCoord: randomX, yCoord: randomY, xPos: tileCoordsWithPositions[[randomX,randomY]]![0], yPos: tileCoordsWithPositions[[randomX,randomY]]![1], width: tileWidth, height: tileHeight)
        newHazard.isUserInteractionEnabled = true
        
        if hazardValue == 0 {
            newHazard.image = UIImage(named: "BlackTileBevel.png")
        }
        
        addTile(tile: newHazard, xPos: newHazard.xCoord, yPos: newHazard.yCoord)
        gameBoardView.addSubview(newHazard)
        
        return newHazard
    }
    
    func determineHazardToAdd(moveNumber: Int) -> Int {
        //future function that will help determine which hazard to add based on what moves number it is
        //harder hazards to overcome will be more likely to appear later into the game, etc
        return 0
    }
    
    func emptyTiles() -> [(Int, Int)] {
        var buffer : [(Int, Int)] = []
        for i in 0...xMax {
            for j in 0...yMax {
                if board[i][j] == nil {
                    buffer += [(i, j)]
                }
            }
        }
        return buffer
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
        
        let tile = Color(color: colorInfo.0, colorString: colorInfo.1, colorType: "Primary", value: colorInfo.2, xCoord: randomX, yCoord: randomY, xPos: tileX, yPos: tileY, width: tileWidth, height: tileHeight, moveCombined: 0)
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
    
    func pickRandomTileColor() -> (UIImage, String, Int) {
        let randomColorInt = Int.random(in: 0...2)
        
        if randomColorInt == 0 {
            return (UIImage(named: "RedTileBevel.png")!, "Red", colorHelper.getValueByColor(color: "Red"))
        } else if randomColorInt == 1 {
            return (UIImage(named: "BlueTileBevel.png")!, "Blue", colorHelper.getValueByColor(color: "Blue"))
        } else {
            return (UIImage(named: "YellowTileBevel.png")!, "Yellow", colorHelper.getValueByColor(color: "Yellow"))
        }
    }
    
    func addTile(tile: Tile, xPos: Int, yPos: Int) {
        board[xPos][yPos] = tile
    }
    
    func removeTile(xPos: Int, yPos: Int) {
        board[xPos][yPos] = nil
    }
    
    func moveTiles(direction: UISwipeGestureRecognizer.Direction, tileCoordsWithPositions: [[Int]:[CGFloat]], tileSize: CGFloat) -> (Bool, Bool) {
        var isValidMove = false
        var tilesDidCombine = false
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
                if tile.type == "Wall"/* || tile.type == "Hazard"*/ {
                    spaces = 0
                    continue
                }
                if tileCanMove(direction: direction, tile: tile) {
                    isValidMove = true
                    scoreChanged = false
                    var newXCoord = -1
                    var newYCoord = -1
                    if spaces < 0 {
                        spaces = 0
                    }
                    
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
                
                let combine = tilesCanCombine(direction: direction, tile: tile)
                let canCombine = combine.0
                let combineType = combine.1
                
                if canCombine {
                    tilesDidCombine = true
                    let color = (tile as! Color)
                    isValidMove = true
                    
                    if color.moveCombined != movesTotal || color.moveCombined == 0 {
                        if direction == .up {
                            spaces += combineTiles(newTile: board[tile.xCoord][tile.yCoord - 1]!, oldTile: tile, oldXCoord: i, oldYCoord: j, tileCoordsWithPositions: tileCoordsWithPositions, tileSize: tileSize)
                        } else if direction == .down {
                            spaces += combineTiles(newTile: board[tile.xCoord][tile.yCoord + 1]!, oldTile: tile, oldXCoord: i, oldYCoord: j, tileCoordsWithPositions: tileCoordsWithPositions, tileSize: tileSize)
                        } else if direction == .right {
                            spaces += combineTiles(newTile: board[tile.xCoord + 1][tile.yCoord]!, oldTile: tile, oldXCoord: j, oldYCoord: i, tileCoordsWithPositions: tileCoordsWithPositions, tileSize: tileSize)
                        } else if direction == .left {
                            spaces += combineTiles(newTile: board[tile.xCoord - 1][tile.yCoord]!, oldTile: tile, oldXCoord: j, oldYCoord: i, tileCoordsWithPositions: tileCoordsWithPositions, tileSize: tileSize)
                        }
                    }
                    
                    color.moveCombined = movesTotal
                    
                    if combineType == "Secondary" {
                        checkForHazard(tile: tile, direction: direction)
                    }
                }
            }
        }
        
        return (isValidMove, tilesDidCombine)
    }
    
    func gameEnded() -> Bool {
        guard emptyTiles().isEmpty else {
            return false
        }
        
        for i in 0...xMax {
            for j in 0...yMax {
                if tilesCanCombine(direction: .up, tile: board[i][j]!).0 ||
                    tilesCanCombine(direction: .right, tile: board[i][j]!).0 {
                    return false
                }
            }
        }
        
        return true
    }
    
    func tilesCanCombine(direction: UISwipeGestureRecognizer.Direction, tile: Tile) -> (Bool, String) {
        var checkTile:Tile? = nil
        var checkType:String? = nil
        let tileType = tile.getTypeByValue(value: tile.value)
        if direction == .up && tile.yCoord > 0 && board[tile.xCoord][tile.yCoord - 1] != nil {
            checkTile = board[tile.xCoord][tile.yCoord - 1]!
            checkType = checkTile!.getTypeByValue(value: checkTile!.value)
        } else if direction == .down && tile.yCoord < yMax && board[tile.xCoord][tile.yCoord + 1] != nil {
            checkTile = board[tile.xCoord][tile.yCoord + 1]!
            checkType = checkTile!.getTypeByValue(value: checkTile!.value)
        } else if direction == .right && tile.xCoord < xMax && board[tile.xCoord + 1][tile.yCoord] != nil {
            checkTile = board[tile.xCoord + 1][tile.yCoord]!
            checkType = checkTile!.getTypeByValue(value: checkTile!.value)
        } else if direction == .left && tile.xCoord > 0 && board[tile.xCoord - 1][tile.yCoord] != nil {
            checkTile = board[tile.xCoord - 1][tile.yCoord]!
            checkType = checkTile!.getTypeByValue(value: checkTile!.value)
        }
        
        if checkType == tileType {
            if tileType == "Primary" && checkType == "Primary" && checkTile!.value != tile.value {
                return (true, "Primary")
            } else if (tileType == "Secondary" && checkType == "Secondary" && checkTile!.value == tile.value) {
                return (true, "Secondary")
            }
        }
        
        return (false, "Nothing")
    }
    
    func checkForHazard(tile: Tile, direction: UISwipeGestureRecognizer.Direction) {
        var combinedTile = tile
        
        switch direction {
        case .left:
            combinedTile.xCoord = tile.xCoord - 1
        case .right:
            combinedTile.xCoord = tile.xCoord + 1
        case .up:
            combinedTile.yCoord = tile.yCoord - 1
        case .down:
            combinedTile.yCoord = tile.yCoord + 1
        default:
            break
        }
        
        /// Check to see if the tile is on an edge, or if it is on a corner
        if combinedTile.yCoord == 0 && combinedTile.xCoord > 0 && combinedTile.xCoord < xMax{
            checkHazardDown(tile: combinedTile)
            checkHazardLeft(tile: combinedTile)
            checkHazardRight(tile: combinedTile)
        } else if combinedTile.xCoord == 0 && combinedTile.yCoord > 0 && combinedTile.yCoord < yMax {
            checkHazardRight(tile: combinedTile)
            checkHazardUp(tile: combinedTile)
            checkHazardDown(tile: combinedTile)
        } else if combinedTile.yCoord == yMax && combinedTile.xCoord < xMax && combinedTile.xCoord > 0 {
            checkHazardUp(tile: combinedTile)
            checkHazardLeft(tile: combinedTile)
            checkHazardRight(tile: combinedTile)
        } else if combinedTile.xCoord == xMax && combinedTile.yCoord < yMax && combinedTile.yCoord > 0 {
            checkHazardLeft(tile: combinedTile)
            checkHazardUp(tile: combinedTile)
            checkHazardDown(tile: combinedTile)
        } else if combinedTile.xCoord == 0 && combinedTile.yCoord == 0 {
            checkHazardRight(tile: tile)
            checkHazardDown(tile: tile)
        } else if combinedTile.xCoord == 0 && combinedTile.yCoord == yMax {
            checkHazardUp(tile: tile)
            checkHazardRight(tile: tile)
        } else if combinedTile.xCoord == xMax && combinedTile.yCoord == 0 {
            checkHazardDown(tile: tile)
            checkHazardLeft(tile: tile)
        } else if combinedTile.xCoord == xMax && combinedTile.yCoord == yMax {
            checkHazardUp(tile: tile)
            checkHazardLeft(tile: tile)
        } else {
            checkHazardLeft(tile: combinedTile)
            checkHazardRight(tile: combinedTile)
            checkHazardUp(tile: combinedTile)
            checkHazardDown(tile: combinedTile)
        }
    }
    
    func checkHazardLeft(tile: Tile) {
        if let checkedTile = board[tile.xCoord - 1][tile.yCoord] {
            if checkedTile.type == "Hazard" {
                removeTile(xPos: checkedTile.xCoord, yPos: checkedTile.yCoord)
                checkedTile.removeFromSuperview()
            }
        }
    }
    
    func checkHazardRight(tile: Tile) {
        if let checkedTile = board[tile.xCoord + 1][tile.yCoord] {
            if checkedTile.type == "Hazard" {
                removeTile(xPos: checkedTile.xCoord, yPos: checkedTile.yCoord)
                checkedTile.removeFromSuperview()
            }
        }
    }
    
    func checkHazardUp(tile: Tile) {
        if let checkedTile = board[tile.xCoord][tile.yCoord - 1] {
            if checkedTile.type == "Hazard" {
                removeTile(xPos: checkedTile.xCoord, yPos: checkedTile.yCoord)
                checkedTile.removeFromSuperview()
            }
        }
    }
    
    func checkHazardDown(tile: Tile) {
        if let checkedTile = board[tile.xCoord][tile.yCoord + 1] {
            if checkedTile.type == "Hazard" {
                removeTile(xPos: checkedTile.xCoord, yPos: checkedTile.yCoord)
                checkedTile.removeFromSuperview()
            }
        }
    }
    
    func combineTiles(newTile: Tile, oldTile: Tile, oldXCoord: Int, oldYCoord: Int, tileCoordsWithPositions: [[Int]:[CGFloat]], tileSize: CGFloat) -> Int {
        let newColor = newTile as! Color
        let oldColor = oldTile as! Color
        var spacesToAdd = 1
        
        let newColorString = colorHelper.getCombinedColorString(color1: oldColor.colorString, color2: newColor.colorString)
        newColor.colorString = newColorString
        newColor.value = colorHelper.getValueByColor(color: newColorString)
        let newImage = UIImage(named: newColorString + "TileBevel")!
        
        if newColor.getTypeByValue(value: newColor.value) == "Secondary" && oldColor.getTypeByValue(value: oldColor.value) == "Secondary" && newColor.value == oldColor.value {
            removeTile(xPos: oldColor.xCoord, yPos: oldColor.yCoord)
            removeTile(xPos: newColor.xCoord, yPos: newColor.yCoord)
            oldColor.pointScored()
            newColor.pointScored()
            score += 1
            scoreChanged = true
            spacesToAdd += 1
        } else {
            oldColor.moveTile(oldCoords: tileCoordsWithPositions[[oldXCoord, oldYCoord]]!, newCoords: tileCoordsWithPositions[[newColor.xCoord, newColor.yCoord]]!, tileSize: tileSize, isCombined: true, newColor: newColor, newImage: newImage)
            removeTile(xPos: oldColor.xCoord, yPos: oldColor.yCoord)
        }
        
        ///
        return spacesToAdd
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
        removeTile(xPos: tile.xCoord, yPos: tile.yCoord)
        tile.xCoord = newXCoord
        tile.yCoord = newYCoord
        addTile(tile: tile, xPos: tile.xCoord, yPos: tile.yCoord)
        tile.moveTile(oldCoords: [tile.xPos, tile.yPos], newCoords: tileCoordsWithPositions[[tile.xCoord, tile.yCoord]]!, tileSize: tileSize, isCombined: false, newColor: tile, newImage: UIImage())
        tile.xPos = tileCoordsWithPositions[[tile.xCoord, tile.yCoord]]![0]
        tile.yPos = tileCoordsWithPositions[[tile.xCoord, tile.yCoord]]![1]
    }
}
