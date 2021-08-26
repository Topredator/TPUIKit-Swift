//
//  UIView+BlankView.swift
//  XTUIKit-swift
//
//  Created by Topredator on 2020/5/26.
//

import UIKit
//import XTUIKit
public extension UIView {
    
    @discardableResult
    /// 加载动画
    func showLoading()  -> ImageBlankView? {
        let blankView = ImageBlankView(in: self, animated: true)
        blankView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        var images: [UIImage] = []
        for i in 1...44 {
            images.append(General.image(String.init(format: "loading%02d", i))!)
        }
        blankView.imageView.animationImages = images
        blankView.imageView.contentMode = UIView.ContentMode.scaleAspectFit
        blankView.imageView.animationDuration = 3.5
        blankView.imageView.animationRepeatCount = 0
        blankView.imageView.startAnimating()
        blankView.imageView.snp.remakeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 50, height: 50))
            make.edges.equalToSuperview()
        }
        return blankView
    }
    
    @discardableResult
    /// 自定义加载
    func showCustomLoading(_ title: String? = nil) -> TextBlankView? {
        guard var path = BlankManager.share.blankMaker.resourcesPath else { return nil }
        path += "/loading"
        guard let imgNames = try? FileManager.default.contentsOfDirectory(atPath: path) else { return nil }
        guard imgNames.count > 0, imgNames[0].contains("CustomLoading") else { return nil }
        var imgs = [UIImage]()
        for index in 0 ..< imgNames.count {
            let name = String(format: "/CustomLoading%02d@2x.png", index)
            let imgPath = path + name
            if let img = UIImage(contentsOfFile: imgPath) { imgs.append(img) }
        }
        
        let blankView = TextBlankView(in: self, animated: true)
        if let title = title {
            blankView.titleLabel.textColor = BlankManager.share.blankMaker.titleColor
            blankView.titleLabel.font = BlankManager.share.blankMaker.titleFont
            blankView.config(title: title)
        }
        blankView.backgroundColor = .black.withAlphaComponent(0.3)
        blankView.imageView.animationImages = imgs
        blankView.imageView.contentMode = .scaleAspectFit
        blankView.imageView.animationDuration = 2.5
        blankView.imageView.animationRepeatCount = 0
        blankView.imageView.startAnimating()
        blankView.snp.updateConstraints { make in
            make.size.equalTo(CGSize(width: 80.0, height: 80.0))
        }
        return blankView
    }
    
    @discardableResult
    func showCustomNoData(_ title: String = "暂无数据") -> TextBlankView? {
        guard var path = BlankManager.share.blankMaker.resourcesPath else { return nil }
        path += "/default"
        guard let imgNames = try? FileManager.default.contentsOfDirectory(atPath: path) else { return nil }
        var isExist = false
        for name in imgNames {
            if name.contains("noData") { isExist = true }
        }
        guard !isExist else { return nil }
        let imgPath: String = path + "/noData@2x.png"
        guard let img = UIImage(contentsOfFile: imgPath) else { return nil }
        let blankView = createBlank(inView: self, image: img, title: title, subText: nil)
        blankView?.titleLabel.font = BlankManager.share.blankMaker.titleFont
        blankView?.titleLabel.textColor = BlankManager.share.blankMaker.titleColor
        return blankView
    }
    
    @discardableResult
    func showCustomNetworkError(_ title: String?, target: Any? = nil, action: Selector? = nil) -> TextBlankView? {
        guard var path = BlankManager.share.blankMaker.resourcesPath else { return nil }
        path += "/network"
        guard let imgNames = try? FileManager.default.contentsOfDirectory(atPath: path) else { return nil }
        var isExist = false
        for name in imgNames {
            if name.contains("CustomNetworkError") { isExist = true }
        }
        guard !isExist else { return nil }
        let imgPath: String = path + "/CustomNetworkError@2x.png"
        guard let img = UIImage(contentsOfFile: imgPath) else { return nil }
        let blankView = createBlank(inView: self, image: img, title: title, subText: nil)
        if let _ = title {
            blankView?.titleLabel.font = BlankManager.share.blankMaker.titleFont
            blankView?.titleLabel.textColor = BlankManager.share.blankMaker.titleColor
        }
        blankView?.refreshBtn.backgroundColor = BlankManager.share.blankMaker.refreshBtnBgColor
        blankView?.refreshBtn.setTitle("重新加载", for: .normal)
        blankView?.refreshBtn.setTitleColor(BlankManager.share.blankMaker.refreshBtnTitleColor, for: .normal)
        blankView?.refreshBtn.titleLabel?.font = BlankManager.share.blankMaker.refreshBtnFont
        blankView?.refreshBtn.layer.masksToBounds = true
        blankView?.refreshBtn.layer.cornerRadius = BlankManager.share.blankMaker.btnRadius
        return blankView
    }
    
    
    @discardableResult
    func showBlank(_ image: UIImage? = nil,
                   title: String? = nil,
                   subTitle: String? = nil,
                   refreshTitle: String? = nil,
                   target: Any? = nil,
                   action: Selector? = nil) -> TextBlankView? {
        let blankView = createBlank(inView: self, image: image, title: title, subText: subTitle)
        blankView?.configBtn(title: refreshTitle, target: target, selector: action)
        return blankView
    }
    @discardableResult
    func showBlank(_ image: UIImage? = nil,
                   title: String? = nil,
                   subTitle: String? = nil,
                   refreshTitle: String? = nil,
                   closure: (() -> ())? = nil)
    -> TextBlankView? {
        let blankView = createBlank(inView: self, image: image, title: title, subText: subTitle)
        blankView?.configBtn(title: refreshTitle, actionBlock: closure)
        return blankView
    }
    
    @discardableResult
    func showNetworkError(err: NSError?, target: Any?, selector: Selector?) -> TextBlankView? {
        guard let err = err else { return nil }
        if err.domain == NSURLErrorDomain && err.code == NSURLErrorNotConnectedToInternet {
            return showNoNetwork("网络不给力，请稍后再试试吧~", target, selector)
        }
        return showNoNetwork("服务器忙，请稍后再试", target, selector)
    }
    @discardableResult
    func showNetworkError(err: NSError?, block: (() -> Void)?) -> TextBlankView? {
        let blankView = showNetworkError(err: err, target: nil, selector: nil)
        blankView?.configBtn(title: "重新加载", actionBlock: block)
        return blankView
    }
    @discardableResult
    func showNoNetwork(_ text: String, _ target: Any?, _ selector: Selector?) -> TextBlankView? {
        let blankView = createBlank(inView: self, image: General.image("networkError"), title: nil, subText: text)
        blankView?.configBtn(title: "重新加载", target: target, selector: selector)
        return blankView
    }
    
    /// 隐藏
    func hideBlank(_ animated: Bool = false) {
        BlankView.hide(inView: self, animated: animated)
    }
    
    /// 创建blank
    @discardableResult
    private func createBlank(inView: UIView, image: UIImage?, title: String?, subText: String?) -> TextBlankView? {
        let blankView = TextBlankView(in: inView, animated: true)
        blankView.imageView.image = image
        blankView.config(title: title, subText: subText)
        return blankView
    }
}
