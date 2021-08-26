//
//  Const.swift
//  XTUIKit-swift
//
//  Created by Topredator on 2020/5/26.
//

import UIKit
import Foundation

/// 获取 本地图片
public struct General {
    static let bundle: Bundle = {
        let bundle = Bundle.init(path: Bundle.init(for: BaseViewController.self).path(forResource: "TPUIKitSwift", ofType: "bundle", inDirectory: nil)!)
       return bundle!
    }()
    /// 获取图片
    public static func image(_ name:String) -> UIImage? {
        var image = UIImage.init(named: name, in: bundle, compatibleWith: nil)
        if image == nil {
            image = UIImage.init(named: name)
        }
        return image
    }
}



