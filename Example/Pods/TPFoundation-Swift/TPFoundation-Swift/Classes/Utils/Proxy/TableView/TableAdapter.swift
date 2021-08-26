//
//  TableAdapter.swift
//  XTFoundation-Swift
//
//  Created by Topredator on 2021/8/11.
//

import Foundation

public class TableAdapter: TableContext {
    private var delegateProxy: MultipleProxy?
    private var dataSourceProxy: MultipleProxy?
    public override init(tableView: UITableView, data: [TableSection] = [], target: AnyObject?) {
        super.init(tableView: tableView, data: data, target: target)
        tableView.delegate = self
        tableView.dataSource = self
    }
    public func setDelegate(_ delegate: UITableViewDelegate?) {
        if let delegate = delegate {
            // 多重代理转发：这里的self和delegate会同时收到回调
            let proxy = MultipleProxy(objects: [self, delegate])
            tableView.delegate = (proxy as! UITableViewDelegate)
            self.delegateProxy = proxy
        } else {
            delegateProxy = nil
            tableView.delegate = self
        }
    }
    public func setDataSource(_ dataSource: UITableViewDataSource?) {
        if let dataSource = dataSource {
            let proxy = MultipleProxy(objects: [self, dataSource])
            tableView.dataSource = (proxy as! UITableViewDataSource)
            self.dataSourceProxy = proxy
        } else {
            dataSourceProxy = nil
            tableView.dataSource = self
        }
    }
}

extension TableAdapter: UITableViewDataSource, UITableViewDelegate {
    // MARK:  ------------- UITableViewDataSource --------------------
    public func numberOfSections(in tableView: UITableView) -> Int {
        data.count
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data[section].count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = data[indexPath.section][indexPath.row]
        return model.cellForRow(at: indexPath, context: self)
    }
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let model = data[indexPath.section][indexPath.row]
        return model.canEditRow(at: indexPath, context: self)
    }
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let model = data[indexPath.section][indexPath.row]
        model.commitEditingStyle(at: indexPath, style: editingStyle, context: self)
    }
    
    // MARK:  ------------- UITableViewDelegate --------------------
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let model = data[indexPath.section][indexPath.row]
        model.willDisplayCell(cell, at: indexPath, context: self)
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = data[indexPath.section][indexPath.row]
        model.didSelectCell(at: indexPath, context: self)
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = data[indexPath.section][indexPath.row]
        return model.heightForCell(at: indexPath, context: self)
    }
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let sectionData = data[section]
        return sectionData.heightForHeader(at: section, context: self)
    }
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let sectionData = data[section]
        return sectionData.heightForFooter(at: section, context: self)
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionData = data[section]
        return sectionData.viewForHeader(at: section, context: self)
    }
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let sectionData = data[section]
        return sectionData.viewForFooter(at: section, context: self)
    }
}


extension UITableView {
    private struct AssociateKeys {
        static var adapterKey: Void?
    }
    public var adapter: TableAdapter? {
        get {
            objc_getAssociatedObject(self, &AssociateKeys.adapterKey) as? TableAdapter
        }
        set {
            objc_setAssociatedObject(self, &AssociateKeys.adapterKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
