//
//  ViewController+TP.swift
//  TPFoundation-Swift
//
//  Created by Topredator on 2021/8/26.
//

import Foundation

extension UIViewController: NameSpaceWrappable {}
private struct AssociatedKeys {
    static var autoSetKey = "autoSetPresentationStyleKey"
}
public extension NameSpace where Base: UIViewController {
    static func autoSetModalPresentationStyle() -> Bool {
        guard Base.isKind(of: UIImagePickerController.self), Base.isKind(of: UIAlertController.self)  else {
            return true
        }
        return false
    }
    
    static func foundationSwizzling() {
        Base.self.methodSwizzling()
    }
}

extension UIViewController {
    fileprivate static func methodSwizzling() {
        FoundationSwizzling(self, #selector(present(_:animated:completion:)), #selector(tp_present(_:animated:completion:)))
    }
    @objc public dynamic func tp_present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        guard #available(iOS 13.0, *) else {
            tp_present(viewControllerToPresent, animated: flag, completion: completion)
            return
        }
        if viewControllerToPresent.autoSetPresentationStyle {
            viewControllerToPresent.modalPresentationStyle = .fullScreen
        }
        tp_present(viewControllerToPresent, animated: flag, completion: completion)
    }
    
    /// 自动设置 模态的 类型
    public var autoSetPresentationStyle: Bool {
        get {
            let presentationStyle = objc_getAssociatedObject(self, &AssociatedKeys.autoSetKey) as? NSNumber
            if let num = presentationStyle { return num.boolValue }
            return  Self.tp.autoSetModalPresentationStyle()
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.autoSetKey, NSNumber(value: newValue), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
