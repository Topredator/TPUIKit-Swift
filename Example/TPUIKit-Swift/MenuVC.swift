//
//  MenuVC.swift
//  TPUIKit-Swift_Example
//
//  Created by Topredator on 2021/8/26.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import TPUIKit_Swift

class MenuVC: BaseViewController {
    var selectedIndex: Int = 0
    weak var menuVC: PopupMenuVC?
    let titles = ["Number1", "Number2", "Number3", "Number4"]
    var titleBtn: UIButton = {
        let btn = UIButton.init(frame: CGRect.zero)
        btn.addTarget(self, action: #selector(selectTitle), for: UIControl.Event.touchUpInside)
        btn.layer.cornerRadius = 5
        btn.layer.masksToBounds = true
        btn.setTitleColor(UIColor.white, for: UIControl.State.normal)
        btn.setTitle("please select", for: UIControl.State.normal)
        btn.backgroundColor = UIColor.purple
        return btn
    }()
    public override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupSubviews()
    }
    func setupSubviews() {
        view.addSubview(titleBtn)
        titleBtn.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.height.equalTo(40)
        }
    }
    @objc func selectTitle() {
        if let _ = self.menuVC { return }
        let config = PopupMenuConfig()
        config.selectedIndex = self.selectedIndex
        
        let menuVC: PopupMenuVC = PopupMenuVC(titles, config: config)
        menuVC.didSelected = { [weak self] (index) in
            self?.selectedIndex = index
            self?.titleBtn.setTitle(self?.titles[index], for: UIControl.State.normal)
        }
        menuVC.dismissblock = {
            print("dismiss")
        }
        menuVC.present(in: self, contentHeight: min(350, menuVC.maxContentHeight()))
        self.menuVC = menuVC
    }
}
