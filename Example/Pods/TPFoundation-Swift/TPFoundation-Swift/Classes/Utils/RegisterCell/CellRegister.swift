//
//  CellRegister.swift
//  XTFoundation-Swift
//
//  Created by Topredator on 2021/3/29.
//

import Foundation

public struct CellRegister {
    let cellCls: AnyClass?
    let reuseIdentifier: String
    public init(_ cellClass: AnyClass? = nil, reuseId: String = "UITableViewCell") {
        cellCls = cellClass
        reuseIdentifier = reuseId
    }
}

extension UITableView: NameSpaceWrappable {}
extension NameSpace where Base: UITableView {
    /// 代码注册cells
    public func registerCells(_ array: [CellRegister]) {
        if array.isEmpty { return }
        for type in array {
            base.register(type.cellCls, forCellReuseIdentifier: type.reuseIdentifier)
        }
    }
    /// xib 注册cells
    public func registerXibCells(_ array: [CellRegister]) {
        if array.isEmpty { return }
        for type in array {
            if let cellCls = type.cellCls {
                let nib = UINib(nibName: NSStringFromClass(cellCls), bundle: nil)
                base.register(nib, forCellReuseIdentifier: type.reuseIdentifier)
            }
        }
    }
}

extension UICollectionView: NameSpaceWrappable {}
extension NameSpace where Base: UICollectionView {
    /// 注册cell
    public func registerCells(array: [CellRegister]) {
        if array.isEmpty { return }
        for type in array {
            base.register(type.cellCls, forCellWithReuseIdentifier: type.reuseIdentifier)
        }
    }
    
    /// 注册xib创建的cell
    public func registerXibCells(array: [CellRegister]) {
        if array.isEmpty { return }
        for type in array {
            if let cellClass = type.cellCls {
                let nib = UINib.init(nibName: NSStringFromClass(cellClass), bundle: nil)
                base.register(nib, forCellWithReuseIdentifier: type.reuseIdentifier)
            }
        }
    }
    
    /// 注册sections
    public func registerSections(array: [CellRegister], elementKind: String) {
        if array.isEmpty { return }
        for type in array {
            base.register(type.cellCls, forSupplementaryViewOfKind: elementKind, withReuseIdentifier: type.reuseIdentifier)
        }
    }
    
    /// 注册xib创建的sections
    public func registerXibSections(array: [CellRegister], elementKind: String) {
        if array.isEmpty { return }
        for type in array {
            if let cellClass = type.cellCls {
                let nib = UINib.init(nibName: NSStringFromClass(cellClass), bundle: nil)
                base.register(nib, forSupplementaryViewOfKind: elementKind, withReuseIdentifier: type.reuseIdentifier)
            }
        }
    }
}
