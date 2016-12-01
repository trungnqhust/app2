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
    
    @IBOutlet weak var tableMusicView: UITableView!
    var url : String!
    let numberOfSong = 50

    var listRow : Variable<[String]> = Variable<[String]>([])
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        // Do any additional setup after loading the view.
        self.initListRow()
        self.listRow.asObservable().bindTo(
            self.tableMusicView.rx.items(cellIdentifier: "tablecell", cellType: TableViewCell.self)
        ) { (row, url ,cell) in
            cell.setUI(url: self.url, row: row)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
