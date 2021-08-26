//
//  PopupMenuVC.swift
//  XTUIKit-Swift
//
//  Created by Topredator on 2020/6/2.
//

import UIKit
import SnapKit
import TPFoundation_Swift
public typealias DidSelectedBlock = (Int) -> Void
public typealias DismissBlock = () -> Void
/// 选择菜单控制器
public class PopupMenuVC: BaseViewController {
    // MARK:  ------------- 传参 --------------------
    /// 内容数组
    fileprivate var menuTitles: [String] = []
    /// 配置项
    var config: PopupMenuConfig  = PopupMenuConfig()
    /// 选中回调
    public var didSelected: DidSelectedBlock?
    /// 消失回调
    @objc public var dismissblock: DismissBlock?
    
    // MARK:  ------------- 私有属性 --------------------
    weak var targetVC: UIViewController?
    var popCellHeight: CGFloat = 44
    lazy var contentView: UIView = {
        let view = UIView.init(frame: CGRect.zero)
        return view
    }()
    lazy var tableView: UITableView = {
        let table: UITableView = UITableView.init(frame: CGRect.zero, style: UITableView.Style.grouped)
        table.delegate = self
        table.dataSource = self
        table.rowHeight = self.popCellHeight
        table.register(PopupMenuCell.self, forCellReuseIdentifier: "PopupMenuCell")
        table.delaysContentTouches = true
        table.backgroundColor = UIColor.white
        table.separatorColor = lineColor
        table.separatorInset = UIEdgeInsets.zero
        self.tp.adjust(scrollInsets: table)
        return table
    }()
    lazy var maskView: UIButton = {
        let btn = UIButton.init(frame: CGRect.zero)
        btn.backgroundColor = UIColor.tp.rgbt(0, 0.5)
        btn.addTarget(self, action: #selector(dismissAction), for: UIControl.Event.touchUpInside)
        btn.alpha = 0
        return btn
    }()
    private var _selectedIndex: Int = 0
    var selectedIndex: Int {
        get { _selectedIndex }
        set {
            _selectedIndex = newValue
            if newValue < 0 || newValue >= self.menuTitles.count {
                if let selectedRow = self.tableView.indexPathForSelectedRow {
                    self.tableView.deselectRow(at: selectedRow, animated: false)
                }
            } else {
                let indexPath: NSIndexPath = NSIndexPath.init(row: newValue, section: 0)
                self.tableView.selectRow(at: indexPath as IndexPath, animated: false, scrollPosition: UITableView.ScrollPosition.none)
            }
        }
    }
    // MARK:  ------------- init --------------------
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 初始化
    /// - Parameters:
    ///   - config: 菜单配置信息
    ///   - titles: 菜单标题列表
    public convenience init(_ titles: [String]?, config: PopupMenuConfig? = nil) {
        self.init()
        if let con = config { self.config = con }
        if let arr = titles { self.menuTitles = arr }
    }
    public override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.clear
        self.setupSubviews()
    }
    func setupSubviews() {
        self.selectedIndex = self.config.selectedIndex
        self.view.addSubview(self.maskView)
        self.view.addSubview(self.contentView)
        self.contentView.addSubview(self.tableView)
        
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.maskView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    @objc func dismissAction() {
        self.dismiss()
    }
    
    /// 模态
    /// - Parameters:
    ///   - targetVC: 目标控制器
    ///   - contentHeight: 内容高低
    public func present(in targetVC: UIViewController, contentHeight: CGFloat) {
        guard self.menuTitles.count > 0 else { return }
        self.targetVC = targetVC
        targetVC.addChild(self)
        targetVC.view.addSubview(self.view)
        if (targetVC.navigationController != nil && !(targetVC.navigationController!.navigationBar.isTranslucent)) || targetVC.navigationController == nil {
            self.view.frame = targetVC.view.bounds
        } else {
            self.view.snp.makeConstraints { (make) in
                make.edges.equalTo(UIEdgeInsets.init(top: UI.TopBarHeight, left: 0, bottom: 0, right: 0))
            }
        }
        self.contentView.snp.makeConstraints { (make) in
            make.left.right.top.height.equalTo(0)
        }
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.2, delay: 0, options: UIView.AnimationOptions.curveEaseInOut, animations: {
            self.contentView.snp.updateConstraints { (make) in
                make.height.equalTo(contentHeight)
            }
            self.maskView.alpha = 1
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    /// 消失
    public func dismiss() {
        UIView.animate(withDuration: 0.2, delay: 0, options: UIView.AnimationOptions.curveEaseInOut, animations: {
            self.contentView.snp.updateConstraints { (make) in
                make.height.equalTo(0)
            }
            self.maskView.alpha = 0
            self.view.layoutIfNeeded()
        }) { (finished) in
            if self.dismissblock != nil { self.dismissblock!() }
            self.view.removeFromSuperview()
            self.removeFromParent()
        }
    }
    /// 内容最大高度
    public func maxContentHeight() -> CGFloat {
        return CGFloat(menuTitles.count) * popCellHeight
    }
    
}

extension PopupMenuVC: UITableViewDataSource, UITableViewDelegate {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menuTitles.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PopupMenuCell", for: indexPath) as! PopupMenuCell
        cell.configCell(title: self.menuTitles[indexPath.row], config: self.config)
        return cell
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        self.dismiss()
        if self.didSelected != nil { self.didSelected!(indexPath.row) }
    }
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
}
