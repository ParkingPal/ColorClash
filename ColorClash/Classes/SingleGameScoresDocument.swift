//
//  SingleGameScoresDocument.swift
//  ColorClash
//
//  Created by ParkingPal on 1/4/21.
//

import Foundation
import Firebase

class SingleGameScoresDocument {
    static var docRef:Firebase.DocumentReference? = nil
    static var isInitialized:Bool = false
    static var docData:[String:Any] = [String:Any]()
    
    init() {}
    
    static func create(docSnap: Firebase.QueryDocumentSnapshot) {
        SingleGameScoresDocument.docRef = docSnap.reference
        SingleGameScoresDocument.docData = docSnap.data()
        SingleGameScoresDocument.isInitialized = true
    }
    
    static func destroy() {
        SingleGameScoresDocument.docRef = nil
        SingleGameScoresDocument.isInitialized = false
        SingleGameScoresDocument.docData = [String:Any]()
    }
}
