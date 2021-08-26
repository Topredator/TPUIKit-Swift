//
//  XTBlankView.swift
//  XTUIKit-swift
//
//  Created by Topredator on 2020/5/26.
//

import UIKit
import SnapKit

// 动画时长
private let animatedDiration: CGFloat = 0.25

/// 缺省页
open class BlankView: UIView {
    private struct AssociatedKeys {
        static var blankViewKey: ()?
    }
    lazy var contentView: UIView = {
        let view = UIView.init(frame: CGRect.zero)
        return view
    }()
    /// contentView 距离顶部距离
    private var _topOffset: CGFloat = 0
    public var topOffset: CGFloat {
        get {
            return _topOffset
        }
        set {
            if _topOffset != newValue && self.superview != nil {
                self.contentView.snp.remakeConstraints { (make) in
                    make.centerX.equalToSuperview()
                    make.left.greaterThanOrEqualToSuperview()
                    make.right.bottom.lessThanOrEqualToSuperview()
                    if newValue == 0 { make.centerY.equalToSuperview() }
                    else { make.top.equalToSuperview().offset(newValue) }
                }
            }
            _topOffset = newValue
        }
    }
    /// 本身视图位于父视图的 insets
    private var _customeEdgeInsets: UIEdgeInsets?
    public var customeEdgeInsets: UIEdgeInsets? {
        get {
            return _customeEdgeInsets
        }
        set {
            if _customeEdgeInsets != newValue && self.superview != nil {
                let offsetX = (newValue!.left - newValue!.right) / 2.0
                let offsetY = (newValue!.top - newValue!.bottom) / 2.0
                self.snp.remakeConstraints { (make) in
                    make.centerX.equalToSuperview().offset(offsetX)
                    make.centerY.equalToSuperview().offset(offsetY)
                    make.edges.equalToSuperview().inset(newValue!)
                }
            }
            _customeEdgeInsets = newValue
        }
    }
    // MARK:  ------------- Init method --------------------
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.setupSubviews()
    }
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience public init(in inView: UIView?, animated: Bool) {
        self.init(frame: CGRect.zero)
        self.show(in: inView, animated: animated)
    }
    /// 展示
    public func show(in inView: UIView?, animated: Bool) {
        // 父视图不存在
        guard let view = inView else { return }
        // 父视图上存在 blankView
        if let oldBlankView = BlankView.blank(inView: view) {
            // 是自己本身不做处理
            if oldBlankView.isEqual(self) { return }
            // 不是自己，移除
            oldBlankView.hide(animated: animated)
        }
        objc_setAssociatedObject(view, &AssociatedKeys.blankViewKey, self, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        alpha = 0
        view.addSubview(self)
        snp.makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
            make.edges.equalToSuperview().inset(UIEdgeInsets.zero)
        }
        if !animated {
            alpha = 1
            return
        }
        UIView.transition(with: self, duration: TimeInterval(animatedDiration), options: UIView.AnimationOptions.transitionCrossDissolve, animations: {
            self.alpha = 1
        }, completion: nil)
    }
    
    @discardableResult
    public static func blank(inView: UIView?) -> BlankView? {
        guard let view = inView else { return nil }
        return objc_getAssociatedObject(view, &AssociatedKeys.blankViewKey) as? BlankView
    }
    
    @discardableResult
    public static func hide(inView: UIView, animated: Bool) -> BlankView? {
        let blankView = BlankView.blank(inView: inView)
        blankView?.hide(animated: animated)
        return blankView
    }
    
    /// 隐藏
    public func hide(animated: Bool) {
        guard superview != nil else { return }
        objc_setAssociatedObject(superview!, &AssociatedKeys.blankViewKey, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        if !animated {
            self.alpha = 0
            self.removeFromSuperview()
            return
        }
        UIView.animate(withDuration: TimeInterval(animatedDiration), animations: {
            self.alpha = 0
        }) { (finished) in
            self.removeFromSuperview()
        }
    }
    
    public func setupSubviews() {
        addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.left.greaterThanOrEqualTo(0)
            make.bottom.right.lessThanOrEqualTo(0)
            if self.topOffset == 0 {
                make.centerY.equalToSuperview()
            } else {
                make.top.equalTo(self.topOffset)
            }
        }
    }
}

