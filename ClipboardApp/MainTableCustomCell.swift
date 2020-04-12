//
//  MainCustomTableCell.swift
//  ClipboardApp
//
//  Created by 이준수 on 2020/04/12.
//  Copyright © 2020 swift. All rights reserved.
//

import UIKit
import SnapKit
import MGSwipeTableCell

class MainTableCustomCell: MGSwipeTableCell {
    
    let colorTag = UIImageView()
    let contextLabel = UILabel()
    let copyBtn = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
        
        colorTag.image = UIImage(systemName: "circle.fill")
        colorTag.tintColor = .white
        
        copyBtn.setImage(UIImage(systemName: "doc.on.clipboard"), for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        self.contentView.addSubview(colorTag)
        self.contentView.addSubview(contextLabel)
        self.contentView.addSubview(copyBtn)
        
        colorTag.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView).offset(20)
            make.bottom.equalTo(self.contentView).offset(-20)
            make.left.equalTo(self.contentView).offset(20)
        }
        
        contextLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView).offset(20)
            make.bottom.equalTo(self.contentView).offset(-20)
            make.left.equalTo(self.colorTag.snp.right).offset(20)
            make.width.equalTo(300)
        }
        
        copyBtn.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView).offset(20)
            make.bottom.equalTo(self.contentView).offset(-20)
            make.left.equalTo(self.contextLabel.snp.right).offset(20)
            make.right.equalTo(self.contentView).offset(-20)
        }
    }
    
    
    

    

}
