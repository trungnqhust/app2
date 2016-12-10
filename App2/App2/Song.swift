//
//  Song.swift
//  App2
//
//  Created by Admin on 12/4/16.
//  Copyright © 2016 Techkids. All rights reserved.
//

import UIKit

class Song {
    static var shared = Song()  //  song playing
    var image : UIImage!
    var name : String!
    var author : String!
    var imageUrl: String!
    var order : Int!
    
    init() {
        // nothing
    }
    static func setData(imageUrl : String, name : String, author : String, order : Int) {
        shared.order = order
        shared.imageUrl = imageUrl
        shared.name = name
        shared.author = author
        DownloadManager.shared.loadImage(url: imageUrl) { (image) in
            shared.image = image
            PlayBar.setDataAndPlay()
        }
    }
    
}
