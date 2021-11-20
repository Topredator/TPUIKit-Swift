//
//  ViewController.swift
//  TPUIKit-Swift
//
//  Created by 周晓路 on 08/26/2021.
//  Copyright (c) 2021 周晓路. All rights reserved.
//

import UIKit
import TPUIKit_Swift
import TPFoundation_Swift
import SnapKit

class ViewController: BaseTableViewVC {

    var titleView: UIView = {
        let view = UIView(frame: CGRect.zero)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tp.navigationItem.navigaitonBarHidden = true
        setupTitleView()
        title = "测试"
        loadData()
    }

    func setupTitleView() {
        view.addSubview(titleView)
        titleView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(UI.TopBarHeight)
        }
        // bgView
        let bgView = BackgroundLineView(frame: CGRect.zero, lineWidth: 4, lineGap: 4, lineColor: UIColor.tp.rgbt(0, 0.015), rotate: CGFloat(Double.pi / 4.0))
        titleView.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        // title
        let string = "TPUIKit-Swift"
        let length = string.lengthOfBytes(using: .utf8)
        let richText = NSMutableAttributedString(string: "TPUIKit-Swift")
        richText.addAttributes([.foregroundColor: UIColor.tp.hex("0x545454")], range: NSMakeRange(0, length))
        richText.addAttributes([.font: UIFont.tp.font(24, weight: .medium)], range: NSMakeRange(0, length))
        richText.addAttributes([.foregroundColor: UIColor.tp.hex("0x4699D9")], range: NSMakeRange(8, 5))
        let label = UILabel(frame: CGRect.zero)
        label.textAlignment = .center
        label.attributedText = richText
        titleView.addSubview(label)
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: UI.StatusBarHeight, left: 0, bottom: 0, right: 0))
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loadData() {
        let items = [
            Item("Banner", type: .banner),
            Item("Tabbar", type: .tabbar),
            Item("Menu", type: .menu),
            Item("Alert", type: .alert),
            Item("Refresh", type: .refresh)
        ]
        var rows = [TableRowWrapper]()
        for item in items {
            rows.append(ListRow(item))
        }
        reloadData([TableSection(rows)])
    }
    
    override func setupTableView() {
        super.setupTableView()
        tableView.isHidden = false
        tableView.separatorStyle = .singleLine
        tableView.snp.makeConstraints { $0.edges.equalToSuperview().inset(UIEdgeInsets(top: UI.TopBarHeight, left: 0, bottom: 0, right: 0)) }
    }
}

