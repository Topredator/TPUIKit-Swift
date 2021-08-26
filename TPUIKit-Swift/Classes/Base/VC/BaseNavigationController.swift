//
//  XTBaseNavigationController.swift
//  XTUIKit-Swift
//
//  Created by Topredator on 2020/6/2.
//

import UIKit
open class BaseNavigationController: UINavigationController, UIGestureRecognizerDelegate, UINavigationControllerDelegate {

    open override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.interactivePopGestureRecognizer?.delegate = self
        super.delegate = self
    }
    open override var shouldAutorotate: Bool {
        return self.topViewController?.shouldAutorotate ?? false
    }
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return self.topViewController?.supportedInterfaceOrientations ?? .portrait
    }
    open override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return self.topViewController?.preferredInterfaceOrientationForPresentation ?? .portrait
    }
    // MARK:  ------------- UIGestureRecognizerDelegate --------------------
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == self.interactivePopGestureRecognizer {
            if self.viewControllers.count < 2 || self.visibleViewController == self.viewControllers.first {
                return false
            }
            let topVC: UIViewController = self.topViewController!
            return !(topVC.tp.navigationItem.disableInteractivePopGestureRecognizer)
        }
        return true
    }
    // MARK:  ------------- UINavigationControllerDelegate --------------------
    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        viewController.tp.navigationItem.navigationController = self
        viewController.tp.navigationItem.updateNavigaitonBarHidden(animated)
    }
    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if self.responds(to: #selector(getter: interactivePopGestureRecognizer)) {
            self.interactivePopGestureRecognizer?.isEnabled = !(viewController.tp.navigationItem.disableInteractivePopGestureRecognizer)
        }
    }
}
