//
//  Profile_ViewController.swift
//  ColorClash
//
//  Created by ParkingPal on 12/8/20.
//

import UIKit
import Firebase

class Profile_ViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var statsHeaderLabel: CustomLabel!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var settingsButton: CustomButton!
    @IBOutlet weak var signOutButton: CustomButton!
    @IBOutlet weak var customizeButton: CustomButton!
    @IBOutlet weak var classicLabel: CustomLabel!
    @IBOutlet weak var arcadeLabel: CustomLabel!
    @IBOutlet weak var hardcoreLabel: CustomLabel!
    @IBOutlet weak var statsScrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var classicView: UIView!
    @IBOutlet weak var arcadeView: UIView!
    @IBOutlet weak var hardcoreView: UIView!
    
    var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
    var gameTypes: Int = 3
    var statsNum: Int = 3
    let headings = ["High Score", "Average Score", "Games Played"]
    var classicStats = ["", "", ""]
    var arcadeStats = ["", "", ""]
    var hardcoreStats = ["", "", ""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Josefin Sans", size: 30.0)!, NSAttributedString.Key.foregroundColor: UIColor(red: 176/255, green: 224/255, blue: 230/255, alpha: 1.0)]
        self.navigationItem.title = UserDocument.docData["name"] as? String
        setupButtons()
        //setupScrollView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupScrollView()
        UIView.animate(withDuration: 0.5) {
            self.statsScrollView.alpha = 1.0
        }
    }
    
    func setupButtons() {
        let buttonWidth = customizeButton.frame.width
        let buttonHeight = customizeButton.frame.height
        customizeButton.setupButton(font: "Vollkorn", size: 20.0, horizontalInsets: buttonWidth/4, verticalInsets: buttonHeight/4, shadowOpacity: 0.3, shadowRadius: 5.0, shadowColor: 0.0)
        customizeButton.isEnabled = false
        customizeButton.alpha = 0.5
        settingsButton.setupButton(font: "Vollkorn", size: 20.0, horizontalInsets: buttonWidth/4, verticalInsets: buttonHeight/4, shadowOpacity: 0.3, shadowRadius: 5.0, shadowColor: 0.0)
        settingsButton.isEnabled = false
        settingsButton.alpha = 0.5
        signOutButton.setupButton(font: "Vollkorn", size: 20.0, horizontalInsets: buttonWidth/4, verticalInsets: buttonHeight/4, shadowOpacity: 0.3, shadowRadius: 5.0, shadowColor: 0.0)
        signOutButton.addTarget(self, action: #selector(signOutButtonClicked), for: .touchUpInside)
    }
    
    @objc func signOutButtonClicked() {
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
        
        performSegue(withIdentifier: "toLogin", sender: self)
    }
    
    func setupScrollView() {
        let classicTableView = UITableView(frame: frame)
        classicTableView.tag = 0
        let arcadeTableView = UITableView(frame: frame)
        arcadeTableView.tag = 1
        let hardcoreTableView = UITableView(frame: frame)
        hardcoreTableView.tag = 2
        statsHeaderLabel.setupLabel(font: "aArang", size: 100.0, shadowOpacity: 0.3, shadowRadius: 5.0, shadowColor: 255.0)
        classicLabel.setupLabel(font: "aArang", size: 20.0, shadowOpacity: 0.3, shadowRadius: 5.0, shadowColor: 255.0)
        arcadeLabel.setupLabel(font: "aArang", size: 20.0, shadowOpacity: 0.3, shadowRadius: 5.0, shadowColor: 255.0)
        hardcoreLabel.setupLabel(font: "aArang", size: 20.0, shadowOpacity: 0.3, shadowRadius: 5.0, shadowColor: 255.0)

        for index in 0 ..< gameTypes {
            frame.origin.x = statsScrollView.frame.width * CGFloat(index)
            frame.size = statsScrollView.frame.size
            
            let stackView = UIStackView(frame: frame)
            stackView.axis = .horizontal

            let headingTableView = UITableView(frame: frame)
            headingTableView.tag = 4
            setupTableView(tableView: headingTableView)
            stackView.addArrangedSubview(headingTableView)
            
            if index == 0 {
                setupTableView(tableView: classicTableView)
                stackView.addArrangedSubview(classicTableView)
                
                NSLayoutConstraint.activate([
                    headingTableView.widthAnchor.constraint(equalTo: classicTableView.widthAnchor, multiplier: 2.5)
                ])
            } else if index == 1 {
                setupTableView(tableView: arcadeTableView)
                stackView.addArrangedSubview(arcadeTableView)
                
                NSLayoutConstraint.activate([
                    headingTableView.widthAnchor.constraint(equalTo: arcadeTableView.widthAnchor, multiplier: 2.5)
                ])
            } else if index == 2 {
                setupTableView(tableView: hardcoreTableView)
                stackView.addArrangedSubview(hardcoreTableView)
                
                NSLayoutConstraint.activate([
                    headingTableView.widthAnchor.constraint(equalTo: hardcoreTableView.widthAnchor, multiplier: 2.5)
                ])
            }
            
            
            
            for row in 0 ..< statsNum {
                switch index {
                case 0:
                    if row == 0 {
                        classicStats[row] = String(SingleGameScoresDocument.docData["classicHS"] as! Int)
                    } else if row == 1 {
                        classicStats[row] = String(((SingleGameScoresDocument.docData["classicAS"] as! Double) * 10).rounded() / 10)
                    } else if row == 2 {
                        classicStats[row] = String(SingleGameScoresDocument.docData["classicGP"] as! Int)
                    }
                case 1:
                    if row == 0 {
                        arcadeStats[row] = String(SingleGameScoresDocument.docData["arcadeHS"] as! Int)
                    } else if row == 1 {
                        arcadeStats[row] = String(((SingleGameScoresDocument.docData["arcadeAS"] as! Double) * 10).rounded() / 10)
                    } else if row == 2 {
                        arcadeStats[row] = String(SingleGameScoresDocument.docData["arcadeGP"] as! Int)
                    }
                case 2:
                    if row == 0 {
                        hardcoreStats[row] = String(SingleGameScoresDocument.docData["hardcoreHS"] as! Int)
                    } else if row == 1 {
                        hardcoreStats[row] = String(((SingleGameScoresDocument.docData["hardcoreAS"] as! Double) * 10).rounded() / 10)
                    } else if row == 2 {
                        hardcoreStats[row] = String(SingleGameScoresDocument.docData["hardcoreGP"] as! Int)
                    }
                default:
                    break
                }
            }
            self.statsScrollView.addSubview(stackView)
        }
        
        statsScrollView.contentSize = CGSize(width: (statsScrollView.frame.size.width * CGFloat(gameTypes)), height: 1.0)
        statsScrollView.delegate = self
    }
    
    func setupTableView(tableView: UITableView) {
        tableView.register(CustomTableCell.self, forCellReuseIdentifier: "CustomTableCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = false
        tableView.isScrollEnabled = false
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width
        pageControl.currentPage = Int(pageNumber)
        let backgroundColor = UIColor(red: 0/255, green: 52/255, blue: 96/255, alpha: 1.0)
        
        switch pageNumber {
        case 0:
            animateLabelTransition(classicColor: backgroundColor, arcadeColor: .clear, hardcoreColor: .clear)
        case 1:
            animateLabelTransition(classicColor: .clear, arcadeColor: backgroundColor, hardcoreColor: .clear)
        case 2:
            animateLabelTransition(classicColor: .clear, arcadeColor: .clear, hardcoreColor: backgroundColor)
        default:
            break
        }
    }
    
    func animateLabelTransition(classicColor: UIColor, arcadeColor: UIColor, hardcoreColor: UIColor) {
        self.classicView.backgroundColor = classicColor
        self.arcadeView.backgroundColor = arcadeColor
        self.hardcoreView.backgroundColor = hardcoreColor
    }
}

extension Profile_ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statsNum
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableCell", for: indexPath as IndexPath) as! CustomTableCell
        
        if tableView.tag == 0 {
            cell.textLabel!.text = "\(classicStats[indexPath.row])"
        } else if tableView.tag == 1 {
            cell.textLabel!.text = "\(arcadeStats[indexPath.row])"
        } else if tableView.tag == 2 {
            cell.textLabel!.text = "\(hardcoreStats[indexPath.row])"
        } else {
            cell.textLabel!.text = "\(headings[indexPath.row])"
        }
        
        if indexPath.row == 0 || indexPath.row == 2 {
            cell.contentView.backgroundColor = UIColor(red: 0/255, green: 52/255, blue: 96/255, alpha: 1.0)
        } else if indexPath.row == 1 {
            cell.contentView.backgroundColor = UIColor(red: 176/255, green: 224/255, blue: 230/255, alpha: 1.0)
        }
        
        cell.textLabel!.font = UIFont(name: "Futura-CondensedMedium", size: 40.0)
        cell.textLabel!.textAlignment = .center
        cell.textLabel!.font = cell.fontToFitHeight()
        cell.textLabel!.adjustsFontSizeToFitWidth = true
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return statsScrollView.frame.height / CGFloat(statsNum)
    }
}
