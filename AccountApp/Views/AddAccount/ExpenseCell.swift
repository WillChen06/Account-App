//
//  ExpenseCell.swift
//  AccountApp
//
//  Created by Chen Kuan Chung on 2018/02/10.
//  Copyright © 2018年 william. All rights reserved.
//

import UIKit

class ExpenseCell: UICollectionViewCell {
    lazy var categoryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 11.0)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init has not been implemented")
    }
    override var isSelected: Bool {
        didSet {
            nameLabel.textColor = isSelected ? .selectedOrange : .black
            let imageName = Category.Expense().imageName[tag]
            categoryImageView.image = isSelected ? UIImage(named:imageName + "Selected") : UIImage(named:imageName)
        }
    }
    
    fileprivate func setupViews() {
        layer.cornerRadius = 5.0
        addSubview(categoryImageView)
        addSubview(nameLabel)
        categoryImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        categoryImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -5.0).isActive = true
        categoryImageView.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, topConstant: 8.0, leftConstant: 8.0, bottomConstant: 0.0, rightConstant: 8.0, widthConstant: 0.0, heightConstant: 0.0)
        nameLabel.anchor(top: categoryImageView.bottomAnchor, left: nil, bottom: contentView.bottomAnchor, right: nil, topConstant: 0.0, leftConstant: 0.0, bottomConstant: 0.0, rightConstant: 0.0, widthConstant: 0.0, heightConstant: 0.0)
        nameLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
    }
}
