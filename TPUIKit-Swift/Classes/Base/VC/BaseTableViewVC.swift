//
//  BaseTableViewVC.swift
//  XTUIKit-Swift
//
//  Created by Topredator on 2021/8/18.
//

import Foundation
import TPFoundation_Swift

/// 列表 基类(自带 tableView)
open class BaseTableViewVC: UIViewController {
    open lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.separatorStyle = .none
        table.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        table.adapter = TableAdapter(tableView: table, target: self)
        table.isHidden = true
        return table
    }()
    
    open override func viewDidLoad() {
        setupTableView()
    }
    // MARK:  ------------- Public method --------------------
    open func setupTableView() {
        view.addSubview(tableView)
    }
    
    /// 加载数据
    /// - Parameter datasources: 数据源
    public func reloadData(_ datasources: [TableSection]) {
        tableView.adapter?.reloadData(datasources)
    }
}
