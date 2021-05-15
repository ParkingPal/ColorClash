//
//  ContinueGameViewController.swift
//  ColorClash
//
//  Created by ParkingPal on 4/8/21.
//

import UIKit
import Firebase
import GoogleMobileAds

class ContinueGameViewController: UIViewController {

    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var popupView: UIView!
    
    var score = 0
    var adFailed = 0
    var interstitial: GADInterstitialAd?
    var fromDemo = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scoreLabel.text = String(score)
        continueButton.addTarget(self, action: #selector(continueButtonClicked), for: .touchUpInside)
        
        if interstitial != nil {
            self.interstitial?.fullScreenContentDelegate = self
        }
    }
    
    @objc func continueButtonClicked() {
        if fromDemo {
            if adFailed < 3 {
                if interstitial != nil {
                    interstitial?.present(fromRootViewController: self)
                } else {
                    adFailed += 1
                    print("Ad isn't ready")
                }
            } else if adFailed >= 3 {
                performSegue(withIdentifier: "unwindToLogin", sender: self)
            }
        } else {
            if UserDocument.docData["adsRemoved"] as! Bool == false {
                if adFailed < 3 {
                    if interstitial != nil {
                        interstitial?.present(fromRootViewController: self)
                    } else {
                        adFailed += 1
                        print("Ad isn't ready")
                    }
                } else if adFailed >= 3 {
                    performSegue(withIdentifier: "unwindToSingleGame", sender: self)
                }
            } else {
                performSegue(withIdentifier: "unwindToSingleGame", sender: self)
            }
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

extension ContinueGameViewController: GADFullScreenContentDelegate {
    /// Tells the delegate that the ad failed to present full screen content.
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Ad did fail to present full screen content.")
    }
    
    /// Tells the delegate that the ad presented full screen content.
    func adDidPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad did present full screen content.")
    }
    
    /// Tells the delegate that the ad dismissed full screen content.
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        //let name = Notification.Name(rawValue: fromContinueGameKey)
        //NotificationCenter.default.post(name: name, object: nil)
        if fromDemo {
            performSegue(withIdentifier: "unwindToLogin", sender: self)
        } else {
            performSegue(withIdentifier: "unwindToSingleGame", sender: self)
        }
        print("Ad did dismiss full screen content.")
    }
}
