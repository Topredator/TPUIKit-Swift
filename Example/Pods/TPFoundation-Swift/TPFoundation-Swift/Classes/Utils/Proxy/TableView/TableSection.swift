//
//  TableSection.swift
//  XTFoundation-Swift
//
//  Created by Topredator on 2021/8/11.
//

import Foundation

public protocol TableSectionWrapper {
    func heightForHeader(at section: Int, context: TableContext) -> CGFloat
    func heightForFooter(at section: Int, context: TableContext) -> CGFloat
    func viewForHeader(at section: Int, context: TableContext) -> UITableViewHeaderFooterView?
    func viewForFooter(at section: Int, context: TableContext) -> UITableViewHeaderFooterView?
}

open class TableSection: Collection, TableSectionWrapper {
    public typealias ListType = [TableRowWrapper]
    public var rows: ListType = []
    public init(_ rows: ListType) {
        self.rows = rows
    }
    public var startIndex: ListType.Index {
        rows.startIndex
    }
    public var endIndex: ListType.Index {
        rows.endIndex
    }
    public func index(after i: ListType.Index) -> ListType.Index {
        rows.index(after: i)
    }
    public subscript(position: ListType.Index) -> ListType.Element {
        get { rows[position] }
        set { rows[position] = newValue }
    }
    
    // MARK:  ------------- TableSectionWrapper --------------------
    open func heightForHeader(at section: Int, context: TableContext) -> CGFloat { .zero }
    open func heightForFooter(at section: Int, context: TableContext) -> CGFloat { .zero }
    open func viewForHeader(at section: Int, context: TableContext) -> UITableViewHeaderFooterView?  { nil }
    open func viewForFooter(at section: Int, context: TableContext) -> UITableViewHeaderFooterView? { nil }
}
