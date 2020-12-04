//
//  MainMenu_ViewController.swift
//  ColorClash
//
//  Created by ParkingPal on 12/3/20.
//

import UIKit

class MainMenu_ViewController: UIViewController {

    @IBOutlet weak var singleGameButton: MainMenu_Button!
    @IBOutlet weak var levelsButton: MainMenu_Button!
    @IBOutlet weak var leaderboardsButton: MainMenu_Button!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        singleGameButton.addTarget(self, action: #selector(singleGameButtonClicked), for: .touchUpInside)

        // Do any additional setup after loading the view.
    }
    
    @objc func singleGameButtonClicked() {
        performSegue(withIdentifier: "toSingleGame", sender: self)
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
