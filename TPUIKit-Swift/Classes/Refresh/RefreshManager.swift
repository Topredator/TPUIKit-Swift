//
//  RefreshManager.swift
//  XTUIKit-Swift
//
//  Created by Topredator on 2021/5/27.
//

import Foundation

public class RefreshMaker {
    /// 资源图片地址
    public var resoursePath: String?
    /// 闲置状态
    public var headerIdleTitle = "刷新成功"
    public var footerIdleTitle = "上拉加载"
    /// 拉动状态
    public var headerPullTitle = "松开进行刷新"
    public var footerPullTitle = "松开加载"
    /// 刷新中状态
    public var headerRefreshTitle = "正在刷新"
    public var footerRefreshTitle = "加载中..."
    /// 将要刷新状态
    public var willRefreshTitle = "即将刷新"
    /// 没有更多数据状态
    public var noMoreTitle = "已经到底了哦"
    
    @discardableResult
    public func path(_ path: String) -> Self {
        resoursePath = path
        return self
    }
    
    @discardableResult
    public func headerIdle(_ title: String) -> Self {
        headerIdleTitle = title
        return self
    }
    
    @discardableResult
    public func footerIdle(_ title: String) -> Self {
        footerIdleTitle = title
        return self
    }
    @discardableResult
    public func headerPull(_ title: String) -> Self {
        headerPullTitle = title
        return self
    }
    @discardableResult
    public func footerPull(_ title: String) -> Self {
        footerPullTitle = title
        return self
    }
    @discardableResult
    public func headerRefresh(_ title: String) -> Self {
        headerRefreshTitle = title
        return self
    }
    @discardableResult
    public func footerRefresh(_ title: String) -> Self {
        footerRefreshTitle = title
        return self
    }
    @discardableResult
    public func willRefresh(_ title: String) -> Self {
        willRefreshTitle = title
        return self
    }
    @discardableResult
    public func noMore(_ title: String) -> Self {
        noMoreTitle = title
        return self
    }
    
    private var _idleImgs: [UIImage]? = nil
    public var idleImgs: [UIImage]? {
        get {
            guard var path = resoursePath else {
                _idleImgs = [General.image("Refresh10")!]
                return _idleImgs
            }
            _idleImgs = nil
            path += "/refresh"
            guard let imgNames = try? FileManager.default.contentsOfDirectory(atPath: path) else { return _idleImgs }
            guard imgNames.count > 0, imgNames[0].contains("RefreshLoading") else { return _idleImgs }
            
            path += String(format: "/RefreshLoading%02d@2x.png", imgNames.count)
            guard let img = UIImage(contentsOfFile: path) else { return _idleImgs }
            _idleImgs = [img]
            return _idleImgs
        }
        set { _idleImgs = newValue }
    }
    
    private var _refreshImgs: [UIImage]? = nil
    public var refreshImgs: [UIImage]? {
        get {
            guard var path = resoursePath else {
                var imgs = [UIImage]()
                for index in 1 ... 9 {
                    let img = General.image(String(format: "Refresh%02d", index))!
                    imgs.append(img)
                }
                _refreshImgs = imgs
                return _refreshImgs
            }
            _refreshImgs = nil
            path += "/refresh"
            guard let imgNames = try? FileManager.default.contentsOfDirectory(atPath: path) else { return _refreshImgs }
            guard imgNames.count > 0, imgNames[0].contains("RefreshLoading") else { return _refreshImgs }
            var imgs = [UIImage]()
            for index in (1 ... imgNames.count-1) {
                let imgUrl: String = path + String(format: "/RefreshLoading%02d@2x.png", index)
                if let img = UIImage(contentsOfFile: imgUrl) { imgs.append(img) }
            }
            _refreshImgs = imgs
            return _refreshImgs
        }
        set { _refreshImgs = newValue }
    }
    
    private var _willRefreshImgs: [UIImage]? = nil
    public var willRefreshImgs: [UIImage]? {
        get {
            guard var path = resoursePath else {
                _willRefreshImgs = [General.image("Refresh01")!]
                return _willRefreshImgs
            }
            _willRefreshImgs = nil
            path += "/refresh"
            guard let imgNames = try? FileManager.default.contentsOfDirectory(atPath: path) else { return _willRefreshImgs }
            guard imgNames.count > 0, imgNames[0].contains("RefreshLoading") else { return _willRefreshImgs }
            
            path += "/RefreshLoading01@2x.png"
            guard let img = UIImage(contentsOfFile: path) else { return _willRefreshImgs }
            _willRefreshImgs = [img]
            return _willRefreshImgs
        }
        set { _willRefreshImgs = newValue }
    }
}


/// 刷新配置
public class RefreshManager {
    let maker: RefreshMaker
    public static let shared = RefreshManager()
    init() { maker = RefreshMaker() }
    
    @discardableResult
    public static func refreshConfig(_ closure: (RefreshMaker) -> ()) -> RefreshManager {
        let manager = RefreshManager.shared
        closure(manager.maker)
        return manager
    }
}
