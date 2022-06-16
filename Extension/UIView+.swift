//
//  UIView+.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/12.
//

import Foundation
import UIKit

extension UIView {
    func corner(byRoundingCorners corners: UIRectCorner, radii: CGFloat) {
        let maskPath = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radii, height: radii)
        )
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = maskPath.cgPath
        layer.mask = maskLayer
    }
    
    func cornerForAll(radii: CGFloat) {
        corner(byRoundingCorners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radii: radii)
    }
    
    func cornerRadii(radii: CGFloat) {
        clipsToBounds = true
        layer.cornerRadius = radii
    }
    
    func makeShadow(shadowOpacity: Float? = 0.4, shadowRadius: CGFloat? = 5, color: CGColor? = UIColor.black.cgColor, offset: CGSize = .zero) {
        guard let shadowRadius = shadowRadius, let shadowOpacity = shadowOpacity else {
            return
        }
        layer.masksToBounds = false
        layer.shadowColor = color
        layer.shadowOpacity = shadowOpacity
        layer.shadowOffset = offset
        layer.shadowRadius = shadowRadius
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
    
    class func fromNib<T: UIView>() -> T {
        guard let output = Bundle(for: T.self).loadNibNamed(String(describing: T.self), owner: nil, options: nil)?[0] as? T else { return T() }
        return output
    }
    
    func stickSubView(_ objectView: UIView) {
        objectView.removeFromSuperview()
        
        addSubview(objectView)
        
        objectView.translatesAutoresizingMaskIntoConstraints = false
        
        objectView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        
        objectView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        
        objectView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        objectView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    func stickSubViewSafeArea(_ objectView: UIView) {
        objectView.removeFromSuperview()
        
        addSubview(objectView)
        
        objectView.translatesAutoresizingMaskIntoConstraints = false
        
        objectView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        
        objectView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        
        objectView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        objectView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    func stickSubView(_ objectView: UIView, inset: UIEdgeInsets) {
        objectView.removeFromSuperview()
        
        addSubview(objectView)
        
        objectView.translatesAutoresizingMaskIntoConstraints = false
        
        objectView.topAnchor.constraint(equalTo: topAnchor, constant: inset.top).isActive = true
        
        objectView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset.left).isActive = true
        
        objectView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -inset.right).isActive = true
        
        objectView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -inset.bottom).isActive = true
    }
    
    enum GlowEffect: Float {
        case small = 15, normal = 20, mid = 25, big = 30
    }
    
    func doGlowAnimation(withColor color: UIColor, withEffect effect: GlowEffect = .normal) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowRadius = 0
        layer.shadowOpacity = 0.8
        layer.shadowOffset = .zero
        
        let glowAnimation = CABasicAnimation(keyPath: "shadowRadius")
        glowAnimation.fromValue = 0
        glowAnimation.toValue = effect.rawValue
        glowAnimation.fillMode = .removed
        glowAnimation.repeatCount = .infinity
        glowAnimation.duration = 2
        glowAnimation.autoreverses = true
        layer.removeAllAnimations()
        
        layer.add(glowAnimation, forKey: "shadowGlowingAnimation")
    }
    
    func initValueCircle(value: Double, color: CGColor) {
        let circlePath = UIBezierPath(
            arcCenter: CGPoint(x: frame.size.width / 2, y: frame.size.height / 2),
            radius: frame.size.width / 2,
            startAngle: CGFloat(-0.5 * .pi),
            endAngle: CGFloat(1.5 * .pi),
            clockwise: true
        )
        // circle shape
        let circleShape = CAShapeLayer()
        circleShape.path = circlePath.cgPath
        circleShape.strokeColor = color
        circleShape.fillColor = UIColor.clear.cgColor
        circleShape.lineWidth = 2
        // set start and end values
        circleShape.strokeStart = 0.0
        circleShape.strokeEnd = value * 0.1
        // add sublayer
        layer.addSublayer(circleShape)
    }
    func initValueSubView(value: Double, color: UIColor?) {
        subviews.map { $0.removeFromSuperview() }
        backgroundColor = color
        let label = UILabel()
        addSubview(label)
        label.font = .boldSystemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        label.text = String(value)
    }
}
