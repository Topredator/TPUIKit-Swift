//
//  PageControl.swift
//  XTUIKit-Swift
//
//  Created by Topredator on 2021/4/1.
//

import Foundation
import TPFoundation_Swift
import SnapKit
public protocol PageControlPotocol: AnyObject {
    
    /// 点击 page
    /// - Parameters:
    ///   - pageControl: 当前pageControl
    ///   - atIndex: 点击的下标
    func pageControl(_ pageControl: PageControl, didSelectPage atIndex: Int)
}

public class PageControl: UIControl {
    /// 当前page 下标
    private var _currentPage: Int = 0
    public var currentPage: Int {
        get { _currentPage }
        set {
            _currentPage = newValue
            reset()
        }
    }
    public func setBgColor(_ color: UIColor?) {
        self.container.backgroundColor = color
    }
    /// pages总数
    private var _numberOfPages: Int = 0
    public var numberOfPages: Int {
        get { _numberOfPages }
        set {
            _numberOfPages = newValue
            reset()
        }
    }
    /// 展示 位置
    private var _position: Position = .center
    public var position: Position {
        get { _position }
        set {
            _position = newValue
            reset()
        }
    }
    /// 单个page 是否隐藏
    public var hideInSinglePage: Bool = false
    /// pages 间隔
    private var _distanceOfPages: CGFloat = 8.0
    public var distanceOfPages: CGFloat {
        get { _distanceOfPages }
        set {
            _distanceOfPages = newValue
            reset()
        }
    }
    /// 默认展示
    private var _pageImage: UIImage? = nil
    public var pageImage: UIImage? {
        get { _pageImage }
        set {
            _pageImage = newValue
            reset()
        }
    }
    /// 选中展示
    private var _pageSelectedImage: UIImage? = nil
    public var pageSelectedImage: UIImage? {
        get { _pageSelectedImage }
        set {
            _pageSelectedImage = newValue
            reset()
        }
    }

    public weak var delegate: PageControlPotocol?
    lazy var container: UIView = {
        let view = UIView(frame: CGRect.zero)
        return view
    }()
    var pages = [UIImageView]()
    
    public convenience init(frame: CGRect, _ position: Position = .center) {
        self.init(frame: frame)
        self.position = position
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 默认值
    func setupSubviews() {
        self.addSubview(container)
        self.container.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.height.equalTo(self)
        }
    }
    
    /// 更新 子视图
    func updatePages() {
        guard numberOfPages > 0 else { return }
        guard let defaultImage = self.pageImage else { return }
        container.snp.remakeConstraints { [weak self] (make) in
            switch self!.position {
            case .center:
                make.centerX.top.bottom.equalTo(0)
                break
            case .left:
                make.left.top.bottom.equalTo(0)
                make.right.lessThanOrEqualTo(0)
                break
            case .right:
                make.right.top.bottom.equalTo(0)
                make.left.greaterThanOrEqualTo(0)
                break
            }
        }
        var lastView: UIImageView? = nil
        let size = defaultImage.size
        for _ in 0 ..< numberOfPages {
            let pageView = UIImageView(image: defaultImage)
            self.container.addSubview(pageView)
            self.pages.append(pageView)
            pageView.snp.makeConstraints { (make) in
                make.centerY.equalToSuperview()
                make.size.equalTo(size)
                if let last = lastView {
                    make.left.equalTo(last.snp.right).offset(self.distanceOfPages)
                } else {
                    make.left.equalTo(self.container.snp.left).offset(self.distanceOfPages / 2)
                }
            }
            lastView = pageView
        }
        if let last = lastView {
            self.container.snp.makeConstraints { (make) in
                make.right.equalTo(last.snp.right).offset(self.distanceOfPages / 2)
            }
        }
        change(true, at: self.currentPage)
        hideSinglePageIfNeed()
    }
    
    func change(_ active: Bool, at index: Int) {
        guard let defaultImage = self.pageImage, let selectedImage = self.pageSelectedImage else { return }
        guard self.pages.count > 0 else { return }
        let pageSize = defaultImage.size
        let selectedSize = selectedImage.size
        let imageView = pages[index] as UIImageView
        imageView.image = active ? selectedImage : defaultImage
        imageView.snp.makeConstraints { (make) in
            make.size.equalTo(active ? selectedSize : pageSize)
        }
    }
    /// 重置
    func reset() {
        container.tp.removeAllSubviews()
        pages.removeAll()
        updatePages()
    }
    
    /// 单个page时，是否需要隐藏
    func hideSinglePageIfNeed() {
        self.isHidden = (pages.count <= 1 && hideInSinglePage)
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchItem = (touches as NSSet).anyObject()
        guard let touch = touchItem as? UITouch, touch.view != self else { return }
        guard self.pages.count < 1 else { return }
        let pageIndex = self.pages.firstIndex(of: touch.view as! UIImageView)
        if let index = pageIndex {
            delegate?.pageControl(self, didSelectPage: index)
        }
    }
    public override func sizeToFit() {
        reset()
    }
}
public extension PageControl {
    /// 位置
    enum Position {
        case center
        case left
        case right
    }
}

public extension PageControlPotocol {
    func pageControl(_ pageControl: PageControl, didSelectPage atIndex: Int) {}
}
