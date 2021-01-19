//
//  Leaderboards_ViewController.swift
//  ColorClash
//
//  Created by ParkingPal on 12/8/20.
//

import UIKit

class Leaderboards_ViewController: UIViewController {

    @IBOutlet weak var classicButton: CustomButton!
    @IBOutlet weak var arcadeButton: CustomButton!
    @IBOutlet weak var hardcoreButton: CustomButton!
    
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
        classicButton.addTarget(self, action: #selector(classicButtonClicked), for: .touchUpInside)
        arcadeButton.setupButton(font: "Abingdon", size: 75.0, horizontalInsets: buttonWidth/6, verticalInsets: buttonHeight, shadowOpacity: 0.3, shadowRadius: 5.0, shadowColor: 0.0)
        arcadeButton.addTarget(self, action: #selector(arcadeButtonClicked), for: .touchUpInside)
        hardcoreButton.setupButton(font: "aAssassinNinja", size: 75.0, horizontalInsets: buttonWidth/6, verticalInsets: buttonHeight, shadowOpacity: 0.3, shadowRadius: 5.0, shadowColor: 0.0)
        hardcoreButton.addTarget(self, action: #selector(hardcoreButtonClicked), for: .touchUpInside)
        
        selectedShadow(button: classicButton, opacity: 0.0)
        selectedShadow(button: arcadeButton, opacity: 0.0)
        selectedShadow(button: hardcoreButton, opacity: 1.0)
        
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
    
    @objc func classicButtonClicked() {
        shadowAnimation(button: classicButton, opacity: 1.0)
        shadowAnimation(button: arcadeButton, opacity: 0.0)
        shadowAnimation(button: hardcoreButton, opacity: 0.0)
    }
    
    @objc func arcadeButtonClicked() {
        shadowAnimation(button: classicButton, opacity: 0.0)
        shadowAnimation(button: arcadeButton, opacity: 1.0)
        shadowAnimation(button: hardcoreButton, opacity: 0.0)
    }
    
    @objc func hardcoreButtonClicked() {
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
