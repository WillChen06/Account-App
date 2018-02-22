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
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init has not been impelemented.")
    }
    
    fileprivate func setupViews() {
        
    }
}
