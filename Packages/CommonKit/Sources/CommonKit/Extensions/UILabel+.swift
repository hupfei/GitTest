import UIKit

public extension UILabel {
    convenience init(font: UIFont,
                     textColor: UIColor? = .black,
                     text: String? = nil,
                     textAlignment: NSTextAlignment = .left,
                     numberOfLines: Int = 1)
    {
        self.init(frame: .zero)
        self.font = font
        self.textColor = textColor
        self.text = text
        self.textAlignment = textAlignment
        self.numberOfLines = numberOfLines
        self.lineBreakMode = .byTruncatingTail
    }

    /// 将目标 UILabel 的样式属性设置到当前 UILabel 上
    func setTheSameAppearanceAsLabel(_ label: UILabel, text: String? = nil) {
        self.text = text
        self.font = label.font
        self.textColor = label.textColor
        self.backgroundColor = label.backgroundColor
        self.lineBreakMode = label.lineBreakMode
        self.textAlignment = label.textAlignment
        self.lineBreakMode = label.lineBreakMode
    }
}
