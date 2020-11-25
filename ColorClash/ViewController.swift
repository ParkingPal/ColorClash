//
//  ViewController.swift
//  ColorClash
//
//  Created by ParkingPal on 11/24/20.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tile1: UIView!
    @IBOutlet weak var tile2: UIView!
    @IBOutlet weak var tile3: UIView!
    @IBOutlet weak var tile4: UIView!
    @IBOutlet weak var tile5: UIView!
    @IBOutlet weak var tile6: UIView!
    @IBOutlet weak var tile7: UIView!
    @IBOutlet weak var tile8: UIView!
    @IBOutlet weak var tile9: UIView!
    @IBOutlet weak var tile10: UIView!
    @IBOutlet weak var tile11: UIView!
    @IBOutlet weak var tile12: UIView!
    @IBOutlet weak var tile13: UIView!
    @IBOutlet weak var tile14: UIView!
    @IBOutlet weak var tile15: UIView!
    @IBOutlet weak var tile16: UIView!
    @IBOutlet weak var gameBoard: UIView!
    @IBOutlet weak var row1: UIStackView!
    @IBOutlet weak var row2: UIStackView!
    @IBOutlet weak var row3: UIStackView!
    @IBOutlet weak var row4: UIStackView!
    
    var tileHeight: CGFloat = 0.0
    var tileWidth: CGFloat = 0.0
    var tileViews = [UIView]()
    var occupiedTiles = [Tile]()
    
    var tileCoordsWithPositions = [[Int]:[CGFloat]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //manualAddTile()
        createGestures()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addTileViewsToArray()
        createNewTile()
        createNewTile()
    }
    
    func addTileViewsToArray() {
        tileViews.append(tile1)
        tileViews.append(tile2)
        tileViews.append(tile3)
        tileViews.append(tile4)
        tileViews.append(tile5)
        tileViews.append(tile6)
        tileViews.append(tile7)
        tileViews.append(tile8)
        tileViews.append(tile9)
        tileViews.append(tile10)
        tileViews.append(tile11)
        tileViews.append(tile12)
        tileViews.append(tile13)
        tileViews.append(tile14)
        tileViews.append(tile15)
        tileViews.append(tile16)
        
        var xIndex = 0
        var yIndex = 0
        tileHeight = tile1.frame.height
        tileWidth = tile1.frame.width
        
        for (_, tile) in tileViews.enumerated() {
            
            if xIndex == 0 {
                let newFrame = gameBoard.convert(tile.frame, from: row4)
                tileCoordsWithPositions[[xIndex, yIndex]] = [newFrame.origin.x, newFrame.origin.y]
            } else if xIndex == 1 {
                let newFrame = gameBoard.convert(tile.frame, from: row3)
                tileCoordsWithPositions[[xIndex, yIndex]] = [newFrame.origin.x, newFrame.origin.y]
            } else if xIndex == 2 {
                let newFrame = gameBoard.convert(tile.frame, from: row2)
                tileCoordsWithPositions[[xIndex, yIndex]] = [newFrame.origin.x, newFrame.origin.y]
            } else if xIndex == 3 {
                let newFrame = gameBoard.convert(tile.frame, from: row1)
                tileCoordsWithPositions[[xIndex, yIndex]] = [newFrame.origin.x, newFrame.origin.y]
            }
            
            yIndex += 1
            
            if yIndex == 4 {
                yIndex = 0
                xIndex += 1
            }
        }
        
        /*for (key, value) in tileCoordsWithPositions {
            //let newTileCoords = pickRandomTile()
            let newTile = Tile(color: pickRandomTileColor(), occupied: true, xCoord: key[0], yCoord: key[1], xPos: value[0], yPos: value[1], width: tileWidth, height: tileHeight)
            self.gameBoard.addSubview(newTile)
        }*/
    }
    
    func createGestures() {
        let right = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        right.direction = .right
        let left = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        left.direction = .left
        let up = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        up.direction = .up
        let down = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        down.direction = .down
        
        self.view.addGestureRecognizer(right)
        self.view.addGestureRecognizer(left)
        self.view.addGestureRecognizer(up)
        self.view.addGestureRecognizer(down)
    }
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) {
        //moveTiles(direction: gesture.direction)
        //move to moveTiles funtion
        createNewTile()
    }
    
    /*func manualAddTile() {
        Tile2.occupied = true
        Tile2.color = pickRandomTileColor()
        Tile2.backgroundColor = Tile2.color
    }*/
    
    func swipeToEmptyTile(oldTile: Tile, newTile: Tile) {
        newTile.backgroundColor = oldTile.backgroundColor
        newTile.occupied = true
        oldTile.backgroundColor = .systemBackground
        oldTile.occupied = false
    }
    
    func moveTiles(direction: UISwipeGestureRecognizer.Direction) {
        
        var group0 = [Tile]()
        var group1 = [Tile]()
        var group2 = [Tile]()
        var group3 = [Tile]()
        
        switch direction {
        case .up:
            var startingIndex = 3
            for _ in 0...3 {
                for tile in occupiedTiles {
                    if tile.xCoord == startingIndex {
                        switch tile.yCoord {
                        case 0:
                            group0.append(tile)
                        case 1:
                            group1.append(tile)
                        case 2:
                            group2.append(tile)
                        case 3:
                            group3.append(tile)
                        default:
                            break
                        }
                    }
                }
                startingIndex -= 1
            }
            
            assessPositions(group: group0)
            
        case .down:
            print()
        case .left:
            print()
        case .right:
            print()
        default:
            break
        }
        
        /*for tile in tileViews {
            if tile.occupied {
                occupiedTiles.append(tile)
            }
        }
        
        occupiedTiles.removeAll()*/
    }
    
    func assessPositions(group: [Tile]) {
        for (index, tile) in group.enumerated() {
            
        }
    }
    
    func combineCheck(oldTile: Tile, newTile: Tile) -> Bool {
        if oldTile.color == newTile.color {
            return false
        } else {
            return true
        }
    }
    
    func pickRandomTile() -> (Int, Int, CGFloat, CGFloat, CGFloat, CGFloat) {
        
        var randomX = -1
        var randomY = -1
        
        repeat {
            randomX = Int.random(in: 0...3)
            randomY = Int.random(in: 0...3)
        } while isTileOccupied(x: randomX, y: randomY)
        
        let coords = [randomX, randomY]
        
        let tileHeight = tile1.frame.height
        let tileWidth = tile1.frame.width
        var tileX: CGFloat = 0.0
        var tileY: CGFloat = 0.0
        
        for (key, value) in tileCoordsWithPositions {
            if key == coords {
                tileX = value[0]
                tileY = value[1]
            }
        }
        
        return (coords[0], coords[1], tileX, tileY, tileWidth, tileHeight)
    }
    
    func isTileOccupied(x: Int, y: Int) -> Bool {
        var isOccupied = false
        
        for tile in occupiedTiles {
            if (tile.xCoord == x) && (tile.yCoord == y) {
                isOccupied = true
            }
        }
        
        return isOccupied
    }
    
    func pickRandomTileColor() -> UIColor {
        let randomColorInt = Int.random(in: 1...3)
        
        if randomColorInt == 1 {
            return .blue
        } else if randomColorInt == 2 {
            return .red
        } else if randomColorInt == 3 {
            return .yellow
        }
        
        return .white
    }
    
    func createNewTile() {
        let newTileCoords = pickRandomTile()
        let newTile = Tile(color: pickRandomTileColor(), occupied: true, xCoord: newTileCoords.0, yCoord: newTileCoords.1, xPos: newTileCoords.2, yPos: newTileCoords.3, width: newTileCoords.4, height: newTileCoords.5)
        occupiedTiles.append(newTile)
        self.gameBoard.addSubview(newTile)
    }
}

class Tile: UIView {

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

