//
//  TestVC.swift
//  SwiftDemo
//
//  Created by hupfei on 2025/12/10.
//

import CommonKit
import SnapKit
import UIKit

class TestVC: UIViewController {
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "IBMPlexSerif", size: 16)!
        label.text = "Hello"
        return label
    }()
    
    private lazy var label1: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "IBMPlexSerif-SmBld", size: 16)!
        label.text = "Hello"
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        view.addSubview(label1)
        label1.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}
