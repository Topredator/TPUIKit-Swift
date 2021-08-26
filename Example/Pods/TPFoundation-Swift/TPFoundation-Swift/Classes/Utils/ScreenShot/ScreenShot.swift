//
//  Screenshot.swift
//  XTFoundation-Swift
//
//  Created by Topredator on 2021/3/29.
//

import Foundation

/// 屏幕快照
public struct ScreenShot {
    
    /// 当前屏幕快照
    static var current: UIImage? {
        let size = UIScreen.main.bounds.size
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(size, true, scale)
        UIApplication.shared.keyWindow?.layer.render(in: UIGraphicsGetCurrentContext()!)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
    
    /// 截取 视图 -> 图片
    /// - Parameter view: 需要截取的视图
    public static func shot(with view: UIView?) -> UIImage? {
        guard let shotView = view else { return nil }
        let size = shotView.frame.size
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(size, true, scale)
        shotView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
    
    /// 截取 scrollview -> 图片
    /// - Parameter scrollView: 需要截取的scrollview
    public static func shot(with scrollView: UIScrollView?) -> UIImage? {
        guard let scroll = scrollView else { return nil }
        let size = scroll.contentSize
        UIGraphicsBeginImageContextWithOptions(size, true, UIScreen.main.scale)
        
        //获取当前scrollview的frame 和 contentOffset
        let saveFrame = scroll.frame
        let saveOffset = scroll.contentOffset
        //置为起点
        scroll.contentOffset = CGPoint.zero
        scroll.frame = CGRect(x: 0.0, y: 0.0, width: scroll.contentSize.width, height: scroll.contentSize.height)
        scroll.layer.render(in: UIGraphicsGetCurrentContext()!)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        scroll.frame = saveFrame
        scroll.contentOffset = saveOffset
        return img
    }
    
    /// 截取视图 部分视图 -> 图片
    /// - Parameters:
    ///   - innerView: 需要截取的视图
    ///   - frame: 截取部分 frame
    public static func shot(in innerView: UIView?, frame: CGRect) -> UIImage? {
        guard let view = innerView else { return nil }
        UIGraphicsBeginImageContext(view.frame.size)
        let context = UIGraphicsGetCurrentContext()!
        context.saveGState()
        UIRectClip(frame)
        view.layer.render(in: context)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        guard let image = img else { return nil }
        return UIImage(cgImage: (image.cgImage?.cropping(to: frame))!)
    }
    
}
