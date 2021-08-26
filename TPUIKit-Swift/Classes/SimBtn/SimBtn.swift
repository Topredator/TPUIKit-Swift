//
//  SimBtn.swift
//  XTUIKit-Swift
//
//  Created by Topredator on 2020/5/27.
//

import UIKit

/// 特殊按钮  可设置图片位置、点击范围
public class SimBtn: UIButton {
    /// 水平 外间距
    private var _h_sideMargin: CGFloat = 5.0
    public var h_sideMargin: CGFloat {
        get { _h_sideMargin }
        set {
            _h_sideMargin = newValue
            setNeedsLayout()
        }
    }
    
    /// 竖直 外间距
    private var _v_sideMargin: CGFloat = 3.0
    public var v_sideMargin: CGFloat {
        get { _v_sideMargin }
        set {
            _v_sideMargin = newValue
            setNeedsLayout()
        }
    }
    
    /// 展示 位置 类型
    public var iconPosition: SimBtn.Position = .default
    /// 图文距离 默认5
    private var _iconTextMargin: CGFloat = 5
    public var iconTextMargin: CGFloat {
        get { _iconTextMargin }
        set {
            _iconTextMargin = newValue
            self.invalidateIntrinsicContentSize()
        }
    }
    /// 按钮点击范围，设定值为单侧的px，上下左右都会加上这个扩展值
    private var _extInteractEdge: CGFloat = 0
    public var extInteractEdge: CGFloat {
        get { _extInteractEdge }
        set {
            _extInteractEdge = newValue
            self.extInteractInsets = UIEdgeInsets.init(top: newValue, left: newValue, bottom: newValue, right: newValue)
        }
    }
    /// 自定义扩展上下左右的值
    public var extInteractInsets: UIEdgeInsets = .zero
    
