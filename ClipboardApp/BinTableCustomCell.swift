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
//    let copyBtn = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func layout() {
        contentView.addSubview(contextLabel)
        
        contextLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView).offset(17)
            make.bottom.equalTo(self.contentView).offset(-18)
            make.left.equalTo(self.contentView).offset(18)
            make.right.equalTo(self.contentView).offset(-20)
        }
        
    }
    
}
