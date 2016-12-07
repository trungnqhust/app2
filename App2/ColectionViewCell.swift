//
//  ColectionViewCell.swift
//  App2
//
//  Created by Admin on 11/28/16.
//  Copyright © 2016 Techkids. All rights reserved.
//

import UIKit

class CollectionViewCell : UICollectionViewCell{
    
    @IBOutlet weak var imageInCell: UIImageView!
    @IBOutlet weak var labelInCell: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imageInCell.image = UIImage()
        self.labelInCell.text = ""
    }
    
    func setUI(url : String, row : Int) {
        
        DownloadManager.shared.downloadGenre(url: url) { (title) in
            self.labelInCell.text = title
            self.imageInCell.image = UIImage(named: "genre-\(row)")
        }
    }
}
