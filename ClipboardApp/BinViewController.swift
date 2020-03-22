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

class BinViewController: UIViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    let binTableView = UITableView()
    var realm: Realm?
    var items: Results<ClipModel>?
    
    var binArray: Results<ClipModel>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        binTableView.register(BinTableCustomCell.self, forCellReuseIdentifier: "binCell")
        binTableView.delegate = self
        binTableView.dataSource = self
        self.view.addSubview(binTableView)
        binTableView.frame = self.view.bounds
    
        self.realm = try! Realm()
        self.items = realm?.objects(ClipModel.self)
        
        
        //  let oddArray = array.filter( { (value: Int) -> Bool in return (value % 2 == 0) } ) : 참고 코드
        guard let items = self.items else {
            print("items is empty")
            self.binArray = nil
        }
        
        let binArray = items.filter( { (item: ClipModel) -> Bool in return (item.isDeleted == true) })
        self.binArray = binArray
    }

    
}

extension BinViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "binCell", for: indexPath) as! BinTableCustomCell
        
        guard let binArray = self.binArray else {
            
            print("bin array is empty")
            return UITableViewCell()
        }
        let binItem = binArray[indexPath.row]
        
        cell.rightButtons = [MGSwipeButton(title: "복원", backgroundColor: .green),
                             MGSwipeButton(title: "삭제", backgroundColor: .red)]
        
        cell.contextLabel.text = binItem.copiedText
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let binArray = self.binArray else {
            
            print("bin array is empty")
            return 0
        }
        
        
        return binArray.count
    }
    
    
}
