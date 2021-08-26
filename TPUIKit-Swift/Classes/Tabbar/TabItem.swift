//
//  TabItem.swift
//  XTUIKit-Swift
//
//  Created by Topredator on 2020/5/29.
//

import UIKit

/// tabbar 的 item
public class TabItem: UIButton {
    /// 父视图中下标
    public var index: Int?
    /// badge样式：默认数字
    public var badgeStyle: TabItem.BadgeStyle = .Number
    public var badge: Int = 0 /// badgestyle==.Number时使用
    public var indicatorInset: UIEdgeInsets = UIEdgeInsets.zero
    /// image、title 竖直方向 偏移量
    var verticalOffset: CGFloat = 0
    /// 间距
    var spacing: CGFloat = 0
    /// badge控件 位置 参数
    var badgeTop: CGFloat = 0
    var badgeCenterRight: CGFloat = 0
    var badgeHorizonalSpace: CGFloat = 0
    var badgeVerticalSpace: CGFloat = 0
    /// 圆点直径
    var badgeDiameter: CGFloat = 0
    // MARK:  ------------- setter getter --------------------
    /// badge文字大小
    private var _badgeTitleFont: UIFont = UIFont.systemFont(ofSize: 13)
    public var badgeTitleFont: UIFont {
        get { return _badgeTitleFont }
        set {
            _badgeTitleFont = newValue
            self.badgeLabel.font = newValue
        }
    }
    /// badge文字颜色
    private var _badgeTitleColor: UIColor?
    public var badgeTitleColor: UIColor? {
        get { return _badgeTitleColor }
        set {
            _badgeTitleColor = newValue
            self.badgeLabel.textColor = newValue
        }
    }
    /// badge背景色
    private var _badgeBgColor: UIColor?
    public var badgeBgColor: UIColor? {
        get { return _badgeBgColor! }
        set {
            _badgeBgColor = newValue
            self.badgeLabel.backgroundColor = newValue
        }
    }
    /// img 与 title 水平居中
    private var _contentHorizontalCenter: Bool = false
    public var contentHorizontalCenter: Bool {
        get { return _contentHorizontalCenter }
        set {
            _contentHorizontalCenter = newValue
            if !_contentHorizontalCenter {
                self.verticalOffset = 0
                self.spacing = 0
            }
            if self.superview != nil {
                self.layoutSubviews()
            }
        }
    }
    /// item 缩放前frame
    private var _frameWithOutTransform: CGRect?
    public var frameWithOutTransform: CGRect {
        get {
            return _frameWithOutTransform!
        }
    }
    /// 设置self.frame.size
    public var size: CGSize {
        get { return self.frame.size }
        set {
            var rect = self.frame
            rect.size = newValue
            self.frame = rect
        }
    }
    
    lazy var badgeLabel: UILabel = {
        let label = UILabel.init(frame: CGRect.zero)
        label.clipsToBounds = true
        label.font = UIFont.systemFont(ofSize: 13)
        label.isHidden = true
        return label
    }()
    // MARK:  ------------- init method --------------------
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setup() {
        self.addSubview(self.badgeLabel)
        self.adjustsImageWhenHighlighted = false
        
    }
    // MARK:  ------------- public method --------------------
    
