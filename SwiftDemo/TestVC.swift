//
//  TestVC.swift
//  SwiftDemo
//
//  Created by hupfei on 2025/12/10.
//

import UIKit
import SnapKit

class TestVC: UIViewController {
    
    private lazy var redView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(redView)
        redView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(100)
            make.horizontalEdges.equalToSuperview().inset(30)
        }
        
        let btn = UIButton(type: .system)
        btn.setTitle("change", for: .normal)
        btn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        view.addSubview(btn)
        btn.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(150)
            make.centerX.equalToSuperview()
        }
    }
    
    @objc func btnClick() {
        UIView.animate(withDuration: 2) {
            self.redView.snp.remakeConstraints { make in
                make.width.equalTo(200)
                make.center.equalToSuperview()
                make.height.equalTo(50)
            }
            self.view.layoutIfNeeded()
        }
    }
}
