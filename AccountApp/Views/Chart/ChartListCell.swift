//
//  ChartListCell.swift
//  AccountApp
//
//  Created by Chen Kuan Chung on 2018/02/18.
//  Copyright © 2018年 william. All rights reserved.
//

import UIKit

class ChartListCell: UITableViewCell {
    
    lazy var typeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17.0)
        return label
    }()
    
    lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17.0)
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
        addSubview(typeImageView)
        addSubview(nameLabel)
        addSubview(amountLabel)
        typeImageView.anchor(top: nil, left: contentView.leftAnchor, bottom: nil, right: nil, topConstant: 0.0, leftConstant: 16.0, bottomConstant: 0.0, rightConstant: 0.0, widthConstant: 15.0, heightConstant: 15.0)
        typeImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        nameLabel.anchor(top: nil, left: typeImageView.rightAnchor, bottom: nil, right: nil, topConstant: 0.0, leftConstant: 8.0, bottomConstant: 0.0, rightConstant: 0.0, widthConstant: 150.0, heightConstant: 0.0)
        nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        amountLabel.anchor(top: nil, left: nameLabel.rightAnchor, bottom: nil, right: contentView.rightAnchor, topConstant: 0.0, leftConstant: 16.0, bottomConstant: 0.0, rightConstant: 8.0, widthConstant: 0.0, heightConstant: 0.0)
        amountLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}
