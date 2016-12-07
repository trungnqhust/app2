//
//  Song.swift
//  App2
//
//  Created by Admin on 12/4/16.
//  Copyright © 2016 Techkids. All rights reserved.
//

import UIKit

class Song {
    var image : UIImage!
    var name : String!
    var author : String!
    var imageUrl: String!
    init(imageUrl : String, name : String, author : String) {
        self.imageUrl = imageUrl
        self.name = name
        self.author = author
    }
    
}
