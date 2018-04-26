//
//  EmptyView.swift
//  AccountApp
//
//  Created by Chen Kuan Chung on 2018/04/20.
//  Copyright © 2018年 william. All rights reserved.
//

import UIKit

class EmptyView: UIView {
    
    lazy var emptyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "file")
        return imageView
    }()
    
    lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20.0)
        label.text = .dataNotFound
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init has not been impelemented.")
    }
    
    fileprivate func setupViews() {
        backgroundColor = .whiteSmoke
        addSubview(emptyImageView)
        addSubview(messageLabel)
        
        emptyImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        emptyImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        emptyImageView.widthAnchor.constraint(equalTo: emptyImageView.heightAnchor, multiplier: 1.0).isActive = true
        messageLabel.anchor(top: emptyImageView.bottomAnchor, left: nil, bottom: nil, right: nil, topConstant: 8.0, leftConstant: 0.0, bottomConstant: 0.0, rightConstant: 0.0, widthConstant: 0.0, heightConstant: 0.0)
        messageLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
}
