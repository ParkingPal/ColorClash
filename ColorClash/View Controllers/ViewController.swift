//
//  ViewController.swift
//  ColorClash
//
//  Created by ParkingPal on 11/24/20.
//

import UIKit
import Firebase
import GoogleMobileAds

class ViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var scoreTitleLabel: CustomLabel!
    @IBOutlet weak var scoreLabel: CustomLabel!
    @IBOutlet weak var gameView: UIView!
    @IBOutlet weak var howToPlayButton: UIButton!
    
    var tileHeight: CGFloat = 0.0
    var tileWidth: CGFloat = 0.0
    var tileViews = [UIView]()
    let gameBoardView = UIView()
    //we need to set up the initialization later so the xMax and yMax below are the same as the xMax and yMax in the Board initilization...so we don't have to manually put in both
    var xMax = 0
    var yMax = 0
    var hazardMultiple = 10
    var scoreMultiple = 5
    
    var tileCoordsWithPositions = [[Int]:[CGFloat]]()
    var board = Board(xMax: 0, yMax: 0, gameType: "")
    var singleGame = SingleGame(authID: Auth.auth().currentUser!.uid, boardSize: 0, gameType: "")
    
    var hazardOwed = false
    var bannerView: GADBannerView!
    var interstitial: GADInterstitialAd?
    
    var turns = [Int]()
    var start = [[String: Int]]()
    var boardSize = 0
    var adFailed = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLabels()
        createBoardGraphically()
        createGestures()
        setupHTPButton()
        
        singleGame.boardSize = xMax + 1
        singleGame.gameType = board.gameType.lowercased()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        if UserDocument.docData["adsRemoved"] as! Bool == false {
            Firestore.firestore().collection("Ad IDs").document("Ad IDs").getDocument { (document, error) in
                if error == nil {
                    self.bannerView = GADBannerView(adSize: GADAdSizeBanner)
                    self.bannerView.delegate = self
                    
                    guard let adID = document?.data()?["Banner"] as? String else {
                        //FirebaseQuery.reportGuardCrash(vc: self, funcName: "loadAd", varName: "adID")
                        return
                    }
                    self.bannerView.adUnitID = adID
                    self.bannerView.rootViewController = self
                    self.bannerView.load(GADRequest())
                } else {
                    print("can't load banner ad")
                }
            }
            
            loadInterstitialAd(adString: "After Game")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParent || self.isBeingDismissed {
            Firestore.firestore().collection("Games").document().setData(["authID": Auth.auth().currentUser!.uid, "score": board.score, "gameType": board.gameType, "boardSize": xMax + 1, "timeFinished": FieldValue.serverTimestamp()], merge: true)
            
            singleGame.gameOver(score: board.score)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addTileViewsToArray()
        
        switch board.gameType {
        case "Classic":
            addWalls()
        case "Arcade":
            addHazard()
        case "Hardcore":
            addWalls()
            addHazard()
        default:
            break
        }
        
        if board.gameType == "Test Level" {
            addStartingLevelTiles()
            testLevel()
        } else {
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
    }
    
    func setupHTPButton() {
        howToPlayButton.titleLabel?.font = UIFont(name: "Josefin Sans", size: 25.0)
        howToPlayButton.titleLabel?.numberOfLines = 0
        howToPlayButton.titleLabel?.adjustsFontSizeToFitWidth = true
        howToPlayButton.titleLabel?.textAlignment = .center
        howToPlayButton.addTarget(self, action: #selector(htpButtonClicked(sender:)), for: .touchUpInside)
    }
    
    @objc func htpButtonClicked(sender: UIButton) {
        let popController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "infoPopover") as! InfoPopover
        popController.modalPresentationStyle = UIModalPresentationStyle.popover
        popController.popoverPresentationController?.delegate = self
        popController.popoverPresentationController?.sourceView = sender
        popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
        
        let width = self.view.frame.width
        popController.preferredContentSize = CGSize(width: width - 30, height: 210)
        
        popController.gameType = "How to Play"
        popController.desc = "Combine primary colors (Red, Blue, & Yellow) to form secondary colors (Red/Blue: Purple, Red/Yellow: Orange, Blue/Yellow: Green. Then combine matching secondary colors together to score points, and get rid of Black Boxes in Arcade and Hardcore game modes."
        
        present(popController, animated: true, completion: nil)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    func loadInterstitialAd(adString: String) {
        Firestore.firestore().collection("Ad IDs").document("Ad IDs").getDocument { (document, error) in
            if error == nil {
                guard let adID = document?.data()?["\(adString)"] as? String else {
                    //FirebaseQuery.reportGuardCrash(vc: self, funcName: "loadAd", varName: "adID")
                    return
                }
                let request = GADRequest()
                GADInterstitialAd.load(withAdUnitID: adID, request: request, completionHandler: { [self] ad, error in
                    if let error = error {
                        print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                        return
                    }
                    interstitial = ad
                })
            } else {
                print("cant load ad")
            }
        }
    }
    
    func addStartingLevelTiles() {
        var index = 0
        for _ in start {
            
            let value = (start[index]["value"])!
            let xCoord = (start[index]["xCoord"])!
            let yCoord = (start[index]["yCoord"])!
            
            if value == -1 {
                let tile = Wall(xCoord: xCoord, yCoord: yCoord, xPos: tileCoordsWithPositions[[xCoord,yCoord]]![0], yPos: tileCoordsWithPositions[[xCoord,yCoord]]![1], width: tileWidth, height: tileHeight)
                board.addTile(tile: tile, xPos: xCoord, yPos: yCoord)
            } else if value >= 0 {
                
                var colorType = ""
                var colorImageName = ""
                var colorString = ""
                
                if value >= 0 && value < 3 {
                    colorType = "Primary"
                } else {
                    colorType = "Secondary"
                }
                
                switch value {
                case 0:
                    colorImageName = "RedTileBevel.png"
                    colorString = "Red"
                case 1:
                    colorImageName = "BlueTileBevel.png"
                    colorString = "Blue"
                case 2:
                    colorImageName = "YellowTileBevel.png"
                    colorString = "Yellow"
                case 3:
                    colorImageName = "PurpleTileBevel.png"
                    colorString = "Purple"
                case 4:
                    colorImageName = "OrangeTileBevel.png"
                    colorString = "Orange"
                case 5:
                    colorImageName = "GreenTileBevel.png"
                    colorString = "Green"
                default:
                    break
                }
                
                let color = Color(color: UIImage(named: colorImageName)!, colorString: colorString, colorType: colorType, value: value, xCoord: xCoord, yCoord: yCoord, xPos: tileCoordsWithPositions[[xCoord,yCoord]]![0], yPos: tileCoordsWithPositions[[xCoord,yCoord]]![1], width: tileWidth, height: tileHeight, moveCombined: 0)
                board.addTile(tile: color, xPos: xCoord, yPos: yCoord)
            }

            index += 1
        }
    }
    
    func addBannerView(_ bannerView: GADBannerView, board: UIView) {
        let distance = view.frame.size.height - (board.frame.size.height + board.frame.origin.y)
        bannerView.alpha = 0.0
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
            [NSLayoutConstraint(item: bannerView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0), NSLayoutConstraint(item: bannerView, attribute: .top, relatedBy: .equal, toItem: board, attribute: .bottom, multiplier: 1, constant: distance/3)])
        
        UIView.animate(withDuration: 0.5) {
            bannerView.alpha = 1.0
        }
    }
    
    func addWalls() {
        board.addWallsRandomly(numToAdd: Int((((xMax + 1) * (yMax + 1)) / 6)), gameBoardView: gameBoardView, tileCoordsWithPositions: tileCoordsWithPositions, tileWidth: tileWidth, tileHeight: tileHeight)
    }
    
    func addHazard() {
        let hazard = board.addHazard(moveNumber: board.movesTotal, gameBoardView: gameBoardView, tileCoordsWithPositions: tileCoordsWithPositions, tileWidth: tileWidth, tileHeight: tileHeight)
        hazard.growAndAppearTile()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hazardTapped(tapGestureRecognizer:)))
        hazard.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func setupLabels() {
        scoreTitleLabel.setupLabel(font: "aArang", size: 40.0, shadowOpacity: 0.3, shadowRadius: 5.0, shadowColor: 0.0)
        scoreLabel.setupLabel(font: "aArang", size: 40.0, shadowOpacity: 0.3, shadowRadius: 5.0, shadowColor: 0.0)
    }
    
    func gameIsOver() {
        for recognizer in self.view.gestureRecognizers ?? []{
            self.view.removeGestureRecognizer(recognizer)
        }
        
        Firestore.firestore().collection("Games").document().setData(["authID": Auth.auth().currentUser!.uid, "score": board.score, "gameType": board.gameType, "boardSize": xMax + 1, "timeFinished": FieldValue.serverTimestamp()], merge: true)
        
        singleGame.gameOver(score: board.score)
        
        scoreLabel.text = "Game Over"
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.performSegue(withIdentifier: "toContinueGame", sender: self)
        }
    }
    
    @objc func hazardTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let hazard = tapGestureRecognizer.view as! Hazard
        let removes = UserDocument.docData["removes"] as! Int
        
        if removes > 0 {
            let newTotal = removes - 1
            UserDocument.docData["removes"] = newTotal
            Firestore.firestore().collection("Users").document("\(Auth.auth().currentUser!.uid)").setData(["removes": newTotal], merge: true)
            
            board.removeTile(xPos: hazard.xCoord, yPos: hazard.yCoord)
            hazard.removeFromSuperview()
        } else {
            print("You have no removes available")
        }
    }
    
    //use for easy testing
    func addTileAtCoords(colorString: String, value: Int, xCoord: Int, yCoord: Int) {
        let colorHelper = ColorHelper()
        let value = colorHelper.getValueByColor(color: colorString)
        let tile = Color(color: UIImage(named: colorString + "TileBevel.png")!, colorString: colorString, colorType: colorHelper.getTypeByValue(value: value), value: value, xCoord: xCoord, yCoord: yCoord, xPos: tileCoordsWithPositions[[xCoord,yCoord]]![0], yPos: tileCoordsWithPositions[[xCoord,yCoord]]![1], width: tileWidth, height: tileHeight, moveCombined: 0)
        board.addTile(tile:tile, xPos: xCoord, yPos: yCoord)
        gameBoardView.addSubview(tile)
    }
    
    func createBoardGraphically() {
        var boardDimension = view.frame.width - 20
        if boardDimension > 500 {
            boardDimension = 500
        }
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
    
    func testLevel() {
        var directionsArray = [UISwipeGestureRecognizer]()
        
        let testRight = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        testRight.direction = .right
        directionsArray.append(testRight)
        let testLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        testLeft.direction = .left
        directionsArray.append(testLeft)
        let testUp = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        testUp.direction = .up
        directionsArray.append(testUp)
        let testDown = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        testDown.direction = .down
        directionsArray.append(testDown)
        
        self.view.addGestureRecognizer(testRight)
        self.view.addGestureRecognizer(testLeft)
        self.view.addGestureRecognizer(testUp)
        self.view.addGestureRecognizer(testDown)
        

        repeat {
            let randomDirectionNum = Int.random(in: 0...3)
            self.handleGesture(gesture: directionsArray[randomDirectionNum])
            /// Add the first tile in the turns array to the board at a random location
            /// Remove that tile after it has been added
        } while !turns.isEmpty
        
        print("\(board.score)")
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
        let checkMove = board.moveTiles(direction: gesture.direction, tileCoordsWithPositions: tileCoordsWithPositions, tileSize: tileWidth)
        let isValidMove = checkMove.0
        let tilesDidCombine = checkMove.1
        
        if tilesDidCombine {
            let musicPlayer = MusicPlayer.shared
            let haptic = UIImpactFeedbackGenerator(style: .medium)
            musicPlayer.playSoundEffect(fileName: "Click2", fileType: "wav")
            musicPlayer.resetVolume()
            haptic.impactOccurred()
        }
        
        if isValidMove {
            board.movesTotal += 1
            
            if board.gameType == "Arcade" || board.gameType == "Hardcore" {
                if board.score.isMultiple(of: scoreMultiple) && hazardMultiple > 1 && board.scoreChanged {
                    hazardMultiple -= 1
                }
                
                if board.movesTotal.isMultiple(of: hazardMultiple) && hazardOwed == false {
                    if board.emptyTiles().isEmpty || board.emptyTiles().count == 1 {
                        hazardOwed = true
                    } else {
                        addHazard()
                    }
                } else if hazardOwed == true {
                    if board.emptyTiles().count > 1 {
                        addHazard()
                        hazardOwed = false
                    }
                }
            }
            
            let newTile = board.addTileRandomly(tileCoordsWithPositions: tileCoordsWithPositions, tileWidth: tileWidth, tileHeight: tileHeight)
            newTile.growAndAppearTile()
            self.gameBoardView.addSubview(newTile)
            scoreLabel.text = String(board.score)
            
            if board.gameEnded() {
                gameIsOver()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toContinueGame" {
            let continueGameVC = segue.destination as! ContinueGameViewController
            continueGameVC.score = board.score
            continueGameVC.interstitial = self.interstitial
        }
    }
}

extension ViewController: GADBannerViewDelegate {
    
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        addBannerView(bannerView, board: gameBoardView)
        print("bannerViewDidReceiveAd")
    }
    
    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        print("bannerView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
        print("bannerViewDidRecordImpression")
    }
    
    func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
        print("bannerViewWillPresentScreen")
    }
    
    func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
        print("bannerViewWillDIsmissScreen")
    }
    
    func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("bannerViewDidDismissScreen")
    }
}
