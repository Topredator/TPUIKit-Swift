//
//  Asyncs.swift
//  XTFoundation-Swift
//
//  Created by Topredator on 2021/3/29.
//

import Foundation

public typealias Task = () -> Void

/// 异步 操作
public struct Asyncs {
    
    /// 异步执行
    /// - Parameter task: 异步任务
    public static func async(_ task: @escaping Task) {
        _async(task)
    }
    
    /// 异步执行
    /// - Parameters:
    ///   - task: 异步任务
    ///   - mainTask: 同步到主线程操作
    public static func async(_ task: @escaping Task, _ mainTask: @escaping Task) {
        _async(task, mainTask)
    }
    private static func _async(_ task: @escaping Task, _ mainTask: Task? = nil) {
        let item = DispatchWorkItem(block: task)
        DispatchQueue.global().async(execute: item)
        if let main = mainTask {
            item.notify(queue: DispatchQueue.main, execute: main)
        }
    }
    
    /// 同步延迟执行
    /// - Parameters:
    ///   - seconds: 秒数
    ///   - block: 延迟回调
    @discardableResult
    public static func delay(seconds: Double, _ block: @escaping Task) -> DispatchWorkItem {
        let item = DispatchWorkItem(block: block)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds, execute: item)
        return item
    }
    
    /// 异步延迟执行
    /// - Parameters:
    ///   - seconds: 秒数
    ///   - task: 延迟执行的操作
    public static func asyncDelay(seconds: Double, _ task: @escaping Task) -> DispatchWorkItem {
        return _asyncDelay(seconds: seconds, task)
    }
    
    /// 异步延迟执行
    /// - Parameters:
    ///   - seconds: 秒数
    ///   - task: 延迟执行的操作
    ///   - mainTask: 同步主线程的操作
    public static func asyncDelay(seconds: Double, _ task: @escaping Task, _ mainTask: @escaping Task) -> DispatchWorkItem {
        return _asyncDelay(seconds: seconds, task, mainTask)
    }
    
    private static func _asyncDelay(seconds: Double, _ task: @escaping Task, _ mainTask: Task? = nil) -> DispatchWorkItem {
        let item = DispatchWorkItem(block: task)
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + seconds, execute: item)
        if let main = mainTask {
            item.notify(queue: DispatchQueue.main, execute: main)
        }
        return item
    }
}
