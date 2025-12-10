//
//  ViewController.swift
//  SwiftDemo
//
//  Created by hupfei on 2025/9/24.
//

import SnapKit
import SwifterSwift
import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var darkMode: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        darkMode.isOn = UserDefaults.standard.bool(forKey: "darkMode")
    }
    
    // 切换深色模式
    @IBAction func changeMode(_ sender: UISwitch) {
        //同步keyWindow设置
        UIApplication.shared.connectedScenes.forEach {
            if let windowScene = $0 as? UIWindowScene {
                windowScene.windows.forEach {
                    $0.overrideUserInterfaceStyle = sender.isOn ? .dark : .light
                }
            }
        }
        
        UserDefaults.standard.set(sender.isOn, forKey: "darkMode")
        UserDefaults.standard.synchronize()
    }
}
