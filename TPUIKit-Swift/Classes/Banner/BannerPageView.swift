//
//  BannerPageView.swift
//  XTUIKit-Swift
//
//  Created by Topredator on 2020/5/27.
//

import UIKit

open class BannerPageView: UIView {
    /// 只读 标识符
    private(set) var reuseIdentifier: String?
    /// 点击手势
    private var _tapGR: UITapGestureRecognizer? = nil
    public var tapGR: UITapGestureRecognizer! {
        get {
            if _tapGR == nil {
                let tap = UITapGestureRecognizer()
                tap.isEnabled = false
                _tapGR = tap
            }
            return _tapGR
        }
    }
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        self.reuseIdentifier = String(describing: BannerPageView.self)
    }
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    public convenience init(reuseIdentifier: String) {
        self.init(frame: CGRect.zero)
        self.reuseIdentifier = reuseIdentifier
        self.addGestureRecognizer(self.tapGR)
    }
    public func preparedForReuse() {}
}
