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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        title = "测试"
        loadData()
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
        tableView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
}

