//
//  RefreshHeader.swift
//  XTUIKit-Swift
//
//  Created by Topredator on 2021/5/26.
//

import UIKit
import MJRefresh
import SnapKit

/// 头部 下拉刷新视图
public class RefreshHeader: MJRefreshGifHeader {

    public override func prepare() {
        super.prepare()
        
        setTitle(RefreshManager.shared.maker.headerIdleTitle, for: .idle)
        setTitle(RefreshManager.shared.maker.headerPullTitle, for: .pulling)
        setTitle(RefreshManager.shared.maker.headerRefreshTitle, for: .refreshing)
        setTitle(RefreshManager.shared.maker.willRefreshTitle, for: .willRefresh)
        
        
        if let idleImgs = RefreshManager.shared.maker.idleImgs {
            setImages(idleImgs, for: .idle)
        }
        if let willRefreshImgs = RefreshManager.shared.maker.willRefreshImgs {
            setImages(willRefreshImgs, for: .pulling)
        }
        if let refreshImgs = RefreshManager.shared.maker.refreshImgs {
            setImages(refreshImgs, for: .refreshing)
        }
        
    }
    
    public override func placeSubviews() {
        gifView!.mj_w = 28
        gifView!.mj_h = 28
        lastUpdatedTimeLabel!.isHidden = true
        let stateWidth = stateLabel!.mj_textWidth()
        stateLabel!.textAlignment = .left
        let offset: CGFloat = (28.0 + labelLeftInset) / 2.0
        stateLabel!.snp.remakeConstraints({ make in
            make.top.bottom.equalToSuperview()
            make.width.equalTo(stateWidth)
            make.centerX.equalToSuperview().offset(offset)
        })
        gifView!.snp.remakeConstraints({ make in
            make.size.equalTo(CGSize(width: 28.0, height: 28.0))
            make.centerY.equalToSuperview()
            make.right.equalTo(stateLabel!.snp.left).offset(-labelLeftInset)
        })
        layoutIfNeeded()
        super.placeSubviews()
    }
}
