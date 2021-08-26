//
//  XTMarginLabel.swift
//  XTUIKit-Swift
//
//  Created by Topredator on 2020/5/29.
//

import UIKit

/// 可设置 内容边框的label
public class MarginLabel: UILabel {
    public var textInsets: UIEdgeInsets = .zero
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    public convenience init(inset: UIEdgeInsets) {
        self.init(frame: CGRect.zero)
        self.textInsets = inset
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: self.textInsets))
    }
    public override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        size.width += self.textInsets.left + self.textInsets.right
        size.height += self.textInsets.top + self.textInsets.bottom
        return size
    }
}
