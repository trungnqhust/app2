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
import AlamofireImage
import AVFoundation

let mp3query : String = "http://api.mp3.zing.vn/api/mobile/search/song?requestdata={\"q\":\"%@\", \"sort\":\"hot\", \"start\":\"0\", \"length\":\"10\"}"
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
    
    func loadImage(url: String, completed: @escaping(_ image: UIImage)->Void) {
        Alamofire.request(url).responseImage { (response) in
            if let image = response.result.value {
                completed(image)
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
                let imname = entry[musicNumber]["im:name"]
                guard let name = imname["label"].string else {
                    return
                }
                
                let imimage = entry[musicNumber]["im:image"]
                guard let image = imimage[2]["label"].string else {
                    return
                }
                let imartist = entry[musicNumber]["im:artist"]
                guard let artist = imartist["label"].string else {
                    return
                }
                completed(name, image, artist)
            }
            
        }
        
    }
    
    func searchMusicMp3(nameAndArtist : String, completed : @escaping(_ link : String) -> Void) {
        
        var max : Double = -10000
        var index = 0
        var link : String = ""
        let urlString = String(format: mp3query, nameAndArtist).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        print(urlString)
        Alamofire.request(urlString).responseJSON { (response) in
            
            if let value = response.result.value {
                let json = JSON(value)
                print("________json: \(json)")
                let docs = json["docs"].array
                print("________docs: \(docs)")
                for doc in docs! {
                    let title = doc["title"].string
                    let artist = doc["artist"].string
                    
                    let text = title! + " " + artist!
                    
                    let score = nameAndArtist.score(text, fuzziness: 1.0)
                    
                    print("score : \(score)")
                    if score > max{
                        max = score
                        let link_download = doc["link_download"]
                        link = link_download["128"].string!
                    }
                }
                print("\(link)")
                
                completed(link)
            }
            
        }
    }
        
}
