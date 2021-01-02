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
    @IBOutlet weak var settingsButton: CustomButton!
    @IBOutlet weak var signOutButton: CustomButton!
    @IBOutlet weak var customizeButton: CustomButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Josefin Sans", size: 30.0)!, NSAttributedString.Key.foregroundColor: UIColor(red: 176/255, green: 224/255, blue: 230/255, alpha: 1.0)]
        self.navigationItem.title = UserDocument.docData["name"] as? String
        setupButtons()
    }
    
    func setupButtons() {
        let buttonWidth = customizeButton.frame.width
        let buttonHeight = customizeButton.frame.height
        customizeButton.setupButton(font: "Vollkorn", size: 20.0, horizontalInsets: buttonWidth/4, verticalInsets: buttonHeight/4, shadowOpacity: 0.3, shadowRadius: 5.0, shadowColor: 0.0)
        settingsButton.setupButton(font: "Vollkorn", size: 20.0, horizontalInsets: buttonWidth/4, verticalInsets: buttonHeight/4, shadowOpacity: 0.3, shadowRadius: 5.0, shadowColor: 0.0)
        signOutButton.setupButton(font: "Vollkorn", size: 20.0, horizontalInsets: buttonWidth/4, verticalInsets: buttonHeight/4, shadowOpacity: 0.3, shadowRadius: 5.0, shadowColor: 0.0)
        //customizeButton.setupButton(font: "Josefin Sans", size: 40.0, insets: 120.0, shadowOpacity: 3.0, shadowRadius: 10.0, shadowColor: 0.0)
        //customizeButton.titleLabel?.setupLabel(font: "Josefin Sans", size: 40.0, shadowOpacity: 0.0, shadowRadius: 0.0, shadowColor: 0.0)
        //customizeButton.titleLabel?.sizeToFit()
        //signOutButton.imageView?.contentMode = .scaleAspectFit
        //settingsButton.imageView?.contentMode = .scaleAspectFit
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
