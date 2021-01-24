//
//  Levels_ViewController.swift
//  ColorClash
//
//  Created by ParkingPal on 12/8/20.
//

import UIKit
import Firebase

class Levels_ViewController: UIViewController {

    @IBOutlet weak var testButton: UIButton!
    let levelNumber = 1
    var turns = [Int]()
    var start = [[String: Int]]()
    var boardSize = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Josefin Sans", size: 30.0)!, NSAttributedString.Key.foregroundColor: UIColor(red: 176/255, green: 224/255, blue: 230/255, alpha: 1.0)]
        testButton.addTarget(self, action: #selector(testButtonClicked), for: .touchUpInside)
    }
    
    @objc func testButtonClicked() {
        fetchLevel()
    }
    
    func fetchLevel() {
        let group = DispatchGroup()
        
        group.enter()
        
        Firestore.firestore().collection("Levels").document("\(levelNumber)").getDocument { (document, error) in
            if let error = error {
                print("Error getting document: \(error)")
            } else {
                let docData = document!.data()
                self.turns = docData!["turns"] as! [Int]
                self.boardSize = docData!["boardSize"] as! Int
                self.start = docData!["start"] as! [[String: Int]]
                
                group.leave()
            }
        }
        
        group.notify(queue: DispatchQueue.main) {
            self.performSegue(withIdentifier: "toLevels", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toLevels" {
            let vc = segue.destination as! ViewController
            vc.board.gameType = "Test Level"
            vc.turns = self.turns
            vc.start = self.start
            vc.xMax = self.boardSize - 1
            vc.yMax = self.boardSize - 1
            vc.board = Board(xMax: self.boardSize - 1, yMax: self.boardSize - 1, gameType: "Test Level")
        }
    }
    

}
