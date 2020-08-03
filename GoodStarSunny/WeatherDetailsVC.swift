//
//  WeatherDetailsVC.swift
//  GoodStarSunny
//
//  Created by HellöM on 2020/7/17.
//  Copyright © 2020 HellöM. All rights reserved.
//

import UIKit
import CoreData
import Hero

class WeatherDetailsVC: UIViewController {

    var areaData: Dictionary<String, Any>!
    @IBOutlet weak var area: UILabel!
    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var temp: UILabel!
    @IBOutlet weak var highTemp: UILabel!
    @IBOutlet weak var lowTemp: UILabel!
    @IBOutlet weak var sunrise: UILabel!
    @IBOutlet weak var sunset: UILabel!
    @IBOutlet weak var feelsLike: UILabel!
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var wind: UILabel!
    @IBOutlet weak var pressure: UILabel!
    @IBOutlet weak var visibility: UILabel!
    @IBOutlet weak var uvi: UILabel!
    @IBOutlet weak var forecastHourCollectionView: UICollectionView!
    @IBOutlet weak var forecastDayTableView: UITableView!
    var forecastHourData: Array<Dictionary<String, Any>> = [] {
        didSet {
            forecastHourCollectionView.reloadData()
        }
    }
    var forecastDayData: Array<Dictionary<String, Any>> = [] {
        didSet {
            forecastDayTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(leftSwipeDismiss(_:)))
        view.addGestureRecognizer(pan)
        
        title = areaData["name"] as? String
        area.text = areaData["area"] as? String
        
        let response = areaData["response"] as! Dictionary<String, Any>
        let current = response["current"] as! Dictionary<String, Any>
        let hourly = response["hourly"] as! Array<Dictionary<String, Any>>
        let daily = response["daily"] as! Array<Dictionary<String, Any>>
        
        let weatherAry = current["weather"] as! Array<Any>
        let weather = weatherAry[0] as! Dictionary<String, Any>
        weatherDescription.text = weather["description"] as? String
        
        temp.text = "\((current["temp"] as! NSNumber).intValue)º"
        
        let currentTemp = daily[0]
        let temp = currentTemp["temp"] as! Dictionary<String, Any>
        highTemp.text = "\((temp["max"] as! NSNumber).intValue)º"
        lowTemp.text = "\((temp["min"] as! NSNumber).intValue)º"
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize(width: 80, height: 120)
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        flowLayout.minimumLineSpacing = 10
        forecastHourCollectionView.collectionViewLayout = flowLayout
        
        forecastHourData = hourly
        forecastDayData = daily
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        var sunriseTime = current["sunrise"] as! NSNumber
        var timeInterval = TimeInterval(exactly: sunriseTime)!
        var date = Date(timeIntervalSince1970: timeInterval)
        sunrise.text = "上午 \(dateFormatter.string(from: date))"
        
        sunriseTime = current["sunset"] as! NSNumber
        timeInterval = TimeInterval(exactly: sunriseTime)!
        date = Date(timeIntervalSince1970: timeInterval)
        sunset.text = "下午 \(dateFormatter.string(from: date))"
        
        let feels_like = current["feels_like"] as! NSNumber
        feelsLike.text = "\(feels_like)º"
        
        humidity.text = "\(current["humidity"] as! NSNumber)%"
        
        let wind_speed = current["wind_speed"] as! NSNumber
        let wind_deg = (current["wind_deg"] as! NSNumber).doubleValue
        var wind_degStr = ""
        
        if wind_deg >= 384.76 || wind_deg <= 11.25 {
            wind_degStr = "北"
        } else if wind_deg >= 11.26 || wind_deg <= 33.75 {
            wind_degStr = "北東北"
        } else if wind_deg >= 33.76 || wind_deg <= 56.25 {
            wind_degStr = "東北"
        } else if wind_deg >= 56.26 || wind_deg <= 78.75 {
            wind_degStr = "東東北"
        } else if wind_deg >= 78.76 || wind_deg <= 101.25 {
            wind_degStr = "東"
        } else if wind_deg >= 101.26 || wind_deg <= 123.75 {
            wind_degStr = "東東南"
        } else if wind_deg >= 123.76 || wind_deg <= 146.25 {
            wind_degStr = "東南"
        } else if wind_deg >= 146.26 || wind_deg <= 168.75 {
            wind_degStr = "南東南"
        } else if wind_deg >= 168.76 || wind_deg <= 191.25 {
            wind_degStr = "男"
        } else if wind_deg >= 191.26 || wind_deg <= 213.75 {
            wind_degStr = "南西南"
        } else if wind_deg >= 213.76 || wind_deg <= 236.25 {
            wind_degStr = "西南"
        } else if wind_deg >= 236.26 || wind_deg <= 258.75 {
            wind_degStr = "西西南"
        } else if wind_deg >= 258.76 || wind_deg <= 281.25 {
            wind_degStr = "西"
        } else if wind_deg >= 281.26 || wind_deg <= 303.75 {
            wind_degStr = "西西北"
        } else if wind_deg >= 303.76 || wind_deg <= 326.25 {
            wind_degStr = "西北"
        } else if wind_deg >= 326.26 || wind_deg <= 348.75 {
            wind_degStr = "北西北"
        } else {
            wind_degStr = ""
        }
        
        wind.text = "\(wind_degStr) \(wind_speed) 公尺/秒"
        pressure.text = "\(current["pressure"] as! NSNumber) 百帕"
        
        let v = (current["visibility"] as! NSNumber).doubleValue
        if v.truncatingRemainder(dividingBy: 10) == 0 {
            
            visibility.text = "\(Int(v)/1000) 公里"
        } else {
            
            visibility.text = "\(v/1000) 公里"
        }
        
        uvi.text = "\(current["uvi"] as! NSNumber)"
//        print("current: \(current)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        view.backgroundColor = bgColor
    }
    
