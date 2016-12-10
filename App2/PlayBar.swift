//
//  PlayBar.swift
//  App2
//
//  Created by Admin on 12/4/16.
//  Copyright © 2016 Techkids. All rights reserved.
//

import UIKit
import MediaPlayer

class PlayBar: UIView {

    static var playBar : PlayBar!
    
    static func shared() -> PlayBar {
        if playBar == nil {
            playBar = Bundle.main.loadNibNamed("PlayBar", owner: self, options: nil)?.first as! PlayBar
            return playBar
        }   else    {
            return playBar
        }
    }
    @IBOutlet weak var playProgress: UIProgressView!
    @IBOutlet weak var imageInCell: UIImageView!
    @IBOutlet weak var musicNameLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var downloadButton: UIButton!
    
    static func setDataAndPlay(){
        self.shared().authorLabel.text = Song.shared.author
        self.shared().musicNameLabel.text = Song.shared.name
        self.shared().playProgress.progress = 0
        
        self.shared().imageInCell.image = Song.shared.image
        self.shared().imageInCell.layer.cornerRadius = self.shared().imageInCell.frame.width / 2
        self.shared().imageInCell.clipsToBounds = true
                
        DownloadManager.shared.searchMusicMp3(nameAndArtist: Song.shared.name + " " + Song.shared.author, completed: { (linkMp3) in
            print("link mp3: \(linkMp3)")
            PlayMusic.shared.playLink(url: linkMp3)
            PlayBar2.updateProgress()
            
            PlayMusic.shared.player.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1/30, Int32(NSEC_PER_SEC)), queue: nil) { (time) in
                let duration = CMTimeGetSeconds(PlayMusic.shared.playerItem.duration)
                PlayBar2.shared().playProgress.progress = Float(CMTimeGetSeconds(time)/duration)
                self.shared().playProgress.progress = Float(CMTimeGetSeconds(time)/duration)
//                print("tim = \(time) , duration = \(duration)")
            }
        })
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
