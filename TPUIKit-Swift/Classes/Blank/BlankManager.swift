//
//  BlankManager.swift
//  XTUIKit-Swift
//
//  Created by Topredator on 2021/5/26.
//

import Foundation

/// 配置
public class BlankMaker {
    /// 主标题
    public var titleFont = UIFont.tp.font(14)
    public var titleColor = UIColor.tp.rgbt(102)
    /// 副标题
    public var subTitleFont = UIFont.tp.font(14)
    public var subTitleColor = UIColor.tp.rgbt(153)
    /// 刷新按钮
    public var refreshBtnFont = UIFont.tp.font(16)
    public var refreshBtnTitleColor = UIColor.white
    public var refreshBtnBgColor = UIColor.tp.rgb(78, 212, 144)
    public var btnRadius: CGFloat = 6.0
    /// 资源地址
    public var resourcesPath: String?
    
    // MARK:  ------------- 链式语法调用 --------------------
    @discardableResult
    public func path(_ path: String) -> Self {
        resourcesPath = path
        return self
    }
    
    @discardableResult
    public func font(_ font: CGFloat) -> Self {
        titleFont = UIFont.tp.font(font)
        return self
    }
    @discardableResult
    public func color(_ color: UIColor) -> Self {
        titleColor = color
        return self
    }
    @discardableResult
    public func subFont(_ font: CGFloat) -> Self {
        subTitleFont = UIFont.tp.font(font)
        return self
    }
    @discardableResult
    public func subColor(_ color: UIColor) -> Self {
        subTitleColor = color
        return self
    }
    @discardableResult
    public func btnTitleColor(_ color: UIColor) -> Self {
        refreshBtnTitleColor = color
        return self
    }
    @discardableResult
    public func btnBgColor(_ color: UIColor) -> Self {
        refreshBtnBgColor = color
        return self
    }
    @discardableResult
    public func btnFont(_ font: CGFloat) -> Self {
        refreshBtnFont = UIFont.tp.font(font)
        return self
    }
    @discardableResult
    public func redius(_ value: CGFloat) -> Self {
        btnRadius = value
        return self
    }
}

public class BlankManager {
    /// 资源地址
    
    public let blankMaker: BlankMaker
    public static let share = BlankManager()
    
    init() {
        blankMaker = BlankMaker()
    }
    
    @discardableResult
    public static func blankConfig(_ closure: ((BlankMaker) -> ())? = nil) -> BlankManager {
        let manager = BlankManager.share
        closure?(manager.blankMaker)
        return manager
    }
}
