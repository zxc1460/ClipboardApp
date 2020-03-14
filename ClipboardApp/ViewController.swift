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

class MainViewController: UIViewController {
    
    let colorTagRGB = [
        UIColor.colorWithRGBHex(hex: 0xdbacfc), // pupple
        UIColor.colorWithRGBHex(hex: 0x82c5ff), // blue
        UIColor.colorWithRGBHex(hex: 0x0aeb99), // green
        UIColor.colorWithRGBHex(hex: 0xf5d442), // yellow
        UIColor.colorWithRGBHex(hex: 0xff8a78), // red
    ]
    let swipeBtnBgColor = UIColor.colorWithRGBHex(hex: 0xe6e6e6)
    
    var sideMenu: SideMenuNavigationController?
    
    var leftButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "menu", style: .plain, target: self, action: #selector(sideMenuButtonClicked(_:)))

        return button
    }()
    
    @IBOutlet var clipsTableView : UITableView?
    @IBAction func sideMenuButtonClicked(_ sender: Any) {
        present(sideMenu!, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        clipsTableView?.delegate = self
        clipsTableView?.dataSource = self
        
        sideMenu = SideMenuNavigationController(rootViewController: MainViewController())
        sideMenu?.leftSide = true
        sideMenu?.statusBarEndAlpha = 0
        sideMenu?.navigationBar.isHidden = true
        
        
        navigationItem.title = "클립보드"
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.barTintColor = UIColor.colorWithRGBHex(hex: 0xff8a69)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        self.navigationItem.leftBarButtonItem = self.leftButton

    }
    

}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "clipboardCell", for: indexPath) as! ClipboardCustomCell
        
        cell.colorTag.tintColor = .white
        
        let delBtn = MGSwipeButton(title: "", icon:UIImage(named: "icons8-trash"), backgroundColor: .red)
        var colorTagBtns : [MGSwipeButton] = [delBtn]
        
        for color in self.colorTagRGB {
            let colorTagBtn = MGSwipeButton(title : "", icon:UIImage(systemName: "circle.fill"), backgroundColor: self.swipeBtnBgColor)
            
            colorTagBtn.tintColor = color
//            colorTagBtn.setImage(UIImage(systemName:"checkmark.circle.fill"), for: .selected)
//            colorTagBtn.addTarget(self, action: #selector(colorTagButtonClicked), for: .touchUpInside)
            colorTagBtns.append(colorTagBtn)
//            colorTagBtn.isSelected = true
        }
        
        delBtn.buttonWidth = UIScreen.main.bounds.width / 6
        cell.rightButtons = colorTagBtns
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0;
    }
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        code
//    }
}



extension UIColor {
    class func colorWithRGBHex(hex: Int, alpha: Float = 1.0) -> UIColor {
        let r = Float((hex >> 16) & 0xFF)
        let g = Float((hex >> 8) & 0xFF)
        let b = Float((hex) & 0xFF)
        
        return UIColor(red: CGFloat(r / 255.0), green: CGFloat(g / 255.0), blue:CGFloat(b / 255.0), alpha: CGFloat(alpha))
    }
}

