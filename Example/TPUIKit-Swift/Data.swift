//
//  Data.swift
//  TPUIKit-Swift_Example
//
//  Created by Topredator on 2021/8/26.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import TPFoundation_Swift
import TPUIKit_Swift
class Item {
    enum ItemType {
        case blank, banner, tabbar, menu, alert, refresh
    }
    var name: String?
    var type: Item.ItemType?
    init(_ name: String, type: Item.ItemType = .blank) {
        self.name = name
        self.type = type
    }
}

class ListRow: TableRowWrapper {
    private let item: Item
    init(_ item: Item) { self.item = item }
    func cellForRow(at indexPath: IndexPath, context: TableContext) -> UITableViewCell {
        let cell = context.dequeueReusableCell(at: indexPath, reuseIdentifier: "UITableViewCell", cellType: UITableViewCell.self)
        cell.textLabel?.text = item.name
        return cell
    }
    func didSelectCell(at indexPath: IndexPath, context: TableContext) {
        context.tableView.deselectRow(at: indexPath, animated: true)
        switch item.type {
        case .banner:
            Navigator.push(BannerVC())
            break
        case .tabbar:
            Navigator.push(TabbarVC())
            break
        case .menu:
            Navigator.push(MenuVC())
            break
        case .alert:
            Navigator.push(AlertVC())
            break
        case .refresh:
            Navigator.push(RefreshVC())
            break
        default: break
        }
    }
}
