//
//  TableRow.swift
//  XTFoundation-Swift
//
//  Created by Topredator on 2021/8/11.
//

import Foundation

public protocol TableRowWrapper {
    func heightForCell(at indexPath: IndexPath, context: TableContext) -> CGFloat
    func cellForRow(at indexPath: IndexPath, context: TableContext) -> UITableViewCell
    func didSelectCell(at indexPath: IndexPath, context: TableContext)
    func willDisplayCell(_ cell: UITableViewCell, at indexPath: IndexPath, context: TableContext)
    func canEditRow(at indexPath: IndexPath, context: TableContext) -> Bool
    func commitEditingStyle(at indexPath: IndexPath, style: UITableViewCell.EditingStyle, context: TableContext)
    func deleteTitleForRow(at indexPath: IndexPath, context: TableContext) -> String
}
extension TableRowWrapper {
    public func heightForCell(at indexPath: IndexPath, context: TableContext) -> CGFloat {
        UITableView.automaticDimension
    }
    public func didSelectCell(at indexPath: IndexPath, context: TableContext) {}
    public func willDisplayCell(_ cell: UITableViewCell, at indexPath: IndexPath, context: TableContext) {}
    public func canEditRow(at indexPath: IndexPath, context: TableContext) -> Bool { false }
    public func commitEditingStyle(at indexPath: IndexPath, style: UITableViewCell.EditingStyle, context: TableContext) {}
    public func deleteTitleForRow(at indexPath: IndexPath, context: TableContext) -> String { "删除" }
}
