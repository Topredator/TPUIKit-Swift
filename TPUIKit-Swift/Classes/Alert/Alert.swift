//
//  Alert.swift
//  XTUIKit-Swift
//
//  Created by Topredator on 2021/3/30.
//

import Foundation

public typealias MakerBlock = (AlertMaker) -> Void

/// 系统alert 封装
public struct Alert {
    
    /// alert 类型的系统alert
    /// - Parameters:
    ///   - make: 内容管理者
    ///   - completion: 模态后的回调
    public static func alert(_ make: MakerBlock, _ completion: Block? = nil) {
        let alertMaker = AlertMaker()
        make(alertMaker)
        Self.buildAlert(alertMark: alertMaker, completion: completion)
    }
    
    /// sheet类型的 系统Alert
    /// - Parameters:
    ///   - make: 内容管理者
    ///   - completion: 模态后的回调
    public static func sheetAlert(_ make: MakerBlock, _ completion: Block? = nil) {
        let alertMaker = AlertMaker(.actionSheet)
        make(alertMaker)
        Self.buildAlert(alertMark: alertMaker, completion: completion)
    }

    /// 开始构建
    /// - Parameter completion: 回调
    private static func buildAlert(alertMark: AlertMaker, completion: Block?) {
        guard alertMark.options.count > 0 else { return }
        // iPad 不能展示 sheet模式
        if alertMark.alertStyle == .actionSheet && UIDevice.current.userInterfaceIdiom == .pad {
            alertMark.alertStyle = .alert
        }
        let alertVC = UIAlertController(title: alertMark.alertTitle, message: alertMark.alertMsg, preferredStyle: alertMark.alertStyle)
        for option in alertMark.options {
            let actionModel = UIAlertAction(title: option.title, style: option.actionStyle) { (action) in
                option.block?()
                if let target = option.target, let selector = option.selector {
                    let _ = target.perform(selector)
                }
            }
            if let textColor = option.textColor {
                actionModel.setValue(textColor, forKey: "titleTextColor")
            }
            alertVC.addAction(actionModel)
        }
        let current = Self.currentVC(UIApplication.shared.keyWindow?.rootViewController)
        current?.present(alertVC, animated: true, completion: completion)
    }
    
    
    /// 递归 获取当前视图
    /// - Parameter from: 根视图
    private static func currentVC(_ from: UIViewController?) -> UIViewController? {
        guard let fromVC = from else { return nil }
        
        if fromVC is UINavigationController {
            return currentVC((fromVC as! UINavigationController).viewControllers.last)
        } else if fromVC is UITabBarController {
            return currentVC((fromVC as! UITabBarController).selectedViewController)
        } else if (fromVC as UIViewController).presentedViewController != nil {
            return currentVC(fromVC.presentedViewController)
        } else {
            return fromVC
        }
    }
}

