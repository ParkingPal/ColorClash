//
//  ViewController.swift
//  ColorClash
//
//  Created by ParkingPal on 11/24/20.
//

import UIKit

class ViewController: UIViewController {
    
    var tileHeight: CGFloat = 0.0
    var tileWidth: CGFloat = 0.0
    var tileViews = [UIView]()
    let gameBoardView = UIView()
    //we need to set up the initialization later so the xMax and yMax below are the same as the xMax and yMax in the Board initilization...so we don't have to manually put in both
    let xMax = 3
    let yMax = 3
    
    var tileCoordsWithPositions = [[Int]:[CGFloat]]()
    var board = Board(xMax:3, yMax:3)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createBoardGraphically()
        createGestures()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addTileViewsToArray()
        let newTile = board.addTileRandomly(tileCoordsWithPositions: tileCoordsWithPositions, tileWidth: tileWidth, tileHeight: tileHeight)
        newTile.growAndAppearTile()
        self.gameBoardView.addSubview(newTile)
    }
    
    func createBoardGraphically() {
        let boardDimension = view.frame.width - 20
        let boardSpacing = (boardDimension / CGFloat(xMax) / 15)
        
        //create board
        gameBoardView.backgroundColor = .brown
        view.addSubview(gameBoardView)
        
        //set up constraints for board
        gameBoardView.translatesAutoresizingMaskIntoConstraints = false
        let horizontalConstraint = gameBoardView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let verticalConstraint = gameBoardView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        let widthConstraint = gameBoardView.widthAnchor.constraint(equalToConstant: boardDimension)
        let heightConstraint = gameBoardView.heightAnchor.constraint(equalToConstant: boardDimension)
        view.addConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
        
        //add vertical stackview to the board
        let verticalStack = UIStackView()
        verticalStack.distribution = .fillEqually
        verticalStack.axis = .vertical
        verticalStack.spacing = boardSpacing
        gameBoardView.addSubview(verticalStack)
        verticalStack.translatesAutoresizingMaskIntoConstraints = false
        let verticalStackLeadingConstraint = verticalStack.leadingAnchor.constraint(equalTo: gameBoardView.leadingAnchor, constant: boardSpacing)
        let verticalStackTrailingConstraint = verticalStack.trailingAnchor.constraint(equalTo: gameBoardView.trailingAnchor, constant: -boardSpacing)
        let verticalStackTopConstraint = verticalStack.topAnchor.constraint(equalTo: gameBoardView.topAnchor, constant: boardSpacing)
        let verticalStackBottomConstraint = verticalStack.bottomAnchor.constraint(equalTo: gameBoardView.bottomAnchor, constant: -boardSpacing)
        gameBoardView.addConstraints([verticalStackLeadingConstraint, verticalStackTrailingConstraint, verticalStackTopConstraint, verticalStackBottomConstraint])
        
        //add horizontal stackviews to the board with views (tiles)
        for _ in 0...xMax {
            let horizontalStack = UIStackView()
            horizontalStack.distribution = .fillEqually
            horizontalStack.axis = .horizontal
            horizontalStack.spacing = boardSpacing
            
            for _ in 0...yMax {
                let backgroundTile = UIView()
                tileViews.append(backgroundTile)
                backgroundTile.backgroundColor = .white
                horizontalStack.addArrangedSubview(backgroundTile)
            }
            verticalStack.addArrangedSubview(horizontalStack)
        }
        
    }
    
    func addTileViewsToArray() {
        var xIndex = 0
        var yIndex = 0
        tileHeight = tileViews[0].frame.height
        tileWidth = tileViews[0].frame.width
        
        for (_, tile) in tileViews.enumerated() {
            let newFrame = gameBoardView.convert(tile.frame, from: tile.superview)
            tileCoordsWithPositions[[xIndex, yIndex]] = [newFrame.origin.x, newFrame.origin.y]
            
            yIndex += 1
            
            if yIndex == yMax + 1 {
                yIndex = 0
                xIndex += 1
            }
        }
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
        let newTile = board.addTileRandomly(tileCoordsWithPositions: tileCoordsWithPositions, tileWidth: tileWidth, tileHeight: tileHeight)
        newTile.growAndAppearTile()
        self.gameBoardView.addSubview(newTile)
    }
    
    func swipeToEmptyTile(oldTile: Tile, newTile: Tile) {
        newTile.backgroundColor = oldTile.backgroundColor
        newTile.occupied = true
        oldTile.backgroundColor = .systemBackground
        oldTile.occupied = false
    }
    
    /*func moveTiles(direction: UISwipeGestureRecognizer.Direction) {
     
        //tile.moveTile(oldCoords: [tile.xPos, tile.yPos], newCoords: tileCoordsWithPositions[[2,3]]!, tileSize: tileHeight)
     
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
    }*/
    
    func assessPositions(group: [Tile]) {
        for (index, tile) in group.enumerated() {
            
        }
    }
    
    func combineCheck(oldTile: Color, newTile: Color) -> Bool {
        if oldTile.color == newTile.color {
            return false
        } else {
            return true
        }
    }
    
    
    /*func pickRandomTileColor() -> UIColor {
        let randomColorInt = Int.random(in: 1...3)
        
        if randomColorInt == 1 {
            return .blue
        } else if randomColorInt == 2 {
            return .red
        } else if randomColorInt == 3 {
            return .yellow
        }
        
        return .white
    }*/
}
