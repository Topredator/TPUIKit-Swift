//
//  XTBaseViewController.swift
//  XTUIKit-Swift
//
//  Created by Topredator on 2020/6/2.
//

import UIKit
import TPFoundation_Swift

/// 基类 控制器
open class BaseViewController: UIViewController {
    open override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.tp.rgbt(245)
    }
    public override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    public override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
    public override var shouldAutorotate: Bool {
        return true
    }
    public override var prefersStatusBarHidden: Bool {
        return false
    }
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
}
