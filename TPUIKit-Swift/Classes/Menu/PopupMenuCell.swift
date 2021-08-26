//
//  PopupMenuCell.swift
//  XTUIKit-Swift
//
//  Created by Topredator on 2020/6/2.
//

import UIKit


/// 菜单选项 单元格
public class PopupMenuCell: BaseTableViewCell {
    var config: PopupMenuConfig = PopupMenuConfig()
    var titleLabel: UILabel = {
        let label = UILabel.init(frame: CGRect.zero)
        label.font = UIFont.tp.font(14, weight: .medium)
        label.textColor = darkColor
        return label
    }()
    public override func setupSubviews() {
        self.contentView.backgroundColor = UIColor.white
        self.contentView.addSubview(self.titleLabel)
    }
    public override func makeConstraints() {
        self.titleLabel.snp.makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
            make.height.equalTo(16)
        }
    }
    /// 配置cell
    public func configCell(title: String, config: PopupMenuConfig) {
        self.titleLabel.text = title
        self.config = config
    }
    public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.titleLabel.font = selected ? self.config.selectTextFont : self.config.normalTextFont
        self.titleLabel.textColor = selected ? self.config.selectTextColor : self.config.normalTextColor
        self.contentView.backgroundColor = selected ? self.config.itemSelectBgColor : self.config.itemBgColor
        // Configure the view for the selected state
    }

}
