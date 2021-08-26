//
//  ViewController+XT.swift
//  XTUIKit-Swift
//
//  Created by Topredator on 2021/3/31.
//

import Foundation
import TPFoundation_Swift

open class XTNavigationItem {
    /// view 出现中
    fileprivate var isViewAppearing: Bool = false
    /// view 正在消失中
    fileprivate var isViewDisappearing: Bool = false
    /// 隐藏navigationbar
    private var _navigaitonBarHidden: Bool = false
    public var navigaitonBarHidden: Bool {
        set { set(navigaitonBar: newValue, animated: false) }
        get { _navigaitonBarHidden }
    }
    /// 禁用 右滑返回
    public var disableInteractivePopGestureRecognizer: Bool = false
    public weak var navigationController: UINavigationController?
    
    public init(navigationBar hidden: Bool, disablePop: Bool = false) {
        self.navigaitonBarHidden = hidden
        self.disableInteractivePopGestureRecognizer = disablePop
    }
    public func set(navigaitonBar hidden: Bool, animated: Bool) {
        _navigaitonBarHidden = hidden
        updateNavigaitonBarHidden(animated)
    }
    /// 更新 navigaitonBar显隐
    /// - Parameter animated: 是否动画执行
    public func updateNavigaitonBarHidden(_ animated: Bool) {
        guard let navigationVC = self.navigationController else { return }
        if navigationVC.isNavigationBarHidden != navigaitonBarHidden  {
            navigationVC.setNavigationBarHidden(navigaitonBarHidden, animated: animated)
        }
    }
}


// MARK:  ------------- UIViewController 前缀扩展 --------------------
private struct AssociatedKeys {
    static let navigationItemKey = "xtuikit.base.navigationItem.key"
}
extension NameSpace where Base: UIViewController {
    public var navigationItem: XTNavigationItem {
        get {
            var xt_navigationItem = objc_getAssociatedObject(base, AssociatedKeys.navigationItemKey) as? XTNavigationItem
            if xt_navigationItem == nil {
                xt_navigationItem = XTNavigationItem(navigationBar: false)
                objc_setAssociatedObject(base, AssociatedKeys.navigationItemKey, xt_navigationItem, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            return xt_navigationItem!
        }
    }
    
    /// 调整 控制器中 scrollview的 insets
    /// - Parameter scroll: 滚动视图
    public func adjust(scrollInsets scroll: UIScrollView) {
        if UIScrollView.instancesRespond(to: NSSelectorFromString("setContentInsetAdjustmentBehavior:")) {
            scroll.perform(NSSelectorFromString("setContentInsetAdjustmentBehavior:"), with: 2)
        }else {
            base.automaticallyAdjustsScrollViewInsets = false
        }
    }
    
    public static func UIKitSwizzling() {
        Base.tp.foundationSwizzling()
        Base.xt_swizzle()
    }
    
}
// MARK:  ------------- UIViewController 扩展 --------------------
extension UIViewController {
    @objc dynamic func _xt_viewWillAppear(_ animated: Bool) {
        self.tp.navigationItem.isViewAppearing = true
        _xt_viewWillAppear(animated)
    }
    @objc dynamic func _xt_viewDidAppear(_ animated: Bool) {
        // 正在消失
        self.tp.navigationItem.isViewAppearing = false
        if self.tp.navigationItem.isViewDisappearing {
            DispatchQueue.main.async { self.tp.navigationItem.updateNavigaitonBarHidden(false) }
        }
        _xt_viewDidAppear(animated)
    }
    @objc dynamic func _xt_viewWillDisappear(_ animated: Bool) {
        self.tp.navigationItem.isViewDisappearing = true
        _xt_viewWillDisappear(animated)
    }
    @objc dynamic func _xt_viewDidDisappear(_ animated: Bool) {
        self.tp.navigationItem.isViewDisappearing = false
        _xt_viewDidDisappear(animated)
    }
    /// 执行 方法替换操作
    public static func xt_swizzle() {
        FoundationSwizzling(self, #selector(viewWillAppear(_:)), #selector(_xt_viewWillAppear(_:)))
        FoundationSwizzling(self, #selector(viewDidAppear(_:)), #selector(_xt_viewDidAppear(_:)))
        FoundationSwizzling(self, #selector(viewWillDisappear(_:)), #selector(_xt_viewWillDisappear(_:)))
        FoundationSwizzling(self, #selector(viewDidDisappear(_:)), #selector(_xt_viewDidDisappear(_:)))
    }
}
