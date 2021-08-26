//
//  TableContext.swift
//  XTFoundation-Swift
//
//  Created by Topredator on 2021/8/11.
//

import Foundation

public class TableContext: NSObject {
    public let tableView: UITableView
    public private(set) var data: [TableSection]
    private(set) var registeredCellIds: Set<String>
    private(set) var registeredSectionViewIds: Set<String>
    public weak var target: AnyObject?
    
    init(tableView: UITableView, data: [TableSection], target: AnyObject?) {
        self.tableView = tableView
        self.data = data
        self.target = target
        registeredCellIds = Set<String>()
        registeredSectionViewIds = Set<String>()
    }
    public func reloadData(_ data: [TableSection]) {
        self.data = data
        tableView.reloadData()
    }
    /// cell 重用
    public func dequeueReusableCell<T>(at indexPath: IndexPath, reuseIdentifier: String, cellType: T.Type = T.self) -> T where T: UITableViewCell {
        if !registeredCellIds.contains(reuseIdentifier) {
            registeredCellIds.insert(reuseIdentifier)
            tableView.register(cellType.self, forCellReuseIdentifier: reuseIdentifier)
        }
        return tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! T
    }
    /// 分区 头尾视图重用
    public func dequeueReusableHeaderFooterView<T>(withReuseIdentifier identifier: String, viewType: T.Type = T.self) -> T? where T: UITableViewHeaderFooterView {
        if !registeredSectionViewIds.contains(identifier) {
            registeredSectionViewIds.insert(identifier)
            tableView.register(viewType.self, forHeaderFooterViewReuseIdentifier: identifier)
        }
        return tableView.dequeueReusableHeaderFooterView(withIdentifier: identifier) as? T
    }
}

extension TableContext: Collection {
    public typealias ListType = [TableSection]
    public var startIndex: ListType.Index { data.startIndex }
    public var endIndex: ListType.Index { data.endIndex }
    public func index(after i: ListType.Index) -> ListType.Index { data.index(after: i) }
    public subscript(position: ListType.Index) -> ListType.Element {
        get { data[position] }
        set { data[position] = newValue }
    }
}