    /// 设置image、title水平居中
    /// - Parameters:
    ///   - verticalOffset: 竖直方向偏移量
    ///   - spacing: 间距
    public func setContentHorizontalCenter(with verticalOffset: CGFloat, spacing: CGFloat) {
        self.verticalOffset = verticalOffset
        self.spacing = spacing
        self.contentHorizontalCenter = true
    }
    
    
    /// 设置数字badge位置
    /// - Parameters:
    ///   - top: 与Item顶部距离
    ///   - centerRight: 中心点 与 Item右侧位置
    ///   - titleHorizonalSpace: 文字水平方向的间距
    ///   - titleVerticalSpace: 文字竖直方向的间距
    public func setNumberBadge(toItem top: CGFloat, centerRight: CGFloat, titleHorizonalSpace: CGFloat, titleVerticalSpace: CGFloat) {
        if self.badgeStyle == .Dot {
            return
        }
        self.badgeTop = top
        self.badgeCenterRight = centerRight
        self.badgeHorizonalSpace = titleHorizonalSpace
        self.badgeVerticalSpace = titleVerticalSpace
        self.updateBadge()
    }
    
    
    /// 设置小圆点badge的位置
    /// - Parameters:
    ///   - top: 与Item顶部距离
    ///   - centerRight: 中心点 与 Item右侧位置
    ///   - sideLength: 小圆点直径
    public func setDotBadge(toItem top: CGFloat, centerRight: CGFloat, sideLength: CGFloat) {
        if self.badgeStyle == .Number {
            return
        }
        self.badgeTop = top
        self.badgeCenterRight = centerRight
        self.badgeDiameter = sideLength
        self.updateBadge()
    }
    /// 指示器的frame
    public func indicatorFrame() -> CGRect {
        let frame = self.frameWithOutTransform
        let insets = self.indicatorInset
        return CGRect.init(x: frame.origin.x + insets.left, y: frame.origin.y + insets.top, width: frame.width - insets.left - insets.right, height: frame.height - insets.top - insets.bottom)
    }
    /// 文字的宽度
    public func titleWidth() -> CGFloat {
        if (self.titleLabel?.text!.isEmpty)! {
            return 0
        }
        let text = self.titleLabel!.text!
        let size = CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let estimatedFrame = NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: self.titleLabel?.font! as Any], context: nil)
        return CGFloat(ceilf(Float(estimatedFrame.width)))
    }
    // MARK:  ------------- private method --------------------
    /// 更新badge
    func updateBadge() {
        switch self.badgeStyle {
        case .Number:
            self.badgeLabel.isHidden = self.badge <= 0
            var badgeNum = String(self.badge)
            if self.badge > 99 {
                badgeNum = "99+"
            }
            let size = CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estimatedSize = NSString(string: badgeNum).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font : self.badgeLabel.font!], context: nil).size
            // 计算badgeButton的宽度和高度
            var width: CGFloat = CGFloat(ceilf(Float(estimatedSize.width))) + self.badgeHorizonalSpace
            let height: CGFloat = CGFloat(ceilf(Float(estimatedSize.height))) + self.badgeVerticalSpace
            // 宽度取width和height的较大值，使badge为个位数时，badgeButton为圆形
            width = max(width, height)
            self.badgeLabel.frame = CGRect.init(x: self.bounds.width - width / 2 - self.badgeCenterRight, y: self.badgeTop, width: width, height: height)
            self.badgeLabel.layer.cornerRadius = height / 2
            self.badgeLabel.text = badgeNum
            break
        default:
            self.badgeLabel.text = ""
            self.badgeLabel.frame = CGRect.init(x: self.bounds.width - self.badgeCenterRight - self.badgeDiameter, y: self.badgeTop, width: self.badgeDiameter, height: self.badgeDiameter)
            self.badgeLabel.layer.cornerRadius = self.badgeDiameter / 2
            self.badgeLabel.isHidden = false
            break
        }
        self.badgeLabel.layer.masksToBounds = true
    }
    // MARK:  ------------- override method --------------------
    override public var frame: CGRect {
        didSet {
            super.frame = frame
            _frameWithOutTransform = frame
            self.updateBadge()
        }
    }
    public override func layoutSubviews() {
        super.layoutSubviews()
        // 图片不为空 且 水平布局
        if self.image(for: .normal) != nil && self.contentHorizontalCenter {
            var titleSize = self.titleLabel?.frame.size
            let imageSize = self.imageView?.frame.size
            titleSize = CGSize.init(width: CGFloat(ceilf(Float(titleSize!.width))), height: CGFloat(ceilf(Float(titleSize!.height))))
            let totalHeight = imageSize!.height + titleSize!.height + self.spacing
            self.imageEdgeInsets = UIEdgeInsets.init(top: -(totalHeight - imageSize!.height - self.verticalOffset), left: 0, bottom: 0, right: -titleSize!.width)
        } else {
            self.imageEdgeInsets = UIEdgeInsets.zero
            self.titleEdgeInsets = UIEdgeInsets.zero
        }
    }
    public override var isHighlighted: Bool {
        didSet {
            if self.adjustsImageWhenHighlighted {
                super.isHighlighted = isHighlighted
            }
        }
    }
}

extension TabItem {
    public enum BadgeStyle { // 数字、圆点
        case Number, Dot
    }
}
