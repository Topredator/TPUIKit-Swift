//
//  BackgroundLineView.swift
//  TPUIKit-Swift
//
//  Created by Topredator on 2021/11/20.
//

import UIKit
public class BackgroundLineView: UIView {
    
    fileprivate let bgView = LinebgView(length: 0)
    
    var lineWidth: CGFloat {
        get { bgView.lineWidth }
        set {
            bgView.lineWidth = newValue
            bgView.setNeedsDisplay()
        }
    }
    
    var lineGap: CGFloat {
        get { bgView.lineGap }
        set {
            bgView.lineGap = newValue
            bgView.setNeedsDisplay()
        }
    }
    var lineColor: UIColor {
        get { bgView.lineColor }
        set {
            bgView.lineColor = newValue
            bgView.setNeedsDisplay()
        }
    }
    var rotate: CGFloat {
        get { bgView.rotate }
        set {
            bgView.rotate = newValue
            bgView.setNeedsDisplay()
        }
    }
    public convenience init(frame: CGRect, lineWidth: CGFloat, lineGap: CGFloat, lineColor: UIColor, rotate: CGFloat) {
        self.init(frame: frame)
        self.lineWidth = lineWidth
        self.lineGap = lineGap
        self.lineColor = lineColor
        self.rotate = rotate
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        layer.masksToBounds = true
        addSubview(bgView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override func layoutSubviews() {
        super.layoutSubviews()
        setupBgView()
    }
    fileprivate func setupBgView() {
        let drawLength = sqrt(bounds.size.width * bounds.size.width + bounds.size.height * bounds.size.height)
        bgView.frame = CGRect(x: 0.0, y: 0.0, width: drawLength, height: drawLength)
        bgView.center = CGPoint(x: bounds.size.width / 2.0, y: bounds.size.height / 2.0)
        bgView.setNeedsDisplay()
    }
}

private class LinebgView: UIView {
    fileprivate var rotate    : CGFloat = 0
    fileprivate var lineWidth : CGFloat = 5
    fileprivate var lineGap   : CGFloat = 3
    fileprivate var lineColor : UIColor = UIColor.gray
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(length : CGFloat) {
        
        self.init(frame : CGRect(x: 0, y: 0, width: length, height: length))
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard self.bounds.size.width > 0 && self.bounds.size.height > 0 else {
            return
        }
        
        let context      = UIGraphicsGetCurrentContext()
        let width        = self.bounds.size.width
        let height       = self.bounds.size.height
        let drawLength   = sqrt(width * width + height * height)
        let outerX       = (drawLength - width)  / 2.0
        let outerY       = (drawLength - height) / 2.0
        let tmpLineWidth = lineWidth <= 0 ? 5 : lineWidth
        let tmpLineGap   = lineGap   <= 0 ? 3 : lineGap
        
        var red   : CGFloat = 0
        var green : CGFloat = 0
        var blue  : CGFloat = 0
        var alpha : CGFloat = 0
        
        context?.translateBy(x: 0.5 * drawLength, y: 0.5 * drawLength)
        context?.rotate(by: rotate)
        context?.translateBy(x: -0.5 * drawLength, y: -0.5 * drawLength)
        
        lineColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        context?.setFillColor(red: red, green: green, blue: blue, alpha: alpha)
        
        var currentX = -outerX
        
        while currentX < drawLength {
            
            context?.addRect(CGRect(x: currentX, y: -outerY, width: tmpLineWidth, height: drawLength))
            currentX += tmpLineWidth + tmpLineGap
        }
        
        context?.fillPath()
    }
}
