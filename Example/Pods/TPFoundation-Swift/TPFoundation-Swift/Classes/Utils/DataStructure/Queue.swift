//
//  Queue.swift
//  XTFoundation-Swift
//
//  Created by Topredator on 2021/3/29.
//

import Foundation

/// 队列
public struct Queue<Element> {
    fileprivate var array = [Element?]()
    fileprivate var head = 0
    
    /// 元素个数
    public var count: Int { return array.count - head }
    /// 判空
    public var isEmpty: Bool { return count == 0 }
    /// 入队
    public mutating func enqueue(_ element: Element) {
        array.append(element)
    }
    /// 出队
    public mutating func dequeue() -> Element? {
        guard head < array.count, let element = array[head] else { return nil }
        array[head] = nil
        head += 1
        
        /*
         * 取出前 ["A", "B", "C", "D", "E", "F"]
         * 取出后 ["C", "D", "E", "F", nil, nil]
         */
        
        let percentAge = Double(head) / Double(array.count)
        if array.count > 50 && percentAge > 0.25 {
            array.removeFirst(head)
            head = 0
        }
        return element
    }
    
    /// 对首元素
    public var front: Element? {
        if isEmpty { return nil }
        return array[head]
    }
    
    /// 所有元素
    public func allElements() -> [Element?] {
        var arr = [Element?]()
        for i in head ..< array.count {
            arr.append(array[i])
        }
        return arr
    }
    /// 清空队列
    public mutating func removeAll() {
        array.removeAll()
        head = 0
    }
}
