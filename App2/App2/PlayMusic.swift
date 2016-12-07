//
//  PlayMusic.swift
//  App2
//
//  Created by Admin on 12/4/16.
//  Copyright © 2016 Techkids. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit
import MediaPlayer

class PlayMusic {
    static let shared = PlayMusic()
    
    var player = AVPlayer()
    var playerItem: AVPlayerItem!
    
    func playLink(url: String) {
        
        self.initRemoteControl()
        
        playerItem = AVPlayerItem(url: URL(string: url)!)
        player = AVPlayer(playerItem: playerItem)
        player.rate = 1.0
        player.play()
        
    }
    
    func initRemoteControl() {
        UIApplication.shared.beginReceivingRemoteControlEvents()
        //self.becomeFirstResponder()
        
        do  {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            print("AVAudioSession Category Playback OK")
            do {
                try AVAudioSession.sharedInstance().setActive(true)
                print("AVAudioSession is Active")
            } catch {
                print(error.localizedDescription)
            }
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    
}
