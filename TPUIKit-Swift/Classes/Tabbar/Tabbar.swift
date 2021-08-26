//
//  Tabbar.swift
//  XTUIKit-Swift
//
//  Created by Topredator on 2020/5/29.
//

import UIKit

public class TabItemModel {
    public var title: String?
    public var image: UIImage?
    public init(title: String, image: UIImage? = nil) {
        self.title = title
        self.image = image
    }
}
@objc public protocol TabbarDelegate {
    /// 是否切换到指定index
    @discardableResult
    @objc optional func shouldSelectedItem(tabbar: Tabbar, atIndex: Int) -> Bool
    /// 将要切换到指定index
    @objc optional func willSelectItem(tabbar: Tabbar, atIndex: Int)
    /// 已经切换到指定index
    @objc optional func didSelectedItem(tabbar: Tabbar, atIndex: Int)
}

/// tabbar
public class Tabbar: UIView {
    /// 代理
    public weak var delegate: TabbarDelegate?
    private var _items = [TabItem]()
    public var items: [TabItem] {
        get { _items }
        set {
            self.selectedItemIndex = NSNotFound
            _items.forEach { $0.removeFromSuperview() }
            _items = newValue
            for item in _items {
                item.setTitleColor(self.itemTitleColor, for: UIControl.State.normal)
                item.setTitleColor(self.itemTitleSelectedColor, for: UIControl.State.selected)
                item.titleLabel?.font = self.itemTitleFont
                item.setContentHorizontalCenter(with: self.itemHorizontalCenterVerticalOffset, spacing: self.itemHorizontalCenterSpacing)
                item.badgeTitleColor = self.badgeTitleColor
                item.badgeTitleFont = self.badgeTitleFont
                item.badgeBgColor = self.badgeBgColor
                item.addTarget(self, action: #selector(tabItemClicked), for: UIControl.Event.touchUpInside)
                self.scrollView.addSubview(item)
            }
            self.scrollView.bringSubviewToFront(self.indicatorView)
            // 更新UI
            self.updateItemsScaleIfNeeded()
            self.updateAllUI()
        }
    }
    /// 指示器 设置private var _indicatorColor: UIColor?
    private var _indicatorColor: UIColor?
    public var indicatorColor: UIColor? {
        get { _indicatorColor }
        set {
            _indicatorColor = newValue
            self.indicatorView.backgroundColor = newValue
        }
    }
    private var _indicatorImage: UIImage?
    public var indicatorImage: UIImage? {
        get { _indicatorImage }
        set {
            _indicatorImage = newValue
            self.indicatorView.image = newValue
        }
    }
    private var _indicatorRadius: CGFloat?
    public var indicatorRadius: CGFloat? {
        get { _indicatorRadius }
        set {
            _indicatorRadius = newValue
            self.indicatorView.layer.cornerRadius = newValue!
        }
    }
    var indicatorWidthFixTitle: Bool = false
    var indicatorSwitchAnimated: Bool = false
    var indicatorPosition: IndicatorPosition?
    var indicatorInsets: UIEdgeInsets?
    var indicatorSize: CGSize?
    public var indicatorAnimationStyle: Tabbar.IndicatorAnimationStyle = .Default
    
    /// item设置
    public var itemTitleColor: UIColor = middleGrayColor
    public var itemTitleFont: UIFont = UIFont.tp.font(15)
    public var itemWidth: CGFloat = 0
    public var itemHeight: CGFloat?
    public var itemMinWidth: CGFloat = 0
    var itemFitTextWidth: Bool = false
    var itemFitTextWidthSpacing: CGFloat = 0
    var itemHorizontalCenterVerticalOffset: CGFloat = 5
    var itemHorizontalCenterSpacing: CGFloat = 5
    /// 选中item设置
    public var itemTitleSelectedColor: UIColor = darkColor
    public var itemTitleSelectedFont: UIFont?
    /// badge设置
    private var _badgeBgColor: UIColor = .red
    public var badgeBgColor: UIColor {
        get { _badgeBgColor }
        set {
            _badgeBgColor = newValue
            self.items.forEach { $0.badgeBgColor = newValue }
        }
    }
    private var _badgeTitleColor: UIColor = .white
    public var badgeTitleColor: UIColor {
        get { _badgeTitleColor }
        set {
            _badgeTitleColor = newValue
            self.items.forEach { $0.badgeTitleColor = newValue }
        }
    }
    private var _badgeTitleFont: UIFont = UIFont.tp.font(10)
    public var badgeTitleFont: UIFont {
        get { _badgeTitleFont }
        set {
            _badgeTitleFont = newValue
            self.items.forEach{ $0.badgeTitleFont = newValue }
        }
    }
    public var badgeMarginTop: CGFloat = 3
    public var badgeCenterRight: CGFloat = 25
    public var badgeHorizontalSpace: CGFloat = 8
    public var badgeVerticalSpace: CGFloat = 2
    public var badgeSideLenght: CGFloat = 10
    /// tabbar边缘 与第一个和最后一个item的距离
    public var marginSpace: CGFloat = 0
    /// 选中的item下标, 默认0
    private var _selectedItemIndex: Int = 0
    public var selectedItemIndex: Int {
        get { _selectedItemIndex }
        set {
            if _selectedItemIndex == newValue || newValue >= self.items.count || self.items.isEmpty { return }
            // 是否可以选中,如果不能，直接返回
            if (self.delegate?.shouldSelectedItem) != nil {
                let isShould: Bool = self.delegate!.shouldSelectedItem!(tabbar: self, atIndex: newValue)
                if !isShould { return }
            }
            if (self.delegate?.willSelectItem) != nil {
                self.delegate?.willSelectItem?(tabbar: self, atIndex: newValue)
            }
            if _selectedItemIndex != NSNotFound {
                let oldItem = self.items[_selectedItemIndex]
                oldItem.isSelected = false
                if self.itemFontChangeFollowScroll {
                    oldItem.transform = CGAffineTransform.init(scaleX: self.itemTitleUnselectedFontScale(), y: self.itemTitleUnselectedFontScale())
                } else {
                    oldItem.titleLabel?.font = self.itemTitleFont
                }
            }
            let newItem = self.items[newValue]
            newItem.isSelected = true
            if self.itemFontChangeFollowScroll {
                newItem.transform = CGAffineTransform.init(scaleX: 1, y: 1)
            } else {
                if self.itemTitleSelectedFont != nil { newItem.titleLabel?.font = self.itemTitleSelectedFont! }
            }
            if self.indicatorSwitchAnimated && _selectedItemIndex != NSNotFound {
                UIView.animate(withDuration: 0.25) {
                    self.updateIndicatorFrame(atIndex: newValue)
                }
            } else {
                self.updateIndicatorFrame(atIndex: newValue)
            }
            _selectedItemIndex = newValue
            // 将选中的item 移动到 中心位置
            self.setSelectedItemMoveToCenter()
            
            if (self.delegate?.didSelectedItem) != nil {
                self.delegate?.didSelectedItem?(tabbar: self, atIndex: newValue)
            }
        }
    }
    /// 拖动内容视图时，item的字体/颜色 是否显示渐变效果
    public var itemFontChangeFollowScroll: Bool = false
    public var itemColorChangeFollowScroll: Bool = true
    /// 拖动视图时，指示器是否跟随
    public var indicatorFrameFollowScroll: Bool = false
    /// item的image、title是否为水平居中，默认true
    public var itemContentHorizontalCenter: Bool = true
    
    var scrollViewLastOffsetX: CGFloat = 0
    // MARK:  ------------- init method --------------------
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 布局子视图
    public func setupSubviews() {
        self.backgroundColor = UIColor.white
        self.clipsToBounds = true
        self.addSubview(self.scrollView)
        self.scrollView.addSubview(self.indicatorView)
    }
    // MARK:  ------------- public method --------------------
    /// 选中返回的item
    public func selectedItem() -> TabItem? {
        if self.selectedItemIndex == NSNotFound {
            return nil
        }
        return self.items[self.selectedItemIndex] as TabItem
    }
    /// 根据titles创建items
    public func setupItems(titles: [TabItemModel]) {
        var items = [TabItem]()
        for model in titles {
            let item = TabItem.init()
            item.setTitle(model.title, for: UIControl.State.normal)
            item.setImage(model.image, for: UIControl.State.normal)
            items.append(item)
        }
        self.items = items
    }
   /// 设置item 的image、title居中，并调整竖直方向位置
   /// - Parameters:
   ///   - verticalOffset: 竖直位置偏移量
   ///   - spacing: image、title间距
    public func itemContentHorizontalCenter(verticalOffset: CGFloat, spacing: CGFloat) {
        self.itemContentHorizontalCenter = true
        self.itemHorizontalCenterVerticalOffset = verticalOffset
        self.itemHorizontalCenterSpacing = spacing
        for item in self.items {
            item.setContentHorizontalCenter(with: verticalOffset, spacing: spacing)
        }
    }
    public func scrollEnable(itemWidth: CGFloat) {
        self.scrollView.isScrollEnabled = true
        self.itemFitTextWidth = false
        self.itemFitTextWidthSpacing = 0
        self.itemWidth = itemWidth
        self.itemMinWidth = 0
        self.updateItemsFrame()
    }
    public func scrollEnableAndItemFitTextWidth(space: CGFloat) {
        self.scrollEnableAndItemFitTextWidth(space: space, minWidth: 0)
    }
    func scrollEnableAndItemFitTextWidth(space: CGFloat, minWidth: CGFloat)  {
        self.scrollView.isScrollEnabled = true
        self.itemFitTextWidth = true
        self.itemFitTextWidthSpacing = space
        self.itemWidth = 0
        self.itemMinWidth = minWidth
        self.updateItemsFrame()
    }
    
    
    /// 父视图 中的scrollView拖动时，改变scrollview的状态
    public func updateSubviewsWhenParentScrollViewScroll(scrollView: UIScrollView) {
        let offsetX: CGFloat = scrollView.contentOffset.x
        let scrollViewWidth: CGFloat = scrollView.frame.width
        let leftIndex: Int = Int(offsetX / scrollViewWidth)
        let rightIndex: Int = leftIndex + 1
        let leftItem = self.items[leftIndex]
        var rightItem: TabItem? = nil
        if rightIndex < self.items.count {
            rightItem = self.items[rightIndex]
        }
        let rightScale: CGFloat = offsetX / scrollViewWidth
        let leftScale = 1 - rightScale
        
        if self.itemFontChangeFollowScroll && self.itemTitleUnselectedFontScale() != 1 {
            let diff: CGFloat = self.itemTitleUnselectedFontScale() - 1
            leftItem.transform = CGAffineTransform.init(scaleX: rightScale * diff + 1, y: rightScale * diff + 1)
            rightItem?.transform = CGAffineTransform.init(scaleX: leftScale * diff + 1, y: leftScale * diff + 1)
        }
        if self.itemColorChangeFollowScroll {
            var normalRed: CGFloat = 0, normalGreen: CGFloat = 0, normalBlue: CGFloat = 0, normalAlpha: CGFloat = 0
            var selectedRed: CGFloat = 0, selectedGreen: CGFloat = 0, selectedBlue: CGFloat = 0, selectedAlpha: CGFloat = 0
            self.itemTitleColor.getRed(&normalRed, green: &normalGreen, blue: &normalBlue, alpha: &normalAlpha)
            self.itemTitleSelectedColor.getRed(&selectedRed, green: &selectedGreen, blue: &selectedBlue, alpha: &selectedAlpha)
            // 获取选中和未选中状态的颜色差值
            let redDiff: CGFloat = selectedRed - normalRed
            let greenDiff: CGFloat = selectedGreen - normalGreen
            let blueDiff: CGFloat = selectedBlue - normalBlue
            let alphaDiff: CGFloat = selectedAlpha - normalAlpha
            // 根据颜色值的差值和偏移量，设置tabItem的标题颜色
            leftItem.titleLabel?.textColor = UIColor.init(red: leftScale * redDiff + normalRed, green: leftScale * greenDiff + normalGreen, blue: leftScale * blueDiff + normalBlue, alpha: leftScale * alphaDiff + normalAlpha)
            rightItem?.titleLabel?.textColor = UIColor.init(red: rightScale * redDiff + normalRed, green: rightScale * greenDiff + normalGreen, blue: rightScale * blueDiff + normalBlue, alpha: rightScale * alphaDiff + normalAlpha)
        }
        if self.indicatorFrameFollowScroll {
            switch self.indicatorAnimationStyle {
            case .Default:
                if rightItem == nil { return }
                var frame: CGRect = self.indicatorView.frame
                // 横坐标x的变化
                let xDiff: CGFloat = rightItem!.indicatorFrame().origin.x - leftItem.indicatorFrame().origin.x
                frame.origin.x = leftItem.indicatorFrame().origin.x + rightScale * xDiff
                // 宽度的变化
                let widthDiff: CGFloat = rightItem!.indicatorFrame().width - leftItem.indicatorFrame().width
                frame.size.width = leftItem.indicatorFrame().width + rightScale * widthDiff
                self.indicatorView.frame = frame
                self.indicatorView.superview?.layoutIfNeeded()
                break
            default:
                let page: Int = Int(offsetX / scrollViewWidth)
                var currentIndex: Int = NSNotFound, targetIndex: Int = NSNotFound
                var scale: CGFloat = CGFloat(offsetX / scrollViewWidth) - CGFloat(page)
                if self.scrollViewLastOffsetX < offsetX { // 左滑
                    currentIndex = page
                    targetIndex = page + 1
                    scale *= 2
                } else if self.scrollViewLastOffsetX > offsetX { // 右滑
                    currentIndex = page + 1
                    targetIndex = page
                    scale = (1 - scale) * 2
                } else { return }
                if targetIndex >= self.items.count { return }
                let currentItem: TabItem = self.items[currentIndex]
                let targetItem: TabItem = self.items[targetIndex]
                let currentItemWidth = currentItem.frameWithOutTransform.width
                let targetItemWidth = targetItem.frameWithOutTransform.width
                if targetIndex > currentIndex { // 左滑过程
                    if scale < 1 { // 小于半个屏幕
                        let addition: CGFloat = scale * (targetItem.indicatorFrame().maxX - currentItem.indicatorFrame().maxX)
                        self.setIndicatorFrame(x: currentItem.indicatorFrame().origin.x, width: currentItem.indicatorFrame().width + addition)
                    } else if scale > 1 { // 大于半个屏幕
                        scale = scale - 1
                        let addition: CGFloat = scale * (targetItem.indicatorFrame().origin.x - currentItem.indicatorFrame().origin.x)
                        self.setIndicatorFrame(x: currentItem.indicatorFrame().origin.x + addition, width: currentItemWidth + targetItemWidth - addition - currentItem.indicatorInset.left - targetItem.indicatorInset.right)
                    }
                } else { // 右滑过程
                    if scale < 1 {
                        let addition: CGFloat = scale * (currentItem.indicatorFrame().origin.x - targetItem.indicatorFrame().origin.x)
                        self.setIndicatorFrame(x: currentItem.indicatorFrame().origin.x - addition, width: currentItem.indicatorFrame().width + addition)
                    } else if scale > 1 {
                        scale = scale - 1
                        let addition: CGFloat = (1 - scale) * (currentItem.indicatorFrame().maxX - targetItem.indicatorFrame().maxX)
                        self.setIndicatorFrame(x: targetItem.indicatorFrame().origin.x, width: targetItem.indicatorFrame().width + addition)
                    }
                }
                self.scrollViewLastOffsetX = offsetX
                break
            }
        }
    }
    /// 通过横坐标 与 宽度 设置指示器frame
    func setIndicatorFrame(x: CGFloat, width: CGFloat) {
        var frame: CGRect = self.indicatorView.frame
        frame.origin.x = x
        frame.size.width = width
        self.indicatorView.frame = frame
    }
    // MARK:  ------------- private method --------------------
    @objc func tabItemClicked(item: TabItem) {
        self.selectedItemIndex = item.index!
    }
    /// 更新所有UI
    func updateAllUI() {
        self.updateItemsFrame()
        self.updateItemIndicatorInsets()
        self.updateIndicatorFrame(atIndex: self.selectedItemIndex)
    }
    /// 更新所有item的frame
    func updateItemsFrame() {
        if self.items.isEmpty { return }
        if self.scrollView.isScrollEnabled { // 支持滚动
            var x: CGFloat = self.marginSpace
            for index in 0 ..< self.items.count {
                let item = self.items[index]
                var width: CGFloat = 0
                // itemWidth设置过 为固定值
                if self.itemWidth > 0 { width = self.itemWidth }
                // item的宽度为根据字体大小和spacing进行适配
                if self.itemFitTextWidth { width = max(item.titleWidth() + self.itemFitTextWidthSpacing, self.itemMinWidth) }
                item.frame = CGRect.init(x: x, y: 0, width: width, height: self.frame.height)
                item.index = index
                x += width
            }
            self.scrollView.contentSize = CGSize.init(width: max(x + self.marginSpace, self.scrollView.frame.width), height: self.scrollView.frame.height)
        } else {
            var x: CGFloat = self.marginSpace
            let allItemsWidth: CGFloat = self.frame.width - self.marginSpace * 2
            self.itemWidth = allItemsWidth / CGFloat(self.items.count)
            self.itemWidth = CGFloat(floorf(Float(self.itemWidth + 0.5)))
            for index in 0 ..< self.items.count {
                let item = self.items[index]
                item.frame = CGRect.init(x: x, y: 0, width: self.itemWidth, height: self.frame.height)
                item.index = index
                x += self.itemWidth
            }
            self.scrollView.contentSize = CGSize.init(width: self.bounds.width, height: self.bounds.height)
        }
    }
    /// 更新item的scale
    func updateItemsScaleIfNeeded() {
        if self.itemTitleSelectedFont != nil && self.itemFontChangeFollowScroll && self.itemTitleSelectedFont!.pointSize != self.itemTitleFont.pointSize {
            /// 全部设为 选中字体
            self.items.forEach { $0.titleLabel?.font = self.itemTitleSelectedFont }
            // 遍历 改变没选中的transform
            for item in self.items {
                if !item.isSelected {
                    item.transform = CGAffineTransform.init(scaleX: self.itemTitleUnselectedFontScale(), y: self.itemTitleUnselectedFontScale())
                }
            }
        }
    }
    /// item未选中的 scale
    func itemTitleUnselectedFontScale() -> CGFloat {
        if self.itemTitleSelectedFont != nil {
            return self.itemTitleFont.pointSize / self.itemTitleSelectedFont!.pointSize
        }
        return 1.0
    }
    /// 将选中的item 移动到中心位置
    func setSelectedItemMoveToCenter() {
        if !self.scrollView.isScrollEnabled { return }
        var offsetX = self.selectedItem()!.center.x - self.scrollView.frame.width * 0.5
        if offsetX < 0 { offsetX = 0 }
        let maxOffsetX = self.scrollView.contentSize.width - self.scrollView.frame.width
        if offsetX > maxOffsetX { offsetX = maxOffsetX }
        self.scrollView.setContentOffset(CGPoint.init(x: offsetX, y: 0), animated: true)
    }
    /// 更新item的指示器嵌入 算出每个选中item的indicator的frame
    func updateItemIndicatorInsets() {
        for item in self.items {
            if self.indicatorWidthFixTitle { // 指示器的宽 适配文字
                let frame = item.frameWithOutTransform
                let space = (frame.size.width - item.titleWidth()) / 2
                item.indicatorInset = UIEdgeInsets.init(top: self.indicatorInsets!.top, left: space, bottom: self.indicatorInsets!.bottom, right: space)
            } else {
                if self.indicatorPosition!.width > 0 {
                    let frame = item.frameWithOutTransform
                    let position = self.indicatorPosition!
                    item.indicatorInset = UIEdgeInsets.init(top: frame.height - position.height - position.bottom, left: (frame.width - position.width) / 2, bottom: position.bottom, right: (frame.width - position.width) / 2)
                    continue
                }
                if self.indicatorSize!.width > 0 {
                    let frame = item.frameWithOutTransform
                    let size = self.indicatorSize!
                    item.indicatorInset = UIEdgeInsets.init(top: frame.height - size.height, left: (frame.width - size.width) / 2, bottom: 0, right: (frame.width - size.width) / 2)
                    continue
                }
                item.indicatorInset = self.indicatorInsets!
            }
        }
    }
    /// 更新每个item对应的indicator的frame
    func updateIndicatorFrame(atIndex: Int) {
        if self.items.isEmpty || atIndex == NSNotFound {
            self.indicatorView.frame = CGRect.zero
            return
        }
        let item = self.items[atIndex] as TabItem
        self.indicatorView.frame = item.indicatorFrame()
    }
    
    public override var frame: CGRect {
        didSet {
            super.frame = frame
            self.scrollView.frame = self.bounds
            self.updateAllUI()
        }
    }
    // MARK:  ------------- lazy method --------------------
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView.init(frame: self.bounds)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isScrollEnabled = false
        return scrollView
    }()
    lazy var indicatorView: UIImageView = {
        let imageView = UIImageView.init(frame: CGRect.zero)
        imageView.layer.masksToBounds = true
        return imageView
    }()
}

