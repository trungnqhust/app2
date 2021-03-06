//
//  ViewController.swift
//  App2
//
//  Created by Admin on 11/27/16.
//  Copyright © 2016 Techkids. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReachabilitySwift

let  url = "https://itunes.apple.com/us/rss/topsongs/limit=50/genre=%d/explicit=true/json"
class GenreViewController: UIViewController {
    
    var genreIndices = [2,3,4,5,6,7,9,10,11,12,14,15,16,17,18,19,20,21,22,24,34,50,51]
    
    var listUrl:Variable<[String]> = Variable<[String]>([])
    
    let animator = Animator()
    
    var disposeBag = DisposeBag()
    var currentUrl : String = ""

//    var reachability = Reachability()

    @IBOutlet weak var collectionView: UICollectionView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
//        self.navigationController?.delegate = self
     
     
                self.createListUrl()
        
        listUrl.asObservable().bindTo(
            self.collectionView.rx.items(cellIdentifier: "cell", cellType: CollectionViewCell.self)
            
        ) { (row, url, cell) in
            
            cell.setUI(url: url, row: self.genreIndices[row])
            
            }.addDisposableTo(self.disposeBag)
        
        
    }
    
    func createListUrl() {
        for i in genreIndices {
            let link = String(format: url, i)
            listUrl.value.append(link)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tapPlayBar(isEnable: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tapPlayBar(isEnable: false)
    }
    // MARK : tap PlayBar gesture
    func tapPlayBar(isEnable : Bool) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(goToPLayScreen))
        if isEnable == true {
                PlayBar.shared().addGestureRecognizer(tap)
        }   else{
            PlayBar.shared().removeGestureRecognizer(tap)
        }
        
    }
    
    @objc
    func goToPLayScreen() {
        let playMusicVC = self.storyboard?.instantiateViewController(withIdentifier: "idplaymusicscreen") as! PlayViewController

        PlayBar.shared().isHidden = true
        self.navigationController?.pushViewController(playMusicVC, animated: true)
        playMusicVC.setData(listUrl: self.currentUrl)
    }
    
}

extension GenreViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate  {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {        
        return CGSize(width: (self.view.frame.width - 30) / 2, height: self.view.frame.height / 3 )
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! CollectionViewCell
        let musicVC = self.storyboard?.instantiateViewController(withIdentifier: "idmusic") as! MusicListViewController
        currentUrl = String(format: url, genreIndices[indexPath.row])
        musicVC.listUrl = currentUrl
        musicVC.titleType = cell.labelInCell.text
        musicVC.image = cell.imageInCell.image
        animator.animationFrame = cell.imageInCell.convert(cell.imageInCell.frame, to: self.view)
        animator.image = cell.imageInCell.image

        
        
        self.navigationController?.pushViewController(musicVC, animated: true)
    }
}


extension GenreViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationControllerOperation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animator
    }
    
}
