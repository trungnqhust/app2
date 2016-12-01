//
//  DownloadManager.swift
//  App2
//
//  Created by Admin on 11/28/16.
//  Copyright © 2016 Techkids. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class DownloadManager {
    
    static let shared = DownloadManager()
    
    func downloadGenre(url: String, completed: @escaping(_ string: String) -> Void) {
        
        guard let genreUrl = URL(string: url) else {
            return
        }
        
        Alamofire.request(genreUrl).responseJSON { (response) in
            
            if let value = response.result.value {
                let json = JSON(value)
                
                let feed = json["feed"]
                let title = feed["title"]
                guard let label = title["label"].string else {
                    return
                }
                let genreName = label.replacingOccurrences(of: "iTunes Store: Top Songs in " , with: "")
                completed(genreName)
            }
            
        }
        
    }
    
    func downloadMusic(url: String, musicNumber : Int,  completed: @escaping(_ imagelink: String, _ musicName : String, _ author : String ) -> Void) {
        
        guard let genreUrl = URL(string: url) else {
            return
        }
        
        Alamofire.request(genreUrl).responseJSON { (response) in
            
            if let value = response.result.value {
                let json = JSON(value)
                
                let feed = json["feed"]
                let entry = feed["entry"]
                guard let name = entry[musicNumber]["im:name"].string else {
                    return
                }
                guard let image = entry[musicNumber]["im:image"].string else {
                    return
                }
                let author = entry[musicNumber]["im:artist"]
                guard let label = author["label"].string else {
                    return
                }
                completed(name, image, label)
            }
            
        }
        
    }
    
}
