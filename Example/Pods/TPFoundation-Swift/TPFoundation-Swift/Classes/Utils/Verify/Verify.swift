//
//  Verify.swift
//  XTFoundation-Swift
//
//  Created by Topredator on 2021/3/29.
//

import Foundation

/// 验证
public struct Verify {
    /// 验证的数据类型
    public enum DataType: String {
        /// 邮箱
        case email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        case phone = "^((14[7])|(13[0-9])|(17[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$"
        case IllegalCharacter = "^([A-Za-z0-9\\u4e00-\\u9fa5]+)$"
        case cardId = "^(\\d{14}|\\d{17})(\\d|[xX])$"
        case pureDigital = "[0-9]*"
    }
    public static func verify(_ content: String?, _ dataType: DataType) -> Bool {
        guard let str = content else { return false }
        return verify(str, dataType.rawValue)
    }
    /// 正则表达式验证
    /// - Parameters:
    ///   - content: 验证的内容
    ///   - regex: 表达式
    public static func verify(_ content: String?, _ regex: String) -> Bool {
        guard let str = content else { return false }
        let predicate = NSPredicate.init(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: str)
    }
}
