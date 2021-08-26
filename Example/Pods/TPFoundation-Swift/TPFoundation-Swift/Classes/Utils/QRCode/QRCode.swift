//
//  QRCode.swift
//  XTFoundation-Swift
//
//  Created by Topredator on 2021/3/29.
//

import Foundation
import CoreGraphics

public struct QRCode {
    
    /// 通过 二维码字符串、尺寸 生成二维码图片
    /// - Parameters:
    ///   - string: 二维码字符串
    ///   - size: 图片尺寸
    public static func image(_ qrString: String,
                             _ size: CGFloat,
                             waterImage: UIImage? = nil,
                             waterSize: CGFloat? = nil) -> UIImage? {
        let filter = CIFilter.init(name: "CIQRCodeGenerator")
        filter?.setDefaults()
        let data = qrString.data(using: String.Encoding.utf8)
        filter?.setValue(data!, forKey: "inputMessage")
        filter?.setValue("Q", forKey: "inputCorrectionLevel")
        guard let outputImage = filter?.outputImage else { return nil }
        return createImage(image: outputImage, size: size, waterImage: waterImage, waterSize: waterSize)
    }
    
    private static func createImage(image: CIImage,
                                                     size: CGFloat,
                                                     waterImage: UIImage? = nil,
                                                     waterSize: CGFloat? = nil) -> UIImage? {
        let integral = image.extent.integral
        let scale: CGFloat = min(size / integral.width, size / integral.height)
        // 1.创建bitmap
        let width: size_t = size_t(integral.width * scale)
        let height: size_t = size_t(integral.height * scale)
        //创建一个DeviceGray颜色空间
        let cs = CGColorSpaceCreateDeviceGray()
        //bitmapInfo：指定的位图应该包含一个alpha通道。
        let bitmapRef = CGContext.init(data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: 0, space: cs, bitmapInfo: 0)
        let context = CIContext(options: nil)
        //创建CoreGraphics image
        let bitmapImage: CGImage = context.createCGImage(image, from: integral)!
        
        bitmapRef!.interpolationQuality = CGInterpolationQuality.none
        bitmapRef!.scaleBy(x: scale, y: scale);
        bitmapRef!.draw(bitmapImage, in: integral);
        let image: CGImage = bitmapRef!.makeImage()!
        // 原图
        let outputImage = UIImage.init(cgImage: image)
        if waterImage == nil {
            return outputImage
        }
        // 给二维码添加 logo
        UIGraphicsBeginImageContextWithOptions(outputImage.size, false, UIScreen.main.scale)
        outputImage.draw(in: CGRect.init(x: 0, y: 0, width: size, height: size))
        waterImage!.draw(in: CGRect.init(x: (size - waterSize!) / 2, y: (size - waterSize!) / 2, width: waterSize!, height: waterSize!))
        let newpic = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newpic
    }
    
}
