//
//  CollectionAdapter.swift
//  XTFoundation-Swift
//
//  Created by Topredator on 2021/8/11.
//

import Foundation

public class CollectionAdapter: CollectionContext {
    private var delegateProxy: MultipleProxy?
    
    public override init(collectionView: UICollectionView, data: [CollectionSection] = [], target: AnyObject? = nil) {
        super.init(collectionView: collectionView, data: data, target: target)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    public func reloadData() {
        collectionView.reloadData()
    }

    public func setDelegate(_ delegate: UICollectionViewDelegateFlowLayout?) {
        if let delegate = delegate {
            // 多重代理转发：这里的self和delegate会同时收到回调
            let delegateProxy = MultipleProxy(objects: [self, delegate])
            collectionView.delegate = (delegateProxy as! UICollectionViewDelegateFlowLayout)
            self.delegateProxy = delegateProxy
        } else {
            self.delegateProxy = nil
            collectionView.delegate = self
        }
    }
}

extension CollectionAdapter: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        data.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        data[section].count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = data[indexPath.section][indexPath.item]
        return item.cellForItem(at: indexPath, context: self)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = data[indexPath.section][indexPath.item]
        return item.sizeForItem(at: indexPath, context: self)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let sectionModel = data[section]
        return sectionModel.referenceSizeForHeader(in: section, context: self)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let sectionModel = data[section]
        return sectionModel.referenceSizeForFooter(in: section, context: self)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let sectionModel = data[section]
        return sectionModel.sectionInset(at: section, context: self)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        let sectionModel = data[section]
        return sectionModel.minimumItemSpacing(at: section, context: self)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let sectionModel = data[section]
        return sectionModel.minimumLineSpacing(at: section, context: self)
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let sectionModel = data[indexPath.section]
        if let view = sectionModel.supplementaryView(ofKind: kind, for: indexPath, context: self) {
            return view
        }
        fatalError("not support supplementaryView of kind \(kind)")
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        let sectionModel = data[indexPath.section]
        sectionModel.willDisplaySupplementaryView(view, forKind: elementKind, at: indexPath, context: self)
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let item = data[indexPath.section][indexPath.row]
        item.willDisplayCell(cell, at: indexPath, context: self)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard data.count > indexPath.section, data[indexPath.section].count > indexPath.row else {
            return
        }
        let item = data[indexPath.section][indexPath.row]
        item.didEndDisplayingCell(cell, at: indexPath, context: self)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = data[indexPath.section][indexPath.row]
        item.didSelectItem(at: indexPath, context: self)
    }
}

extension UICollectionView {
    private struct AssiocateKeys {
        static var adapter: Void?
    }
    public var adapter: CollectionAdapter? {
        get {
            objc_getAssociatedObject(self, &AssiocateKeys.adapter) as? CollectionAdapter
        }
        set {
            objc_setAssociatedObject(self, &AssiocateKeys.adapter, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
