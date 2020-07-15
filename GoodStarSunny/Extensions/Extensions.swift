//
//  Extensions.swift
//  Magnetic
//
//  Created by Lasha Efremidze on 3/25/17.
//  Copyright © 2017 efremidze. All rights reserved.
//

import Foundation
import UIKit

var keyboardHeight: CGFloat = 0

func showToast(_ message: String) {
    
    hideToast()
    let toastLb = UILabel()
    toastLb.numberOfLines = 0
    toastLb.lineBreakMode = .byWordWrapping
    toastLb.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    toastLb.textColor = UIColor.white
    toastLb.layer.cornerRadius = 10.0
    toastLb.textAlignment = .center
    toastLb.font = UIFont.systemFont(ofSize: 16.0)
    toastLb.text = message
    toastLb.layer.masksToBounds = true
    toastLb.tag = 9999
    
    let maxSize = CGSize(width: UIApplication.shared.keyWindow!.bounds.width - 60, height: UIApplication.shared.keyWindow!.bounds.height)
    var expectedSize = toastLb.sizeThatFits(maxSize)
    var lbWidth = maxSize.width
    var lbHeight = maxSize.height
    if maxSize.width >= expectedSize.width{
        lbWidth = expectedSize.width
    }
    if maxSize.height >= expectedSize.height{
        lbHeight = expectedSize.height
    }
    expectedSize = CGSize(width: lbWidth, height: lbHeight)
    toastLb.frame = CGRect(x: ((UIApplication.shared.keyWindow!.bounds.size.width)/2) - ((expectedSize.width + 20)/2), y: UIApplication.shared.keyWindow!.bounds.height/3, width: expectedSize.width + 20, height: expectedSize.height + 20)
    UIApplication.shared.keyWindow!.addSubview(toastLb)
    
    UIView.animate(withDuration: 1.5, delay: 1.5, animations: {
        toastLb.alpha = 0.0
    }) { (complete) in
        toastLb.removeFromSuperview()
    }
}

private func hideToast() {
    for view in UIApplication.shared.keyWindow!.subviews{
        if view is UILabel , view.tag == 9999{
            view.removeFromSuperview()
        }
    }
}

extension UIView {    
    
    func shake() {
        
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.repeatCount = 2
        animation.values = [-10, 10, -8, 8, -5, 5, -3, 3, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
    
    @IBInspectable var borderColor: UIColor? {
        
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        
        get {
            return layer.borderWidth
        }
        
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        
        get {
            return layer.cornerRadius
        }
        
        set {
            clipsToBounds = true
            layer.cornerRadius = newValue
        }
    }
}

