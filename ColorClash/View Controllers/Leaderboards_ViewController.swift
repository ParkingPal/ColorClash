//
//  Leaderboards_ViewController.swift
//  ColorClash
//
//  Created by ParkingPal on 12/8/20.
//

import UIKit
import Firebase

class Leaderboards_ViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var classicButton: CustomButton!
    @IBOutlet weak var arcadeButton: CustomButton!
    @IBOutlet weak var hardcoreButton: CustomButton!
    @IBOutlet weak var leadersScrollView: UIScrollView!
    
    let stats = ["High Score", "Average Score", "Games Played"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Josefin Sans", size: 30.0)!, NSAttributedString.Key.foregroundColor: UIColor(red: 176/255, green: 224/255, blue: 230/255, alpha: 1.0)]
        // Do any additional setup after loading the view.
    }
    
    func setupLayout() {
        let buttonWidth = classicButton.frame.width
        let buttonHeight = classicButton.frame.height

        classicButton.setupButton(font: "Vollkorn", size: 75.0, horizontalInsets: buttonWidth/6, verticalInsets: buttonHeight, shadowOpacity: 0.3, shadowRadius: 5.0, shadowColor: 0.0)
        classicButton.addTarget(self, action: #selector(classicButtonClicked(sender:)), for: .touchUpInside)
        arcadeButton.setupButton(font: "Abingdon", size: 75.0, horizontalInsets: buttonWidth/6, verticalInsets: buttonHeight, shadowOpacity: 0.3, shadowRadius: 5.0, shadowColor: 0.0)
        arcadeButton.addTarget(self, action: #selector(arcadeButtonClicked(sender:)), for: .touchUpInside)
        hardcoreButton.setupButton(font: "aAssassinNinja", size: 75.0, horizontalInsets: buttonWidth/6, verticalInsets: buttonHeight, shadowOpacity: 0.3, shadowRadius: 5.0, shadowColor: 0.0)
        hardcoreButton.addTarget(self, action: #selector(hardcoreButtonClicked(sender:)), for: .touchUpInside)
        
        selectedShadow(button: classicButton, opacity: 1.0)
        selectedShadow(button: arcadeButton, opacity: 0.0)
        selectedShadow(button: hardcoreButton, opacity: 0.0)
    }
    
    func selectedShadow(button: CustomButton, opacity: Float) {
        let size: CGFloat = -10
        let distance: CGFloat = -10
        let rect = CGRect(
            x: -size,
            y: button.frame.height - (size * 0.4) + distance,
            width: button.frame.width + size * 2,
            height: size
        )

        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowRadius = 5
        button.layer.shadowOpacity = opacity
        button.layer.shadowPath = UIBezierPath(ovalIn: rect).cgPath
    }
    
    @objc func classicButtonClicked(sender: CustomButton) {
        sender.tag = 0
        shadowAnimation(button: classicButton, opacity: 1.0)
        shadowAnimation(button: arcadeButton, opacity: 0.0)
        shadowAnimation(button: hardcoreButton, opacity: 0.0)
    }
    
    @objc func arcadeButtonClicked(sender: CustomButton) {
        sender.tag = 1
        shadowAnimation(button: classicButton, opacity: 0.0)
        shadowAnimation(button: arcadeButton, opacity: 1.0)
        shadowAnimation(button: hardcoreButton, opacity: 0.0)
    }
    
    @objc func hardcoreButtonClicked(sender: CustomButton) {
        sender.tag = 2
        shadowAnimation(button: classicButton, opacity: 0.0)
        shadowAnimation(button: arcadeButton, opacity: 0.0)
        shadowAnimation(button: hardcoreButton, opacity: 1.0)
    }
    
    func shadowAnimation(button: CustomButton, opacity: Float) {
        let animation = CABasicAnimation(keyPath: "shadowOpacity")
        animation.fromValue = button.layer.shadowOpacity
        animation.toValue = opacity
        animation.duration = 1.0
        button.layer.add(animation, forKey: animation.keyPath)
        button.layer.shadowOpacity = opacity
    }
    
    func fetchLeaderboard(tag: Int) {
        var gameType = ""
        
        switch tag {
        case 0:
            gameType = "classic"
        case 1:
            gameType = "arcade"
        case 2:
            gameType = "hardcore"
        default:
            break
        }
        
        /// Query High Score
        Firestore.firestore().collection("SG_Scores").order(by: "\(gameType)HS", descending: true).limit(to: 10).getDocuments(completion: { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                //do Leaderboard
            }
        })
        
        /// Query Average Score
        Firestore.firestore().collection("SG_Scores").order(by: "\(gameType)AS", descending: true).limit(to: 10).getDocuments(completion: { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                //do Leaderboard
            }
        })
        
        /// Query Games Played
        Firestore.firestore().collection("SG_Scores").order(by: "\(gameType)GP", descending: true).limit(to: 10).getDocuments(completion: { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                //do Leaderboard
            }
        })
    }
    
    func fillLeaderboard(querySnapshot: QuerySnapshot?) {
        let docCount = querySnapshot!.documents.count
        var numbers = [String]()
        var names = [String]()
        var values = [String]()
        
        if docCount > 0 {
            for num in 1...docCount {
                numbers.append(String(num))
            }
        }
        
        for document in querySnapshot!.documents {
            let docData = document.data()
            let name = docData["userName"]
        }
        
    }
}

extension Leaderboards_ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
}
