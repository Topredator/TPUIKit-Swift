//
//  CollectionItem.swift
//  XTFoundation-Swift
//
//  Created by Topredator on 2021/8/11.
//

import Foundation

public protocol CollectionItem {
    func cellForItem(at indexPath: IndexPath, context: CollectionContext) -> UICollectionViewCell
    func sizeForItem(at indexPath: IndexPath, context: CollectionContext) -> CGSize
    func willDisplayCell(_ cell: UICollectionViewCell, at indexPath: IndexPath, context: CollectionContext)
    func didEndDisplayingCell(_ cell: UICollectionViewCell, at indexPath: IndexPath, context: CollectionContext)
    func didSelectItem(at indexPath: IndexPath, context: CollectionContext)
}

extension CollectionItem {
    func sizeForItem(at indexPath: IndexPath, context: CollectionContext) -> CGSize {
        return context.itemSize
    }
    
    func didSelectItem(at indexPath: IndexPath, context: CollectionContext) {}
    
    func willDisplayCell(_ cell: UICollectionViewCell, at indexPath: IndexPath, context: CollectionContext) {}
    
    func didEndDisplayingCell(_ cell: UICollectionViewCell, at indexPath: IndexPath, context: CollectionContext) {}
}
