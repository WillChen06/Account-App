//
//  LocalNotificationCell.swift
//  AccountApp
//
//  Created by Chen Kuan Chung on 2018/02/25.
//  Copyright © 2018年 william. All rights reserved.
//

import UIKit

class LocalNotificationCell: UITableViewCell {
    
    var delegate: SettingViewControllerDelegate?
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17.0)
        label.text = .dailyNotification
        return label
    }()
    
    lazy var switchButton: UISwitch = {
        let switchButton = UISwitch()
        switchButton.translatesAutoresizingMaskIntoConstraints = false
        switchButton.setOn(UserDefaults.standard.isNotificationMode(), animated: true)
        switchButton.addTarget(self, action: #selector(switchValue(_:)), for: .valueChanged)
        return switchButton
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init has not been implemented.")
    }
    
    fileprivate func setupViews() {
//        accessoryType = .disclosureIndicator
        addSubview(titleLabel)
        addSubview(switchButton)
        
        titleLabel.anchor(top: nil, left: contentView.leftAnchor, bottom: nil, right: nil, topConstant: 0.0, leftConstant: 8.0, bottomConstant: 0.0, rightConstant: 0.0, widthConstant: 150.0, heightConstant: 0.0)
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        switchButton.anchor(top: nil, left: nil, bottom: nil, right: contentView.rightAnchor, topConstant: 0.0, leftConstant: 0.0, bottomConstant: 0.0, rightConstant: 8.0, widthConstant: 0.0, heightConstant: 0.0)
        switchButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    @objc func switchValue(_ sender: UISwitch) {
        delegate?.switchMode(sender)
    }
}
