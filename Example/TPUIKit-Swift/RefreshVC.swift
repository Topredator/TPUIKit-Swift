//
//  RefreshVC.swift
//  TPUIKit-Swift_Example
//
//  Created by Topredator on 2021/8/26.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import TPUIKit_Swift

class RefreshVC: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Refresh"
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    @objc private func reload() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            self.tableView.mj_header?.endRefreshing()
        }
    }
    @objc private func loadMore() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            self.tableView.mj_footer?.endRefreshingWithNoMoreData()
        }
    }
    // MARK:  ------------- Lazy method --------------------
    lazy var tableView: UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.dataSource = self
        table.delegate = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.mj_header = RefreshHeader(refreshingTarget: self, refreshingAction: #selector(reload))
        table.mj_footer = RefreshFooter(refreshingTarget: self, refreshingAction: #selector(loadMore))
        self.tp.adjust(scrollInsets: table)
        return table
    }()
}

extension RefreshVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = "Number \(indexPath.row + 1)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        nil
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        0.1
    }
}
