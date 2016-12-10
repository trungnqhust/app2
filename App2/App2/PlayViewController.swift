//
//  PlayViewController.swift
//  App2
//
//  Created by Admin on 12/7/16.
//  Copyright © 2016 Techkids. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PlayViewController: UIViewController {
    @IBOutlet weak var largeImageSong: UIImageView!
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var playMiddleBar: UIView!
    
    var listUrl : String!
    
    var listRow : Variable<[String]> = Variable<[String]>([])
    let numberOfSong = 50
    var disposeBag = DisposeBag()
//    var imageTop : UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        //set image
        self.largeImageSong.image = Song.shared.image
        //set play bar
        PlayBar2.shared().frame = CGRect(x: 0, y: 0, width: self.playMiddleBar.frame.width, height: self.playMiddleBar.frame.height)
        self.playMiddleBar.addSubview(PlayBar2.shared())
        
        //set list music
        self.listTableView.delegate = self
        let nib = UINib(nibName: "TableViewCell", bundle: nil)
        self.initListRow()
        listTableView.register(nib, forCellReuseIdentifier: "cell")
        self.listRow.asObservable().bindTo(
            self.listTableView.rx.items(cellIdentifier: "cell", cellType: TableViewCell.self)
        ) { (row, url ,cell) in
            cell.setUI(url: self.listUrl, number: row)
            }.addDisposableTo(self.disposeBag)
        
        // set first row
        
        listTableView.selectRow(at: IndexPath(item: Song.shared.order, section: 0), animated: true, scrollPosition: .top)
    }

    
    func initListRow() {
        for i in 0..<numberOfSong{
            listRow.value.append("\(i)")
        }
    }
    
    func setData(listUrl : String) {
        self.listUrl = listUrl
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: tap Back Gesture
    @IBAction func backTap(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
        PlayBar.shared().isHidden = false
    }

    
    func chooseSongNumber(number : Int) {
        
        DownloadManager.shared.downloadMusic(url: self.listUrl, musicNumber: number) { (name, imagelink, artist) in
            DownloadManager.shared.loadImage(url: imagelink, completed: { (image) in
                self.largeImageSong.image = image
            })
            Song.setData(imageUrl: imagelink, name: name , author: artist, order : number)
            self.listTableView.selectRow(at: IndexPath(item: Song.shared.order, section: 0), animated: true, scrollPosition: .top)
        }

        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension PlayViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.chooseSongNumber(number: indexPath.row)

    }
}

