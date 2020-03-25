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
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        NotificationCenter.default.addObserver(self, selector: #selector(self.getCopiedText), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    let colorTagRGB = [
        UIColor.colorWithRGBHex(hex: 0xdbacfc), // purple
        UIColor.colorWithRGBHex(hex: 0x82c5ff), // blue
        UIColor.colorWithRGBHex(hex: 0x0aeb99), // green
        UIColor.colorWithRGBHex(hex: 0xf5d442), // yellow
        UIColor.colorWithRGBHex(hex: 0xff8a78), // red
    ]
    let swipeBtnBgColor = UIColor.colorWithRGBHex(hex: 0xe6e6e6)
    
    // 스토리보드 상에서 네비게이션바 아이템으로 사이드 메뉴 네비게이션 컨트롤러가 안띄어지네요.. 그래서 코드상으로 했습니다.
    let sideMenu = SideMenuNavigationController(rootViewController: SideMenuViewController())

    var items: Results<ClipModel>?
    
    @IBOutlet var clipsTableView : UITableView?
    @objc func sideMenuButtonClicked(_ sender: UIBarButtonItem) {
        present(sideMenu, animated: true, completion: nil)
    }
    
    
    // 카피된 내용 가져오는 함수
    @objc func getCopiedText() {
        DispatchQueue(label: "background").async {
            autoreleasepool {
                let realm = try! Realm()
                if let str = UIPasteboard.general.string {
                    var flag: Bool = true
                    let arr = realm.objects(ClipModel.self)
                    for item in arr {
                        if item.copiedText == str {
                            flag = false
                            break
                        }
                    }
                    if flag {
                        let newClip = ClipModel()
                        newClip.copiedText = str
                        
                        try! realm.write {
                            realm.add(newClip)
                        }
                    }
                    
                    print("data insert done")
                       
                }
                self.asyncReloadData()
            }
        }
    }
    
    func asyncReloadData() {
        DispatchQueue.main.async {
            self.clipsTableView?.reloadData()
            
            print("reload data done")
        }
    }
    
    @objc func colorTagTouched() {
        
        
        
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
        
        
        navigationItem.title = "클립보드"
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.barTintColor = UIColor.colorWithRGBHex(hex: 0xff8a69)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        self.navigationItem.leftBarButtonItem = leftButton
        
        // realm 초기화, 저장 데이터 가져오기
        let realm = try! Realm()
        self.items = realm.objects(ClipModel.self)

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
        
        // MGSwiftTableCell 상속받아 커스터 마이징 하면 버튼들에 액션을 못준다?
        let cell = tableView.dequeueReusableCell(withIdentifier: "clipboardCell", for: indexPath) as! ClipboardCustomCell
        
        cell.colorTag.tintColor = .white // item.tagColor
        cell.copyBtn.tag = indexPath.row
        cell.copyBtn.addTarget(self, action: #selector(copyText(_:)), for: .touchUpInside)
        
        let delBtn = MGSwipeButton(title: "", icon:UIImage(named: "icons8-trash"), backgroundColor: .red)
        
        var colorTagBtns : [MGSwipeButton] = [delBtn]
        
        let colorTagBtn = MGSwipeButton(title : "", icon:UIImage(systemName: "circle.fill"), backgroundColor: self.swipeBtnBgColor)
        for color in self.colorTagRGB {
            
            
            colorTagBtn.tintColor = color
//            colorTagBtn.setImage(UIImage(systemName:"checkmark.circle.fill"), for: .selected)
            
            colorTagBtns.append(colorTagBtn)
            
        }
        
        delBtn.buttonWidth = UIScreen.main.bounds.width / 6
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

//extension MainViewController: MGSwipeTableCellDelegate {
//
//    func swipeTableCell(_ cell: MGSwipeTableCell, tappedButtonAt index: Int, direction: MGSwipeDirection, fromExpansion: Bool) -> Bool {
//
//
//
//
//
//    }
//}




extension UIColor {
    class func colorWithRGBHex(hex: Int, alpha: Float = 1.0) -> UIColor {
        let r = Float((hex >> 16) & 0xFF)
        let g = Float((hex >> 8) & 0xFF)
        let b = Float((hex) & 0xFF)
        
        return UIColor(red: CGFloat(r / 255.0), green: CGFloat(g / 255.0), blue:CGFloat(b / 255.0), alpha: CGFloat(alpha))
    }
}

