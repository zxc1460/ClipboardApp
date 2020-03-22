//
//  BinTableCustomCell.swift
//  ClipboardApp
//
//  Created by 이준수 on 2020/03/22.
//  Copyright © 2020 swift. All rights reserved.
//

import UIKit
import SnapKit
import MGSwipeTableCell

class BinTableCustomCell: MGSwipeTableCell {

    let contextLabel = UILabel()
    let copyBtn = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(contextLabel)
        self.addSubview(copyBtn)
        
        contextLabel.backgroundColor = .green
        copyBtn.backgroundColor = .green
        
//        copyBtn.imageView.image = UIImage(systemName: "doc.on.clipboard")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func layout() {
        contextLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(17)
            make.bottom.equalTo(self).offset(-18)
            make.left.equalTo(self).offset(18)
        }
        
        copyBtn.snp.makeConstraints { (make) in
            make.left.equalTo(contextLabel.snp.right).offset(11)
            make.top.equalTo(self).offset(14)
            make.bottom.equalTo(self).offset(-15)
            make.right.equalTo(self).offset(-9)
        }
        
        
    }
    
    


//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

}
