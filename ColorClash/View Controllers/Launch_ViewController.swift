//
//  LaunchViewController.swift
//  ColorClash
//
//  Created by ParkingPal on 12/3/20.
//

import UIKit
import Firebase

class Launch_ViewController: UIViewController {

    @IBOutlet weak var tmpLogo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func userSignedIn() -> Bool {
        if Auth.auth().currentUser == nil {
            return false
        } else {
            return true
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: {self.animate()})
    }
    
    func animate() {
        UIView.animate(withDuration: 0.5) {
            self.tmpLogo.transform = CGAffineTransform(scaleX: 10.0, y: 10.0)
            self.tmpLogo.alpha = 0.0
        } completion: { (done) in
            if done {
                if self.userSignedIn() {
                    self.performSegue(withIdentifier: "toLoading", sender: self)
                } else {
                    self.performSegue(withIdentifier: "toLogin", sender: self)
                }
                
            }
        }

    }

}
