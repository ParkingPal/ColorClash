//
//  Profile_ViewController.swift
//  ColorClash
//
//  Created by ParkingPal on 12/8/20.
//

import UIKit
import Firebase

class Profile_ViewController: UIViewController {

    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var signOutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Josefin Sans", size: 30.0)!, NSAttributedString.Key.foregroundColor: UIColor(red: 176/255, green: 224/255, blue: 230/255, alpha: 1.0)]
        signOutButton.imageView?.contentMode = .scaleAspectFit
        settingsButton.imageView?.contentMode = .scaleAspectFit
        nameLabel.text = UserDocument.docData["name"] as? String
        nameLabel.numberOfLines = 2
        nameLabel.font = UIFont(name: "Josefin Sans", size: 50.0)
        nameLabel.adjustsFontSizeToFitWidth = true
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
