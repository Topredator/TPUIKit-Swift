//
//  MethodSwizzling.swift
//  TPFoundation-Swift
//
//  Created by Topredator on 2021/8/26.
//

/// MethodSwizzling方法
/// - Parameters:
///   - cls: 需要替换方法的类
///   - name: 原方法选择器
///   - swizzlingName: 替换的方法选择器
public func FoundationSwizzling(_ cls: AnyClass?, _ name: Selector, _ swizzlingName: Selector) {
    let originMethod: Method? = class_getInstanceMethod(cls, name)
    let swizzledMethod: Method? = class_getInstanceMethod(cls, swizzlingName)
    if let originMethod = originMethod, let swizzledMethod = swizzledMethod  {
        if class_addMethod(cls, name, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod)) {
            class_replaceMethod(cls, swizzlingName, method_getImplementation(originMethod), method_getTypeEncoding(originMethod))
        } else {
            method_exchangeImplementations(originMethod, swizzledMethod)
        }
    }
}


/// MethodSwizzling 方法
/// - Parameters:
///   - originalClass: 原始类
///   - swizzledClass: 替换类
///   - originalSelector: 原始类方法选择器
///   - swizzledSelector: 替换类方法选择器
public func FoundationSwizzling(_ originalClass: AnyClass?, swizzledClass: AnyClass?, originalSelector: Selector, swizzledSelector: Selector) {
    let originalMethod = class_getInstanceMethod(originalClass, originalSelector)
    let swizzledMethod = class_getInstanceMethod(swizzledClass, swizzledSelector)
    if let originalMethod = originalMethod, let swizzledMethod = swizzledMethod {
        if class_addMethod(originalClass, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod)) {
            class_replaceMethod(originalClass, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }
}
