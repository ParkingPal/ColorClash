//
//  SingleGame_ViewController.swift
//  ColorClash
//
//  Created by ParkingPal on 12/5/20.
//

import UIKit

class SingleGame_ViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var singleGameTitleLabel: UILabel!
    @IBOutlet weak var quickStatsTitleLabel: UILabel!
    @IBOutlet weak var classicButton: UIButton!
    @IBOutlet weak var arcadeButton: UIButton!
    @IBOutlet weak var statsScrollView: UIScrollView!
    @IBOutlet weak var statsPageControl: UIPageControl!
    
    var headers: [String] = ["High Score", "Average Score", "Games Played"]
    var scores: [Double] = [64, 22.3, 10]
    var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        // Do any additional setup after loading the view.
    }
    
    func setupLayout() {
        singleGameTitleLabel.font = UIFont(name: "Arang", size: 100.0)
        singleGameTitleLabel.adjustsFontSizeToFitWidth = true
        quickStatsTitleLabel.font = UIFont(name: "Arang", size: 100.0)
        quickStatsTitleLabel.adjustsFontSizeToFitWidth =  true
        
        classicButton.titleLabel?.font = UIFont(name: "Arang", size: 75.0)
        classicButton.titleLabel?.adjustsFontSizeToFitWidth = true
        arcadeButton.titleLabel?.font = UIFont(name: "Arang", size: 75.0)
        arcadeButton.titleLabel?.adjustsFontSizeToFitWidth = true
        
        classicButton.addTarget(self, action: #selector(classicButtonClicked), for: .touchUpInside)
        
        setupScrollView()
    }
    
    func setupScrollView() {
        for index in 0 ..< headers.count {
            frame.origin.x = statsScrollView.frame.width * CGFloat(index)
            frame.size = statsScrollView.frame.size
            
            let stack = UIStackView(frame: frame)
            let header = UILabel(frame: frame)
            let score = UILabel(frame: frame)
            
            let isInteger = floor(scores[index]) == scores[index]
            if isInteger {
                score.text = String(Int(scores[index]))
            } else {
                score.text = String(scores[index])
            }
            
            header.text = headers[index]
            header.font = UIFont(name: "Arang", size: 20.0)
            score.font = UIFont(name: "Arang", size: 40.0)
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
