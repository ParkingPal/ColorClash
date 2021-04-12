//
//  Store_ViewController.swift
//  ColorClash
//
//  Created by ParkingPal on 12/8/20.
//

import UIKit
import StoreKit
import Firebase

class Store_ViewController: UIViewController, SKPaymentTransactionObserver {

    @IBOutlet weak var adsButton: UIButton!
    @IBOutlet weak var boardButton: UIButton!
    @IBOutlet weak var comboButton: UIButton!
    
    let removeAdsID = "com.parkingpal.ColorClashGame.RemoveAds"
    let bigBoardID = "com.parkingpal.ColorClashGame.BigBoard"
    let comboDealID = "com.parkingpal.ColorClashGame.PackageDeal"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SKPaymentQueue.default().add(self)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Josefin Sans", size: 30.0)!, NSAttributedString.Key.foregroundColor: UIColor(red: 176/255, green: 224/255, blue: 230/255, alpha: 1.0)]
        setupButtons()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if UserDocument.docData["customTableUnlocked"] as! Bool == true {
            boardButton.isEnabled = false
            boardButton.alpha = 0.5
            comboButton.isEnabled = false
            comboButton.alpha = 0.5
        }
        
        if UserDocument.docData["adsRemoved"] as! Bool == true {
            adsButton.isEnabled = false
            adsButton.alpha = 0.5
            comboButton.isEnabled = false
            comboButton.alpha = 0.5
        }
    }
    
    func setupButtons() {
        adsButton.titleLabel?.font = UIFont(name: "Josefin Sans", size: 25.0)
        adsButton.titleLabel?.numberOfLines = 0
        adsButton.titleLabel?.textAlignment = .center
        adsButton.addTarget(self, action: #selector(buyRemoveAds), for: .touchUpInside)
        boardButton.titleLabel?.font = UIFont(name: "Josefin Sans", size: 25.0)
        boardButton.titleLabel?.numberOfLines = 0
        boardButton.titleLabel?.textAlignment = .center
        boardButton.addTarget(self, action: #selector(buyBigBoard), for: .touchUpInside)
        comboButton.titleLabel?.font = UIFont(name: "Josefin Sans", size: 25.0)
        comboButton.titleLabel?.numberOfLines = 0
        comboButton.titleLabel?.textAlignment = .center
        comboButton.addTarget(self, action: #selector(buyComboDeal), for: .touchUpInside)
    }
    
    
    
    // MARK: - In-App Purchase Methods
    
    @objc func buyRemoveAds() {
        if SKPaymentQueue.canMakePayments() {
            let paymentRequest = SKMutablePayment()
            paymentRequest.productIdentifier = removeAdsID
            SKPaymentQueue.default().add(paymentRequest)
            
        } else {
            print("User can't make payments")
        }
    }
    
    @objc func buyBigBoard() {
        if SKPaymentQueue.canMakePayments() {
            let paymentRequest = SKMutablePayment()
            paymentRequest.productIdentifier = bigBoardID
            SKPaymentQueue.default().add(paymentRequest)
            
        } else {
            print("User can't make payments")
        }
    }
    
    @objc func buyComboDeal() {
        if SKPaymentQueue.canMakePayments() {
            let paymentRequest = SKMutablePayment()
            paymentRequest.productIdentifier = comboDealID
            SKPaymentQueue.default().add(paymentRequest)
            
        } else {
            print("User can't make payments")
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transaction in transactions {
            if transaction.transactionState == .purchased {
                //User payment successful
                if transaction.payment.productIdentifier == removeAdsID {
                    Firestore.firestore().collection("Users").document("\(Auth.auth().currentUser!.uid)").setData(["adsRemoved": true], merge: true)
                    UserDocument.docData["adsRemoved"] = true
                    UserDefaults.standard.set(true, forKey: removeAdsID)
                } else if transaction.payment.productIdentifier == bigBoardID {
                    Firestore.firestore().collection("Users").document("\(Auth.auth().currentUser!.uid)").setData(["customTableUnlocked": true], merge: true)
                    UserDocument.docData["customTableUnlocked"] = true
                    UserDefaults.standard.set(true, forKey: bigBoardID)
                } else if transaction.payment.productIdentifier == comboDealID {
                    Firestore.firestore().collection("Users").document("\(Auth.auth().currentUser!.uid)").setData(["adsRemoved": true, "customTableUnlocked": true], merge: true)
                    UserDocument.docData["adsRemoved"] = true
                    UserDocument.docData["customTableUnlocked"] = true
                    UserDefaults.standard.set(true, forKey: removeAdsID)
                    UserDefaults.standard.set(true, forKey: bigBoardID)
                }
                SKPaymentQueue.default().finishTransaction(transaction)
                performSegue(withIdentifier: "unwindToSingleGame", sender: self)
                print("Transaction successful")
            } else if transaction.transactionState == .failed {
                //User payment failed
                
                if let error = transaction.error {
                    let errorDescription = error.localizedDescription
                    print("Transaction failed due to error: \(errorDescription)")
                }
                
                SKPaymentQueue.default().finishTransaction(transaction)
                print("Transaction failed")
            } else if transaction.transactionState == .restored {
                if transaction.payment.productIdentifier == removeAdsID {
                    Firestore.firestore().collection("Users").document("\(Auth.auth().currentUser!.uid)").setData(["adsRemoved": true], merge: true)
                    UserDocument.docData["adsRemoved"] = true
                    UserDefaults.standard.set(true, forKey: removeAdsID)
                } else if transaction.payment.productIdentifier == bigBoardID {
                    Firestore.firestore().collection("Users").document("\(Auth.auth().currentUser!.uid)").setData(["customTableUnlocked": true], merge: true)
                    UserDocument.docData["customTableUnlocked"] = true
                    UserDefaults.standard.set(true, forKey: bigBoardID)
                } else if transaction.payment.productIdentifier == comboDealID {
                    Firestore.firestore().collection("Users").document("\(Auth.auth().currentUser!.uid)").setData(["adsRemoved": true, "customTableUnlocked": true], merge: true)
                    UserDocument.docData["adsRemoved"] = true
                    UserDocument.docData["customTableUnlocked"] = true
                    UserDefaults.standard.set(true, forKey: removeAdsID)
                    UserDefaults.standard.set(true, forKey: bigBoardID)
                }
                
                navigationItem.setRightBarButton(nil, animated: true)
                performSegue(withIdentifier: "unwindToSingleGame", sender: self)
                SKPaymentQueue.default().finishTransaction(transaction)
                print("Transaction restored")
            }
        }
    }
    
    @IBAction func restoreButtonClicked(_ sender: UIBarButtonItem) {
        SKPaymentQueue.default().restoreCompletedTransactions()
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
