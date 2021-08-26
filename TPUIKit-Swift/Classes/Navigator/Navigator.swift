//
//  Navigator.swift
//  XTUIKit-Swift
//
//  Created by Topredator on 2020/5/27.
//

import UIKit

/// 导航 控制器
public struct Navigator {
    /// 当前控制器
    public static func currentVC() -> UIViewController? {
        let rootVC = UIApplication.shared.keyWindow?.rootViewController
        return self.current(from: rootVC)
    }
    /// 当前导航控制器
    public static func currentNavigationVC() -> UINavigationController? {
        return self.currentVC()?.navigationController
    }
    // MARK:  ------------- push --------------------
    /// push
    public static func push(_ targetVC: UIViewController?, animated: Bool = true) {
        guard let target = targetVC, !(target is UINavigationController) else { return }
        guard let navigaitonVC = self.currentNavigationVC() else { return }
        navigaitonVC.pushViewController(target, animated: animated)
    }
    // MARK:  ------------- present 模态 --------------------
    public static func present(_ targetVC: UIViewController?, animated: Bool) {
        self.present(targetVC, animated: animated, completion: nil)
    }
    public static func present(_ targetVC: UIViewController?, animated: Bool = true, completion: (() -> Void)? = nil) {
        guard let navigationVC = self.currentNavigationVC(), let target = targetVC else { return }
        navigationVC.present(target, animated: animated, completion: completion)
    }
    // MARK:  ------------- pop --------------------
    public static func pop(_ withTimes: Int, animated: Bool) {
        guard let currentNavigationVC = self.currentNavigationVC() else { return }
        let count: Int = currentNavigationVC.viewControllers.count
        if count > withTimes {
            currentNavigationVC.popToViewController(currentNavigationVC.viewControllers[count - 1 - withTimes], animated: animated)
        }
    }
    public static func popToRootVC(animated: Bool) {
        guard let currentNavigationVC = self.currentNavigationVC() else { return }
    
        let count: Int = currentNavigationVC.viewControllers.count
        self.pop(count-1, animated: animated)
    }
    // MARK:  ------------- dismiss --------------------
    public static func dismissVC(_ withTimes: Int, animated: Bool, completion: (() -> Void)?) {
        guard var currentVC = self.currentVC(), (currentVC.presentingViewController != nil) else {
            return
        }
        var times = withTimes
        while times > 0 {
            currentVC = currentVC.presentingViewController!
            if currentVC.presentingViewController == nil { break }
            times -= 1
        }
        currentVC.dismiss(animated: animated, completion: completion)
    }
    public static func dismissToRoot(animated: Bool, completion: (() -> Void)? = nil) {
        guard var currentVC = self.currentVC(), (currentVC.presentingViewController != nil) else {
            return
        }
        while currentVC.presentingViewController != nil {
            currentVC = currentVC.presentingViewController!
        }
        currentVC.dismiss(animated: animated, completion: completion)
    }
    /// 递归 拿到当前控制器
    /// - Parameter from: root
    /// - Returns: 当前控制器
    static func current(from: UIViewController?) -> UIViewController? {
        if from is UINavigationController {
            return self.current(from: (from as! UINavigationController).viewControllers.last)
        } else if from is UITabBarController {
            return self.current(from: (from as! UITabBarController).selectedViewController)
        } else if from?.presentedViewController != nil {
            return self.current(from: from?.presentedViewController)
        } else {
            return from
        }
    }
    
}
