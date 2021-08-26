//
//  Image+TP.swift
//  TPFoundation-Swift
//
//  Created by Topredator on 2021/8/26.
//

import Foundation
import CoreGraphics

extension UIImage: NameSpaceWrappable {}
public extension NameSpace where Base: UIImage {
    /// 给定 尺寸，截取部分图像
    /// - Parameter size: 给定的尺寸
    func image(forSize size: CGSize) -> UIImage? {
        let img = base.tp.scale(toSide: CGSize(width: size.width  * 2, height: size.height * 2))
        return img
    }
    
    /// 截取 部分图像
    /// - Parameter rect: 截取图像的 rect
    func subImage(toRect rect: CGRect) -> UIImage {
        var rect = rect
        rect.origin.x *= base.scale
        rect.origin.y *= base.scale
        rect.size.width *= base.scale
        rect.size.height *= base.scale
        let imageRef = base.cgImage!.cropping(to: rect)
        let image = UIImage(cgImage: imageRef!, scale: base.scale, orientation: base.imageOrientation)
        return image
    }
    
    enum SideType {
        case long, short
    }
    /// 等比缩放
    /// - Parameters:
    ///   - size: 缩放尺寸
    ///   - scaleSideType: 取边长 长度类型 long(最长) short(最短)
    func scale(toSide size: CGSize, scaleSideType: SideType = .long) -> UIImage? {
        var width = CGFloat(base.cgImage!.width)
        var height = CGFloat(base.cgImage!.height)
        let verticalRadio = size.height / CGFloat(height)
        let horizontalRadio = size.width / CGFloat(width)
        var radio = 1.0
        switch scaleSideType {
        case .long:
            if verticalRadio > 1 && horizontalRadio > 1 {
                radio = Double(verticalRadio > horizontalRadio ? verticalRadio : horizontalRadio)
            } else {
                radio = Double(verticalRadio < horizontalRadio ? horizontalRadio : verticalRadio)
            }
        case .short:
            if verticalRadio > 1 && horizontalRadio > 1 {
                radio = Double(verticalRadio > horizontalRadio ? horizontalRadio : verticalRadio)
            } else {
                radio = Double(verticalRadio < horizontalRadio ? verticalRadio : horizontalRadio)
            }
        }
        width *= CGFloat(radio)
        height *= CGFloat(radio)
        let xPos = (size.width - width) / 2
        let yPos = (size.height - height) / 2
        UIGraphicsBeginImageContext(size)
        base.draw(in: CGRect(x: xPos, y: yPos, width: width, height: height))
        let scaleImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaleImg
    }
    /// 颜色 生成图片
    /// - Parameter color: 生成图片的颜色
    static func image(withColor color: UIColor, size: CGSize = CGSize(width: 1.0, height: 1.0)) -> UIImage {
        let rect = CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: size)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
    
    /// 调整 图片尺寸
    /// - Parameters:
    ///   - name: 图片名称
    ///   - left: 左侧偏移
    ///   - top: 顶部偏移
    static func resizedImage(withName name: String, left: CGFloat = 0.5, top: CGFloat = 0.5) -> UIImage? {
        let image = UIImage(named: name)
        guard let img = image else { return nil }
        return img.stretchableImage(withLeftCapWidth: Int(img.size.width * left), topCapHeight: Int(img.size.height * top))
    }
    
    /// 调整 图片尺寸
    /// - Parameters:
    ///   - left: 左侧偏移
    ///   - top: 顶部偏移
    func resizedImage(withLeft left: CGFloat, top: CGFloat) -> UIImage {
        return base.stretchableImage(withLeftCapWidth: Int(base.size.width * left), topCapHeight: Int(base.size.height * top))
    }
    
    enum ImageVertical {
        case top, center, bottom
    }
    enum ImageHorizontal {
        case left, center, right
    }
    func imageCapture(withSize size: CGSize, vertical: ImageVertical, horizontal: ImageHorizontal) -> UIImage? {
        guard let width = base.cgImage?.width else { return nil }
        guard let height = base.cgImage?.height else { return nil }
        let imgRadio = CGFloat(width) / CGFloat(height)
        let sizeRadio = size.width / size.height
        var rect = CGRect.zero
        if imgRadio > sizeRadio { // 裁剪 宽
            switch horizontal {
            case .left:
                rect = CGRect(x: 0, y: 0, width: CGFloat(height) * sizeRadio, height: CGFloat(height))
            case .center:
                rect = CGRect(x: (CGFloat(width) - CGFloat(height) * sizeRadio) * 0.5, y: 0.0, width: CGFloat(height) * sizeRadio, height: CGFloat(height))
            default:
                rect = CGRect(x: CGFloat(width) - CGFloat(height) * sizeRadio, y: 0.0, width: CGFloat(height) * sizeRadio, height: CGFloat(height))
            }
        } else { // 裁剪 高
            switch vertical {
            case .top:
                rect = CGRect(x: 0.0, y: 0.0, width: CGFloat(width), height: CGFloat(width) * size.height / size.width)
            case .center:
                rect = CGRect(x: 0.0, y: (CGFloat(height) - CGFloat(width) * size.height / size.width) * 0.5, width: CGFloat(width), height: CGFloat(width) * size.height / size.width)
            default:
                rect = CGRect(x: 0.0, y: CGFloat(height) - CGFloat(width) * size.height / size.width, width: CGFloat(width), height: CGFloat(width) * size.height / size.width)
            }
        }
        guard let subImg = base.cgImage?.cropping(to: rect) else { return nil }
        let image = UIImage(cgImage: subImg, scale: 2.0, orientation: .up)
        return image
    }
}
