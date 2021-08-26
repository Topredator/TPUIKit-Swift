//
//  Stack.swift
//  XTFoundation-Swift
//
//  Created by Topredator on 2021/3/29.
//

import Foundation
/// 栈
public struct Stack<Element> {
    fileprivate var array = [Element]()
    
    /// 判空
    public var isEmpty: Bool { return array.isEmpty }
    /// 元素个数
    public var count: Int { return array.count }
    /// 入栈
    /// - Parameter element: 入栈元素
    public mutating func push(_ element: Element) {
        array.append(element)
    }
    
    /// 出栈
    /// - Returns: 出栈的元素
    public mutating func pop() -> Element? {
        return array.popLast()
    }
    
    /// 栈顶元素
    public var peek: Element? {
        return array.last
    }
    /// 所有元素
    public func allElements() -> [Element?] {
        return array
    }
}
