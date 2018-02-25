//
//  ListTableViewCell.swift
//  AccountApp
//
//  Created by Chen Kuan Chung on 2018/02/22.
//  Copyright © 2018年 william. All rights reserved.
//

import UIKit
//import Foundation

class ListTableViewCell: UITableViewCell {
    
    lazy var insideView: UIView = {
        let insideView = UIView()
        insideView.translatesAutoresizingMaskIntoConstraints = false
        insideView.backgroundColor = .white
        insideView.layer.shadowColor = UIColor.black.cgColor
        insideView.layer.shadowOpacity = 0.7
        insideView.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
        insideView.layer.cornerRadius = 5
        insideView.layer.shadowRadius = 5
        return insideView
    }()
    
    lazy var typeImageView: UIImageView = {
        let typeImageView = UIImageView()
        typeImageView.translatesAutoresizingMaskIntoConstraints = false
        typeImageView.contentMode = .scaleAspectFit
        return typeImageView
    }()
    
    lazy var dataLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13.0)
        label.textColor = .listTitleGray
        return label
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17.0)
        return label
    }()
    
    lazy var describeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13.0)
        label.textColor = .placeholderGrey
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
        fatalError("init has not been impelemented.")
    }
    
    fileprivate func setupViews() {
        backgroundColor = .clear
        selectionStyle = .none
        addSubview(insideView)
        insideView.addSubview(typeImageView)
        insideView.addSubview(dataLabel)
        insideView.addSubview(titleLabel)
        insideView.addSubview(describeLabel)
        insideView.addSubview(amountLabel)
        insideView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 8.0, leftConstant: 8.0, bottomConstant: 8.0, rightConstant: 8.0, widthConstant: 0.0, heightConstant: 0.0)
        typeImageView.anchor(top: insideView.topAnchor, left: insideView.leftAnchor, bottom: insideView.bottomAnchor, right: nil, topConstant: 24.0, leftConstant: 8.0, bottomConstant: 24.0, rightConstant: 0.0, widthConstant: 0.0, heightConstant: 0.0)
        typeImageView.widthAnchor.constraint(equalTo: typeImageView.heightAnchor, multiplier: 1.0).isActive = true
        typeImageView.centerYAnchor.constraint(equalTo: insideView.centerYAnchor).isActive = true
        dataLabel.anchor(top: insideView.topAnchor, left: typeImageView.rightAnchor, bottom: nil, right: nil, topConstant: 8.0, leftConstant: 8.0, bottomConstant: 0.0, rightConstant: 0.0, widthConstant: 0.0, heightConstant: 0.0)
        titleLabel.anchor(top: nil, left: typeImageView.rightAnchor, bottom: nil, right: nil, topConstant: 0.0, leftConstant: 8.0, bottomConstant: 0.0, rightConstant: 0.0, widthConstant: 150.0, heightConstant: 0.0)
        titleLabel.centerYAnchor.constraint(equalTo: insideView.centerYAnchor).isActive = true
        describeLabel.anchor(top: titleLabel.bottomAnchor, left: typeImageView.rightAnchor, bottom: nil, right: nil, topConstant: 8.0, leftConstant: 8.0, bottomConstant: 0.0, rightConstant: 0.0, widthConstant: 0.0, heightConstant: 0.0)
        amountLabel.anchor(top: nil, left: nil, bottom: nil, right: insideView.rightAnchor, topConstant: 0.0, leftConstant: 0.0, bottomConstant: 0.0, rightConstant: 8.0, widthConstant: 0.0, heightConstant: 0.0)
        amountLabel.centerYAnchor.constraint(equalTo: insideView.centerYAnchor).isActive = true
    }
}
