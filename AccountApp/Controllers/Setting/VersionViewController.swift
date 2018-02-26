//
//  VersionViewController.swift
//  AccountApp
//
//  Created by Chen Kuan Chung on 2018/02/25.
//  Copyright © 2018年 william. All rights reserved.
//

import UIKit

class VersionViewController: UIViewController {
    
    // MARK: - Properties
    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage.appIcon
        return imageView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17.0)
        label.textAlignment = .center
        label.text = .appName
        return label
    }()
    
    lazy var versionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17.0)
        label.textAlignment = .center
        label.text = .appVersion
        return label
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Setup
    private func setupViews() {
        navigationItem.title = .info
        view.backgroundColor = .white
        view.addSubview(iconImageView)
        view.addSubview(nameLabel)
        view.addSubview(versionLabel)
        
        iconImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        iconImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        iconImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        iconImageView.heightAnchor.constraint(equalTo: iconImageView.widthAnchor).isActive = true
        nameLabel.anchor(top: iconImageView.bottomAnchor, left: nil, bottom: nil, right: nil, topConstant: 8.0, leftConstant: 0.0, bottomConstant: 0.0, rightConstant: 0.0, widthConstant: 0.0, heightConstant: 30.0)
        nameLabel.widthAnchor.constraint(equalTo: iconImageView.widthAnchor).isActive = true
        nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        versionLabel.anchor(top: nameLabel.bottomAnchor, left: nil, bottom: nil, right: nil, topConstant: 8.0, leftConstant: 0.0, bottomConstant: 0.0, rightConstant: 0.0, widthConstant: 0.0, heightConstant: 30.0)
        versionLabel.widthAnchor.constraint(equalTo: iconImageView.widthAnchor).isActive = true
        versionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
