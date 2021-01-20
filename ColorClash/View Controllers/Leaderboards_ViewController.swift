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
    
    let statHeadings = ["High Score", "Average Score", "Games Played"]
    let test = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
    var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
    let listAmount = 10
    var number = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Josefin Sans", size: 30.0)!, NSAttributedString.Key.foregroundColor: UIColor(red: 176/255, green: 224/255, blue: 230/255, alpha: 1.0)]
        // Do any additional setup after loading the view.
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
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width
        pageControl.currentPage = Int(pageNumber)
    }
    
    @objc func classicButtonClicked(sender: CustomButton) {
        sender.tag = 0
        shadowAnimation(button: classicButton, opacity: 1.0)
        shadowAnimation(button: arcadeButton, opacity: 0.0)
        shadowAnimation(button: hardcoreButton, opacity: 0.0)
        fetchLeaderboard(tag: sender.tag)
    }
    
    @objc func arcadeButtonClicked(sender: CustomButton) {
        sender.tag = 1
        shadowAnimation(button: classicButton, opacity: 0.0)
        shadowAnimation(button: arcadeButton, opacity: 1.0)
        shadowAnimation(button: hardcoreButton, opacity: 0.0)
        fetchLeaderboard(tag: sender.tag)
    }
    
    @objc func hardcoreButtonClicked(sender: CustomButton) {
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
    
    func fetchLeaderboard(tag: Int) {
        var gameType = ""
        var queriedStats = [String]()
        var snapshots = [QuerySnapshot]()
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
        
        queriedStats.append("\(gameType)HS")
        queriedStats.append("\(gameType)AS")
        queriedStats.append("\(gameType)GP")
        
        group.enter() // Enter for High Score
        group.enter() // Enter for Average Score
        group.enter() // Enter for Games Played
        
        /// Query High Score
        Firestore.firestore().collection("SG_Scores").order(by: "\(gameType)HS", descending: true).limit(to: listAmount).getDocuments(completion: { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                snapshots.append(querySnapshot!)
                group.leave()
            }
        })
        
        /// Query Average Score
        Firestore.firestore().collection("SG_Scores").order(by: "\(gameType)AS", descending: true).limit(to: listAmount).getDocuments(completion: { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                snapshots.append(querySnapshot!)
                group.leave()
            }
        })
        
        /// Query Games Played
        Firestore.firestore().collection("SG_Scores").order(by: "\(gameType)GP", descending: true).limit(to: listAmount).getDocuments(completion: { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                snapshots.append(querySnapshot!)
                group.leave()
            }
        })
        
        group.notify(queue: DispatchQueue.main) {
            var index = 0
            
            for snapshot in snapshots {
                self.fillLeaderboard(querySnapshot: snapshot, stat: queriedStats[index])
                index += 1
            }
        }
    }
    
    func fillLeaderboard(querySnapshot: QuerySnapshot, stat: String) {
        let docCount = querySnapshot.documents.count
        var names = [String]()
        var stats = [String]()
        var numbers = [String]()
        
        if docCount > 0 {
            for num in 1...docCount {
                numbers.append(String(num))
            }
        }
        
        for document in querySnapshot.documents {
            let docData = document.data()
            let name = docData["userName"]
            var score = docData["\(stat)"]
            
            if stat.contains("AS") {
                score = round(score as! Double * 100) / 100
            }
            
            names.append("\(name ?? "No Name")")
            stats.append("\(score ?? "No Score")")
        }
        
        setupScrollView(numbers: numbers, names: names, stats: stats)
    }
    
    func setupScrollView(numbers: [String], names: [String], stats: [String]) {
        for index in 0 ..< statHeadings.count {
            frame.origin.x = leadersScrollView.frame.width * CGFloat(index)
            frame.size = leadersScrollView.frame.size
            
            let stackView = setupPageInScrollView(frame: frame, numbers: numbers, names: names, stats: stats)
            leadersScrollView.addSubview(stackView)
        }
        
        leadersScrollView.contentSize = CGSize(width: (leadersScrollView.frame.size.width * CGFloat(statHeadings.count)), height: 1.0)
        leadersScrollView.delegate = self
    }
    
    func setupPageInScrollView(frame: CGRect, numbers: [String], names: [String], stats: [String]) -> UIStackView {
        let stackView = UIStackView(frame: frame)
        let numbersTableView = UITableView(frame: frame)
        let namesTableView = UITableView(frame: frame)
        let statsTableView = UITableView(frame: frame)
        numbersTableView.tag = 0
        namesTableView.tag = 1
        statsTableView.tag = 2
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        setupTableView(tableView: numbersTableView)
        setupTableView(tableView: namesTableView)
        setupTableView(tableView: statsTableView)
        
        stackView.addArrangedSubview(numbersTableView)
        stackView.addArrangedSubview(namesTableView)
        stackView.addArrangedSubview(statsTableView)
        
        return stackView
    }
    
    func setupTableView(tableView: UITableView) {
        tableView.register(CustomTableCell.self, forCellReuseIdentifier: "CustomTableCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = false
        tableView.isScrollEnabled = false
    }
}

extension Leaderboards_ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listAmount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableCell", for: indexPath as IndexPath) as! CustomTableCell
        
        if indexPath.row == 0 || indexPath.row.isMultiple(of: 2) {
            cell.contentView.backgroundColor = UIColor(red: 0/255, green: 52/255, blue: 96/255, alpha: 1.0)
        } else {
            cell.contentView.backgroundColor = UIColor(red: 176/255, green: 224/255, blue: 230/255, alpha: 1.0)
        }
        
        if tableView.tag == 0 {
            
        } else if tableView.tag == 1 {
            
        } else if tableView.tag == 2 {
            
        }
        
        cell.textLabel!.text = test[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return leadersScrollView.frame.height / CGFloat(listAmount)
    }
}
