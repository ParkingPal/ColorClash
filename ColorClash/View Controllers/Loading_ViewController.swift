//
//  Loading_ViewController.swift
//  ColorClash
//
//  Created by ParkingPal on 12/30/20.
//

import UIKit
import Firebase

class Loading_ViewController: UIViewController {
    
    @IBOutlet weak var tmpLogo: UIImageView!
    @IBOutlet weak var loadingLabel: UILabel!
    var cycles = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingLabel.alpha = 0.0
        loadingLabel.font = UIFont(name: "Futura-CondensedMedium", size: 40.0)
        createUserDocument()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animate()
    }
    
    func animate() {
        cycles += 1
        
        UIView.animate(withDuration: 0.3) {
            self.tmpLogo.alpha = 1.0
        } completion: { (finished) in
            UIView.animate(withDuration: 0.3, delay: 0.3, animations: {
                self.tmpLogo.transform = CGAffineTransform.identity.scaledBy(x: 1.8, y: 1.8)
            }) { finished in
                UIView.animate(withDuration: 0.7, animations: {
                    self.tmpLogo.transform = CGAffineTransform.identity.scaledBy(x: 0.7, y: 0.7)
                }) { finished in
                    UIView.animate(withDuration: 0.5, animations: {
                        self.tmpLogo.transform = CGAffineTransform.identity
                    }) { finished in
                        if self.cycles >= 5 {
                            UIView.animate(withDuration: 0.3) {
                                self.loadingLabel.alpha = 1.0
                            }
                        }
                        if self.checkCompletion() {
                            UIView.animate(withDuration: 0.7) {
                                self.tmpLogo.alpha = 0.0
                            } completion: { (finished) in
                                self.performSegue(withIdentifier: "toGame", sender: self)
                                MusicPlayer.shared.startBackgroundMusic(vc: self)
                            }
                        } else {
                            self.animate()
                        }
                    }
                }
            }
        }
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
    
    func checkCompletion() -> Bool {
        if UserDocument.isInitialized {
            return true
        } else {
            return false
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
