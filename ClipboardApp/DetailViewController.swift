//
//  DetailViewController.swift
//  ClipboardApp
//
//  Created by Seok on 08/04/2020.
//  Copyright © 2020 swift. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    var copiedText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "클립 상세"
        
        if let str = copiedText {
            textView.text = str
        }
        
        // 텍스트에서 링크 감지
        self.textView.isEditable = false
        self.textView.dataDetectorTypes = .link
        

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
