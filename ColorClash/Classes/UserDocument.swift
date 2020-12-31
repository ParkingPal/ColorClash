//
//  UserDocument.swift
//  ColorClash
//
//  Created by ParkingPal on 12/30/20.
//

import Foundation
import Firebase

class UserDocument {
    
    static var docRef:Firebase.DocumentReference? = nil
    static var isInitialized:Bool = false
    static var docData:[String:Any] = [String:Any]()
    
    init() {}
    
    static func create(docSnap: Firebase.QueryDocumentSnapshot) {
        let time = FieldValue.serverTimestamp()
        
        UserDocument.docRef = docSnap.reference
        UserDocument.docData = docSnap.data()
        UserDocument.docData["lastLogin"] = time
        docSnap.reference.setData(["lastLogin": time], merge: true)
        UserDocument.isInitialized = true
    }
    
    static func destroy() {
        UserDocument.docRef = nil
        UserDocument.isInitialized = false
        UserDocument.docData = [String:Any]()
    }
}
