//
//  StampBackgroundView.swift
//  Daily
//
//  Created by hupfei on 2025/12/3.
//

import UIKit

class StampBackgroundView: UIView {
    let holeRadius: CGFloat = 3
    let holeSpacing: CGFloat = 5
    let edgeMargin: CGFloat = 5
    
    private var lastBounds: CGRect = .zero
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .red
        clipsToBounds = true
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if !lastBounds.size.equalTo(bounds.size) {
            lastBounds = bounds
            applyStampMask()
        }
    }
    
    private func applyStampMask() {
        let path = UIBezierPath(rect: bounds)
        
        addHoles(on: .minYEdge, path: path)
        addHoles(on: .maxYEdge, path: path)
        addHoles(on: .minXEdge, path: path)
        addHoles(on: .maxXEdge, path: path)
        
        let maskLayer = CAShapeLayer()
        maskLayer.fillRule = .evenOdd
        maskLayer.path = path.cgPath
        layer.mask = maskLayer
    }
    
    private func addHoles(on edge: CGRectEdge, path: UIBezierPath) {
        let length: CGFloat
        let startPoint: CGPoint
        let isHorizontal: Bool
        
        switch edge {
        case .minYEdge: // 顶部
            length = bounds.width - edgeMargin * 2
            startPoint = CGPoint(x: edgeMargin, y: 0)
            isHorizontal = true
        case .maxYEdge: // 底部
            length = bounds.width - edgeMargin * 2
            startPoint = CGPoint(x: edgeMargin, y: bounds.height)
            isHorizontal = true
        case .minXEdge: // 左侧
            length = bounds.height - edgeMargin * 2
            startPoint = CGPoint(x: 0, y: edgeMargin)
            isHorizontal = false
        case .maxXEdge: // 右侧
            length = bounds.height - edgeMargin * 2
            startPoint = CGPoint(x: bounds.width, y: edgeMargin)
            isHorizontal = false
        default:
            return
        }
        
        let step = holeRadius * 2 + holeSpacing
        let count = Int(length / step)
        
        for i in 0 ... count {
            let offset = CGFloat(i) * step + holeRadius

            let center: CGPoint
            if isHorizontal {
                center = CGPoint(
                    x: startPoint.x + offset,
                    y: startPoint.y
                )
            } else {
                center = CGPoint(
                    x: startPoint.x,
                    y: startPoint.y + offset
                )
            }
            
            path.append(
                UIBezierPath(ovalIn: CGRect(
                    x: center.x - holeRadius,
                    y: center.y - holeRadius,
                    width: holeRadius * 2,
                    height: holeRadius * 2
                ))
            )
        }
    }
}

extension StampBackgroundView {
    func setBackgroundColorSmoothly(_ newColor: UIColor, duration: CFTimeInterval = 0.25) {
        let animation = CABasicAnimation(keyPath: "backgroundColor")
        animation.fromValue = layer.backgroundColor
        animation.toValue = newColor.cgColor
        animation.duration = duration
        layer.add(animation, forKey: "bgColorAnimation")

        layer.backgroundColor = newColor.cgColor
    }
}
