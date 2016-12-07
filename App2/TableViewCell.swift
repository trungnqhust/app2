//
//  TableViewCell.swift
//  App2
//
//  Created by Admin on 11/29/16.
//  Copyright © 2016 Techkids. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage
class TableViewCell : UITableViewCell{
    
    @IBOutlet weak var imageInCell: UIImageView!
    @IBOutlet weak var musicNameLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var isPlayingView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.isPlayingView.layer.cornerRadius = self.isPlayingView.frame.width / 2
        self.isPlayingView.isHidden = true
        self.imageInCell.image = UIImage()
        self.musicNameLabel.text = ""
        self.authorLabel.text = ""
    }
    
    func setPlayingView(set : Bool) {
        self.isPlayingView.isHidden = !set
        print("set = \(set)")
    }
    
    func setUI(url : String, number : Int) {

//        self.imageInCell.layer.cornerRadius = self.imageInCell.frame.width / 2
//        self.imageInCell.clipsToBounds = true
        DownloadManager.shared.downloadMusic(url: url, musicNumber: number, completed: { (name, image, author) in
            self.musicNameLabel.text = name
            print("image url : " + image)
  
 //           let url = URL(string: image)
//            self.imageInCell.sd_setImage(with: url!, placeholderImage: UIImage(named: "placeholder.png"))
//            self.imageInCell.sd_setImage(with: url!)
            DownloadManager.shared.loadImage(url: image, completed: { (image) in
                self.imageInCell.image = image
                self.imageInCell.layer.cornerRadius = self.imageInCell.frame.width / 2
                self.imageInCell.clipsToBounds = true
            })
            self.authorLabel.text = author
        })
    }
}

