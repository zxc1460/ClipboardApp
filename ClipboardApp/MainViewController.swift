//
//  ViewController.swift
//  ClipboardApp
//
//  Created by Seok on 08/03/2020.
//  Copyright © 2020 swift. All rights reserved.
//

import UIKit
import SideMenu
import MGSwipeTableCell
import RealmSwift

class MainViewController: UIViewController {
    
    let colorTagRGB = [
        UIColor.colorWithRGBHex(hex: 0xff8a78), // red
        UIColor.colorWithRGBHex(hex: 0xf5d442), // yellow
        UIColor.colorWithRGBHex(hex: 0x0aeb99), // green
        UIColor.colorWithRGBHex(hex: 0x82c5ff), // blue
        UIColor.colorWithRGBHex(hex: 0xdbacfc), // purple
    ]
    let swipeBtnBgColor = UIColor.colorWithRGBHex(hex: 0xe6e6e6)
    
    // 스토리보드 상에서 네비게이션바 아이템으로 사이드 메뉴 네비게이션 컨트롤러가 안띄어지네요.. 그래서 코드상으로 했습니다.
    let sideMenu = SideMenuNavigationController(rootViewController: SideMenuViewController())

    
    // realm과 데이터모델 변수
    var realm: Realm?
    var items: Results<ClipModel>?
    
    
    
    @IBOutlet var clipsTableView : UITableView?
    @objc func sideMenuButtonClicked(_ sender: UIBarButtonItem) {
        present(sideMenu, animated: true, completion: nil)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //앱이 백그라운드에서 포그라운드로 돌아올 때 카피된 것이 있는지 확인하고 가져오기.
        NotificationCenter.default.addObserver(self, selector: #selector(self.getCopiedText), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //뷰가 사라지면 노티피케이션 제거
        NotificationCenter.default.removeObserver(self)
    }
    
    
    // 카피된 내용 가져오는 함수
    @objc func getCopiedText() {
        if let str = UIPasteboard.general.string {
            print("정상적으로 복사됨 텍스트: \(str)")
            var flag: Bool = true
            if let arr = items {
                for item in arr {
                    if item.copiedText == str {
                        flag = false
                        break
                    }
                }
            }
            
            if flag {
                let newClip = ClipModel()
                newClip.copiedText = str
                
                try! realm?.write {
                    realm?.add(newClip)
                }
            }
            
        }
        
        self.clipsTableView?.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // button 에 action 이 안먹어서 버튼 선언을 viewDidLoad() 안에로 바꿨어요
        let leftButton = UIBarButtonItem(title: "menu", style: .plain, target: self, action: #selector(sideMenuButtonClicked(_:)))

        
        clipsTableView?.delegate = self
        clipsTableView?.dataSource = self
        
        
        sideMenu.leftSide = true
        sideMenu.presentationStyle = .viewSlideOutMenuIn
        sideMenu.statusBarEndAlpha = 0
        sideMenu.navigationBar.isHidden = true
        sideMenu.menuWidth = 290
        
        navigationItem.title = "클립보드"
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.barTintColor = UIColor.colorWithRGBHex(hex: 0xff8a69)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        self.navigationItem.leftBarButtonItem = leftButton
        
        // realm 초기화, 저장 데이터 가져오기
        realm = try! Realm()
        items = realm?.objects(ClipModel.self)
        

    }
    

}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = items?.count {
            return count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = items?[indexPath.row] else {
            return UITableViewCell()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "clipboardCell", for: indexPath) as! ClipboardCustomCell
        
        
        
        cell.colorTag.tintColor = .white
        cell.copyBtn.tag = indexPath.row
        cell.copyBtn.addTarget(self, action: #selector(copyText(_:)), for: .touchUpInside)
        
        let delBtn = MGSwipeButton(title: "", icon:UIImage(named: "icons8-trash"), backgroundColor: .red, callback: {
            (sender: MGSwipeTableCell!) -> Bool in
            try! self.realm?.write {
                item.copiedText = "deleted"
                tableView.reloadData()
            }
            return true
        })
        
        var colorTagBtns : [MGSwipeButton] = []
        
        var colorIndex = 1
        for (index, color) in (self.colorTagRGB).enumerated() {
            let colorTagBtn = MGSwipeButton(title : "", icon:UIImage(systemName: "circle.fill"), backgroundColor: self.swipeBtnBgColor, callback: {
                (sender: MGSwipeTableCell!) -> Bool in
                try! self.realm?.write {
                    item.copiedText = String(index)
                }
                
                colorIndex = index
                
                tableView.reloadData()
                return true
            })
            colorTagBtn.setImage(UIImage(systemName:"checkmark.circle.fill"), for: .selected)
            colorTagBtn.tintColor = color
            
            colorTagBtns.append(colorTagBtn)
        }
        
        for btn in colorTagBtns {
            btn.backgroundColor = self.swipeBtnBgColor
            btn.isSelected = false
        }
        
        
        colorTagBtns[colorIndex].backgroundColor = self.colorTagRGB[colorIndex]
        colorTagBtns[colorIndex].tintColor = self.swipeBtnBgColor
        colorTagBtns[colorIndex].isSelected = true
        cell.colorTag.tintColor = self.colorTagRGB[colorIndex]
        
        
        delBtn.buttonWidth = UIScreen.main.bounds.width / 6
        colorTagBtns.append(delBtn)
        colorTagBtns.reverse()
        cell.rightButtons = colorTagBtns
        
        
        cell.contextLabel.text = item.copiedText
        

        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0;
    }
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        code
//    }
    
    @objc func copyText(_ sender: UIButton) {
        if let item = items?[sender.tag] {
            UIPasteboard.general.string = item.copiedText
        }
    }
    
    
}



extension UIColor {
    class func colorWithRGBHex(hex: Int, alpha: Float = 1.0) -> UIColor {
        let r = Float((hex >> 16) & 0xFF)
        let g = Float((hex >> 8) & 0xFF)
        let b = Float((hex) & 0xFF)
        
        return UIColor(red: CGFloat(r / 255.0), green: CGFloat(g / 255.0), blue:CGFloat(b / 255.0), alpha: CGFloat(alpha))
    }
}

