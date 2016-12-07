//
//  MusicListViewController.swift
//  App2
//
//  Created by Admin on 11/29/16.
//  Copyright © 2016 Techkids. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReachabilitySwift

class MusicListViewController: UIViewController {
    @IBOutlet weak var imageGenre: UIImageView!    
    @IBOutlet weak var labelGenre: UILabel!
    @IBOutlet weak var tableMusicView: UITableView!
    
    var currentMusicPlaying = 0
    var url : String!
    let numberOfSong = 50
    var titleType : String!
    var image : UIImage!
    
    var listRow : Variable<[String]> = Variable<[String]>([])
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        // Do any additional setup after loading the view.
        self.tableMusicView.delegate = self
        self.labelGenre.text = titleType
        self.imageGenre.image = self.image
        self.title = "Discover"
        self.navigationItem.setHidesBackButton(true, animated: true)
        let nib = UINib(nibName: "TableViewCell", bundle: nil)
        tableMusicView.register(nib, forCellReuseIdentifier: "cell")
        self.initListRow()
        self.event()
        self.listRow.asObservable().bindTo(
            self.tableMusicView.rx.items(cellIdentifier: "cell", cellType: TableViewCell.self)
        ) { (row, url ,cell) in
            cell.setUI(url: self.url, number: row)
            }.addDisposableTo(self.disposeBag)
    }

    func initListRow() {
        for i in 0..<numberOfSong{
            listRow.value.append("\(i)")
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: tap Back Gesture
    
    func event() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(back))
        self.imageGenre.isUserInteractionEnabled = true
        self.imageGenre.addGestureRecognizer(tap)
    }
    
    @objc
    func back() {
        self.navigationController?.popViewController(animated: true)
    }

    //MARK : tap PlayBar gesture
    
    func tapPlayBar() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(goToPLayScreen))
        PlayBar.shared().addGestureRecognizer(tap)
    }
    
    @objc
    func goToPLayScreen() {
        let playMusicVC = self.storyboard?.instantiateViewController(withIdentifier: "idplaymusicscreen") as! PlayViewController
        if PlayBar.shared().imageInCell.image != nil {
            playMusicVC.largeImageSong.image = PlayBar.shared().imageInCell.image
            print("not not not n;l")
        }   else    {
            print("nil nil nil nil nli ")
        }
        PlayBar.shared().isHidden = true
        self.navigationController?.pushViewController(playMusicVC, animated: true)
        
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

extension MusicListViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("sellected")
        let oldIndex = IndexPath (item: currentMusicPlaying, section: 0)
        print("\(currentMusicPlaying)")
        let oldCell = tableView.cellForRow(at: oldIndex) as? TableViewCell
        oldCell?.setPlayingView(set: false)
        currentMusicPlaying = indexPath.row
                print("\(currentMusicPlaying)")
        let newCell = tableView.cellForRow(at: indexPath) as! TableViewCell
        newCell.setPlayingView(set: true)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        DownloadManager.shared.downloadMusic(url: self.url, musicNumber: currentMusicPlaying) { (name, imagelink, artist) in
            let song = Song(imageUrl: imagelink, name: name , author: artist)
            PlayBar.setDataAndPlay(song: song)
            PlayBar.shared().isHidden = false        
    }
    }
}


