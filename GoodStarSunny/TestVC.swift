//
//  TestVC.swift
//  HabitDevelopment
//
//  Created by HellöM on 2020/6/9.
//  Copyright © 2020 HellöM. All rights reserved.
//

import UIKit

protocol TestVCDelegate {
    func enterMain()
}

class TestVC: SpotlightViewController {

    var testVCDelegate: TestVCDelegate?
    var stepIndex = 0
    var txt: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        txt = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        txt.numberOfLines = 0
        txt.alpha = 0
        txt.font = UIFont.systemFont(ofSize: 20)
        txt.textColor = .white
        txt.textAlignment = .center
        spotlightView.addSubview(txt)
        delegate = self
    }
    
    func next() {
        
        let screenSize = UIScreen.main.bounds.size
        switch stepIndex {
        case 0:
            UIView.animate(withDuration: 0.5) {
                self.txt.alpha = 1
            }
            txt.center = CGPoint(x: view.frame.width/2, y: view.frame.height/2)
            txt.text = "歡迎使用好星晴,\n請點擊螢幕繼續..."
            spotlightView.appear(Spotlight.Rect(center: CGPoint(x: screenSize.width/2, y: screenSize.height/2), size: CGSize(width: 0, height: 0)))
        case 1:
            
            UIView.animate(withDuration: 0.5, animations: {
                self.txt.alpha = 0
            }, completion: { (bool) in
                self.txt.text = "可透過下方按鈕\n來新增地區"
                UIView.animate(withDuration: 0.5) {
                    self.txt.alpha = 1
                }
            })
            spotlightView.move(Spotlight.Oval(center: CGPoint(x: screenSize.width/2, y: screenSize.height-tabbarVC.tabBar.frame.height+15), diameter: 60), moveType: .disappear)
            
        case 2:
            dismiss(animated: true) {
                self.testVCDelegate?.enterMain()
            }
        default:
            break
        }
        
        stepIndex += 1
    }
}

extension TestVC: SpotlightViewControllerDelegate {
    
    func spotlightViewControllerWillPresent(_ viewController: SpotlightViewController, animated: Bool) {
        next()
    }

    func spotlightViewControllerTapped(_ viewController: SpotlightViewController, isInsideSpotlight: Bool) {
        next()
    }

    func spotlightViewControllerWillDismiss(_ viewController: SpotlightViewController, animated: Bool) {
        spotlightView.disappear()
    }
}
