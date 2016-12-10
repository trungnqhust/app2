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

    var repeatState = 0
    var shuffleState = 0
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        PlayBar2.updateProgress()
    }
    static func updateProgress() {
        
        PlayMusic.shared.player.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1/30, Int32(NSEC_PER_SEC)), queue: nil) { (time) in
            let duration = CMTimeGetSeconds(PlayMusic.shared.playerItem.duration)
            self.shared().playProgress.progress = Float(CMTimeGetSeconds(time)/duration)
            if duration.isNaN == false  {
                let durationInt =  Int(duration)
                var timeInt =  Int(CMTimeGetSeconds(time))
                timeInt = durationInt - timeInt
                self.shared().totalTimeLabel.text = "\(durationInt/60):\(durationInt % 60)"
                self.shared().remainTimeLabel.text = "-\(timeInt / 60):\(timeInt % 60)"
            }
          
        }
    }
    
    
    @IBAction func clickPlayPause(_ sender: AnyObject) {
        if PlayMusic.shared.player.rate == 0 {
            PlayMusic.shared.player.play()
            self.playButton.setImage(UIImage(named: "img-player-pause"), for: .normal)
        }   else{
            PlayMusic.shared.player.pause()
            self.playButton.setImage(UIImage(named: "img-player-play"), for: .normal)
        }
    }
    
    func moveFoward(step : Int) {
        let PVC = self.superview?.parentViewController as! PlayViewController
        let currentNumber = Song.shared.order
//        if  currentNumber > 0{
            PVC.chooseSongNumber(number: (currentNumber! + step + kNumberOfSong) % kNumberOfSong)
//        }
    }
    @IBAction func clickPrevious(_ sender: AnyObject) {
        switch shuffleState {
        case 0: // shuffle
            let diceRoll = Int(arc4random_uniform(UInt32(kNumberOfSong - 1 ))) + 1
            moveFoward(step: diceRoll)
            break
        case 1: // not shuffle
            moveFoward(step: -1)
        default:
            break
        }
    }
    
    @IBAction func clickNext(_ sender: AnyObject) {
        print("click next")
        switch shuffleState {
        case 0: // shuffle
            let diceRoll = Int(arc4random_uniform(UInt32(kNumberOfSong - 1))) + 1
            moveFoward(step: diceRoll)
            break
        case 1: // not shuffle
            moveFoward(step: 1)
        default:
            break
        }

    }
    
    @IBAction func clickRepeat(_ sender: AnyObject) {
        repeatState += 1
        repeatState %= 3
        switch repeatState {
        case 0:
            self.repeatButton.setImage(UIImage(named: "img-player-repeat"), for: .normal)
            break
        case 1:
            self.repeatButton.setImage(UIImage(named: "img-player-repeat-none"), for: .normal)
            break
        case 2:
            self.repeatButton.setImage(UIImage(named: "img-player-repeat-1"), for: .normal)
            break
        default:
            break
        }
    }
//    let diceRoll = Int(arc4random_uniform(6) + 1)
    @IBAction func clickShuffle(_ sender: AnyObject) {
        shuffleState += 1
        shuffleState %= 2
        switch shuffleState {
        case 0:
            self.shuffleButton.setImage(UIImage(named:"img-player-shuffle"), for: .normal)
            break
        case 1:
            self.shuffleButton.setImage(UIImage(named:"img-player-shuffle-off"), for: .normal)
            break
        default :
            break
        }
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    // MARK: Pan Gesture
    
    func event() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panGesture))
        self.previousButton.addGestureRecognizer(pan)
        self.nextButton.addGestureRecognizer(pan)
    }
    
    @objc
    func panGesture(sender : AnyObject) {

    }

    
}