// MARK:  ------------- ImageBlankView --------------------
public class ImageBlankView: BlankView {
    lazy public var imageView: UIImageView = {
        let imageView = UIImageView.init(frame: CGRect.zero)
        return imageView
    }()
    public override func setupSubviews() {
        super.setupSubviews()
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets.zero)
        }
    }
    
    public func configImage(_ image: UIImage) {
        imageView.image = image
    }
}

// MARK:  ------------- TextBlankView --------------------
public class TextBlankView: ImageBlankView {
    lazy public var titleLabel: UILabel = {
        let label = UILabel.init(frame: CGRect.zero)
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = UIColor.black
        return label
    }()
    
    lazy public var subTextLabel: UILabel = {
        let label = UILabel.init(frame: CGRect.zero)
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.gray
        return label
    }()
    lazy public var refreshBtn: UIButton = {
        let btn = UIButton.init(frame: CGRect.zero)
        btn.layer.cornerRadius = 17
        btn.layer.masksToBounds = true
        btn.contentEdgeInsets = UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: 10)
        btn.setTitleColor(UIColor.white, for: UIControl.State.normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.backgroundColor = UIColor.purple
        btn.isHidden = true
        return btn
    }()
    var refreshBlock: (() -> Void)?
    public override func setupSubviews() {
        super.setupSubviews()
        contentView.addSubview(titleLabel)
        contentView.addSubview(subTextLabel)
        contentView.addSubview(refreshBtn)
        
        imageView.snp.remakeConstraints { (make) in
            make.centerX.top.equalToSuperview()
            make.left.greaterThanOrEqualTo(10)
            make.right.lessThanOrEqualTo(-10)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.imageView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.left.greaterThanOrEqualTo(10)
            make.right.lessThanOrEqualTo(-10)
        }
        subTextLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
            make.left.greaterThanOrEqualTo(10)
            make.right.lessThanOrEqualTo(-10)
        }
        refreshBtn.snp.makeConstraints { (make) in
            make.top.equalTo(self.subTextLabel.snp.bottom).offset(25)
            make.bottom.equalTo(-20)
            make.centerX.equalToSuperview()
            make.height.equalTo(34)
            make.width.lessThanOrEqualTo(220)
            make.width.greaterThanOrEqualTo(130)
        }
    }
    // MARK:  ------------- 配置信息 --------------------
    /// 文案配置
    public func config(title: String?, subText: String? = nil) {
        titleLabel.text = title
        subTextLabel.text = subText
        titleLabel.snp.updateConstraints { (make) in
            make.top.equalTo(self.imageView.snp.bottom).offset(self.stringVerify(title) ? 10 : 0)
        }
        subTextLabel.snp.updateConstraints { (make) in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(self.stringVerify(subText) ? 15 : 0)
        }
        contentView.layoutIfNeeded()
    }
    /// 按钮配置 T-A
    public func configBtn(title: String?, target: Any?, selector: Selector?) {
        refreshBtn.isHidden = true
        if let _ = title { refreshBtn.isHidden = false }
        refreshBtn.setTitle(title, for: UIControl.State.normal)
        refreshBtn.isHidden = !stringVerify(title)
        refreshBtn.removeTarget(nil, action: nil, for: UIControl.Event.touchUpInside)
        if let target = target, let selector = selector {
            refreshBtn.addTarget(target, action: selector, for: UIControl.Event.touchUpInside)
        }
        refreshBtn.snp.updateConstraints { (make) in
            make.top.equalTo(self.subTextLabel.snp.bottom).offset(self.stringVerify(title) ? 25 :  0)
        }
        contentView.layoutIfNeeded()
    }
    /// 按钮配置 block形式
    public func configBtn(title: String?, actionBlock: (() -> Void)?) {
        refreshBlock = actionBlock
        configBtn(title: title, target: self, selector: #selector(actionRefresh))
    }
    
    
    @objc func actionRefresh() {
        refreshBlock?()
    }
    
    /// 字符串判断不为空
    private func stringVerify(_ str: String?) -> Bool {
        guard let str = str else { return false }
        guard str.count > 0 else { return false }
        return true
    }
}
