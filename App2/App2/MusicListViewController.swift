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
    
    var currentMusicPlayingIndex = IndexPath(row: 0, section: 0)
    var listUrl : String!
    var titleType : String!
    var image : UIImage!
    
    var listRow : Variable<[String]> = Variable<[String]>([])
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        // Do any additional setup after loading the view.
        //event
        tapPlayBar()
        self.event()
        
        //
        self.labelGenre.text = titleType
        self.imageGenre.image = self.image
        self.title = "Discover"
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        // tableView
        self.tableMusicView.delegate = self
        let nib = UINib(nibName: "TableViewCell", bundle: nil)
        tableMusicView.register(nib, forCellReuseIdentifier: "cell")
        self.initListRow()
        self.listRow.asObservable().bindTo(
            self.tableMusicView.rx.items(cellIdentifier: "cell", cellType: TableViewCell.self)
        ) { (row, url ,cell) in
            cell.setUI(url: self.listUrl, number: row)
            }.addDisposableTo(self.disposeBag)
    }

    func initListRow() {
        for i in 0..<kNumberOfSong{
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

    // MARK : tap PlayBar gesture
    func tapPlayBar() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(goToPLayScreen))
        PlayBar.shared().addGestureRecognizer(tap)
    }
    
    @objc
    func goToPLayScreen() {
        let playMusicVC = self.storyboard?.instantiateViewController(withIdentifier: "idplaymusicscreen") as! PlayViewController
        
        PlayBar.shared().isHidden = true
        self.navigationController?.pushViewController(playMusicVC, animated: true)
        playMusicVC.setData(listUrl: listUrl)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func markPlaying(indexPath : IndexPath) {
        let oldCell = self.tableMusicView.cellForRow(at: currentMusicPlayingIndex) as? TableViewCell
        oldCell?.setPlayingView(set: false)
        let newCell = self.tableMusicView.cellForRow(at: indexPath) as! TableViewCell
        newCell.setPlayingView(set: true)
        currentMusicPlayingIndex = indexPath
    }
}

extension MusicListViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.markPlaying(indexPath: indexPath)
        DownloadManager.shared.downloadMusic(url: self.listUrl, musicNumber: currentMusicPlayingIndex.row) { (name, imagelink, artist) in
            Song.setData(imageUrl: imagelink, name: name , author: artist, order : indexPath.row)            
            PlayBar.shared().isHidden = false        
    }
    }
}


