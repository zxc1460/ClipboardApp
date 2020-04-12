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
import SnapKit

class MainViewController: UIViewController {
    
    var items: Results<ClipModel>?
    let clipsTableView = UITableView()
    
    // realm 객체들의 변화를 감지할 노티피케이션
    var notificationToken: NotificationToken?
    
    init(items: Results<ClipModel>?) {
        super.init(nibName: nil, bundle: nil)
        self.items = items
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.getCopiedText), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
        notificationToken?.invalidate()
    }
    
    let colorTagRGB = [
        UIColor.colorWithRGBHex(hex: 0xff8a78), // red
        UIColor.colorWithRGBHex(hex: 0xf5d442), // yellow
        UIColor.colorWithRGBHex(hex: 0x0aeb99), // green
        UIColor.colorWithRGBHex(hex: 0x82c5ff), // blue
        UIColor.colorWithRGBHex(hex: 0xdbacfc), // purple
    ]
    let swipeBtnBgColor = UIColor.colorWithRGBHex(hex: 0xe6e6e6)
    
    

    // search
    let searchController = UISearchController(searchResultsController: nil)
    var filteredClips: [ClipModel] = []
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
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
                        if item.copiedText == str && item.isDeleted == false {
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
            }
        }
    }
    
    private func sortByModiDate() {
        if let realm = try? Realm() {
            self.items = realm.objects(ClipModel.self).filter("isDeleted == false").sorted(byKeyPath: "modiDate", ascending: false)
            clipsTableView.reloadData()
        }
    }
    
    func filterContentForSearchText(_ searchText: String) {

        if let clips = self.items {
            filteredClips = clips.filter { (clip: ClipModel) -> Bool in
                return clip.copiedText.lowercased().contains(searchText.lowercased())
            }
        }
        
        clipsTableView.reloadData()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // button 에 action 이 안먹어서 버튼 선언을 viewDidLoad() 안에로 바꿨어요
//        let leftButton = UIBarButtonItem(title: "menu", style: .plain, target: self, action: #selector(sideMenuButtonClicked(_:)))
//        self.navigationItem.leftBarButtonItem = leftButton
        
        self.navigationItem.title = "클립보드"
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.barTintColor = UIColor.colorWithRGBHex(hex: 0xff8a69)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        self.view.addSubview(clipsTableView)
        clipsTableView.frame = self.view.bounds
        clipsTableView.delegate = self
        clipsTableView.dataSource = self
        clipsTableView.register(MainTableCustomCell.self, forCellReuseIdentifier: "clipCell")

        navigationItem.title = "클립보드"
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.barTintColor = UIColor.colorWithRGBHex(hex: 0xff8a69)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        // 검색 기능
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Clips"
        if #available(iOS 13.0, *) {
            searchController.searchBar.searchTextField.backgroundColor = UIColor.white
        }

        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        
        // items에 변화가 있을 때마다 테이블뷰를 리로드할 수 있도록 노티피케이션 등록
//        notificationToken = items!.observe { [weak self] (changes: RealmCollectionChange) in
//            switch changes {
//            case .initial:
//                // Results are now populated and can be accessed without blocking the UI
//                DispatchQueue.main.async {
//                    self?.reloadData()
//                }
//            case .update:
//                DispatchQueue.main.async {
//                    self?.reloadData()
//                }
//            case .error(let error):
//                // An error occurred while opening the Realm file on the background worker thread
//                fatalError("\(error)")
//            }
//        }
//

    }
}

extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        if let text = searchBar.text {
            filterContentForSearchText(text)
        }
    }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = items?.count {
            if isFiltering {
                return filteredClips.count
            }
            return count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let clip = items?[indexPath.row] else {
            return UITableViewCell()
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: "clipCell", for: indexPath) as! MainTableCustomCell

        let item: ClipModel
        if isFiltering {
            item = filteredClips[indexPath.row]
        } else {
            item = clip
        }
        
        cell.colorTag.tintColor = .white
        cell.copyBtn.tag = indexPath.row
        cell.copyBtn.addTarget(self, action: #selector(copyText(_:)), for: .touchUpInside)
        
        var colorTagBtns : [MGSwipeButton] = []
        
        let delBtn = MGSwipeButton(title: "", icon:UIImage(named: "icons8-trash"), backgroundColor: .red, callback: {
            (sender: MGSwipeTableCell!) -> Bool in
            let realm = try! Realm()
            try! realm.write {
                item.isDeleted = true
                item.modiDate = Date()
            }
            self.clipsTableView.reloadData()
            return true
        })
        
        
        let colorIndex = item.color
        
        for (index, color) in (self.colorTagRGB).enumerated() {
            let colorTagBtn = MGSwipeButton(title : "", icon:UIImage(systemName: "circle.fill"), backgroundColor: self.swipeBtnBgColor, callback: {
                (sender: MGSwipeTableCell!) -> Bool in
                let realm = try! Realm()
                try! realm.write {
                    if item.color == index {
                        item.color = -1
                    }
                    else {
                        item.color = index
                    }
                }
                self.clipsTableView.reloadData()
                return true
                
            })
            
            colorTagBtn.setImage(UIImage(systemName:"checkmark.circle.fill"), for: .selected)
            colorTagBtn.tintColor = color
            colorTagBtn.backgroundColor = self.swipeBtnBgColor
            colorTagBtn.isSelected = false
            
            colorTagBtns.append(colorTagBtn)
        }
        
        
        

        if colorIndex != -1 { // 선택된 color tag 없으면 pass
            colorTagBtns[colorIndex].backgroundColor = .white
            colorTagBtns[colorIndex].isSelected = true
            cell.colorTag.tintColor = self.colorTagRGB[colorIndex]
        }
        
        
        
        delBtn.buttonWidth = UIScreen.main.bounds.width / 6
        colorTagBtns.append(delBtn)
        colorTagBtns.reverse() // 쌓인 순서 바꿔주기 <-
        cell.rightButtons = colorTagBtns
        
        cell.contextLabel.text = item.copiedText
        

        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.performSegue(withIdentifier: "DetailSegue", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "DetailSegue" {
//            if let tableView = self.clipsTableView {
//                if let indexPath = tableView.indexPathForSelectedRow {
//                    if let vc = segue.destination as? DetailViewController {
//                        if let item = items?[indexPath.row] {
//                            vc.copiedText = item.copiedText
//                        }
//                    }
//                }
//            }
//        }
//    }
    
    @objc func copyText(_ sender: UIButton) {
        if let item = items?[sender.tag] {
            UIPasteboard.general.string = item.copiedText
            
            let alert = UIAlertController(title: nil, message: "복사되었습니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
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

//        local realm data 저장되어 있는 위치 출력
//        print("Realm is located at:", realm.configuration.fileURL!)
