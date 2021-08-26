//
//  CollectionContext.swift
//  XTFoundation-Swift
//
//  Created by Topredator on 2021/8/11.
//

import Foundation

public class CollectionContext: NSObject {
    public let collectionView: UICollectionView
    public private(set) var data: [CollectionSection]
    private(set) var registeredCellIds: Set<String>
    private(set) var registeredSupplementaryViewIds: Set<String>
    public weak var target: AnyObject?
    
    init(collectionView: UICollectionView, data: [CollectionSection], target: AnyObject?) {
        self.collectionView = collectionView
        self.data = data
        self.target = target
        registeredCellIds = Set<String>()
        registeredSupplementaryViewIds = Set<String>()
    }
    
    public var collectionLayout: UICollectionViewLayout {
        collectionView.collectionViewLayout
    }
    
    public var collectionFlowLayout: UICollectionViewFlowLayout? {
        collectionLayout as? UICollectionViewFlowLayout
    }
    
    public var itemSize: CGSize {
        return collectionFlowLayout?.itemSize ?? .zero
    }
        
    public var headerReferenceSize: CGSize {
        return collectionFlowLayout?.headerReferenceSize ?? .zero
    }
    
    public var footerReferenceSize: CGSize {
        return collectionFlowLayout?.footerReferenceSize ?? .zero
    }
    
    public var minimumItemSpacing: CGFloat {
        return collectionFlowLayout?.minimumInteritemSpacing ?? 0
    }
    
    public var minimumLineSpacing: CGFloat {
        return collectionFlowLayout?.minimumLineSpacing ?? 0
    }
    
    public var sectionInset: UIEdgeInsets {
        return collectionFlowLayout?.sectionInset ?? .zero
    }
    
    public func reloadData(_ data: [CollectionSection]) {
        self.data = data
        commit()
    }
    
    func commit() {
        collectionView.reloadData()
    }
    
    func dequeueReusableCell<T>(at indexPath: IndexPath, reuseIdentifier: String, cellType: T.Type = T.self) -> T where T : UICollectionViewCell {
        if !registeredCellIds.contains(reuseIdentifier) {
            registeredCellIds.insert(reuseIdentifier)
            collectionView.register(cellType.self, forCellWithReuseIdentifier: reuseIdentifier)
        }
        return collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! T
    }

    func dequeueReusableSupplementaryView<T>(ofKind kind: String, reuseIdentifier: String, for indexPath: IndexPath, viewType: T.Type = T.self) -> T where T : UICollectionReusableView {
        if !registeredSupplementaryViewIds.contains(reuseIdentifier) {
            registeredSupplementaryViewIds.insert(reuseIdentifier)
            collectionView.register(
                viewType.self, forSupplementaryViewOfKind: kind, withReuseIdentifier: reuseIdentifier)
        }
        return collectionView.dequeueReusableSupplementaryView(
            ofKind: kind, withReuseIdentifier: reuseIdentifier, for: indexPath) as! T
    }
}

extension CollectionContext: Collection {
    public typealias ListType = [CollectionSection]
    
    public var startIndex: ListType.Index {
        data.startIndex
    }
    
    public var endIndex: ListType.Index {
        data.endIndex
    }
    
    public subscript(position: ListType.Index) -> ListType.Element {
        get { data[position] }
        set { data[position] = newValue }
    }
    
    public func index(after i: ListType.Index) -> ListType.Index {
        return data.index(after: i)
    }
}

extension Collection where Element: CollectionSection {
    func first<T>(of sectionType: T.Type) -> T? where T: CollectionSection {
        if let item = self.first(where: { $0 is T }) {
            return (item as! T)
        } else {
            return nil
        }
    }
    
    func firstIndex<T>(of sectionType: T.Type) -> Index? where T: CollectionSection {
        return self.firstIndex(where: { $0 is T })
    }
}
