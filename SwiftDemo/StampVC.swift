//
//  StampVC.swift
//  SwiftDemo
//
//  Created by hupfei on 2025/12/9.
//

import AVFAudio
import Lottie
import SnapKit
import SwifterSwift
import UIKit

class StampVC: UIViewController {
    private lazy var animationView: LottieAnimationView = {
        let animationView = LottieAnimationView()
        animationView.contentMode = .scaleAspectFit
        return animationView
    }()

    var displayLink: CADisplayLink?

    private let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)

    private let planStampFile1 = "pp_plan_1"
    private let planStampFile2 = "pp_plan_2"
    private let planStampFile3 = "pp_plan_3"

    /// 使用统一数据结构定义触发点
    private struct ProgressTrigger {
        let time: CGFloat
        let action: () -> Void
        var didTrigger: Bool = false
    }

    /// 所有触发事件，按时间排序
    private lazy var triggers: [ProgressTrigger] = [
        ProgressTrigger(time: 0.01) { [weak self] in
            guard let self else { return }
            AudioPreloadManager.shared.play(self.planStampFile1)
        },
        ProgressTrigger(time: 1.3) { [weak self] in
            guard let self else { return }
            AudioPreloadManager.shared.play(self.planStampFile2)
            self.impactFeedbackGenerator.impactOccurred()
        },
        ProgressTrigger(time: 1.8) { [weak self] in
            self?.impactFeedbackGenerator.impactOccurred()
        },
        ProgressTrigger(time: 2.1) { [weak self] in
            self?.impactFeedbackGenerator.impactOccurred()
        },
        ProgressTrigger(time: 2.7) { [weak self] in
            guard let self else { return }
            AudioPreloadManager.shared.play(self.planStampFile3)
            self.impactFeedbackGenerator.impactOccurred()
        }
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        impactFeedbackGenerator.prepare()
        AudioPreloadManager.shared.preload(files: [planStampFile1, planStampFile2, planStampFile3])

        displayLink = CADisplayLink(target: self, selector: #selector(updateProgress))
        displayLink?.add(to: .main, forMode: .common)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        showAnimation()
    }
    
    
    func showAnimation() {
        animationView.animation = LottieAnimation.named(overrideUserInterfaceStyle == .dark ? "pp_session_finish_dark" : "pp_session_finish")
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .playOnce
        view.addSubview(animationView)
        animationView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        print("开始播放")
        animationView.play { [weak self] completed in
            if completed {
                print("播放完成")
                self?.displayLink?.invalidate()
            }
        }
    }

    @objc func updateProgress() {
        let currentTime = animationView.currentTime

        for i in triggers.indices {
            if !triggers[i].didTrigger, currentTime >= triggers[i].time {
                triggers[i].didTrigger = true
                triggers[i].action()
            }
        }
    }

    deinit {
        displayLink?.invalidate()
    }
}

/// 预加载所有音频，避免播放时卡顿
class AudioPreloadManager: NSObject {
    static let shared = AudioPreloadManager()
    override private init() {}

    private var cachedPlayers: [String: AVAudioPlayer] = [:]
    private var activePlayers: Set<AVAudioPlayer> = []
    private let lock = NSLock()

    func preload(files: [String]) {
        lock.lock()
        defer { lock.unlock() }

        for name in files where cachedPlayers[name] == nil {
            guard
                let url = Bundle.main.url(forResource: name, withExtension: "mp3"),
                let player = try? AVAudioPlayer(contentsOf: url)
            else { continue }

            player.prepareToPlay()
            cachedPlayers[name] = player
        }
    }

    func play(_ fileName: String) {
        lock.lock()
        defer { lock.unlock() }

        guard let player = cachedPlayers[fileName] else { return }

        player.stop()
        player.currentTime = 0
        player.prepareToPlay()
        player.play()

        activePlayers.insert(player)
        player.delegate = self
    }
}

extension AudioPreloadManager: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        lock.lock()
        activePlayers.remove(player)
        lock.unlock()
    }
}
