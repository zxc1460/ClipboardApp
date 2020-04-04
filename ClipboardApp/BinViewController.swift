//
//  BinViewController.swift
//  ClipboardApp
//
//  Created by 이준수 on 2020/03/22.
//  Copyright © 2020 swift. All rights reserved.
//

import UIKit
import RealmSwift
import MGSwipeTableCell
import SideMenu

class BinViewController: UIViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    let binTableView = UITableView()
    var binArray: Results<ClipModel>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(binTableView)
        binTableView.register(BinTableCustomCell.self, forCellReuseIdentifier: "binCell")
        binTableView.frame = self.view.bounds
        binTableView.delegate = self
        binTableView.dataSource = self
        self.navigationItem.title = "휴지통"
        
        let realm = try! Realm()
        let binArray = realm.objects(ClipModel.self).filter("isDeleted == true").sorted(byKeyPath: "modiDate", ascending: false)
        self.binArray = binArray
        
    }
}


extension BinViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "binCell", for: indexPath) as! BinTableCustomCell
        
        guard let binArray = self.binArray else {
            print("bin array is nil")
            return UITableViewCell()
        }
        if binArray.isEmpty {
            print("bin array is empty")
            return UITableViewCell()
        }
        
        let binItem = binArray[indexPath.row]
            
        let recoverBtn: MGSwipeButton = MGSwipeButton(title: "복원", backgroundColor: .green) {
          (sender: MGSwipeTableCell!) -> Bool in
            let realm = try! Realm()
            try! realm.write {
                binItem.isDeleted = false
                binItem.modiDate = Date()
            }
            self.binTableView.reloadData()
            return true
        }
        
        let completeDeleteBtn: MGSwipeButton = MGSwipeButton(title: "삭제", backgroundColor: .red) {
            (sender: MGSwipeTableCell!) -> Bool in
            let realm = try! Realm()
            try! realm.write {
                realm.delete(binItem)
            }
            self.binTableView.reloadData()
            return true
        }
        
        cell.rightButtons = [completeDeleteBtn, recoverBtn]
        cell.contextLabel.text = binItem.copiedText
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let binArray = self.binArray else {
            print("bin array is nil")
            return 0
        }
        
        if binArray.isEmpty {
            return 0
        } else {
            return binArray.count
        }
    }
}
