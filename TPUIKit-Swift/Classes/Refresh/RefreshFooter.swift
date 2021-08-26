//
//  RefreshFooter.swift
//  XTUIKit-Swift
//
//  Created by Topredator on 2021/5/27.
//

import UIKit
import MJRefresh


/// 底部 上拉加载更多
public class RefreshFooter: MJRefreshBackStateFooter {
    
    private lazy var loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: self.activityStyle)
        view.hidesWhenStopped = true
        return view
    }()
    private var _activityStyle: UIActivityIndicatorView.Style = .gray
    public var activityStyle: UIActivityIndicatorView.Style {
        get { _activityStyle }
        set {
            _activityStyle = newValue
            setNeedsLayout()
        }
    }
    
    public override func prepare() {
        super.prepare()
        
        setTitle(RefreshManager.shared.maker.footerIdleTitle, for: .idle)
        setTitle(RefreshManager.shared.maker.footerPullTitle, for: .pulling)
        setTitle(RefreshManager.shared.maker.footerRefreshTitle, for: .refreshing)
        setTitle(RefreshManager.shared.maker.noMoreTitle, for: .noMoreData)
    }
    public override func placeSubviews() {
        super.placeSubviews()
        self.addSubview(loadingView)
        var arrowCenterX: CGFloat = mj_w * 0.5
        if !stateLabel!.isHidden {
            arrowCenterX -= labelLeftInset + stateLabel!.mj_textWidth() * 0.5
        }
        let arrowCenterY: CGFloat = mj_h * 0.5
        let arrowCenter = CGPoint(x: arrowCenterX, y: arrowCenterY)
        if loadingView.constraints.count == 0 {
            loadingView.center = arrowCenter
        }
    }
    
    public override var state: MJRefreshState {
        didSet {
            switch state {
            case .refreshing:
                loadingView.startAnimating()
            default:
                loadingView.stopAnimating()
            }
        }
    }
    
}
