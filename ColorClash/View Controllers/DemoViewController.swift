//
//  DemoViewController.swift
//  ColorClash
//
//  Created by ParkingPal on 5/15/21.
//

import UIKit
import Firebase
import GoogleMobileAds

class DemoViewController: UIViewController, UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var gameView: UIView!
    @IBOutlet weak var scoreTitleLabel: CustomLabel!
    @IBOutlet weak var scoreLabel: CustomLabel!
    @IBOutlet weak var howToPlayButton: UIButton!
    
    let xMax = 3
    let yMax = 3
    var tileViews = [UIView]()
    let gameBoardView = UIView()
    var board = Board(xMax: 3, yMax: 3, gameType: "Classic")
    var tileCoordsWithPositions = [[Int]:[CGFloat]]()
    var tileHeight: CGFloat = 0.0
    var tileWidth: CGFloat = 0.0
    
    var bannerView: GADBannerView!
    var interstitial: GADInterstitialAd?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLabels()
        createBoardGraphically()
        createGestures()
        setupHTPButton()
        
        loadBannerAd()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addTileViewsToArray()
        addWalls()
        
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
    
    func loadBannerAd() {
        self.bannerView = GADBannerView(adSize: GADAdSizeBanner)
        self.bannerView.delegate = self
        
        self.bannerView.adUnitID = "ca-app-pub-2313664443232233/5270628424"
        self.bannerView.rootViewController = self
        self.bannerView.load(GADRequest())
        
        loadInterstitialAd(adString: "After Game")
    }
    
    func loadInterstitialAd(adString: String) {
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID: "ca-app-pub-2313664443232233/5079056735", request: request, completionHandler: { [self] ad, error in
            if let error = error {
                print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                return
            }
            interstitial = ad
        })
    }
    
    func setupLabels() {
        scoreTitleLabel.setupLabel(font: "aArang", size: 40.0, shadowOpacity: 0.3, shadowRadius: 5.0, shadowColor: 0.0)
        scoreLabel.setupLabel(font: "aArang", size: 40.0, shadowOpacity: 0.3, shadowRadius: 5.0, shadowColor: 0.0)
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
            
            let newTile = board.addTileRandomly(tileCoordsWithPositions: tileCoordsWithPositions, tileWidth: tileWidth, tileHeight: tileHeight)
            newTile.growAndAppearTile()
            self.gameBoardView.addSubview(newTile)
            scoreLabel.text = String(board.score)
            
            if board.gameEnded() {
                gameIsOver()
            }
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
    
    func gameIsOver() {
        for recognizer in self.view.gestureRecognizers ?? []{
            self.view.removeGestureRecognizer(recognizer)
        }
        
        Firestore.firestore().collection("Demo_Games").document().setData(["authID": "No Auth ID", "score": board.score, "gameType": board.gameType, "boardSize": xMax + 1, "timeFinished": FieldValue.serverTimestamp()], merge: true)
        
        scoreLabel.text = "Game Over"
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.performSegue(withIdentifier: "toContinueGame", sender: self)
        }
    }
    

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toContinueGame" {
            let continueGameVC = segue.destination as! ContinueGameViewController
            continueGameVC.score = board.score
            continueGameVC.interstitial = self.interstitial
            continueGameVC.fromDemo = true
        }
    }

}

extension DemoViewController: GADBannerViewDelegate {
    
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
