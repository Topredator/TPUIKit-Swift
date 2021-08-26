//
//  AppDelegate.swift
//  TPUIKit-Swift
//
//  Created by 周晓路 on 08/26/2021.
//  Copyright (c) 2021 周晓路. All rights reserved.
//

import UIKit
import TPUIKit_Swift
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UIViewController.tp.UIKitSwizzling()
        
        RefreshManager.refreshConfig { make in
            make.path(Bundle.main.path(forResource: "Config", ofType: "bundle")!)
        }
        
        window = UIWindow.init(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        
        let navigationVC = BaseNavigationController(rootViewController: ViewController())
        navigationVC.navigationBar.isTranslucent = false
        window?.rootViewController = navigationVC
        window?.makeKeyAndVisible()
        return true
    }
}

