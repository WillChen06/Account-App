//
//  AccountDisplayCell.swift
//  AccountApp
//
//  Created by Chen Kuan Chung on 2018/02/04.
//  Copyright © 2018年 william. All rights reserved.
//

import UIKit

class AccountDisplayCell: UITableViewCell {
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17.0)
        return label
    }()
    
    lazy var typeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17.0)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var amountContentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .clear
        return contentView
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
        addSubview(amountContentView)
        amountContentView.addSubview(typeImageView)
        amountContentView.addSubview(amountLabel)
        titleLabel.anchor(top: nil, left: contentView.leftAnchor, bottom: nil, right: nil, topConstant: 0.0, leftConstant: 16.0, bottomConstant: 0.0, rightConstant: 0.0, widthConstant: 0.0, heightConstant: 0.0)
        titleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.6).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        amountContentView.anchor(top: nil, left: titleLabel.rightAnchor, bottom: nil, right: contentView.rightAnchor, topConstant: 0.0, leftConstant: 0.0, bottomConstant: 0.0, rightConstant: 16.0, widthConstant: 0.0, heightConstant: 0.0)
        amountContentView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        typeImageView.anchor(top: nil, left: amountContentView.leftAnchor, bottom: nil, right: nil, topConstant: 0.0, leftConstant: 0.0, bottomConstant: 0.0, rightConstant: 0.0, widthConstant: 15.0, heightConstant: 15.0)
        typeImageView.centerYAnchor.constraint(equalTo: amountContentView.centerYAnchor).isActive = true
        amountLabel.anchor(top: nil, left: nil, bottom: nil, right: amountContentView.rightAnchor, topConstant: 0.0, leftConstant: 0.0, bottomConstant: 0.0, rightConstant: 0.0, widthConstant: 0.0, heightConstant: 0.0)
        amountLabel.centerYAnchor.constraint(equalTo: amountContentView.centerYAnchor).isActive = true
    }
}
