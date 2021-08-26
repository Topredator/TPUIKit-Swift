//
//  BackNavigationVC.swift
//  XTUIKit-Swift
//
//  Created by Topredator on 2021/5/27.
//

import UIKit

open class BackNavigationVC: BaseNavigationController {

    open override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    public override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if children.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem.backItem(General.image("blackBack"), target: viewController, action: #selector(backAction))
        }
        super.pushViewController(viewController, animated: animated)
    }
}

public extension UIViewController {
    @objc func backAction() { navigationController?.popViewController(animated: true) }
}
public extension UINavigationBar {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if self.point(inside: point, with: event) {
            isUserInteractionEnabled = true
        } else {
            isUserInteractionEnabled = false
        }
        return super.hitTest(point, with: event)
    }
}


public extension UIBarButtonItem {
    
    /// 返回Item
    static func backItem(_ image: UIImage? = nil,
                  highImage: UIImage? = nil,
                  target: Any?,
                  action: Selector) -> UIBarButtonItem {
        let btn = UIButton(type: .custom)
        btn.setImage(image, for: .normal)
        btn.setImage(image, for: .highlighted)
        btn.frame = CGRect(x: 0.0, y: 0.0, width: 30.0, height: 30.0)
        btn.contentEdgeInsets = UIEdgeInsets(top: 0.0, left: -25, bottom: 0.0, right: 0.0)
        btn.addTarget(target, action: action, for: .touchUpInside)
        btn.isUserInteractionEnabled = true
        return UIBarButtonItem(customView: btn)
    }
}
