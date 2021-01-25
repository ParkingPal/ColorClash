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
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var leadersView: UIView!
    
    let statHeadings = ["High Score", "Average Score", "Games Played"]
    let test = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
    var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
    let listAmount = 10
    var number = 0
    
    var highScoreLeaders = [Leader]()
    var averageScoreLeaders = [Leader]()
    var gamesPlayedLeaders = [Leader]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Josefin Sans", size: 30.0)!, NSAttributedString.Key.foregroundColor: UIColor(red: 176/255, green: 224/255, blue: 230/255, alpha: 1.0)]
        // Do any additional setup after loading the view.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        leadersScrollView.alpha = 0.0
        selectedShadow(selectedView: classicButton, opacity: 0.0)
        selectedShadow(selectedView: arcadeButton, opacity: 0.0)
        selectedShadow(selectedView: hardcoreButton, opacity: 0.0)
    }
    
    func setupLayout() {
        let buttonWidth = classicButton.frame.width
        let buttonHeight = classicButton.frame.height
        
        leadersScrollView.delegate = self

        classicButton.setupButton(font: "Vollkorn", size: 75.0, horizontalInsets: buttonWidth/6, verticalInsets: buttonHeight, shadowOpacity: 0.3, shadowRadius: 5.0, shadowColor: 0.0)
        classicButton.addTarget(self, action: #selector(classicButtonClicked(sender:)), for: .touchUpInside)
        arcadeButton.setupButton(font: "Abingdon", size: 75.0, horizontalInsets: buttonWidth/6, verticalInsets: buttonHeight, shadowOpacity: 0.3, shadowRadius: 5.0, shadowColor: 0.0)
        arcadeButton.addTarget(self, action: #selector(arcadeButtonClicked(sender:)), for: .touchUpInside)
        hardcoreButton.setupButton(font: "aAssassinNinja", size: 75.0, horizontalInsets: buttonWidth/6, verticalInsets: buttonHeight, shadowOpacity: 0.3, shadowRadius: 5.0, shadowColor: 0.0)
        hardcoreButton.addTarget(self, action: #selector(hardcoreButtonClicked(sender:)), for: .touchUpInside)
        
        selectedShadow(selectedView: classicButton, opacity: 0.0)
        selectedShadow(selectedView: arcadeButton, opacity: 0.0)
        selectedShadow(selectedView: hardcoreButton, opacity: 0.0)
    }
    
    func addGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped(sender:)))
        leadersView.addGestureRecognizer(tap)
    }
    
    @objc func tapped(sender: UIGestureRecognizer) {
        var frame: CGRect = leadersScrollView.frame
        var index = pageControl.currentPage
        frame.origin.y = 0
        
        let point = sender.location(in: leadersView)
        let leftArea = CGRect(x: 0, y: 0, width: leadersView.frame.width/2, height: leadersView.frame.height)
        let rightArea = CGRect(x: leadersView.frame.width/2, y: 0, width: leadersView.frame.width/2, height: leadersView.frame.height)
        if leftArea.contains(point) {
            print("Left Tapped")
            if index != 0 {
                index -= 1
            }
        }
        if rightArea.contains(point) {
            print("Right Tapped")
            if index != 2 {
                index += 1
            }
        }
        
        frame.origin.x = frame.size.width * CGFloat(index)
        pageControl.currentPage = index
        leadersScrollView.scrollRectToVisible(frame, animated: true)
    }

    func selectedShadow(selectedView: UIView, opacity: Float) {
        let size: CGFloat = -10
        let distance: CGFloat = -10
        let rect = CGRect(
            x: -size,
            y: selectedView.frame.height - (size * 0.4) + distance,
            width: selectedView.frame.width + size * 2,
            height: size
        )

        selectedView.layer.shadowColor = UIColor.black.cgColor
        selectedView.layer.shadowRadius = 5
        selectedView.layer.shadowOpacity = opacity
        selectedView.layer.shadowPath = UIBezierPath(ovalIn: rect).cgPath
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width
        pageControl.currentPage = Int(pageNumber)
    }
    
    @objc func classicButtonClicked(sender: CustomButton) {
        clearArraysAndViews()
        sender.tag = 0
        shadowAnimation(button: classicButton, opacity: 1.0)
        shadowAnimation(button: arcadeButton, opacity: 0.0)
        shadowAnimation(button: hardcoreButton, opacity: 0.0)
        fetchLeaderboard(tag: sender.tag)
    }
    
    @objc func arcadeButtonClicked(sender: CustomButton) {
        clearArraysAndViews()
        sender.tag = 1
        shadowAnimation(button: classicButton, opacity: 0.0)
        shadowAnimation(button: arcadeButton, opacity: 1.0)
        shadowAnimation(button: hardcoreButton, opacity: 0.0)
        fetchLeaderboard(tag: sender.tag)
    }
    
    @objc func hardcoreButtonClicked(sender: CustomButton) {
        clearArraysAndViews()
        sender.tag = 2
        shadowAnimation(button: classicButton, opacity: 0.0)
        shadowAnimation(button: arcadeButton, opacity: 0.0)
        shadowAnimation(button: hardcoreButton, opacity: 1.0)
        fetchLeaderboard(tag: sender.tag)
    }
    
    func shadowAnimation(button: CustomButton, opacity: Float) {
        let animation = CABasicAnimation(keyPath: "shadowOpacity")
        animation.fromValue = button.layer.shadowOpacity
        animation.toValue = opacity
        animation.duration = 1.0
        button.layer.add(animation, forKey: animation.keyPath)
        button.layer.shadowOpacity = opacity
    }
    
    func clearArraysAndViews() {
        highScoreLeaders.removeAll()
        averageScoreLeaders.removeAll()
        gamesPlayedLeaders.removeAll()
        
        UIView.animate(withDuration: 0.1, delay: 0.0, options: UIView.AnimationOptions()) {
            self.leadersScrollView.alpha = 0.0
        } completion: { Bool in
            for view in self.leadersScrollView.subviews {
                view.removeFromSuperview()
            }
        }
    }
    
    func fetchLeaderboard(tag: Int) {
        var gameType = ""
        
        let group = DispatchGroup()
        
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
        
        group.enter() // Enter for High Score
        group.enter() // Enter for Average Score
        group.enter() // Enter for Games Played
        
        /// Query High Score
        Firestore.firestore().collection("SG_Scores").order(by: "\(gameType)HS", descending: true).limit(to: listAmount).getDocuments(completion: { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                self.fillLeaderArarys(querySnapshot: querySnapshot, gameType: gameType, statType: "HS")
                group.leave()
            }
        })
        
        /// Query Average Score
        Firestore.firestore().collection("SG_Scores").order(by: "\(gameType)AS", descending: true).limit(to: listAmount).getDocuments(completion: { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                self.fillLeaderArarys(querySnapshot: querySnapshot, gameType: gameType, statType: "AS")
                group.leave()
            }
        })
        
        /// Query Games Played
        Firestore.firestore().collection("SG_Scores").order(by: "\(gameType)GP", descending: true).limit(to: listAmount).getDocuments(completion: { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                self.fillLeaderArarys(querySnapshot: querySnapshot, gameType: gameType, statType: "GP")
                group.leave()
            }
        })
        
        group.notify(queue: DispatchQueue.main) {
            let hsLeadersCount = self.highScoreLeaders.count
            let asLeadersCount = self.averageScoreLeaders.count
            let gpLeadersCount = self.gamesPlayedLeaders.count
            
            for _ in hsLeadersCount ..< self.listAmount {
                let emptyLeader = Leader(rank: -1, name: "", score: -1.0)
                self.highScoreLeaders.append(emptyLeader)
            }
            
            for _ in asLeadersCount ..< self.listAmount {
                let emptyLeader = Leader(rank: -1, name: "", score: -1.0)
                self.averageScoreLeaders.append(emptyLeader)
            }
            
            for _ in gpLeadersCount ..< self.listAmount {
                let emptyLeader = Leader(rank: -1, name: "", score: -1.0)
                self.gamesPlayedLeaders.append(emptyLeader)
            }
            self.setupScrollView()
        }
    }
    
    func fillLeaderArarys(querySnapshot: QuerySnapshot!, gameType: String, statType: String) {
        let docCount = querySnapshot!.documents.count
        
        if docCount > 0 {
            var rank = 1
            for document in querySnapshot!.documents {
                let docData = document.data()
                let name = docData["userName"] as! String
                let score = docData["\(gameType)\(statType)"] as! Double

                let leader = Leader(rank: rank, name: name, score: score)
                
                if statType == "HS" {
                    self.highScoreLeaders.append(leader)
                } else if statType == "AS" {
                    self.averageScoreLeaders.append(leader)
                } else if statType == "GP" {
                    self.gamesPlayedLeaders.append(leader)
                }
                
                rank += 1
            }
        } else {
            print("No documents available")
        }
    }
    
    func setupScrollView() {
        addGestures()

        for index in 0 ..< statHeadings.count {
            frame.origin.x = leadersScrollView.frame.width * CGFloat(index)
            frame.size = leadersScrollView.frame.size
            
            let stackView = UIStackView(frame: frame)
            stackView.axis = .vertical
            stackView.distribution = .fill
            leadersScrollView.addSubview(stackView)
            
            let labelView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: frame.width, height: frame.height * 0.2))
            let tableView = setupPageInScrollView(frame: frame, index: index)

            stackView.addArrangedSubview(labelView)
            stackView.addArrangedSubview(tableView)
            
            tableView.heightAnchor.constraint(equalTo: labelView.heightAnchor, multiplier: 4.0).isActive = true
            
            let label = CustomLabel(frame: labelView.frame)
            labelView.addSubview(label)
            
            label.translatesAutoresizingMaskIntoConstraints = false
            
            label.leadingAnchor.constraint(equalTo: labelView.leadingAnchor, constant: labelView.frame.width/6).isActive = true
            label.topAnchor.constraint(equalTo: labelView.topAnchor, constant: labelView.frame.height/5).isActive = true
            label.bottomAnchor.constraint(equalTo: labelView.bottomAnchor, constant: -labelView.frame.height/5).isActive = true
            label.trailingAnchor.constraint(equalTo: labelView.trailingAnchor, constant: -labelView.frame.width/6).isActive = true
            
            label.text = statHeadings[index]
            label.textColor = UIColor(red: 0/255, green: 52/255, blue: 96/255, alpha: 1.0)
            label.setupLabel(font: "aArang", size: 75.0, shadowOpacity: 0.3, shadowRadius: 5.0, shadowColor: 255.0)
        }
        
        leadersScrollView.contentSize = CGSize(width: (leadersScrollView.frame.size.width * CGFloat(statHeadings.count)), height: 1.0)
        leadersScrollView.delegate = self
        
        UIView.animate(withDuration: 1.0) {
            self.leadersScrollView.alpha = 1.0
        }
    }
    
    func setupPageInScrollView(frame: CGRect, index: Int) -> UITableView {
        let tableView = UITableView(frame: frame)
        tableView.tag = index
        tableView.backgroundColor = .clear
        setupTableView(tableView: tableView)
        
        return tableView
    }
    
    func setupTableView(tableView: UITableView) {
        tableView.register(LeaderboardsTableCell.self, forCellReuseIdentifier: "LeaderboardsTableCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = false
        tableView.isScrollEnabled = false
    }
}

