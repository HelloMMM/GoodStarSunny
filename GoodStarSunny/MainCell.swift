//
//  MainCell.swift
//  GoodStarSunny
//
//  Created by HellöM on 2020/7/16.
//  Copyright © 2020 HellöM. All rights reserved.
//

import UIKit
import CoreData

class MainCell: UICollectionViewCell, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var weather: UILabel!
    @IBOutlet weak var area: UILabel!
    @IBOutlet weak var temp: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    var isEdit = false {
        didSet {
            if isEdit {
                startAnimate()
            } else {
                stopAnimate()
            }
        }
    }
    
    var width: CGFloat!
    var height: CGFloat!
    let impactLight = UIImpactFeedbackGenerator(style: .light)
    var pan: UIPanGestureRecognizer!
    var deleteImageView: UIImageView!
    var isImpact = false
    
    override func awakeFromNib() {
        
        pan = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
        pan.delegate = self
        addGestureRecognizer(pan)
        
        deleteImageView = UIImageView()
        deleteImageView.image = UIImage(named: "delete")
        insertSubview(deleteImageView, belowSubview: self.contentView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        width = contentView.frame.width
        height = contentView.frame.height
        
        deleteImageView.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        deleteImageView.center = CGPoint(x: width-60, y: height/2)
    }
    
    private func startAnimate() {
        let shakeAnimation = CABasicAnimation(keyPath: "transform.rotation")
        shakeAnimation.duration = 0.2
        shakeAnimation.repeatCount = .infinity
        
        let startAngle: Float = (-0.5) * 3.14159/180
        let stopAngle = -startAngle
        
        shakeAnimation.fromValue = NSNumber(value: startAngle as Float)
        shakeAnimation.toValue = NSNumber(value: 3 * stopAngle as Float)
        shakeAnimation.autoreverses = true
        shakeAnimation.timeOffset = 290 * drand48()
        
        layer.add(shakeAnimation, forKey:"animate")
    }
    
    private func stopAnimate() {
        layer.removeAnimation(forKey: "animate")
    }
    
    @objc func onPan(_ pan: UIPanGestureRecognizer) {
        
        let p: CGPoint = pan.translation(in: self)
        
        if pan.state == .began {
            
        } else if pan.state == .changed {
            
            if p.x > 0 {
                return
            }

            contentView.frame = CGRect(x: p.x,y: 0, width: width, height: height)
            
            if p.x < -(width*0.6) {
                deleteImageView.image = UIImage(named: "delete-1")
                if !isImpact {
                    isImpact = true
                    impactLight.impactOccurred()
                }
            } else {
                deleteImageView.image = UIImage(named: "delete")
                isImpact = false
            }
        } else {
             
            if pan.translation(in: self).x < -(width*0.6) {

                let collectionView: UICollectionView = self.superview as! UICollectionView
                let indexPath: IndexPath = collectionView.indexPathForItem(at: self.center)!
                collectionView.delegate?.collectionView!(collectionView, performAction: #selector(onPan(_:)), forItemAt: indexPath, withSender: nil)
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.setNeedsLayout()
                    self.layoutIfNeeded()
                })
            }
        }
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return abs((pan.velocity(in: pan.view)).x) > abs((pan.velocity(in: pan.view)).y)
    }
}
