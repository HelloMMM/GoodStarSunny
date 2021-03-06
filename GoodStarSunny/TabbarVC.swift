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
import GoogleMobileAds

var tabbarVC: ESTabBarController!

class TabbarVC: ESTabBarController, MoreVCDelegate {

    var interstitial: GADInterstitial!
    var bannerView: GADBannerView!
    var mainVC: MainVC!
    var addVC: UIViewController!
    var moreVC: MoreVC!
    var n1: UINavigationController!
    var n2: UINavigationController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        interstitial = createAndLoadInterstitial()
        if !isRemoveAD {
            addBannerViewToView()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(removeAD), name: NSNotification.Name("RemoveAD") , object: nil)
        
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
            
            self?.addClick()
        }
        
        tabbarVC = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if UserDefaults.standard.object(forKey: "firstOpen") == nil {
            
            let testVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TestVC") as! TestVC
            testVC.testVCDelegate = self
            present(testVC, animated: true, completion: nil)
        }
    }
    
    @objc func removeAD(notification: NSNotification) {
            
        isRemoveAD = true
        
        if bannerView != nil {
            bannerView.removeFromSuperview()
        }
    }
    
    func createAndLoadInterstitial() -> GADInterstitial {
        
        #if DEBUG
            interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        #else
            interstitial = GADInterstitial(adUnitID: "ca-app-pub-1223027370530841/3525494731")
        #endif
        interstitial.delegate = self
        interstitial.load(GADRequest())
        
        return interstitial
    }
    
    func addBannerViewToView() {
        
        bannerView = GADBannerView(adSize: kGADAdSizeFullBanner)
        
        #if DEBUG
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        #else
        bannerView.adUnitID = "ca-app-pub-1223027370530841/4118227965"
        #endif

        bannerView.delegate = self
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(bannerView)
        bannerView.bottomAnchor.constraint(equalTo: tabBar.topAnchor, constant: 0).isActive = true
        bannerView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        bannerView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        
        view.bringSubviewToFront(tabBar)
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
        
        var tabBarColor: UIColor!
        
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
    
    func addClick() {
        
        let addVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddVC") as! AddVC
        addVC.delegate = self
        present(addVC, animated: true, completion: nil)
    }
}

extension TabbarVC: TestVCDelegate {
    
    func enterMain() {
        
        addClick()
    }
}

extension TabbarVC: AddVCDelegate {
    
    func addRegion(_ addressDic: Dictionary<String, Any>) {
    
        CoreDataConnect.shared.insert(attributeInfo: addressDic)
        if CoreDataConnect.shared.retrieve(predicate: nil, sort: nil, limit: nil) != nil {
            
            areaData = CoreDataConnect.shared.retrieve(predicate: nil, sort: [["id": true]], limit: nil)!
        }
        mainVC.collectionView.reloadData()
        
        selectedViewController = viewControllers![0]
//        selectedIndex = 0
    }
}

extension TabbarVC: GADBannerViewDelegate, GADInterstitialDelegate {
    
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        
        if UserDefaults.standard.object(forKey: "firstOpen") != nil {
            
            if !isRemoveAD {
                interstitial.present(fromRootViewController: self)
            }
        } else {
            UserDefaults.standard.set(true, forKey: "firstOpen")
        }
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {

//        interstitial = createAndLoadInterstitial()
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
      print("adViewDidReceiveAd")
    }

    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView,
        didFailToReceiveAdWithError error: GADRequestError) {
      print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }

    /// Tells the delegate that a full-screen view will be presented in response
    /// to the user clicking on an ad.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
      print("adViewWillPresentScreen")
    }

    /// Tells the delegate that the full-screen view will be dismissed.
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
      print("adViewWillDismissScreen")
    }

    /// Tells the delegate that the full-screen view has been dismissed.
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
      print("adViewDidDismissScreen")
    }

    /// Tells the delegate that a user click will open another app (such as
    /// the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
      print("adViewWillLeaveApplication")
    }
}
