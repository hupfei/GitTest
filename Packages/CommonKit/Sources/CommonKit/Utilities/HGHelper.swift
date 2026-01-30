import Foundation
import UIKit

// MARK: - typealias

public typealias CompletionBlock = () -> Void

// MARK: - 常量

/// 屏幕宽度
public let kScreenWidth: CGFloat = UIScreen.main.bounds.width
/// 屏幕高度
public let kScreenHeight: CGFloat = UIScreen.main.bounds.height
/// 状态栏高度
public var kStatusBarHeight: CGFloat {
    let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
    return windowScene?.statusBarManager?.statusBarFrame.height ?? 0
}

/// 导航栏高度
public let kNavigationBarHeight: CGFloat = (kStatusBarHeight + 44)
/// 底部安全区域高度
public let kSafeAreaBottomHeight: CGFloat = kStatusBarHeight > 20 ? 34 : 0

// MARK: - CGRect

public extension CGRect {
    static func setX(_ rect: CGRect, x: CGFloat) -> CGRect {
        return CGRect(origin: CGPoint(x: x, y: rect.origin.y), size: rect.size)
    }

    static func setY(_ rect: CGRect, y: CGFloat) -> CGRect {
        return CGRect(origin: CGPoint(x: rect.origin.x, y: y), size: rect.size)
    }

    static func setWidth(_ rect: CGRect, width: CGFloat) -> CGRect {
        if width < 0 { return rect }
        return CGRect(origin: rect.origin, size: CGSize(width: width, height: rect.height))
    }

    static func setHeight(_ rect: CGRect, height: CGFloat) -> CGRect {
        if height < 0 { return rect }
        return CGRect(origin: rect.origin, size: CGSize(width: rect.width, height: height))
    }
}
