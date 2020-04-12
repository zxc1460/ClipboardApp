//
//  SideMenuViewController.swift
//  ClipboardApp
//
//  Created by 이준수 on 2020/03/15.
//  Copyright © 2020 swift. All rights reserved.
//

import UIKit
import RealmSwift

class SideMenuViewController: UIViewController {
    
    private let tableView = UITableView()
    let iconImageList: [String] = ["Clipboard", "Config", "Bin"]
    let menuTextList: [String] = ["클립보드", "설정", "휴지통"]
    
    let colorList: [UIColor] = [.red, .yellow, .green, .blue, .purple]
    let colorName: [String] = ["빨간색", "노란색", "초록색", "파란색", "보라색"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .blue
        self.view.addSubview(tableView)
        
        self.tableView.frame = view.bounds
        
        self.tableView.register(SideMenuCustomCell.self, forCellReuseIdentifier: "menuCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // 메뉴를 가장한 BackButton(pop!)
        let backItem = UIBarButtonItem(title: "메뉴", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backItem
        
    }
    
}

extension SideMenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) as! SideMenuCustomCell
        
        if indexPath.section == 0 {
            cell.iconView.image = UIImage(named:"\(iconImageList[indexPath.row])")
            cell.labelView.text = "\(menuTextList[indexPath.row])"
            
        } else if indexPath.section == 1 {
            cell.iconView.backgroundColor = colorList[indexPath.row]
//            cell.iconView.layer.cornerRadius = cell.iconView.bounds.width/2
//            cell.iconView.clipsToBounds = true
            
            cell.labelView.text = colorName[indexPath.row]
            
        } else {
            return cell
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 3
        } else if section == 1 {
            return 5
        } else {
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return CGFloat(60)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 50
        } else if section == 1 {
            return 50
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "ClipboardApp"
        } else if section == 1 {
            return "Color"
        } else {
            return ""
        }
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        if section == 0 {
//          return UITableViewCell()
//        } else if section == 1 {
//            return UITableViewCell()
//        } else {
//            return UITableViewCell()
//        }
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 && indexPath.row == 0 {
            
            let realm = try! Realm()
            let items = realm.objects(ClipModel.self).filter("isDeleted == false").sorted(byKeyPath: "modiDate", ascending: false)
            
            self.navigationController?.pushViewController(MainViewController(items: items), animated: true)
        }
        
        if indexPath.section == 0 && indexPath.row == 2 {
            self.navigationController?.pushViewController(BinViewController(), animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 1 {
            
            let realm = try! Realm()
            let items = realm.objects(ClipModel.self).filter("isDeleted == false").filter("color == \(indexPath.row)")
                .sorted(byKeyPath: "modiDate", ascending: false)
            
            self.navigationController?.pushViewController(MainViewController(items: items), animated: true)
        }
    }
    
}
