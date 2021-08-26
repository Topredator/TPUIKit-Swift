//
//  Banner.swift
//  XTUIKit-Swift
//
//  Created by Topredator on 2020/5/27.
//

import UIKit
import Foundation

public class Banner: UIView {
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubviews()
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    /// 滚动视图
    public fileprivate(set) lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: CGRect.zero)
        scrollView.isPagingEnabled = true
        scrollView.clipsToBounds = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.isDirectionalLockEnabled = true
        scrollView.delegate = self
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        }
        return scrollView
    }()
    /// pageControl
    public fileprivate(set) lazy var pageControl: PageControl = {
        let pageControl = PageControl(frame: CGRect.zero)
        pageControl.pageSelectedImage = UIImage.tp.image(withColor: .white, size: CGSize(width: 5.0, height: 5.0))
        pageControl.pageImage = UIImage.tp.image(withColor: UIColor.tp.rgbt(255, 0.3), size: CGSize(width: 5.0, height: 5.0))
        pageControl.addTarget(self, action: #selector(pageControlChanged), for: .valueChanged)
        return pageControl
    }()
    /// 页面总数
    public var numberOfPages: Int {
        get {
            return self.delegate?.numberOfPages(self) ?? 0
        }
    }
    /// 预加载的分页数 默认0
    public var preparedPageCount: Int = 0
    /// 循环滚动模式 默认 false
    public var isCarousel: Bool = false
    /// 自动滚动时间间隔
    private(set) var timeInteraval: TimeInterval = 3.0
    /// 滑动方向 默认水平方向
    public var scrollDirection: Banner.Direction = .Horizontal
    open weak var delegate: BannerDelegate?
    var pages: Dictionary = [ NSNumber : BannerPageView ]()
    var reusablePages = [ String : Set<BannerPageView> ]()
    var pageIndexes: Set<NSNumber> = Set()
    private var _innerCurrentPageIndex: Int = 0
    private var innerCurrentPageIndex: Int {
        get {  _innerCurrentPageIndex }
        set {
            if _innerCurrentPageIndex == newValue { return }
            _innerCurrentPageIndex = newValue
            let currentIndex: Int = currentPageIndex()
            delegate?.currentPageIndexDidChanged(self, at: currentIndex)
        }
    }
    var currentPageRate: Double = 0
    var timer: Timer?
    var isTimerValid: Bool = false
    // MARK:  ------------- public method --------------------
    /// 重新加载，默认显示第0个分页
    public func reloadData() {
        reloadData(show: 0)
    }
    /// 重新加载，并显示当前界面
    public func reloadData(show currentIndex: Int) {
        pageControl.numberOfPages = numberOfPages
        _innerCurrentPageIndex = NSNotFound
        currentPageRate = Double(NSNotFound)
        // 清理
        cleanUp()
        // 判断线程 如果在主线程上直接执行，否则放入主队列当中
        if Thread.current.isMainThread {
            setScrollContentSizeIfNeed()
            setCurrent(pageIndex: currentIndex, animated: false)
        } else {
            DispatchQueue.main.async {
                self.setScrollContentSizeIfNeed()
                self.setCurrent(pageIndex: currentIndex, animated: false)
            }
        }
    }
    /// 开启定时器
    public func startTimer(interval: TimeInterval) {
        timeInteraval = interval
        if interval == 0 {
            stopTimer()
            return
        }
        if timer?.timeInterval != interval {
            timer?.invalidate()
        }
        let flag = timer?.isValid ?? false
        if !flag  {
            timer = Timer(timeInterval: interval, target: self, selector: #selector(timerDidTriggered), userInfo: nil, repeats: true)
            RunLoop.current.add(timer!, forMode: RunLoop.Mode.common)
        }
    }
    /// 停止定时器
    public func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    /// 设置当前显示的分页
    public func setCurrent(pageIndex: Int, animated: Bool) {
        var index = pageIndex
        if isCarousel {
            index = numberOfPages > 1 ? index + 1 : 0
        }
        setPageRate(pageRate: Double(index), animated: animated, scroll: true)
    }
    /// 当前分页下标
    public func currentPageIndex() -> Int {
        return normalPageIndex(pageIndex: _innerCurrentPageIndex)
    }
    /// 分页重用
    public func dequeueReusablePage(indentifier: String?) -> BannerPageView? {
        guard let iden = indentifier else { return nil }
        var pageSet = self.reusablePages[iden]
        if pageSet == nil || !(pageSet!.isEmpty) { return nil }
        let pageView: BannerPageView? = pageSet!.popFirst()
        return pageView
    }
    
    // MARK:  ------------- private method --------------------
    func setupSubviews() {
        addSubview(scrollView)
        addSubview(pageControl)
        pageControl.frame = CGRect(x: 0, y: self.frame.size.height - 15, width: self.frame.size.width, height: 15)
        NotificationCenter.default.addObserver(self, selector: #selector(handleMemoryWarning), name: UIApplication.didReceiveMemoryWarningNotification, object: nil)
    }
    /// 清理
    func cleanUp() {
        for key in pages.keys {
            reusePageView(at: key.intValue)
        }
        reusablePages.removeAll()
    }
    /// 处理页面警告
    @objc func handleMemoryWarning() {
        reusePageViewsIfNeed(with: self.currentPageRate)
        reusablePages.removeAll()
    }
    @objc func pageControlChanged(pageControl: UIPageControl) {
        setCurrent(pageIndex: pageControl.currentPage, animated: true)
    }
    @objc func timerDidTriggered(timer: Timer) {
        let pageIndex: Int = timerPageIndex(pageIndex: _innerCurrentPageIndex + 1)
        setPageRate(pageRate: Double(pageIndex), animated: true, scroll: true)
    }
    override public func layoutSubviews() {
        super.layoutSubviews()
        let pageIndex = currentPageIndex()
        if setScrollContentSizeIfNeed() {
            setCurrent(pageIndex: pageIndex, animated: false)
        }
    }
    override public func didMoveToWindow() {
        if self.window == nil {
            isTimerValid = timer?.isValid ?? false
            stopTimer()
        } else if self.isTimerValid {
            startTimer(interval: self.timeInteraval)
        }
    }
    /// 是否需要设置contentSize
    @discardableResult
    func setScrollContentSizeIfNeed() -> Bool {
        let width: CGFloat = self.frame.width
        let height: CGFloat = self.frame.height
        var count: Int = numberOfPages
        var contentSize = CGSize(width: width, height: height)
        if count > 1 {
            count = isCarousel ? count + 2 : count
            contentSize = (scrollDirection == .Horizontal) ? CGSize(width: width * CGFloat(count), height: height) : CGSize(width: width, height: height * CGFloat(count))
        }
        if !contentSize.equalTo(scrollView.contentSize) {
            scrollView.frame = CGRect.init(x: 0, y: 0, width: width, height: height)
            scrollView.contentSize = contentSize
            return true
        }
        return false
    }
    /// 传入的下标对应的真正下标
    func normalPageIndex(pageIndex: Int) -> Int {
        let count: Int = numberOfPages
        if count <= 1 { return 0 }
        var index: Int = pageIndex
        if isCarousel {
            if index < 1 {
                index = count - 1
            } else if index > count {
                index = 0
            } else {
                index = index - 1;
            }
        } else if index < 0 {
            index = count - 1
        } else if index >= count {
            index = 0
        }
        return index
    }
    /// 定时器所在的下标
    func timerPageIndex(pageIndex: Int) -> Int {
        var count = numberOfPages
        if count <= 1 { return 0 }
        count = isCarousel ? count + 2 : count
        var index: Int = pageIndex
        if index < 0 {
            index = count - 1
        } else if index >= count {
            index = 0
        }
        return index
    }
    /// pageIndex 是否有效
    func isVaild(pageIndex: Int) -> Bool {
        let count = numberOfPages
        if isCarousel {
            if count > 1 {
                return (pageIndex >= 0 && pageIndex < count + 2)
            } else {
                return (pageIndex == 0)
            }
        }
        return (pageIndex >= 0 && pageIndex < count)
    }
    /// 设置pageIndex 对应的页面
    func setPageRate(pageRate: Double, animated: Bool, scroll: Bool) {
        let currentIndex: Int = Int(round(pageRate))
        // 如果当前分页不可用(即index无效,超出数组范围)，直接返回
        if !isVaild(pageIndex: currentIndex) { return }
        
        // 滚动到指定分页
        if scroll {
            switch scrollDirection {
            case .Horizontal:
                let offset: CGFloat = CGFloat(currentIndex) * scrollView.frame.width
                if offset != scrollView.contentOffset.x {
                    scrollView.setContentOffset(CGPoint.init(x: offset, y: 0), animated: animated)
                    return
                }
                break
            default:
                let offset: CGFloat = CGFloat(currentIndex) * scrollView.frame.height
                if offset != scrollView.contentOffset.y {
                    scrollView.setContentOffset(CGPoint.init(x: 0, y: offset), animated: animated)
                    return
                }
                break
            }
        }
        if pageControl.numberOfPages > 0 {
            pageControl.currentPage = currentPageIndex()
        }
        if shouldLoadPages(at: pageRate) {
            currentPageRate = pageRate
            innerCurrentPageIndex = currentIndex
            pageIndexes = usedPageIndexes(with: pageRate)
            // 重用分页
            reusePageViewsIfNeed(with: pageRate)
            // 加载分页
            loadPageViewsIfNeed(with: pageRate)
        }
    }
    /// 滑动比例 是否需要加载视图
    func shouldLoadPages(at pageRate: Double) -> Bool {
        if ceil(currentPageRate) != ceil(pageRate) || floor(currentPageRate) != floor(pageRate) {
            return true
        }
        let pageIndex: Int = Int(round(pageRate))
        let normalIndex: Int = normalPageIndex(pageIndex: pageIndex)
        let pageView: BannerPageView? = pages[NSNumber(value: normalIndex)]
        guard let page = pageView else {
            return true
        }
        // 如果pageView的frame 与应当出现的frame不一致，则需要加载
        return !(page.frame.equalTo(pageViewFrame(at: pageIndex)))
    }
    /// 下标页面尺寸
    func pageViewFrame(at pageIndex: Int) -> CGRect {
        let width = self.frame.width
        let height = self.frame.height
        return (self.scrollDirection == .Horizontal) ? CGRect(x: width * CGFloat(pageIndex), y: 0, width: width, height: height) : CGRect(x: 0, y: height * CGFloat(pageIndex), width: width, height: height)
    }
    /// 把滑动的pageRate存入 pageIndexes
    func usedPageIndexes(with pageRate: Double) -> Set<NSNumber> {
        var set = Set<NSNumber>()
        let leftIndex: Int = Int(floor(pageRate))
        let rightIndex: Int = Int(ceil(pageRate))
        if preparedPageCount == 0 {
            if isVaild(pageIndex: leftIndex) {
                set.insert(NSNumber(value: leftIndex))
            }
            if isVaild(pageIndex: rightIndex) {
                set.insert(NSNumber(value: rightIndex))
            }
        } else {
            let currentIndex: Int = Int(round(pageRate))
            let preparedCount: Int = preparedPageCount
            for i in (currentIndex - preparedCount ..< currentIndex + preparedCount + 1) {
                if isVaild(pageIndex: i) {
                    set.insert(NSNumber(value: i))
                }
            }
        }
        return set
    }
    func reusePageViewsIfNeed(with pageRate: Double) {
        for key in pages.keys {
            if !(pageIndexes.contains(key)) {
                reusePageView(at: key.intValue)
            }
        }
    }
    func loadPageViewsIfNeed(with pageRate: Double) {
        for key in pageIndexes {
            loadPageView(at: key.intValue)
        }
    }
    func loadPageView(at index: Int) {
        if !isVaild(pageIndex: index) {
            return
        }
        let normalIndex: Int = normalPageIndex(pageIndex: index)
        let key = NSNumber(value: normalIndex)
        var pageView: BannerPageView? = pages[key]
        if pageView == nil {
            pageView = delegate?.viewForPageIndex(self, at: normalIndex)
            if pageView != nil {
                pages[key] = pageView!
                scrollView.addSubview(pageView!)
                // 添加手势
                handleTapGesture(in: pageView!, at: normalIndex)
            }
        }
        pageView?.frame = pageViewFrame(at: index)
        
    }
    func reusePageView(at index: Int) {
        let key = NSNumber(value: index)
        let pageView: BannerPageView? = pages[key]
        if let page = pageView {
            page.preparedForReuse()
            page.removeFromSuperview()
            pages.removeValue(forKey: key)
            var pageSet: Set<BannerPageView>? = reusablePages[page.reuseIdentifier!]
            if var set = pageSet {
                set.insert(page)
            } else {
                pageSet = Set<BannerPageView>()
                pageSet!.insert(page)
                reusablePages[page.reuseIdentifier!] = pageSet!
            }
            delegate?.preparedForReuse(self, at: index)
        }
    }
    // MARK:  ------------- 添加手势方法 --------------------
    private struct AssociatedKeys {
        static var kBannerKey: String = "xtuikit-swift.bannerKey"
    }
    func handleTapGesture(in pageView: BannerPageView, at index: Int) {
        pageView.tapGR.isEnabled = delegate?.canSelected(self, at: index) ?? false
        pageView.tapGR.removeTarget(nil, action: nil)
        objc_setAssociatedObject(pageView.tapGR as Any, &AssociatedKeys.kBannerKey, index, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        pageView.tapGR.addTarget(self, action: #selector(actionTap))
    }
    @objc func actionTap(_ tapGR: UITapGestureRecognizer) {
        let numPageIndex = objc_getAssociatedObject(tapGR, &AssociatedKeys.kBannerKey)
        if let index = numPageIndex {
            delegate?.didSelected(self, at: index as! Int)
        }
    }
}

public protocol BannerDelegate : UIScrollViewDelegate {
    /// 页数
    func numberOfPages(_ banner: Banner) -> Int
    /// page
    func viewForPageIndex(_ banner: Banner, at index: Int) -> BannerPageView
    /// 分页被收回 重用时回触发
    func preparedForReuse(_ banner: Banner, at index: Int)
    /// 展示
    func showPageView(_ banner: Banner, at index: Int)
    /// 点击
    func didSelected(_ banner: Banner, at index: Int)
    /// 当前页改变
    func currentPageIndexDidChanged(_ banner: Banner, at index: Int)
    /// 是否可以点击
    func canSelected(_ banner: Banner, at index: Int) -> Bool
}

public extension BannerDelegate {
    func preparedForReuse(_ banner: Banner, at index: Int) {}
    func showPageView(_ banner: Banner, at index: Int) {}
    func didSelected(_ banner: Banner, at index: Int) {}
    func currentPageIndexDidChanged(_ banner: Banner, at index: Int) {}
    func canSelected(_ banner: Banner, at index: Int) -> Bool { false }
}


extension Banner: UIScrollViewDelegate {
    /// banner滑动方向
    public enum Direction {
        case Horizontal
        case Vertical
    }
    
    // MARK:  ------------- UIScrollViewDelegate --------------------
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.scrollViewDidScroll?(scrollView)
        let width: CGFloat = scrollView.frame.width
        let height: CGFloat = scrollView.frame.height
        let count: Int = numberOfPages
        switch scrollDirection {
        case .Horizontal:
            var offset = scrollView.contentOffset.x
            if count <= 1 || width == 0 { return }
            let pageRate: Double = Double(offset / width)
            let currentIndex = Int(round(pageRate))
            if isCarousel {
                if currentIndex < 1 {
                    offset = width * CGFloat(count) + offset
                    scrollView.contentOffset = CGPoint.init(x: offset, y: 0)
                    return
                } else if currentIndex > count {
                    offset = offset - width * CGFloat(count)
                    scrollView.contentOffset = CGPoint.init(x: offset, y: 0)
                    return
                }
            }
            
            setPageRate(pageRate: pageRate, animated: false, scroll: false)
            break
        default:
            var offset = scrollView.contentOffset.y
            if count <= 1 || height == 0 { return }
            let pageRate: Double = Double(offset / height)
            let currentIndex = Int(round(pageRate))
            if isCarousel {
                if currentIndex < 1 {
                    offset = height * CGFloat(count) + offset
                    scrollView.contentOffset = CGPoint.init(x: 0, y: offset)
                    return
                } else if currentIndex > count {
                    offset = offset - height * CGFloat(count)
                    scrollView.contentOffset = CGPoint.init(x: 0, y: offset)
                    return
                }
            }
            setPageRate(pageRate: pageRate, animated: false, scroll: false)
            break
        }
        
    }
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        delegate?.scrollViewDidEndScrollingAnimation?(scrollView)
        delegate?.showPageView(self, at: currentPageIndex())
    }
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isTimerValid = timer?.isValid ?? false
        stopTimer()
        delegate?.scrollViewWillBeginDragging?(scrollView)
    }
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if isTimerValid {
            startTimer(interval: timeInteraval)
        }
        delegate?.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
        if !decelerate {
            self.delegate?.showPageView(self, at: self.currentPageIndex())
        }
    }
    public func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        self.delegate?.scrollViewWillBeginDecelerating?(scrollView)
    }
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.delegate?.scrollViewDidEndDecelerating?(scrollView)
        self.delegate?.showPageView(self, at: self.currentPageIndex())
    }
}