extension Leaderboards_ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 0 {
            return highScoreLeaders.count
        } else if tableView.tag == 1 {
            return averageScoreLeaders.count
        } else if tableView.tag == 2 {
            return gamesPlayedLeaders.count
        }
        
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "LeaderboardsTableCell", for: indexPath as IndexPath) as! LeaderboardsTableCell
        
        if tableView.tag == 0 {
            let leader = highScoreLeaders[indexPath.row]
            cell = emptyCheck(cell: cell, leader: leader)
            cell.set(leader: leader)
        } else if tableView.tag == 1 {
            let leader = averageScoreLeaders[indexPath.row]
            cell = emptyCheck(cell: cell, leader: leader)
            cell.set(leader: leader)
        } else if tableView.tag == 2 {
            let leader = gamesPlayedLeaders[indexPath.row]
            cell = emptyCheck(cell: cell, leader: leader)
            cell.set(leader: leader)
        }
        
        if indexPath.row == 0 || indexPath.row.isMultiple(of: 2) {
            cell.contentView.backgroundColor = UIColor(red: 0/255, green: 52/255, blue: 96/255, alpha: 0.2)
            cell.rankLabel.textColor = UIColor(red: 176/255, green: 224/255, blue: 230/255, alpha: 1.0)
            cell.nameLabel.textColor = UIColor(red: 176/255, green: 224/255, blue: 230/255, alpha: 1.0)
            cell.scoreLabel.textColor = UIColor(red: 176/255, green: 224/255, blue: 230/255, alpha: 1.0)
        } else {
            cell.contentView.backgroundColor = UIColor(red: 176/255, green: 224/255, blue: 230/255, alpha: 0.2)
            cell.rankLabel.textColor = UIColor(red: 0/255, green: 52/255, blue: 96/255, alpha: 1.0)
            cell.nameLabel.textColor = UIColor(red: 0/255, green: 52/255, blue: 96/255, alpha: 1.0)
            cell.scoreLabel.textColor = UIColor(red: 0/255, green: 52/255, blue: 96/255, alpha: 1.0)
        }
        
        cell.rankLabel.font = UIFont(name: "Futura-CondensedMedium", size: 40.0)
        cell.nameLabel.font = UIFont(name: "Futura-CondensedMedium", size: 40.0)
        cell.scoreLabel.font = UIFont(name: "Futura-CondensedMedium", size: 40.0)
        
        cell.rankLabel.textAlignment = .center
        cell.nameLabel.textAlignment = .center
        cell.scoreLabel.textAlignment = .center
        
        cell.rankLabel.font = cell.fontToFitHeight(label: cell.rankLabel)
        cell.nameLabel.font = cell.fontToFitHeight(label: cell.nameLabel)
        cell.scoreLabel.font = cell.fontToFitHeight(label: cell.scoreLabel)
        
        cell.rankLabel.adjustsFontSizeToFitWidth = true
        cell.nameLabel.adjustsFontSizeToFitWidth = true
        cell.scoreLabel.adjustsFontSizeToFitWidth = true

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView.tag == 0 {
            return (leadersScrollView.frame.height * 0.8) / CGFloat(highScoreLeaders.count)
        } else if tableView.tag == 1 {
            return (leadersScrollView.frame.height * 0.8) / CGFloat(averageScoreLeaders.count)
        } else if tableView.tag == 2 {
            return (leadersScrollView.frame.height * 0.8) / CGFloat(gamesPlayedLeaders.count)
        }
        
        return (leadersScrollView.frame.height * 0.8) / CGFloat(10)
    }
    
    func emptyCheck(cell: LeaderboardsTableCell, leader: Leader) -> LeaderboardsTableCell {
        if leader.rank == -1 {
            cell.rankView.alpha = 0.0
            cell.nameView.alpha = 0.0
            cell.scoreView.alpha = 0.0
        }
        
        return cell
    }
}
