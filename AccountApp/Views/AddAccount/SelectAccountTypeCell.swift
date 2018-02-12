//
//  SelectAccountTypeCell.swift
//  AccountApp
//
//  Created by Kuan-Chung Chen on 2017/12/22.
//  Copyright © 2017年 william. All rights reserved.
//

import UIKit

class SelectAccountTypeCell: UITableViewCell {
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17.0)
        label.text = .account
        return label
    }()
    
    lazy var typeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17.0)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init has not been implemented")
    }
    
    fileprivate func setupViews() {
        addSubview(titleLabel)
        addSubview(typeLabel)
        
        titleLabel.anchor(top: nil, left: contentView.leftAnchor, bottom: nil, right: nil, topConstant: 0.0, leftConstant: 16.0, bottomConstant: 0.0, rightConstant: 0.0, widthConstant: 150.0, heightConstant: 0.0)
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        typeLabel.anchor(top: nil, left: titleLabel.rightAnchor, bottom: nil, right: contentView.rightAnchor, topConstant: 0.0, leftConstant: 8.0, bottomConstant: 0.0, rightConstant: 0.0, widthConstant: 0.0, heightConstant: 0.0)
        typeLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
}