    @objc func leftSwipeDismiss(_ pan:UIPanGestureRecognizer) {
        
        let translation = pan.translation(in: nil)
        let progress = translation.x / 2 / view.bounds.width
        let gestureView = pan.location(in: self.view)
        
        switch pan.state {
        case .began:
            
            if gestureView.x <= 30 {
                hero_dismissViewController()
            }

        case .changed:
            
            let translation = pan.translation(in: nil)
            let progress = translation.x / 2 / view.bounds.width
            Hero.shared.update(progress)
            
        default:
            if progress + pan.velocity(in: nil).x / view.bounds.width > 0.3 {
                Hero.shared.finish()
            } else {
                Hero.shared.cancel()
            }
        }
    }
}

extension WeatherDetailsVC: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        

        return forecastHourData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "forecastHourCell", for: indexPath) as! forecastHourCell
        
        let data = forecastHourData[indexPath.row]
        
        let dt = data["dt"] as! Int
        let timeInt = TimeInterval(dt)
        let date = Date(timeIntervalSince1970: timeInt)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH：mm"
        let dt_txt = dateFormatter.string(from: date)
        let time1 = String(dt_txt.suffix(8))
        let time2 = String(time1.prefix(2))
        if indexPath.row != 0 {
            if ((time2 as NSString).intValue - 12) < 0{
                cell.time.text = "上午\((time2 as NSString).intValue)時"
            } else {
                cell.time.text = "下午\((time2 as NSString).intValue)時"
            }
        } else {
            cell.time.text = "現在"
        }
        
        let dataAry = data["weather"]! as! NSArray
        let weatherDic = dataAry[0] as! NSDictionary
        let weatherIcon = weatherDic["icon"] as! String
        cell.weatherImageView.image = UIImage(named: weatherIcon)
        
        let temp = data["temp"] as! NSNumber
        cell.temp.text = "\(temp.intValue)º"
        
        return cell
    }
}

extension WeatherDetailsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return forecastDayData.count - 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "forecastDayCell", for: indexPath) as! ForecastDayCell
        
        let dayData = forecastDayData[indexPath.row]
        
        let timeStamp = dayData["dt"]! as! Int
        let timeInt: TimeInterval = TimeInterval(timeStamp)
        let date = Date(timeIntervalSince1970: timeInt)
        let dateComponents = Calendar.current.dateComponents(in: TimeZone.current, from: date)
        let weekday = dateComponents.weekday!
        
        switch weekday {
        case 1:
            cell.week.text = "星期日"
        case 2:
            cell.week.text = "星期一"
        case 3:
            cell.week.text = "星期二"
        case 4:
            cell.week.text = "星期三"
        case 5:
            cell.week.text = "星期四"
        case 6:
            cell.week.text = "星期五"
        case 7:
            cell.week.text = "星期六"
        default:
            cell.week.text = ""
        }
        
        let dataAry = dayData["weather"]! as! NSArray
        let weatherDic = dataAry[0] as! NSDictionary
        let weatherIcon = weatherDic["icon"] as! String
        cell.weatherImageView.image = UIImage(named: weatherIcon)
        
        let temp = dayData["temp"] as! Dictionary<String, Any>
        let max = temp["max"] as! NSNumber
        let min = temp["min"] as! NSNumber
        cell.highTemp.text = "\(max.intValue)º"
        cell.lowTemp.text = "\(min.intValue)º"
        
        return cell
    } 
}
