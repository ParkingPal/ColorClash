//
//  MusicPlayer.swift
//  ColorClash
//
//  Created by ParkingPal on 12/1/20.
//

import Foundation
import UIKit
import AVFoundation

class MusicPlayer: NSObject, AVAudioPlayerDelegate {
    static let shared = MusicPlayer()
    var backgroundPlayer: AVAudioPlayer?
    var soundEffectPlayer: AVAudioPlayer?
    var regularVolume: Float = 0.03
    var soundEffectVolume: Float = 0.1
    var bundle1 = Bundle.main.url(forResource: "BackgroundMusic", withExtension: "mp3")
    var bundle2 = Bundle.main.url(forResource: "BackgroundMusic2", withExtension: "mp3")
    
    
    func startBackgroundMusic(vc: UIViewController) {
        
        /*let song1 = AVPlayerItem(asset: AVAsset(url: bundle1!))
        let song2 = AVPlayerItem(asset: AVAsset(url: bundle2!))
        
        let songs = [song1, song2]
        let player = AVQueuePlayer(items: songs)
        player.volume = regularVolume
        let playerLayer = AVPlayerLayer(player: player)
        vc.view.layer.addSublayer(playerLayer)
        player.play()*/
        
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
            soundEffectPlayer!.volume = soundEffectVolume
        } catch {
            print("error playing sound")
        }
    }
    
    func resetVolume() {
        backgroundPlayer!.volume = regularVolume
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if player == soundEffectPlayer {
            backgroundPlayer?.volume = regularVolume
        }
    }
}