    override public func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let actualRect = CGRect.init(x: self.bounds.origin.x - self.extInteractInsets.left, y: self.bounds.origin.y - self.extInteractInsets.top, width: self.bounds.width + self.extInteractInsets.left + self.extInteractInsets.right, height: self.bounds.height + self.extInteractInsets.top + self.extInteractInsets.bottom)
        return actualRect.contains(point)
    }
    
    
    /// 是否存在图片
    var isExistImg = false
    /// 是否存在文案
    var isExistTitle = false
    
    public override func setTitle(_ title: String?, for state: UIControl.State) {
        super.setTitle(title, for: state)
        isExistTitle = (title != nil)
    }
    public override func setImage(_ image: UIImage?, for state: UIControl.State) {
        super.setImage(image, for: state)
        isExistImg = (image != nil)
    }
    
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        // title、image 必须有一个存在
        guard isExistImg || isExistTitle else { return }
        if self.iconPosition == .default { return }
        // 自适应 title、image 的frame
        self.titleLabel?.sizeToFit()
        self.imageView?.sizeToFit()
        if isExistTitle && !isExistImg { // 只用title
            var titleFrame = self.titleLabel!.frame
            titleFrame.size.width = min(self.frame.size.width - 2 * h_sideMargin, titleFrame.size.width)
            titleFrame.size.height = min(self.frame.size.height - 2 * v_sideMargin, titleFrame.size.height)
            self.titleLabel!.frame = titleFrame
            return
        } else if isExistImg && !isExistTitle { // 只用image
            return
        }
        var titleRect = self.titleLabel!.frame
        var imageRect = self.imageView!.frame
        
        switch self.iconPosition {
        case .left: // image、titlelabel的origin.x
            // 总宽度
            let totalWidth = self.frame.size.width - 2 * h_sideMargin
            let width: CGFloat = titleRect.width + imageRect.width + iconTextMargin
            if totalWidth < width {
                self.imageView!.frame = CGRect(x: h_sideMargin, y: imageRect.minY, width: imageRect.width, height: imageRect.height)
                self.titleLabel!.frame = CGRect(x: self.imageView!.frame.maxX + iconTextMargin, y: titleRect.minY, width: totalWidth - self.imageView!.frame.width - iconTextMargin, height: titleRect.height)
                break
            }
            let right: CGFloat = self.frame.width / 2 + width / 2
            titleRect.origin.x = right - titleRect.width
            self.titleLabel!.frame = titleRect
            
            let left: CGFloat = self.frame.width / 2 - width / 2
            imageRect.origin.x = left
            self.imageView!.frame = imageRect
            break
        case .right:
            // 总宽度
            let totalWidth = self.frame.size.width - 2 * h_sideMargin
            let width: CGFloat = imageRect.width + titleRect.width + iconTextMargin
            if totalWidth < width {
                self.imageView!.frame = CGRect(x: self.frame.size.width - h_sideMargin - imageRect.width, y: imageRect.origin.y, width: imageRect.width, height: imageRect.height)
                self.titleLabel!.frame = CGRect(x: h_sideMargin, y: titleRect.origin.y, width: totalWidth - self.imageView!.frame.size.width - h_sideMargin, height: titleRect.height)
                break
            }
            let right: CGFloat = self.frame.width / 2 + width / 2
            imageRect.origin.x = right - imageRect.width
            self.imageView!.frame = imageRect
            
            let left: CGFloat = self.frame.width / 2 - width / 2
            titleRect.origin.x = left
            self.titleLabel!.frame = titleRect
            break
        case .top:
            let height: CGFloat = imageRect.height + titleRect.height + iconTextMargin
            let top = self.frame.height / 2 - height / 2
            imageRect.origin.y = top
            self.imageView!.frame = imageRect
            
            let bottom = self.frame.height / 2 + height / 2
            titleRect.origin.y = bottom - titleRect.height
            self.titleLabel!.frame = titleRect
            
            let centerX: CGFloat = self.frame.width / 2
            var imageCenter: CGPoint = self.imageView!.center
            imageCenter = CGPoint(x: centerX, y: imageCenter.y)
            self.imageView!.center = imageCenter
            
            var titleCenter: CGPoint = self.titleLabel!.center
            titleCenter = CGPoint(x: centerX, y: titleCenter.y)
            self.titleLabel!.center = titleCenter
            break
        case .bottom:
            let height: CGFloat = imageRect.height + titleRect.height + iconTextMargin
            let top = self.frame.height / 2 - height / 2
            titleRect.origin.y = top
            self.titleLabel!.frame = titleRect
            
            let bottom = self.frame.height / 2 + height / 2
            imageRect.origin.y = bottom - imageRect.height
            self.imageView!.frame = imageRect
            
            let centerX: CGFloat = self.frame.width / 2
            var imageCenter: CGPoint = self.imageView!.center
            imageCenter = CGPoint(x: centerX, y: imageCenter.y)
            self.imageView!.center = imageCenter
            
            var titleCenter: CGPoint = self.titleLabel!.center
            titleCenter = CGPoint(x: centerX, y: titleCenter.y)
            self.titleLabel!.center = titleCenter
            break
        default: break
        }
    }
    
    override public func sizeToFit() {
        if self.iconPosition == .default {
            super.sizeToFit()
        } else {
            self.titleLabel?.sizeToFit()
            let image: UIImage? = self.currentImage
            var width: CGFloat = 0.0
            var height: CGFloat = 0.0
            let titleWidth = self.titleLabel?.frame.width
            let titleHeight = self.titleLabel?.frame.height
            switch self.iconPosition {
            case .left, .right:
                if isExistTitle && isExistImg {
                    width = titleWidth! + image!.size.width + self.iconTextMargin + h_sideMargin * 2
                    height = max(titleHeight!, image!.size.height) + v_sideMargin * 2
                } else if isExistTitle && !isExistImg {
                    width = titleWidth! + h_sideMargin * 2
                    height = titleHeight! + v_sideMargin * 2
                } else if !isExistTitle && isExistImg {
                    width = image!.size.width + h_sideMargin * 2
                    height = image!.size.height + v_sideMargin * 2
                }
                break
            case .top, .bottom:
                if isExistTitle && isExistImg {
                    width = max(titleWidth!, image!.size.width) + h_sideMargin * 2
                    height = titleHeight! + image!.size.height + self.iconTextMargin + v_sideMargin * 2
                } else if isExistTitle && !isExistImg {
                    width = titleWidth! + h_sideMargin * 2
                    height = titleHeight! + v_sideMargin * 2
                } else if !isExistTitle && isExistImg {
                    width = image!.size.width + h_sideMargin * 2
                    height = image!.size.height + v_sideMargin * 2
                }
                break
            default: break
            }
            var rect = self.frame
            rect.size = CGSize(width: ceil(width), height: ceil(height))
            self.frame = rect
        }
        
    }
    
    override public var intrinsicContentSize: CGSize {
        let labelSize = self.titleLabel?.intrinsicContentSize
        let imageSize = self.imageView?.intrinsicContentSize
        
        var width: CGFloat = 0, height: CGFloat = 0
        switch self.iconPosition {
        case .left, .right:
            if isExistTitle && isExistImg {
                width = labelSize!.width + imageSize!.width + iconTextMargin + h_sideMargin * 2
                height = max(labelSize!.height, imageSize!.height) + v_sideMargin * 2
            } else if isExistTitle && !isExistImg {
                width = labelSize!.width + h_sideMargin * 2
                height = labelSize!.height + v_sideMargin * 2
            } else if !isExistTitle && isExistImg {
                width = imageSize!.width + h_sideMargin * 2
                height = imageSize!.height + v_sideMargin * 2
            }
            break
        case .top, .bottom:
            if isExistTitle && isExistImg {
                width = max(labelSize!.width, imageSize!.width) + h_sideMargin * 2
                height = labelSize!.height + imageSize!.height + iconTextMargin + v_sideMargin * 2
            } else if isExistTitle && !isExistImg {
                width = labelSize!.width + h_sideMargin * 2
                height = labelSize!.height + v_sideMargin * 2
            } else if !isExistTitle && isExistImg {
                width = imageSize!.width + h_sideMargin * 2
                height = imageSize!.height + v_sideMargin * 2
            }
            break
        default: break
        }
        return CGSize.init(width: ceil(width), height: ceil(height))
    }
}

extension SimBtn {
    /// icon位于文案的位置
    public enum Position: Int {
        case `default` = 0
        case left
        case right
        case top
        case bottom
    }
}
