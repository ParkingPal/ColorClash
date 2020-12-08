//
//  SingleGame_ViewController.swift
//  ColorClash
//
//  Created by ParkingPal on 12/5/20.
//

import UIKit

class SingleGame_ViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var singleGameTitleLabel: CustomLabel!
    @IBOutlet weak var quickStatsTitleLabel: CustomLabel!
    @IBOutlet weak var classicButton: CustomButton!
    @IBOutlet weak var arcadeButton: CustomButton!
    @IBOutlet weak var hardcoreButton: CustomButton!
    @IBOutlet weak var statsScrollView: UIScrollView!
    @IBOutlet weak var statsPageControl: UIPageControl!
    @IBOutlet weak var quickStatsView: UIView!
    
    var headers: [String] = ["High Score", "Average Score", "Games Played"]
    var scores: [Double] = [64, 22.3, 10]
    var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupScrollView()
    }
    
    func setupLayout() {
        quickStatsView.alpha = 0.0
        singleGameTitleLabel.setupLabel(font: "Arang", size: 100.0, shadowOpacity: 0.3, shadowRadius: 5.0, shadowColor: 0.0)
        quickStatsTitleLabel.setupLabel(font: "Arang", size: 100.0, shadowOpacity: 0.3, shadowRadius: 5.0, shadowColor: 255.0)
        
        classicButton.titleLabel?.font = UIFont(name: "DelicateSansBold", size: 75.0)
        classicButton.titleLabel?.adjustsFontSizeToFitWidth = true
        classicButton.titleEdgeInsets = UIEdgeInsets(top: 100.0, left: 100.0, bottom: 100.0, right: 100.0)
        arcadeButton.titleLabel?.font = UIFont(name: "Abingdon", size: 75.0)
        arcadeButton.titleLabel?.adjustsFontSizeToFitWidth = true
        arcadeButton.titleEdgeInsets = UIEdgeInsets(top: 100.0, left: 100.0, bottom: 100.0, right: 100.0)
        hardcoreButton.titleLabel?.font = UIFont(name: "TheBattleContinuez", size: 75.0)
        hardcoreButton.titleLabel?.adjustsFontSizeToFitWidth = true
        hardcoreButton.titleEdgeInsets = UIEdgeInsets(top: 100.0, left: 100.0, bottom: 100.0, right: 100.0)
        
        classicButton.addTarget(self, action: #selector(classicButtonClicked), for: .touchUpInside)
    }
    
    func setupScrollView() {
        for index in 0 ..< headers.count {
            frame.origin.x = statsScrollView.frame.width * CGFloat(index)
            frame.size = statsScrollView.frame.size
            
            let stack = UIStackView(frame: frame)
            let header = CustomLabel(frame: frame)
            let score = CustomLabel(frame: frame)
            
            let isInteger = floor(scores[index]) == scores[index]
            if isInteger {
                score.text = String(Int(scores[index]))
            } else {
                score.text = String(scores[index])
            }
            
            header.text = headers[index]
            header.setupLabel(font: "Arang", size: 20.0, shadowOpacity: 0.3, shadowRadius: 3.0, shadowColor: 255.0)
            header.textColor = UIColor(red: 0/255, green: 52/255, blue: 96/255, alpha: 1.0)
            score.setupLabel(font: "Arang", size: 60.0, shadowOpacity: 0.3, shadowRadius: 5.0, shadowColor: 255.0)
            score.textColor = UIColor(red: 0/255, green: 52/255, blue: 96/255, alpha: 1.0)
            header.textAlignment = .center
            score.textAlignment = .center
            
            stack.axis = .vertical
            stack.distribution = .fill
            stack.addArrangedSubview(header)
            stack.addArrangedSubview(score)
            
            score.heightAnchor.constraint(equalTo: header.heightAnchor, multiplier: 2.0).isActive = true
            
            self.statsScrollView.addSubview(stack)
        }
        
        statsScrollView.contentSize = CGSize(width: (statsScrollView.frame.size.width * CGFloat(headers.count)), height: 1.0)
        statsScrollView.delegate = self
        
        UIView.animate(withDuration: 0.5) {
            self.quickStatsView.alpha = 1.0
        }
    }
    
    @objc func classicButtonClicked() {
        performSegue(withIdentifier: "toPlayClassic", sender: self)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width
        statsPageControl.currentPage = Int(pageNumber)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
