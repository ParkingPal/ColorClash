//
//  LaunchViewController.swift
//  ColorClash
//
//  Created by ParkingPal on 12/3/20.
//

import UIKit

class LaunchViewController: UIViewController {

    @IBOutlet weak var tmpLogo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func animate() {
        UIView.animate(withDuration: 0.5) {
            self.tmpLogo.transform = CGAffineTransform(scaleX: 10.0, y: 10.0)
            self.tmpLogo.alpha = 0.0
        } completion: { (done) in
            if done {
                //will use this probably similar to Trivia Ace where it will check to see if they are a new user or not. For now, will just continue to VC
            }
        }

    }

}