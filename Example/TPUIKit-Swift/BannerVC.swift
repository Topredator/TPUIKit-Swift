//
//  BannerVC.swift
//  TPUIKit-Swift_Example
//
//  Created by Topredator on 2021/8/26.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import TPUIKit_Swift

class BannerVC: BaseViewController {
    
    lazy var banner: Banner = {
        let banner = Banner(frame: CGRect.zero)
        banner.delegate = self
        banner.isCarousel = true
        return banner
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Banner"
        setupSubviews()
    }
    
    func setupSubviews() {
        view.addSubview(banner)
        banner.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        banner.reloadData()
//        banner.startTimer(interval: 3)
    }
}

extension BannerVC: BannerDelegate {
    func numberOfPages(_ banner: Banner) -> Int { 3 }
    
    func viewForPageIndex(_ banner: Banner, at index: Int) -> BannerPageView {
        var pageView = banner.dequeueReusablePage(indentifier: "page")
        if pageView == nil {
            pageView = PageView(reuseIdentifier: "page")
            pageView!.backgroundColor = .red
        }
        (pageView as! PageView).label.text = "Number \(index + 1)"
        return pageView!
    }
    func canSelected(_ banner: Banner, at index: Int) -> Bool { true }
    func didSelected(_ banner: Banner, at index: Int) {
        print("click number\(index + 1)")
    }
    
}

class PageView: BannerPageView {
    public var label: UILabel = {
        let label = UILabel.init(frame: CGRect.zero)
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = NSTextAlignment.center
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
        label.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.equalTo(30)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
