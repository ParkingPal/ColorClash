//
//  MusicPlayer.swift
//  ColorClash
//
//  Created by ParkingPal on 12/1/20.
//

import Foundation
import AVFoundation

class MusicPlayer: NSObject, AVAudioPlayerDelegate {
    static let shared = MusicPlayer()
    var backgroundPlayer: AVAudioPlayer?
    var soundEffectPlayer: AVAudioPlayer?
    var regularVolume: Float = 0.1
    let songNames = ["BackgroundMusic", "BackgroundMusic2"]
    
    func startBackgroundMusic() {
        let bundle = Bundle.main.path(forResource: "BackgroundMusic", ofType: "mp3")
        let backgroundMusic = NSURL(fileURLWithPath: bundle!)
        do {
            backgroundPlayer = try AVAudioPlayer(contentsOf: backgroundMusic as URL)
            backgroundPlayer!.delegate = self
            backgroundPlayer!.numberOfLoops = -1
            backgroundPlayer!.prepareToPlay()
            backgroundPlayer!.play()
            backgroundPlayer!.volume = regularVolume
        } catch {
            print("cannot play file")
        }
    }
    
    func playSoundEffect(fileName: String, fileType: String) {
        
        
        let pathToSound = Bundle.main.path(forResource: "\(fileName)", ofType: "\(fileType)")!
        let url = URL(fileURLWithPath: pathToSound)
        
        /*if fileName == "Crowd_Cheering" {
            backgroundPlayer?.volume = regularVolume / 100
        }*/
        
        do {
            soundEffectPlayer = try AVAudioPlayer(contentsOf: url)
            soundEffectPlayer!.delegate = self
            soundEffectPlayer!.prepareToPlay()
            soundEffectPlayer!.play()
            soundEffectPlayer!.volume = regularVolume
        } catch {
            print("error playing sound")
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if player == soundEffectPlayer {
            backgroundPlayer?.volume = regularVolume
        }
    }
}
