//
//  TestVC.swift
//  SwiftDemo
//
//  Created by hupfei on 2025/9/28.
//
//https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4

import UIKit
import AVKit
import AVFoundation

class TestVC: UIViewController, AVPictureInPictureControllerDelegate{
    var player: AVPlayer!
    var playerLayer: AVPlayerLayer!
    var pipController: AVPictureInPictureController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAudioSession()
        setupPlayer()
        setupPIPButton()
        setupNotifications()
    }
    
    deinit {
        // 移除通知监听
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Functions
    func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .moviePlayback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("音频会话设置失败: \(error)")
        }
    }
    
    func setupPlayer() {
        // 使用可靠的测试视频链接
        let testVideoURL = URL(string: "https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4")!
        
        player = AVPlayer(url: testVideoURL)
        
        // 创建自定义播放器图层 - 不会有任何控制按钮
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = CGRect(x: 0, y: 100, width: view.bounds.width, height: 300)
        playerLayer.videoGravity = .resizeAspect
        view.layer.addSublayer(playerLayer)
        
        // 设置 PiP
        setupPictureInPicture()
        
        // 开始播放
        player.play()
    }
    
    func setupPictureInPicture() {
        guard AVPictureInPictureController.isPictureInPictureSupported() else {
            print("该设备不支持画中画")
            return
        }
        
        pipController = AVPictureInPictureController(playerLayer: playerLayer)
        pipController?.delegate = self
    }
    
    func setupPIPButton() {
        let button = UIButton(type: .system)
        button.setTitle("启动", for: .normal)
        button.backgroundColor = .blue
        button.setTitleColor(.white, for: .normal)
        button.frame = CGRect(x: 20, y: 420, width: 150, height: 50)
        button.addTarget(self, action: #selector(togglePiP), for: .touchUpInside)
        button.layer.cornerRadius = 8
        view.addSubview(button)
    }
    
    // 设置通知监听
    func setupNotifications() {
        // 监听应用进入后台
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appDidEnterBackground),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )
        
        // 监听应用回到前台
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appWillEnterForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
    }
    
    @objc func appDidEnterBackground() {
        print("应用进入后台")
        
        // 检查是否支持 PiP
        guard AVPictureInPictureController.isPictureInPictureSupported() else {
            print("设备不支持画中画")
            return
        }
        
        // 检查 PiP 控制器是否已初始化
        guard let pipController = pipController else {
            print("PiP 控制器未初始化")
            return
        }
        
        // 检查 PiP 是否已经在运行
        guard !pipController.isPictureInPictureActive else {
            print("PiP 已经在运行")
            return
        }
        
        // 启动 PiP
        pipController.startPictureInPicture()
    }
    
    @objc func appWillEnterForeground() {
        print("应用回到前台")
        
        // 检查 PiP 是否在运行
        if let pipController = pipController, pipController.isPictureInPictureActive {
            // 停止 PiP
            pipController.stopPictureInPicture()
        }
    }
    
    @objc func togglePiP() {
        guard let pipController = pipController else {
            print("PiP 控制器未初始化")
            return
        }
        
        if pipController.isPictureInPictureActive {
            pipController.stopPictureInPicture()
        } else {
            pipController.startPictureInPicture()
        }
    }
    
    // MARK: - PiP Delegate Methods
    func pictureInPictureControllerWillStartPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        print("画中画即将启动")
    }
    
    func pictureInPictureControllerDidStartPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        print("画中画已启动")
    }
    
    func pictureInPictureControllerWillStopPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        print("画中画即将停止")
    }
    
    func pictureInPictureControllerDidStopPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        print("画中画已停止")
    }
    
    func pictureInPictureController(_ pictureInPictureController: AVPictureInPictureController, failedToStartPictureInPictureWithError error: Error) {
        print("画中画启动失败: \(error.localizedDescription)")
    }
    
    // 确保在视图大小变化时调整 playerLayer
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer.frame = CGRect(x: 0, y: 100, width: view.bounds.width, height: 300)
    }
}
