import Foundation
import SwifterSwift
import UIKit

public class HGUILabel: UILabel {
    /// 圆角保持为高度的 1/2
    public var cornerRadiusAdjustsBounds = false
    
    /// 控制label内容的padding
    public var contentEdgeInsets: UIEdgeInsets = .zero {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override public func sizeThatFits(_ size: CGSize) -> CGSize {
        var newSize = super.sizeThatFits(CGSize(width: size.width - contentEdgeInsets.horizontal, height: size.height - contentEdgeInsets.vertical))
        newSize.width += contentEdgeInsets.horizontal
        newSize.height += contentEdgeInsets.vertical
        return newSize
    }
    
    override public var intrinsicContentSize: CGSize {
        var preferredMaxLayoutWidth = self.preferredMaxLayoutWidth
        if preferredMaxLayoutWidth <= 0 {
            preferredMaxLayoutWidth = CGFloat.greatestFiniteMagnitude
        }
        return sizeThatFits(CGSize(width: preferredMaxLayoutWidth, height: CGFloat.greatestFiniteMagnitude))
    }
    
    override public func drawText(in rect: CGRect) {
        var newRect = rect.inset(by: contentEdgeInsets)
        if numberOfLines == 1, lineBreakMode == .byWordWrapping || lineBreakMode == .byCharWrapping {
            newRect = CGRect.setHeight(newRect, height: newRect.height + contentEdgeInsets.top * 2)
        }
        super.drawText(in: newRect)
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        if bounds.isEmpty {
            return
        }
        
        if cornerRadiusAdjustsBounds {
            layer.cornerRadius = bounds.height / 2
            layer.masksToBounds = true
        }
    }
}
