//
//  Font+TP.swift
//  TPFoundation-Swift
//
//  Created by Topredator on 2021/8/26.
//


extension UIFont: NameSpaceWrappable {}
public extension NameSpace where Base: UIFont {
    /// weight类型 枚举
    enum FontWeight {
        case thin, regular, medium, semibold, bold, light
        func systemWeight() -> UIFont.Weight {
            switch self {
            case .thin: return UIFont.Weight.thin
            case .regular: return UIFont.Weight.regular
            case .medium: return UIFont.Weight.medium
            case .semibold: return UIFont.Weight.semibold
            case .bold: return UIFont.Weight.bold
            case .light: return UIFont.Weight.light
            }
        }
    }
    
    /// UIFont 类方法
    /// - Parameters:
    ///   - size: 字号大小
    ///   - weight: 字号类型
    static func font(_ size: CGFloat = 16, weight: FontWeight = .regular) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: weight.systemWeight())
    }
}
