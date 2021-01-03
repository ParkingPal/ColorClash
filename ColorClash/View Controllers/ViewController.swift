//
//  ViewController.swift
//  ColorClash
//
//  Created by ParkingPal on 11/24/20.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    var tileHeight: CGFloat = 0.0
    var tileWidth: CGFloat = 0.0
    var tileViews = [UIView]()
    let gameBoardView = UIView()
    //we need to set up the initialization later so the xMax and yMax below are the same as the xMax and yMax in the Board initilization...so we don't have to manually put in both
    var xMax = 0
    var yMax = 0
    
    var tileCoordsWithPositions = [[Int]:[CGFloat]]()
    var board = Board(xMax: 0, yMax: 0, gameType: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createBoardGraphically()
        createGestures()
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addTileViewsToArray()
        
        if board.gameType == "Hardcore" {
            board.addWallsRandomly(numToAdd: Int(((xMax + 1) * (yMax + 1) / 5)), gameBoardView: gameBoardView, tileCoordsWithPositions: tileCoordsWithPositions, tileWidth: tileWidth, tileHeight: tileHeight)
        }
        
        let newTile = board.addTileRandomly(tileCoordsWithPositions: tileCoordsWithPositions, tileWidth: tileWidth, tileHeight: tileHeight)
        newTile.growAndAppearTile()
        self.gameBoardView.addSubview(newTile)
        let newTile2 = board.addTileRandomly(tileCoordsWithPositions: tileCoordsWithPositions, tileWidth: tileWidth, tileHeight: tileHeight)
        newTile2.growAndAppearTile()
        self.gameBoardView.addSubview(newTile2)
        
        UIView.animate(withDuration: 0.5) {
            self.gameBoardView.alpha = 1.0
        }
    }
    
    func gameIsOver() {
        for recognizer in self.view.gestureRecognizers ?? []{
            self.view.removeGestureRecognizer(recognizer)
        }
        
        Firestore.firestore().collection("Games").document().setData(["authID": Auth.auth().currentUser!.uid, "score": board.score, "gameType": board.gameType, "boardSize": xMax + 1, "timeFinished": FieldValue.serverTimestamp()], merge: true)
        
        scoreLabel.text = "Final Score: \(String(board.score))"
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.performSegue(withIdentifier: "unwindToSingleGame", sender: self)
        }
    }
    
    //use for easy testing
    func addTileAtCoords(colorString: String, xCoord: Int, yCoord: Int) {
        let colorHelper = ColorHelper()
        let value = colorHelper.getValueByColor(color: colorString)
        let tile = Color(color: UIImage(named: colorString + "TileBevel.png")!, colorString: colorString, colorType: colorHelper.getTypeByValue(value: value), value: value, xCoord: xCoord, yCoord: yCoord, xPos: tileCoordsWithPositions[[xCoord,yCoord]]![0], yPos: tileCoordsWithPositions[[xCoord,yCoord]]![1], width: tileWidth, height: tileHeight)
        board.addTile(tile:tile, xPos: xCoord, yPos: yCoord)
        gameBoardView.addSubview(tile)
    }
    
    func createBoardGraphically() {
        let boardDimension = view.frame.width - 20
        let boardSpacing = (boardDimension / CGFloat(xMax) / 15)
        
        //create board
        gameBoardView.backgroundColor = .brown
        //add shadow
        gameBoardView.layer.masksToBounds = false
        gameBoardView.layer.shadowColor = CGColor(srgbRed: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        gameBoardView.layer.shadowOpacity = 1.0
        gameBoardView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        gameBoardView.layer.shadowRadius = 50.0
        gameBoardView.alpha = 0.0
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
            
            xIndex += 1
            
            if xIndex == xMax + 1 {
                xIndex = 0
                yIndex += 1
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
        let isValidMove = board.moveTiles(direction: gesture.direction, tileCoordsWithPositions: tileCoordsWithPositions, tileSize: tileWidth)
        if isValidMove {
            let newTile = board.addTileRandomly(tileCoordsWithPositions: tileCoordsWithPositions, tileWidth: tileWidth, tileHeight: tileHeight)
            newTile.growAndAppearTile()
            self.gameBoardView.addSubview(newTile)
            scoreLabel.text = String(board.score)
            
            if board.gameEnded() {
                gameIsOver()
            }
        }
    }
}
