//
//  DetailViewController.swift
//  ClipboardApp
//
//  Created by Seok on 08/04/2020.
//  Copyright © 2020 swift. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    let textView = UITextView()
    var copiedText: String?
    
    init(copiedText: String) {
        self.copiedText = copiedText
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "클립 상세"
        
        if let str = copiedText {
            textView.text = str
        }
        
        // 텍스트 뷰 설정
        self.textView.frame = self.view.frame
        self.textView.isEditable = false
        self.textView.dataDetectorTypes = .link
        self.view.addSubview(textView)

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
