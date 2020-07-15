//
//  MoreVC.swift
//  GoodStarSunny
//
//  Created by HellöM on 2020/7/14.
//  Copyright © 2020 HellöM. All rights reserved.
//

import UIKit

protocol MoreVCDelegate {
    
    func changeStyle(_ style: AppStyle)
}

class MoreVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let titleAry = ["去除廣告", "恢復購買", "樣式", "當前版本", "客服與意見回饋"]
    let styleNames = ["天空☁️", "布丁🍮", "櫻花🌸"]
    var lastSelect = 0
    var delegate: MoreVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lastSelect = appStyle
        tableView.tableFooterView = UIView()
    }
}

extension MoreVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleAry.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MoreCell", for: indexPath) as! MoreCell
        
        if indexPath.row == 2 {
            cell.rightText.text = styleNames[appStyle]
        } else if indexPath.row == 3 {
            cell.rightText.text = "v1.0.0"
        } else {
            cell.rightText.text = ""
        }
        
        cell.myTitle.text = titleAry[indexPath.row]
        cell.myImageView.image = UIImage(named: "MoreCell_\(indexPath.row)")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            let _ = IAPManager.shared.startPurchase()
        case 1:
            let _ = IAPManager.shared.restorePurchase()
        case 2:
            changeStyle()
        case 4:
            showAppStore()
        default:
            break
        }
    }
    
    func changeStyle() {
        
        let customPickerView = CustomPickerView(styleNames) { (selectNumber) in
            
            self.lastSelect = selectNumber
            appStyle = selectNumber
            UserDefaults.standard.set(appStyle, forKey: "appStyle")
            self.delegate?.changeStyle(AppStyle(rawValue: selectNumber)!)
            self.tableView.reloadData()
        }
        
        customPickerView.lastSelect = lastSelect
    }
    
    func showAppStore() {
        
        let urlString =  "itms-apps:itunes.apple.com/us/app/apple-store/id1520163103?mt=8&action=write-review"
        let url = URL(string: urlString)!
        UIApplication.shared.open(url, completionHandler: nil)
    }
}
