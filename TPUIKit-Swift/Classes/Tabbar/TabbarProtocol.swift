//
//  XTTabbarProtocol.swift
//  XTUIKit-Swift
//
//  Created by Topredator on 2020/5/29.
//

import UIKit

/// 指示器位置
public struct IndicatorPosition {
    public var bottom: CGFloat = 0.0
    public var width: CGFloat = 0.0
    public var height: CGFloat = 0.0
    public init(bottom: CGFloat, width: CGFloat, height: CGFloat) {
        self.bottom = bottom
        self.width = width
        self.height = height
    }
}

public protocol TabbarIndicatorProtocol {
    /* 设置指示器 位置及尺寸, 点击切换是否支持动画
     * 与indicatorWidthFixText方法互斥, 后调用者生效
     */
    func indicatorPosition(position: IndicatorPosition, switchAnimated: Bool)
    /// 设置指示器宽度 根据text匹配，与indicatorPosition方法互斥, 后调用者生效
    func indicatorWidthFixText(top: CGFloat, bottom: CGFloat, switchAnimated: Bool)
}

public protocol TabbarBadgeProtocol {
    /// 设置number类型的badge
    /// - Parameters:
    ///   - top: 离顶部距离
    ///   - centerRight: 中心点离右边距离
    ///   - horizontalSpace: item文字 的 水平间距
    ///   - verticalSpace: item文字的 竖中间距
    func configNumberBadge(top: CGFloat, centerRight: CGFloat, horizontalSpace: CGFloat, verticalSpace: CGFloat)
    /// 设置 圆点 类型的badge
    /// - Parameters:
    ///   - top: 离顶部距离
    ///   - centerRight: 中心点离右边 距离
    ///   - sideLenght: 圆点直径
    func configDotBadge(top: CGFloat, centerRight: CGFloat, sideLenght: CGFloat)
}
