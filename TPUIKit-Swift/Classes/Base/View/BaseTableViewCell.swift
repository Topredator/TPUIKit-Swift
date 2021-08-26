//
//  XTBaseTableViewCell.swift
//  XTUIKit-Swift
//
//  Created by Topredator on 2020/6/2.
//

import UIKit

open class BaseTableViewCell: UITableViewCell {
    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = UITableViewCell.SelectionStyle.none
        self.setupSubviews()
        self.makeConstraints()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 添加子视图
    open func setupSubviews() {}
    /// 添加约束
    open func makeConstraints() {}
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
