//
//  AlertMaker.swift
//  XTUIKit-Swift
//
//  Created by Topredator on 2021/3/30.
//

import Foundation

public typealias Block = () -> Void
/// 选项
public class AlertOption {
    public var title: String? = nil
    public var block: Block? = nil
    public var target: AnyObject?
    public var selector: Selector?
    var textColor: UIColor? = nil
    public var actionStyle: UIAlertAction.Style = .default
    public init(_ title: String?) {
        self.title = title
    }
    convenience public init(_ title: String?,
                _ block: Block? = nil) {
        self.init(title)
        self.block = block
    }
    convenience public init(_ title: String?, _ target: AnyObject?, _ selector: Selector) {
        self.init(title)
        self.target = target
        self.selector = selector
    }
    
    public func titleColor(_ color: UIColor) -> AlertOption {
        self.textColor = color
        return self
    }
    public func style(_ style: UIAlertAction.Style) -> AlertOption {
        self.actionStyle = style
        return self
    }
    public func add(target: AnyObject?, selector: Selector?) -> AlertOption {
        self.target = target
        self.selector = selector
        return self
    }
}

open class AlertMaker {
    var alertTitle : String?
    var alertMsg : String?
    var alertStyle : UIAlertController.Style = .alert
    var options = [AlertOption]()
    public init() {}
    convenience public init(_ alertStyle: UIAlertController.Style) {
        self.init()
        self.alertStyle = alertStyle
    }
    @discardableResult
    public func title(_ title: String) -> AlertMaker {
        alertTitle = title
        return self
    }
    @discardableResult
    public func msg(_ msg: String) -> AlertMaker {
        alertMsg = msg
        return self
    }
    @discardableResult
    public func style(_ style: UIAlertController.Style) -> AlertMaker {
        alertStyle = style
        return self
    }
    @discardableResult
    public func addOption(_ option: AlertOption) -> AlertMaker {
        self.options.append(option)
        return self
    }
    @discardableResult
    public func cancleOption(_ title: String) -> AlertMaker {
        let option = AlertOption(title)
        option.textColor = .lightGray
        self.options.append(option)
        return self
    }
}


