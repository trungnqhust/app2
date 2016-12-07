//
//  PlayBar2.swift
//  App2
//
//  Created by Admin on 12/7/16.
//  Copyright © 2016 Techkids. All rights reserved.
//

import UIKit
import MediaPlayer

class PlayBar2: UIView {


    static var playBar2 : PlayBar2!
    
    static func shared() -> PlayBar2 {
        if playBar2 == nil {
            playBar2 = Bundle.main.loadNibNamed("PlayBar2", owner: self, options: nil)?.first as! PlayBar2
            return playBar2
        }   else    {
            return playBar2
        }
    }
    
    @IBOutlet weak var playProgress: UIProgressView!

    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var remainTimeLabel: UILabel!
    @IBOutlet weak var repeatButton: UIButton!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var playButton: UIButton!

    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var shuffleButton: UIButton!
    
    static func updateProgress() {
        PlayMusic.shared.player.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1/30, Int32(NSEC_PER_SEC)), queue: nil) { (time) in
            let duration = CMTimeGetSeconds(PlayMusic.shared.playerItem.duration)
            self.shared().playProgress.progress = Float(CMTimeGetSeconds(time)/duration)
            //                print("tim = \(time) , duration = \(duration)")
        }
    }
    
    
    @IBAction func clickPlayPause(_ sender: AnyObject) {
        if PlayMusic.shared.player.rate == 0 {
            PlayMusic.shared.player.play()
            self.playButton.imageView?.image = UIImage(named: "img-player-pause")
        }   else{
            PlayMusic.shared.player.pause()
            self.playButton.imageView?.image = UIImage(named: "img-player-play")
        }
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
}
