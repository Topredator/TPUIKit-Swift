//
//  CollectionSection.swift
//  XTFoundation-Swift
//
//  Created by Topredator on 2021/8/11.
//

import Foundation

open class CollectionSection: Collection {
    public typealias ListType = [CollectionItem]
    public var items: ListType = []
    
    public init(_ items: ListType) {
        self.items = items
    }
    public var startIndex: ListType.Index {
        items.startIndex
    }
    public var endIndex: ListType.Index {
        items.endIndex
    }
    public func index(after i: ListType.Index) -> ListType.Index {
        items.index(after: i)
    }
    public subscript(position: ListType.Index) -> ListType.Element {
        get { items[position] }
        set { items[position] = newValue }
    }
    
    
    // MARK: - CollectionSectionDelegate
    public func supplementaryView(ofKind kind: String, for indexPath: IndexPath, context: CollectionContext) -> UICollectionReusableView? {
        fatalError("supplementaryView(ofKind:for:context:) has not been implemented")
    }
    
    public func referenceSizeForFooter(in section: Int, context: CollectionContext) -> CGSize {
        context.footerReferenceSize
    }
    
    public func referenceSizeForHeader(in section: Int, context: CollectionContext) -> CGSize {
        context.headerReferenceSize
    }
    
    public func sectionInset(at section: Int, context: CollectionContext) -> UIEdgeInsets {
        context.sectionInset
    }
        
    public func minimumItemSpacing(at section: Int, context: CollectionContext) -> CGFloat {
        context.minimumItemSpacing
    }
    
    public func minimumLineSpacing(at section: Int, context: CollectionContext) -> CGFloat {
        context.minimumLineSpacing
    }
    
    public func willDisplaySupplementaryView(_ view: UICollectionReusableView, forKind kind: String, at indexPath: IndexPath, context: CollectionContext) {
    }
}
