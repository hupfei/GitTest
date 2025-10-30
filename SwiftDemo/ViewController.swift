//
//  ViewController.swift
//  SwiftDemo
//
//  Created by hupfei on 2025/9/24.
//https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupButton()
    }
            
    // MARK: - Functions
    @objc func startActivity() {
        
    }
    
    
    func setupButton() {
        let button = UIButton(type: .system)
        button.setTitle("启动", for: .normal)
        button.backgroundColor = .blue
        button.setTitleColor(.white, for: .normal)
        button.frame = CGRect(x: 20, y: 420, width: 150, height: 50)
        button.addTarget(self, action: #selector(startActivity), for: .touchUpInside)
        button.layer.cornerRadius = 8
        view.addSubview(button)
    }
}
