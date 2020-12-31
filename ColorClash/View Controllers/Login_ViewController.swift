//
//  Login_ViewController.swift
//  ColorClash
//
//  Created by ParkingPal on 12/10/20.
//

import UIKit
import Firebase
import AuthenticationServices
import CryptoKit

class Login_ViewController: UIViewController, ASAuthorizationControllerPresentationContextProviding {
    
    @IBOutlet weak var signInView: UIView!
    
    fileprivate var currentNonce: String?
    let delegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSignInButton()
        // Do any additional setup after loading the view.
    }
    
    enum AppleNameError: Error {
        case nilName
    }
    
    func setupSignInButton() {
        let signInButton = ASAuthorizationAppleIDButton()
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        
        signInButton.addTarget(self, action: #selector(startSignInWithAppleFlow), for: .touchUpInside)
        signInView.addSubview(signInButton)
        
        NSLayoutConstraint.activate([
            signInButton.centerYAnchor.constraint(equalTo: signInView.centerYAnchor),
            signInButton.leadingAnchor.constraint(equalTo: signInView.leadingAnchor),
            signInButton.trailingAnchor.constraint(equalTo: signInView.trailingAnchor),
            signInButton.topAnchor.constraint(equalTo: signInView.topAnchor),
            signInButton.bottomAnchor.constraint(equalTo: signInView.bottomAnchor)
        ])
    }
    
    @objc @available(iOS 13, *)
    func startSignInWithAppleFlow() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    // Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    func getName(appleIDCredential: ASAuthorizationAppleIDCredential) throws -> (String, String, String) {
        let firstName: String
        let lastName: String
        let fullName: String
        
        if appleIDCredential.fullName?.givenName == nil {
            throw AppleNameError.nilName
        } else {
            firstName = appleIDCredential.fullName?.givenName ?? "No First Name"
            lastName = appleIDCredential.fullName?.familyName ?? "No Last Name"
        }
        
        let capFirstName = firstName.capitalizingFirstLetter()
        let capLastName = lastName.capitalizingFirstLetter()
        
        fullName = "\(capFirstName) \(capLastName)"
        
        return (firstName, lastName, fullName)
    }
    
    func startLoginSequence(name: String) {
        handleUserFirebase(name: name)
        //need to add handle token at a later date
        _ = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(loginTransition), userInfo: nil, repeats: false)
    }
    
    func handleUserFirebase(name: String) {
        Firestore.firestore().collection("Users").whereField("authID", isEqualTo: Auth.auth().currentUser!.uid).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting User Documents: \(error)")
            } else {
                var documentCount: Int = 0
                
                for _ in querySnapshot!.documents {
                    documentCount = querySnapshot!.documents.count
                }
                
                if documentCount == 0 {
                    var data: [String: Any]
                    
                    data = [
                        "name": name,
                        "email": Auth.auth().currentUser!.email ?? "Email Not Provided",
                        "authID": Auth.auth().currentUser!.uid,
                        "lastLogin": FieldValue.serverTimestamp()
                    ]
                    
                    Firestore.firestore().collection("Users").document("\(Auth.auth().currentUser!.uid)").setData(data)
                    { error in
                        if let error = error {
                            print("Error writing User Document: \(error)")
                        } else {
                            print("User Document successfully written!")
                        }
                    }
                } else {
                    Firestore.firestore().collection("Users").document("\(Auth.auth().currentUser!.uid)").setData(["lastLogin": FieldValue.serverTimestamp()], merge: true)
                }
            }
        }
    }
    
    @objc func loginTransition() {
        self.performSegue(withIdentifier: "toLoading", sender: self)
    }
    
    @IBAction func unwindToLogin(segue: UIStoryboardSegue) {}
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

@available(iOS 13.0, *)
extension Login_ViewController: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            // Initialize a Firebase credential.
            let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                      idToken: idTokenString,
                                                      rawNonce: nonce)
            var name = "No Name Given"
            
            do {
                try name = getName(appleIDCredential: appleIDCredential).2
            } catch {
                print("No Apple Name")
            }
            
            // Sign in with Firebase.
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if (error != nil) {
                    // Error. If error.code == .MissingOrInvalidNonce, make sure
                    // you're sending the SHA256-hashed nonce as a hex string with
                    // your request to Apple.
                    print(error!.localizedDescription)
                    return
                }
                // User is signed in to Firebase with Apple.
                // ...
                self.startLoginSequence(name: name)
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print("Sign in with Apple errored: \(error)")
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
