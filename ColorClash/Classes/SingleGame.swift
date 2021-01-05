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
    var score: Int
    
    init(authID: String, boardSize: Int, gameType: String, score: Int) {
        self.authID = authID
        self.boardSize = boardSize
        self.gameType = gameType
        self.score = score
    }
}
