//
//  MainMenu_Button.swift
//  ColorClash
//
//  Created by ParkingPal on 12/3/20.
//

import UIKit

class MainMenu_Button: UIButton {

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        titleLabel?.font = UIFont(name: "Arang", size: 100.0)
        titleLabel?.adjustsFontSizeToFitWidth = true
        titleEdgeInsets = UIEdgeInsets(top: 10.0, left: 30.0, bottom: 10.0, right: 30.0)
        //setTitleColor(UIColor(red: 233/255, green: 190/255, blue: 110/255, alpha: 1.0), for: .normal)
        //self.backgroundColor = UIColor(red: 252/255, green: 125/255, blue: 0/255, alpha: 1.0)
        //self.setBackgroundImage(UIImage(named: "MainMenuButton"), for: .normal)
        
        layer.masksToBounds = false
        layer.shadowColor = CGColor(srgbRed: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        layer.shadowRadius = 15.0
        
    }
    
    
}
