//
//  Toast.swift
//  XTUIKit-Swift
//
//  Created by Topredator on 2021/4/2.
//

import Foundation
import MBProgressHUD

public typealias ToastErrorHandle = (Error?) -> String?
var globalErrorHandler: ToastErrorHandle? = nil
public class Toast: MBProgressHUD {
    public override init(view: UIView) {
        super.init(view: view)
        self.contentColor = .white
        self.detailsLabel.font = UIFont.systemFont(ofSize: 14)
        self.bezelView.style = .solidColor
        self.animationType = .fade
        self.bezelView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        self.bezelView.layer.cornerRadius = 10
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:  ------------- Public method --------------------
    public static func setError(handler: @escaping ToastErrorHandle) {
        globalErrorHandler = handler
    }
    public static var errorHandler: ToastErrorHandle? {
        globalErrorHandler
    }
    
    /// 展示正在加载的视图
    /// - Parameters:
    ///   - str: 加载文案
    ///   - inView: 父视图
    @discardableResult
    public static func show(loading str: String?, in inView: UIView? = nil) -> Toast? {
        var view: UIView = UIApplication.shared.keyWindow!
        if let bgView = inView {
            view = bgView
            self.hide(in: view)
        } else { self.hideToast() }
        
        let toast = self.showAdded(to: view, animated: true)
        toast.mode = .customView
        let imageView = self.animateView()
        toast.customView = imageView
//        toast.minSize = CGSize(width: 110, height: 110)
        toast.minSize = imageView.frame.size
        toast.isSquare = true
        if let content = str {
            toast.detailsLabel.text = content
            toast.detailsLabel.textColor = .white
        }
        imageView.startAnimating()
        return toast
    }
    
    /// 无文案 加载动画
    @discardableResult
    public static func showLoading() -> Toast? { self.show(loading: nil) }
    /// 展示成功
    /// - Parameters:
    ///   - str: 成功文案
    ///   - inView: 父视图
    ///   - time: 展示时间
    @discardableResult
    public static func show(success str: String?, in inView: UIView? = nil, time: TimeInterval = 0.0) -> Toast? {
        return self.show(str, icon: General.image("toastSuccess"), in: inView, time: time, mode: .customView)
    }
    
    /// 无文案的 成功提醒
    @discardableResult
    public static func showSuccess() -> Toast? {
        return self.show(success: nil)
    }
    /// 错误提示
    /// - Parameters:
    ///   - err: 错误对象
    ///   - inView: 父视图
    @discardableResult
    public static func show(error: Error?, in inView: UIView? = nil) -> Toast? {
        var msg: String?
        if let errorHandler = self.errorHandler {
             msg = errorHandler(error)
        } else {
            msg = error?.localizedDescription
        }
        return self.show(msg, icon: General.image("iconError"), in: inView, mode: .customView)
    }
    @discardableResult
    public static func showError() -> Toast? {
        return self.show(nil, icon: General.image("iconError"), mode: .customView)
    }
    /// 提醒文案
    /// - Parameters:
    ///   - str: 提醒文案
    ///   - inView: 父视图
    ///   - time: 展示时间
    @discardableResult
    public static func show(info str: String?, in inView: UIView? = nil, time: TimeInterval = 0.0) -> Toast? {
        let view = bgView(inView)
        guard let content = str else { return nil }
        let toast = self.showAdded(to: view, animated: true)
        toast.mode = .text
        toast.detailsLabel.textColor = .white;
        toast.detailsLabel.text = content;
        toast.hide(animated: true, afterDelay: time > 0 ? time : self.duration(forDisplay: str))
        return toast
    }
    
    static func duration(forDisplay string: String?) -> TimeInterval {
        guard let content = string else { return 1.5 }
        return max(1.8, min(Double(content.count) * 0.1 + 0.5, 5.0))
    }
    
    /// 隐藏视图
    /// - Parameter inView: 父视图
    public static func hide(in inView: UIView?) {
        guard let view = inView else { return }
        self.hide(for: view, animated: true)
    }
    
    /// 隐藏视图 (父视图为keyWindow)
    public static func hideToast() {
        self.hide(for: UIApplication.shared.keyWindow!, animated: true)
    }
    
    /// 通用 Toast
    /// - Parameters:
    ///   - text: 文案
    ///   - icon: 图标
    ///   - inView: 父视图
    ///   - time: 展示时间
    ///   - mode: 展示 类型
    @discardableResult
    public static func show(_ text: String?, icon: UIImage? = nil, in inView: UIView? = nil, time: TimeInterval = 0.0, mode: MBProgressHUDMode = .text) -> Toast? {
        let view = bgView(inView)
        let toast = self.showAdded(to: view, animated: true)
        toast.mode = mode
        if let content = text {
            toast.detailsLabel.text = content
            toast.detailsLabel.textColor = .white
        }
        if let image = icon {
            toast.customView = UIImageView(image: image)
        }
        toast.removeFromSuperViewOnHide = true
        toast.hide(animated: true, afterDelay: time > 0 ? time : self.duration(forDisplay: text))
        return toast
    }
    
    // MARK:  ------------- Private method --------------------
    
    /// 获取 toast的父视图
    /// - Parameter inView: 传入的视图 （nil时，取keyWindow）
    private static func bgView(_ inView: UIView?) -> UIView {
        var view: UIView = UIApplication.shared.keyWindow!
        if let bgView = inView {
            view = bgView
            self.hide(in: view)
        } else {
            self.hideToast()
        }
        return view
    }
    
    /// 自定义动画 图片视图
    private static func animateView() -> UIImageView {
        let imageView = UIImageView(frame: CGRect.zero)
        var images = [UIImage]()
        for i in 1 ... 44 {
            let image = General.image(String(format: "loading%02d", i))
            if let animateImage = image { images.append(animateImage) }
        }
        imageView.animationImages = images
        imageView.contentMode = .scaleAspectFill
        imageView.animationDuration = 3.0
        imageView.animationRepeatCount = 0
        return imageView
    }
}
