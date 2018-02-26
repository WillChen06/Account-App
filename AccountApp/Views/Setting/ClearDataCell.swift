//
//  ClearDataCell.swift
//  AccountApp
//
//  Created by Chen Kuan Chung on 2018/02/25.
//  Copyright © 2018年 william. All rights reserved.
//

import UIKit

class ClearDataCell: UITableViewCell {
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17.0)
        label.textColor = .red
        label.text = .clearData
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init has not been implemented.")
    }
    
    fileprivate func setupViews() {
        addSubview(titleLabel)
        titleLabel.anchor(top: nil, left: contentView.leftAnchor, bottom: nil, right: nil, topConstant: 0.0, leftConstant: 8.0, bottomConstant: 0.0, rightConstant: 0.0, widthConstant: 0.0, heightConstant: 0.0)
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}
