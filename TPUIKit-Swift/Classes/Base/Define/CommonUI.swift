//
//  XTCommonMacros.swift
//  XTExtension
//
//  Created by Topredator on 2020/5/25.
//  Copyright © 2020 Topredator. All rights reserved.
//

import UIKit


public struct UI {
    /// 屏幕宽
    public static var ScreenWidth: CGFloat { UIScreen.main.bounds.size.width }
    /// 屏幕高
    public static var ScreenHeight: CGFloat { UIScreen.main.bounds.size.height }
    /// 状态栏高
    public static var StatusBarHeight: CGFloat { UIApplication.StatusBarHeight }
    /// 导航栏高
    public static var NavigationBarHeiht: CGFloat { 44.0 }
    /// 状态栏 + 导航栏
    public static var TopBarHeight: CGFloat { UIApplication.StatusBarHeight + NavigationBarHeiht }
    /// Tabbar 高
    public static var TabbarHeight: CGFloat { 49.0 }
    /// Tabbar + 底部安全区域高
    public static var BottomBarHeight: CGFloat { StatusBarHeight > 20.0 ? 83.0 : 49.0 }
    /// 底部安全区域高
    public static var BottomSafeAreaHeight: CGFloat { StatusBarHeight > 20.0 ? 34.0 : 0.0 }
    
    
    /// 生成属性字符串
    public static func generateAttString(_ str: String, _ att: [NSAttributedString.Key : Any]? = nil) -> NSAttributedString {
        NSAttributedString(string: str, attributes: att)
    }
}



public extension UIApplication {
    /// 状态栏 高度
    static var StatusBarHeight: CGFloat {
        var statusBarHeight: CGFloat = 0.0
        if #available(iOS 13.0, *) {
            let window = shared.windows.filter { $0.isKeyWindow }.first
            statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.size.height ?? 0.0
        } else {
            statusBarHeight = shared.statusBarFrame.size.width
        }
        return statusBarHeight
    }
}
