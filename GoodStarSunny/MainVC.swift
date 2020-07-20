//
//  MainVC.swift
//  GoodStarSunny
//
//  Created by HellöM on 2020/7/14.
//  Copyright © 2020 HellöM. All rights reserved.
//

import UIKit
import CoreData

class MainVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var toDayAreaData: Dictionary<String, Any> = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 66, right: 0)
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width-30, height: 104)
        layout.scrollDirection = .vertical
        
        collectionView.collectionViewLayout = layout
    }
}

extension MainVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return areaData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var dic: Dictionary<String, Any> = [:]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCell", for: indexPath) as! MainCell
        
        cell.name.text = areaData[indexPath.row].value(forKey: "name") as? String
        cell.area.text = areaData[indexPath.row].value(forKey: "area") as? String
        dic["name"] = areaData[indexPath.row].value(forKey: "name") as? String
        dic["area"] = areaData[indexPath.row].value(forKey: "area") as? String
        
        let lat = areaData[indexPath.row].value(forKey: "lat") as! String
        let lon = areaData[indexPath.row].value(forKey: "lon") as! String
        dic["lat"] = areaData[indexPath.row].value(forKey: "lat") as? String
        dic["lon"] = areaData[indexPath.row].value(forKey: "lon") as? String
        let url = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&apikey=5777a715d3b69dba2f196271765e6404&units=metric&lang=zh_tw"
        
        AlamofireManager.shared.requestAPI(url: url, onSuccess: { (response) in

            dic["response"] = response
            
            let weatherAry = response["weather"] as! Array<Any>
            let weather = weatherAry[0] as! Dictionary<String, Any>
            cell.weather.text = weather["description"] as? String
            
            let icon = weather["icon"] as! String
            cell.weatherImageView.image = UIImage(named: icon)
            
            let timezone = response["timezone"] as! Int
            let timeZone = TimeZone(secondsFromGMT: timezone)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH：mm"
            dateFormatter.timeZone = timeZone
            cell.time.text = dateFormatter.string(from: Date())
            
            let main = response["main"] as! Dictionary<String, Any>
            let temp = main["temp"] as! Double
            cell.temp.text = "\(temp)º"
            
            self.toDayAreaData["\(indexPath.row)"] = dic
        }) { (error) in

        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let weatherDetailsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WeatherDetailsVC") as! WeatherDetailsVC
        
        weatherDetailsVC.areaData = toDayAreaData["\(indexPath.row)"] as? Dictionary<String, Any>
        
        navigationController?.pushViewController(weatherDetailsVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
        
        let name = "name = '\(areaData[indexPath.row].value(forKey: "name")!)'"
        CoreDataConnect.shared.delete(predicate: name)
        
        areaData.remove(at: indexPath.row)
        collectionView.deleteItems(at: [indexPath])
    }
}
