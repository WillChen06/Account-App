//
//  ListSectionView.swift
//  AccountApp
//
//  Created by Chen Kuan Chung on 2018/02/23.
//  Copyright © 2018年 william. All rights reserved.
//

import UIKit

class ListSectionView: UIView {
    
    lazy var sectionTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15.0)
        label.textColor = .placeholderGrey
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init has not been implemented.")
    }
    
    fileprivate func setupViews() {
        backgroundColor = .white
        addSubview(sectionTitle)
        sectionTitle.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, topConstant: 0.0, leftConstant: 8.0, bottomConstant: 0.0, rightConstant: 0.0, widthConstant: 0.0, heightConstant: 0.0)
        sectionTitle.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}
