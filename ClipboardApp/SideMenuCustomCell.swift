//
//  SideMenuCustomCell.swift
//  ClipboardApp
//
//  Created by 이준수 on 2020/03/15.
//  Copyright © 2020 swift. All rights reserved.
//

import UIKit

class SideMenuCustomCell: UITableViewCell {
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let iconView = UIImageView()
    let labelView = UILabel()
    let detailArrowView = UIImageView()
    
    override func layoutSubviews() {
        super.layoutSubviews()

//       사이드 메뉴 뷰가 오른쪽을 부분적으로 보여지는 거라 .detailArrowView 화살표가 안보입니다. 그래서 그냥 이미지 뷰로.
//        self.accessoryType = .detailButton

        
//        self.iconView.backgroundColor = .white
        self.labelView.backgroundColor = .white
        self.detailArrowView.backgroundColor = .white
        self.detailArrowView.image = UIImage(named: "Arrow")
        self.addSubview(iconView)
        self.addSubview(labelView)
        self.addSubview(detailArrowView)
        
        iconView.translatesAutoresizingMaskIntoConstraints = false
        labelView.translatesAutoresizingMaskIntoConstraints = false
        detailArrowView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            iconView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            iconView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            iconView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
            iconView.widthAnchor.constraint(equalToConstant: 40),
            
            iconView.rightAnchor.constraint(equalTo: labelView.leftAnchor, constant: -20),
            labelView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            labelView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            labelView.widthAnchor.constraint(equalToConstant: 100),
            
            labelView.rightAnchor.constraint(equalTo: detailArrowView.leftAnchor, constant: -20),
            detailArrowView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            detailArrowView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            detailArrowView.widthAnchor.constraint(equalToConstant: 30)
        ])
    }
}
