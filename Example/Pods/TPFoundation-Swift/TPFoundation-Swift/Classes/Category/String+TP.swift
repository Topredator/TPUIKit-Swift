//
//  String+TP.swift
//  TPFoundation-Swift
//
//  Created by Topredator on 2021/8/26.
//

import Foundation
import CommonCrypto

extension String: NameSpaceWrappable {}
public extension NameSpace where Base == String {
    // MARK:  ------------- 加解密 --------------------
    /// base64 编码
    var base64Encode: String? {
        guard base.count > 0 else { return nil }
        let encodeData = base.data(using: .utf8)
        let string = encodeData?.base64EncodedString(options: Data.Base64EncodingOptions.init(rawValue: 0))
        return string
    }
    
    /// base64 解码
    var base64Decode: String? {
        guard base.count > 0 else { return nil }
        let decodeData = Data(base64Encoded: base, options: Data.Base64DecodingOptions.init(rawValue: 0))
        let decodeStr = String(data: decodeData! as Data, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
        return decodeStr
    }
    /// MD5 加密 默认 16位小写
    var MD5: String {
        guard base.count > 0 else { return "" }
        
        let str = base.cString(using: .utf8)
        let strLen = CC_LONG(base.lengthOfBytes(using: .utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        
        CC_MD5(str!, strLen, result)
        var hash = String()
        for i in 0 ..< digestLen {
            hash.append(String(format: "%02x", result[i]))
        }
        result.deallocate()
        return String(format: hash)
    }
    
    /// AES / ECB 加密  (过程：先加密，再base64编码)
    /// - Parameter key: 加密秘钥
    func AESEncrypt(key: String) -> String? {
        let data = base.data(using: .utf8)
        guard let encryptData = data?.tp.AESEncrypt(key: key) else { return nil }
        return encryptData.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
    }
    func AESDecrypt(key: String) -> String? {
        let data = Data.init(base64Encoded: base, options: Data.Base64DecodingOptions(rawValue: 0))
        guard let decryptData = data?.tp.AESDecrypt(key: key) else { return nil }
        return String(data: decryptData, encoding: .utf8)
    }
    
    // MARK:  ------------- 字符串 过滤 --------------------
    /// 删除前后空格
    var removeWhitespace: String {
        guard base.count > 0 else { return "" }
        return base.trimmingCharacters(in: .whitespaces)
    }
    
    /// 删除所有空格
    var removeAllWhitespace: String {
        guard base.count > 0 else { return "" }
        let string = base.components(separatedBy: .whitespaces)
        return string.joined(separator: "")
    }
    /// url 查询 允许的字符
    var urlQueryAllowed: String? {
        guard base.count > 0 else { return nil }
        return base.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }
    
    var toUrl: URL? {
        if base.isEmpty { return nil }
        return URL(string:  base.tp.urlQueryAllowed!)
    }
    
    var isUsableString: Bool {
        if base.tp.removeAllWhitespace.isEmpty { return true }
        return false
    }
    
    // MARK:  ------------- 时间转换 --------------------
    
    /// 时间格式枚举
    enum FormatterType {
        case `default` // xxxx.xx.xx xx:xx:xx
        case point // xxxx.xx.xx xx:xx
        case dash // xxxx-xx-xx xx:xx
        case text // xxxx年xx月xx日 xx:xx
        case onlyDate // xxxx.xx.xx
        case onlyDash // xxxx-xx-xx
        case onlyText // xxxx年xx月xx日
        case month // xx.xx (月.日)
        case dashMonth // xx-xx (月-日)
        case textMonth // xx月xx日
        case hours // xx:xx （时:分）
        func formatter() -> String {
            switch self {
            case .default: return "yyyy.MM.dd HH:mm:ss"
            case .point: return "yyyy.MM.dd HH:mm"
            case .dash: return "yyyy-MM-dd HH:mm"
            case .text: return "yyyy年MM月dd日 HH:mm"
            case .onlyDate: return "yyyy.MM.dd"
            case .onlyDash: return "yyyy-MM-dd"
            case .onlyText: return "yyyy年MM月dd日"
            case .month: return "MM.dd"
            case .dashMonth: return "MM-dd"
            case .textMonth: return "MM月dd日"
            case .hours: return "HH:mm"
            }
        }
    }
    
    
    /// 时间戳(毫秒) 转时间
    /// - Parameters:
    ///   - string: 格式
    ///   - timeInterval: 时间戳 Double
    static func time(formatter string: String, timeInterval: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timeInterval / 1000)
        let formatter = DateFormatter()
        formatter.dateFormat = string
        return formatter.string(from: date)
    }
    
    /// 时间戳(毫秒) 转时间
    /// - Parameters:
    ///   - string: 格式
    ///   - interval: 时间戳字符串
    static func time(formatter string: String, stamp interval: String) -> String {
        return Self.time(formatter: string, timeInterval: Double(interval)!)
    }
    
    /// 时间戳(毫秒) 转 时间
    /// - Parameter type: 格式 类型
    func time(formatter type: FormatterType = .default) -> String {
        guard base.count > 0 else { return "" }
        return Self.time(formatter: type.formatter(), stamp: base)
    }
    
    
    /// 时间转时间戳
    /// - Parameter type: 格式 类型
    func timeStamp(_ type: FormatterType = .default) -> Double {
        let formatter = DateFormatter()
        formatter.dateFormat = type.formatter()
        let last = formatter.date(from: base)
        let timeStamp = last?.timeIntervalSince1970
        return timeStamp!
    }
    
    
    /// 获取星期
    var weekDay: String {
        guard base.count > 0 else { return "" }
        let weekdays = ["", "星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六"]
        var calendar = Calendar(identifier: .gregorian)
        let timeZone = TimeZone(identifier: "Asia/Shanghai")
        calendar.timeZone = timeZone!
        let date = Date.init(timeIntervalSince1970: Double(base)! / 1000)
        let component = calendar.component(.weekday, from: date)
        return weekdays[component]
    }
    
    func size(with font: UIFont, maxSize: CGSize) -> CGSize {
        base.boundingRect(with:CGSize(width:maxSize.width, height: maxSize.height), options: .usesLineFragmentOrigin, attributes: [.font: font], context:nil).size
    }
}
