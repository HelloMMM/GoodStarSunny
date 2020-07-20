//
//  WeatherDetailsVC.swift
//  GoodStarSunny
//
//  Created by HellöM on 2020/7/17.
//  Copyright © 2020 HellöM. All rights reserved.
//

import UIKit
import CoreData

class WeatherDetailsVC: UIViewController {

    var areaData: Dictionary<String, Any>!
    @IBOutlet weak var area: UILabel!
    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var temp: UILabel!
    @IBOutlet weak var highTemp: UILabel!
    @IBOutlet weak var lowTemp: UILabel!
    @IBOutlet weak var forecastHourCollectionView: UICollectionView!
    var forecastHourData: Array<Dictionary<String, Any>> = [] {
        didSet {
            forecastHourCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = bgColor
        
        let response = areaData["response"] as! Dictionary<String, Any>
        
        title = areaData["name"] as? String
        area.text = areaData["area"] as? String
        
        let weatherAry = response["weather"] as! Array<Any>
        let weather = weatherAry[0] as! Dictionary<String, Any>
        weatherDescription.text = weather["description"] as? String
        
        let main = response["main"] as! Dictionary<String, Any>
        temp.text = "\(main["temp"] as! Double)º"
        highTemp.text = "\(main["temp_max"] as! Double)º"
        lowTemp.text = "\(main["temp_min"] as! Double)º"
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize(width: 80, height: 120)
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        flowLayout.minimumLineSpacing = 5
        forecastHourCollectionView.collectionViewLayout = flowLayout
        postForecastHourAPI()
        postForecastDatAPI()
//        print(response)
    }
    
    func postForecastHourAPI() {
        
        let lat = areaData["lat"] as! String
        let lon = areaData["lon"] as! String
        let url = "https://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(lon)&apikey=5777a715d3b69dba2f196271765e6404&units=metric&lang=zh_tw"
        
        AlamofireManager.shared.requestAPI(url: url, onSuccess: { (response) in

            let list = response["list"] as! Array<Dictionary<String, Any>>
            self.forecastHourData = list
        }) { (error) in

        }
    }
    
    func postForecastDatAPI() {
        let lat = areaData["lat"] as! String
        let lon = areaData["lon"] as! String
        let url = "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(lon)&apikey=5777a715d3b69dba2f196271765e6404&units=metric&lang=zh_tw"
        
    }
}

extension WeatherDetailsVC: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        

        return forecastHourData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "forecastHourCell", for: indexPath) as! forecastHourCell
        
        let data = forecastHourData[indexPath.row]
        
        let dt_txt = data["dt_txt"]! as! String
        let time1 = String(dt_txt.suffix(8))
        let time2 = String(time1.prefix(2))
        if ((time2 as NSString).intValue - 12) < 0{
            cell.time.text = "上午\((time2 as NSString).intValue)時"
        } else {
            cell.time.text = "下午\((time2 as NSString).intValue)時"
        }
        
        let dataAry = data["weather"]! as! NSArray
        let weatherDic = dataAry[0] as! NSDictionary
        let weatherIcon = weatherDic["icon"] as! String
        cell.weatherImageView.image = UIImage(named: weatherIcon)
        
        let main = data["main"] as! Dictionary<String, Any>
        let temp = main["temp"] as! Double
        cell.temp.text = "\(temp)º"
        
        return cell
    }
}
