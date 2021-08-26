//
//  VIew+TP.swift
//  TPFoundation-Swift
//
//  Created by Topredator on 2021/8/26.
//

extension UIView: NameSpaceWrappable {}
public extension NameSpace where Base: UIView {
    /// 移除所有子视图
    func removeAllSubviews() {
        for subview in base.subviews {
            subview.removeFromSuperview()
        }
    }
    
    /// 为视图添加圆角
    /// - Parameters:
    ///   - radius: 圆角半径
    ///   - rectCorner: 圆角方位
    func draw(cornerRadius radius: CGFloat, corners: UIRectCorner = .allCorners) {
        base.layoutIfNeeded()
        let path = UIBezierPath(roundedRect: base.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = base.bounds
        shapeLayer.path = path.cgPath
        base.layer.mask = shapeLayer
    }
    
    /// 视图 快照
    func snapshotImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(base.bounds.size, base.isOpaque, 0)
        base.layer.render(in: UIGraphicsGetCurrentContext()!)
        let snapImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return snapImage
    }
    
    /// 视图 快照
    /// - Parameter update: 屏幕是否更新后截取
    func snapshot(afterScreenUpdate update: Bool) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(base.bounds.size, base.isOpaque, 0)
        base.drawHierarchy(in: base.bounds, afterScreenUpdates: update)
        let snapImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return snapImg
    }
}
