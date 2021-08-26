//
//  TabbarVC.swift
//  TPUIKit-Swift_Example
//
//  Created by Topredator on 2021/8/26.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import TPUIKit_Swift
import TPFoundation_Swift
class TabbarVC: BaseViewController {
    
    lazy var pageControl: PageControl = {
        let control = PageControl(frame: CGRect.zero)
        control.pageImage = UIImage.tp.image(withColor: .white, size: CGSize(width: 10.0, height: 10.0))
        control.pageSelectedImage = UIImage.tp.image(withColor: .red, size: CGSize(width: 10.0, height: 10.0))
        control.backgroundColor = .gray
        return control
    }()
    
    /// 管控 点击tabbarItem时，动画执行scroll，指示器动画错乱
    var isClickItem: Bool = false
    public lazy var tabbar: Tabbar = {
        let tabbar = Tabbar.init(frame: CGRect.zero)
        tabbar.delegate = self
        tabbar.itemTitleColor = UIColor.tp.rgbt(102)
        tabbar.itemTitleSelectedColor = UIColor.tp.rgbt(51)
        tabbar.itemTitleFont = UIFont.tp.font(15, weight: .medium)
        tabbar.itemTitleSelectedFont = UIFont.tp.font(18, weight: .medium)
        tabbar.indicatorColor = UIColor.red
        tabbar.indicatorFrameFollowScroll = true
        tabbar.indicatorWidthFixText(top: 43, bottom: 0, switchAnimated: true)
        return tabbar
    }()
    public lazy var scrollView: Banner = {
        let banner = Banner(frame: CGRect.zero)
        banner.delegate = self
        banner.pageControl.isHidden = true
        return banner
    }()
    /// 初始化索引  默认0
    public var initialTabIndex: Int = 0
    private var _viewControllers = [UIViewController]()
    public var viewControllers: [UIViewController] {
        get { return _viewControllers }
        set {
            _viewControllers = newValue
            childViewControllers.forEach{ $0.removeFromParentViewController() }
            var itemList: [TabItem] = []
            for vc in newValue {
                addChildViewController(vc)
                let item = TabItem()
                item.setTitle(vc.title, for: UIControl.State.normal)
                itemList.append(item)
            }
            tabbar.items = itemList
            DispatchQueue.main.async {
                self.tabbar.selectedItemIndex = self.initialTabIndex
                self.scrollView.reloadData(show: self.initialTabIndex)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        
        viewControllers = [
            ScrollTabbarVC("test1"),
            ScrollTabbarVC("test2")
        ]
        pageControl.numberOfPages = 2
    }
    
    func setupSubviews() {
        view.addSubview(scrollView)
        view.addSubview(tabbar)
        tabbar.frame = CGRect(x: 0.0, y: 0.0, width: UI.ScreenWidth, height: 45)
        scrollView.snp.makeConstraints { $0.edges.equalTo(UIEdgeInsets(top: 45, left: 0, bottom: 0, right: 0)) }
        scrollView.addSubview(pageControl)
        pageControl.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-30)
            $0.height.equalTo(20)
            $0.centerX.equalToSuperview()
        }
    }
}

extension TabbarVC: BannerDelegate, TabbarDelegate {
    // MARK:  ------------- BannerDelegate --------------------
    func numberOfPages(_ banner: Banner) -> Int {
        viewControllers.count
    }
    func viewForPageIndex(_ banner: Banner, at index: Int) -> BannerPageView {
        let pageVC: UIViewController = viewControllers[index]
        var pageView = banner.dequeueReusablePage(indentifier: "page")
        if pageView == nil {
            pageView = BannerPageView(reuseIdentifier: "page")
        }
        if pageVC.view.superview == nil || !(pageVC.view.superview!.isEqual(pageView!)) {
            pageView!.addSubview(pageVC.view)
            pageVC.view.frame = CGRect.init(x: 0, y: 0, width: pageView!.frame.width, height: pageView!.frame.height)
        }
        return pageView!
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isClickItem { return }
        let x: CGFloat = scrollView.contentOffset.x
        let maxIndex = viewControllers.count - 1
        if x >= 0 && x <= UI.ScreenWidth * CGFloat(maxIndex) {
            tabbar.updateSubviewsWhenParentScrollViewScroll(scrollView: scrollView)
        }
    }
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        isClickItem = false
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page: Int = Int(scrollView.contentOffset.x / scrollView.frame.width)
        tabbar.selectedItemIndex = page
        pageControl.currentPage = page
        isClickItem = false
    }
    // MARK:  ------------- TabbarDelegate --------------------
    func didSelectedItem(tabbar: Tabbar, atIndex: Int) {
        isClickItem = true
        scrollView.setCurrent(pageIndex: atIndex, animated: true)
        pageControl.currentPage = atIndex
    }
}




class ScrollTabbarVC: BaseViewController {
     convenience init(_ title: String) {
        self.init()
        self.title = title
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.tp.random
    }
}