extension Tabbar: TabbarIndicatorProtocol, TabbarBadgeProtocol {
    
    /// 指示器 动画类型(默认、弹性)
    public enum IndicatorAnimationStyle {
        case `Default`, Elasticity
    }
    
    // MARK:  ------------- TabbarIndicatorProtocol --------------------
    public func indicatorPosition(position: IndicatorPosition, switchAnimated: Bool) {
        self.indicatorWidthFixTitle = false
        self.indicatorSwitchAnimated = switchAnimated
        self.indicatorPosition = position
        self.updateItemIndicatorInsets()
        self.updateIndicatorFrame(atIndex: self.selectedItemIndex)
    }
    
    public func indicatorWidthFixText(top: CGFloat, bottom: CGFloat, switchAnimated: Bool) {
        self.indicatorWidthFixTitle = true
        self.indicatorSwitchAnimated = switchAnimated
        self.indicatorInsets = UIEdgeInsets.init(top: top, left: 0, bottom: bottom, right: 0)
        self.updateItemIndicatorInsets()
        self.updateIndicatorFrame(atIndex: self.selectedItemIndex)
    }
    // MARK:  ------------- TabbarBadgeProtocol --------------------
    public func configNumberBadge(top: CGFloat, centerRight: CGFloat, horizontalSpace: CGFloat, verticalSpace: CGFloat) {
        self.badgeMarginTop = top
        self.badgeCenterRight = centerRight
        self.badgeHorizontalSpace = horizontalSpace
        self.badgeVerticalSpace = verticalSpace
        for item in self.items {
            item.setNumberBadge(toItem: top, centerRight: centerRight, titleHorizonalSpace: horizontalSpace, titleVerticalSpace: verticalSpace)
        }
    }
    public func configDotBadge(top: CGFloat, centerRight: CGFloat, sideLenght: CGFloat) {
        self.badgeMarginTop = top
        self.badgeCenterRight = centerRight
        self.badgeSideLenght = sideLenght
        for item in self.items {
            item.setDotBadge(toItem: top, centerRight: centerRight, sideLength: sideLenght)
        }
    }
}
