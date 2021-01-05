//
//  SingleGame.swift
//  ColorClash
//
//  Created by ParkingPal on 1/4/21.
//

import Foundation
import Firebase

class SingleGame {
    
    var authID: String
    var boardSize: Int
    var gameType: String
    
    init(authID: String, boardSize: Int, gameType: String) {
        self.authID = authID
        self.boardSize = boardSize
        self.gameType = gameType
    }
    
    func gameOver(score: Int) {
        let totalGP = (SingleGameScoresDocument.docData["totalGP"] as! Int) + 1
        let typeGP = (SingleGameScoresDocument.docData["\(gameType)GP"] as! Int) + 1
        let tempHS = SingleGameScoresDocument.docData["\(gameType)HS"] as! Int
        let tempAS = SingleGameScoresDocument.docData["\(gameType)AS"] as! Double
        
        let typeHS = calculateHS(highScore: tempHS, score: score)
        let typeAS = calculateAS(gp: typeGP, avgScore: tempAS, score: score)
        
        writeStats(totalGP: totalGP, typeGP: typeGP, typeHS: typeHS, typeAS: typeAS)
    }
    
    private func calculateHS(highScore: Int, score: Int) -> Int {
        if highScore >= score {
            return highScore
        } else {
            return score
        }
    }
    
    private func calculateAS(gp: Int, avgScore: Double, score: Int) -> Double {
        let prevGP = gp - 1
        let totalScore = (Double(prevGP) * avgScore) + Double(score)
        let newAverageScore: Double = totalScore / Double(gp)
        
        return newAverageScore
    }
    
    private func writeStats(totalGP: Int, typeGP: Int, typeHS: Int, typeAS: Double) {
        let docRef = Firestore.firestore().collection("SG_Scores").document("\(Auth.auth().currentUser!.uid)")
        
        SingleGameScoresDocument.docData["totalGP"] = totalGP
        SingleGameScoresDocument.docData["\(gameType)GP"] = typeGP
        SingleGameScoresDocument.docData["\(gameType)HS"] = typeHS
        SingleGameScoresDocument.docData["\(gameType)AS"] = typeAS
        
        docRef.setData(["totalGP": totalGP, "\(gameType)GP": typeGP, "\(gameType)HS": typeHS, "\(gameType)AS": typeAS], merge: true)
    }
}
