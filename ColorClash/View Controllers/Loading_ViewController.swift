//
//  Loading_ViewController.swift
//  ColorClash
//
//  Created by ParkingPal on 12/30/20.
//

import UIKit
import Firebase

class Loading_ViewController: UIViewController {
    
    var timer = Timer()

    override func viewDidLoad() {
        super.viewDidLoad()
        createUserDocument()
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(checkCompletion), userInfo: nil, repeats: true)

        // Do any additional setup after loading the view.
    }
    
    func createUserDocument() {
        if !UserDocument.isInitialized {
            let db = Firestore.firestore()
            
            db.collection("Users").whereField("authID", isEqualTo: Auth.auth().currentUser!.uid)
                .getDocuments { (querySnapshot, error) in
                    if let error = error {
                        print("Error getting documents: \(error)")
                    } else {
                        for document in querySnapshot!.documents {
                            let documentCount = (querySnapshot?.documents.count)!
                            if documentCount == 1 {
                                UserDocument.create(docSnap: document)
                        }
                    }
                }
            }
        }
    }
    
    @objc func checkCompletion() {
        if UserDocument.isInitialized {
            self.performSegue(withIdentifier: "toGame", sender: self)
            timer.invalidate()
        } else {
            print("User not yet initialized")
        }
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
