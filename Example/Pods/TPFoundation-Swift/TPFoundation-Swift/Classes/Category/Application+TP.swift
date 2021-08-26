//
//  Application+TP.swift
//  TPFoundation-Swift
//
//  Created by Topredator on 2021/8/26.
//

import Foundation


extension UIApplication: NameSpaceWrappable {}
public extension NameSpace where Base: UIApplication {
    /// 沙盒 Document 地址
    static var documentPath: String { NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! }
    /// 沙盒 Document URL
    static var documentUrl: URL { FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last! }
    /// 沙盒 Cache 地址
    static var cachePath: String { NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first! }
    /// 沙盒 Cache URL
    static var cacheUrl: URL { FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).last! }
    /// 沙盒 Library 地址
    static var libraryPath: String { NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first! }
    /// 沙盒 Library URL
    static var libraryUrl: URL { FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).last! }
    /// Application's Bundle Name (show in SpringBoard).
    static var appBundleName: String { Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String }
    /// Application's Bundle ID.  e.g. "com.xuetian.cn"
    static var appBundleId: String { Bundle.main.object(forInfoDictionaryKey: "CFBundleIdentifier") as! String }
    /// Application's Version.  e.g. "1.0.0"
    static var appVersion: String { Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String }
    /// Application's Build number. e.g. "123"
    static var appBuildVersion: String { Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String }
}
