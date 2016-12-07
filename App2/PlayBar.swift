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
    
    static func setDataAndPlay(song : Song){
        self.shared().authorLabel.text = song.author
        self.shared().musicNameLabel.text = song.name
        self.shared().playProgress.progress = 0
        DownloadManager.shared.loadImage(url: song.imageUrl) { (image) in
                    self.shared().imageInCell.image = image
            self.shared().imageInCell.layer.cornerRadius = self.shared().imageInCell.frame.width / 2
            self.shared().imageInCell.clipsToBounds = true
        }
        
//        print("start search in mp3")
        DownloadManager.shared.searchMusicMp3(nameAndArtist: song.name + " " + song.author, completed: { (linkMp3) in
            print("link mp3: \(linkMp3)")
            PlayMusic.shared.playLink(url: linkMp3)
            PlayMusic.shared.player.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1/30, Int32(NSEC_PER_SEC)), queue: nil) { (time) in
                let duration = CMTimeGetSeconds(PlayMusic.shared.playerItem.duration)
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
