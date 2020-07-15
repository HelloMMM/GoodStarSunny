//
//  ViewController.swift
//  GoodStarSunny
//
//  Created by HellöM on 2020/7/14.
//  Copyright © 2020 HellöM. All rights reserved.
//

import UIKit
import ESTabBarController_swift
import Hero

var tabBarColor: UIColor!

class TabbarVC: ESTabBarController, MoreVCDelegate {

    var mainVC: MainVC!
    var addVC: UIViewController!
    var moreVC: MoreVC!
    var n1: UINavigationController!
    var n2: UINavigationController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainVC") as? MainVC
        
        addVC = UIViewController()
        addVC.hero.isEnabled = true
        
        moreVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MoreVC") as? MoreVC
        moreVC.delegate = self
        
        n1 = UINavigationController(rootViewController: mainVC)
        n2 = UINavigationController(rootViewController: moreVC)
        
        changeStyle(AppStyle(rawValue: appStyle)!)
        
        viewControllers = [n1, addVC, n2]
        
        shouldHijackHandler = {
            tabbarController, viewController, index in
            if index == 1 {
                return true
            }
            return false
        }
        
        didHijackHandler = {
            [weak self] tabbarController, viewController, index in
            
            let addVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddVC") as! AddVC
            
            self?.present(addVC, animated: true, completion: nil)
        }
    }
    
    func changeStyle(_ style: AppStyle) {
        
        let exampleIrregularityContentView = ExampleIrregularityContentView()
        exampleIrregularityContentView.imageView.hero.isEnabled = true
        exampleIrregularityContentView.imageView.hero.isEnabledForSubviews = true
        exampleIrregularityContentView.imageView.hero.id = "AddVC"
        let basicContentView1 = ExampleIrregularityBasicContentView()
        basicContentView1.backdropColor = .clear
        basicContentView1.highlightBackdropColor = .clear
        let basicContentView2 = ExampleIrregularityBasicContentView()
        basicContentView2.backdropColor = .clear
        basicContentView2.highlightBackdropColor = .clear
        
        var bgColor: UIColor!
        var basicColor: UIColor!
        
        switch style {
        case .blue:
            tabBarColor = UIColor(red: 10/255.0, green: 66/255.0, blue: 91/255.0, alpha: 1.0)
            bgColor = UIColor(red: 165.0/255.0, green: 222.0/255.0, blue: 228.0/255.0, alpha: 1.0)
            basicColor = UIColor.init(red: 23/255.0, green: 149/255.0, blue: 158/255.0, alpha: 1.0)
        case .yellow:
            tabBarColor = UIColor(red: 217.0/255.0, green: 127.0/255.0, blue: 71.0/255.0, alpha: 1.0)
            bgColor = UIColor(red: 248.0/255.0, green: 223.0/255.0, blue: 152.0/255.0, alpha: 1.0)
            basicColor = UIColor(red: 246.0/255.0, green: 189.0/255.0, blue: 96.0/255.0, alpha: 1.0)
        case .pink:
            tabBarColor = UIColor(red: 243.0/255.0, green: 163.0/255.0, blue: 178.0/255.0, alpha: 1.0)
            bgColor = UIColor(red: 245.0/255.0, green: 202.0/255.0, blue: 195.0/255.0, alpha: 1.0)
            basicColor = UIColor(red: 227.0/255.0, green: 141.0/255.0, blue: 131.0/255.0, alpha: 1.0)
        }
        
        tabBar.backgroundColor = tabBarColor
        n1.navigationBar.barTintColor = tabBarColor
        n2.navigationBar.barTintColor = tabBarColor
        
        mainVC.view.backgroundColor = bgColor
        moreVC.view.backgroundColor = bgColor
        
        exampleIrregularityContentView.imageView.backgroundColor = basicColor
        basicContentView1.highlightTextColor = basicColor
        basicContentView1.highlightIconColor = basicColor
        basicContentView2.highlightTextColor = basicColor
        basicContentView2.highlightIconColor = basicColor
        
        mainVC.tabBarItem = ESTabBarItem(basicContentView1, title: "Home", image: UIImage(named: "home"), selectedImage: UIImage(named: "home"))
        addVC.tabBarItem = ESTabBarItem(exampleIrregularityContentView, title: nil, image: UIImage(named: "add"), selectedImage: UIImage(named: "add"))
        moreVC.tabBarItem = ESTabBarItem(basicContentView2, title: "更多", image: UIImage(named: "more"), selectedImage: UIImage(named: "more"))
    }
}
