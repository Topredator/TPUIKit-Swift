//
//  UIColor+TP.swift
//  TPFoundation-Swift
//
//  Created by Topredator on 2021/8/26.
//

extension UIColor: NameSpaceWrappable {}
public extension NameSpace where Base: UIColor {
    /// RGB 色
    static func rgb(_ r: Int, _ g: Int, _ b: Int, _ a: CGFloat = 1.0) -> UIColor {
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: a)
    }
    
    /// RGB相同的颜色
    static func rgbt(_ t: Int, _ a: CGFloat = 1.0) -> UIColor {
        return Self.rgb(t, t, t, a)
    }
    
    /// 随机色
    static var random: UIColor {
        return UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: CGFloat.random(in: 0...1))
    }
    
    /// 16进制 颜色
    static func hex(_ hexString: String, alpha: CGFloat = 1.0) -> UIColor {
        var hex = hexString
        var red: UInt64 = 0, green: UInt64 = 0, blue: UInt64 = 0
        if hex.hasPrefix("0x") || hex.hasPrefix("0X") {
            hex = String(hex[hex.index(hex.startIndex, offsetBy: 2)...])
        } else if hex.hasPrefix("#") {
            hex = String(hex[hex.index(hex.startIndex, offsetBy: 1)...])
        }
        if hex.count < 6 {
            for _ in (0 ..< (6 - hex.count)) {
                hex += "0"
            }
        }
        // red green blue 进行转换
        Scanner(string: String(hex[..<hex.index(hex.startIndex, offsetBy: 2)])).scanHexInt64(&red)
        Scanner(string: String(hex[hex.index(hex.startIndex, offsetBy: 2)..<hex.index(hex.startIndex, offsetBy: 4)])).scanHexInt64(&green)
        Scanner(string: String(hex[hex.index(hex.startIndex, offsetBy: 4)...])).scanHexInt64(&blue)
        return UIColor(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
    }
}
