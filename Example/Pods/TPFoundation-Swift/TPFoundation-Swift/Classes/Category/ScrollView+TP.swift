//
//  ScrollView+TP.swift
//  TPFoundation-Swift
//
//  Created by Topredator on 2021/8/26.
//

import Foundation

extension UIScrollView: NameSpaceWrappable {}
public extension NameSpace where Base: UIScrollView {
    /// 滑动到顶部
    /// - Parameter animated: 是否动画
    func scrollToTop(_ animated: Bool = false) {
        var offSet = base.contentOffset
        offSet.y = 0 - base.contentInset.top
        base.setContentOffset(offSet, animated: animated)
    }
    
    /// 滑动到底部
    /// - Parameter animated: 是否动画
    func scrollToBottom(_ animated: Bool = false) {
        var offSet = base.contentOffset
        offSet.y = base.contentSize.height - base.bounds.size.height + base.contentInset.bottom
        base.setContentOffset(offSet, animated: animated)
    }
    
    /// 滑动到最左侧
    /// - Parameter animated: 是否动画
    func scrollToLeft(_ animated: Bool) {
        var offSet = base.contentOffset
        offSet.x = 0 - base.contentInset.left
        base.setContentOffset(offSet, animated: animated)
    }
    
    /// 滑动到最右侧
    /// - Parameter animated: 是否动画
    func scrollToRight(_ animated: Bool) {
        var offSet = base.contentOffset
        offSet.x = base.contentSize.width - base.bounds.size.width + base.contentInset.right
        base.setContentOffset(offSet, animated: animated)
    }
}
