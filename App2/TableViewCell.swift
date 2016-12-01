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
    
    func setUI(url : String, number : Int) {
        
        DownloadManager.shared.downloadMusic(url: url, musicNumber: number, completed: { (name, image, author) in
            self.musicNameLabel.text = name
            self.imageInCell.sd_setImage(with: NSURL(string: url) as URL!)
            self.authorLabel.text = author
        })
    }
}

