//
//  AlertVC.swift
//  TPUIKit-Swift_Example
//
//  Created by Topredator on 2021/8/26.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import TPUIKit_Swift

class AlertVC: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Alert"
        setupSubviews()
        tp.navigationItem.navigaitonBarHidden = true
    }
    func setupSubviews() {
        // alert
        let alertBtn: UIButton = {
            let btn = UIButton.init(type: .custom)
            btn.setTitle("alert", for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            btn.setTitleColor(UIColor.white, for: .normal)
            btn.backgroundColor = UIColor.purple
            btn.addTarget(self, action: #selector(alertBtnAction), for: .touchUpInside)
            return btn
        }()
        view.addSubview(alertBtn)
        alertBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize.init(width: 100, height: 30))
            make.top.equalTo(88)
        }
        // blank
        let blankBtn: UIButton = {
            let btn = UIButton.init(type: .custom)
            btn.setTitle("blank", for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            btn.setTitleColor(UIColor.white, for: .normal)
            btn.backgroundColor = UIColor.purple
            btn.addTarget(self, action: #selector(blankBtnAction), for: .touchUpInside)
            return btn
        }()
        view.addSubview(blankBtn)
        blankBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize.init(width: 100, height: 30))
            make.top.equalTo(alertBtn.snp.bottom).offset(30)
        }
        
        // blank
        let networkBtn: UIButton = {
            let btn = UIButton.init(type: .custom)
            btn.setTitle("networkErr", for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            btn.setTitleColor(UIColor.white, for: .normal)
            btn.backgroundColor = UIColor.purple
            btn.addTarget(self, action: #selector(networkBtnAction), for: .touchUpInside)
            return btn
        }()
        view.addSubview(networkBtn)
        networkBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize.init(width: 100, height: 30))
            make.top.equalTo(blankBtn.snp.bottom).offset(30)
        }
        
        let simBtn: SimBtn = {
            let btn = SimBtn(frame: CGRect.zero)
            btn.setTitle("点击", for: .normal)
            btn.setImage(UIImage(named: "right"), for: .normal)
            btn.iconPosition = .bottom
            btn.iconTextMargin = 3.0
            btn.h_sideMargin = 2.0
            btn.v_sideMargin = 2.0
            btn.titleLabel?.font = UIFont.tp.font(11, weight: .medium)
            btn.backgroundColor = .purple
            btn.addTarget(self, action: #selector(clickBtn(_:)), for: .touchUpInside)
            return btn
        }()
        view.addSubview(simBtn)
        simBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(30)
            make.width.equalTo(70)
            make.top.equalTo(networkBtn.snp.bottom).offset(30)
        }
    }
    
    
    @objc func networkBtnAction() {
        self.view.showNetworkError(err: NSError(domain: "错误", code: 502, userInfo: nil)) { [weak self] in
            self?.view.hideBlank()
        }
    }
    @objc func blankBtnAction() {
        self.view.showLoading()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.view.hideBlank()
        }
    }
    
    @objc func alertBtnAction() {
//        XTAlert({ make in
//            make.title("aa").msg("侧首")
//            make.addOption(option: XTAlertOption("确定", block: {}))
//            make.addOption(option: XTAlertOption(title: "彩色", block: nil, color: .green))
//            make.cancleOption(title: "取消")
//        })
        Alert.sheetAlert { (make) in
            make.title("aa").msg("测试")
            make.addOption(AlertOption("确定", {
//                Toast.show(loading: "加载中...")
//                Toast.show(info: "测试下")
                Toast.showError()
//                Toast.showSuccess()
            }).titleColor(.red))
            make.addOption(AlertOption("测试", self, #selector(blankBtnAction)))
            make.addOption(AlertOption("彩色").titleColor(.green).add(target: self, selector: #selector(blankBtnAction)))
            make.cancleOption("取消")
        } _: {
            print("出现了")
        }
//        Alert.alert { (make) in
//            make.title("aa").msg("测试")
//            make.addOption(AlertOption("确定", {
//                print("")
//            }).titleColor(.red))
//            make.addOption(AlertOption("测试", self, #selector(blankBtnAction)))
//            make.addOption(AlertOption("彩色").titleColor(.green).add(target: self, selector: #selector(blankBtnAction)))
//            make.cancleOption("取消")
//        }
    }
    @objc func clickBtn(_ btn: SimBtn) {
        btn.setTitle("点击测试", for: .normal)
        btn.setImage(nil, for: .normal)
    }
}
