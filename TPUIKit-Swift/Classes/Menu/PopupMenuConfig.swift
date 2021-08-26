//
//  PopupMenuConfig.swift
//  XTUIKit-Swift
//
//  Created by Topredator on 2020/6/2.
//

import UIKit
/// 菜单配置模型
open class PopupMenuConfig {
    public var normalTextColor: UIColor = darkColor
    public var selectTextColor: UIColor = UIColor.tp.rgb(41, 143, 237)
    public var itemBgColor: UIColor = UIColor.white
    public var itemSelectBgColor: UIColor = UIColor.white
    public var normalTextFont: UIFont = UIFont.tp.font(14)
    public var selectTextFont: UIFont = UIFont.tp.font(14)
    public var selectedIndex: Int = 0
    public init() {}
    @discardableResult
    public func color(_ color: UIColor) -> PopupMenuConfig {
        normalTextColor = color
        return self
    }
    @discardableResult
    public func selectedColor(_ color: UIColor) -> PopupMenuConfig {
        selectTextColor = color
        return self
    }
    @discardableResult
    public func font(_ font: UIFont) -> PopupMenuConfig {
        normalTextFont = font
        return self
    }
    @discardableResult
    public func selectedFont(_ font: UIFont) -> PopupMenuConfig {
        selectTextFont = font
        return self
    }
    @discardableResult
    public func bgColor(_ color: UIColor) -> PopupMenuConfig {
        itemBgColor = color
        return self
    }
    @discardableResult
    public func selectedBgColor(_ color: UIColor) -> PopupMenuConfig {
        itemSelectBgColor = color
        return self
    }
    @discardableResult
    public func index(_ index: Int) -> PopupMenuConfig {
        selectedIndex = index
        return self
    }
    
}
