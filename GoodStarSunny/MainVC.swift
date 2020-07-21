//
//  MainVC.swift
//  GoodStarSunny
//
//  Created by HellöM on 2020/7/14.
//  Copyright © 2020 HellöM. All rights reserved.
//

import UIKit
import CoreData
import AudioToolbox

enum LYFTableViewType {
    case top
    case bottom
}

class MainVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var toDayAreaData: Dictionary<String, Any> = [:]
    var isEdit = false
    var longPressGesture: UILongPressGestureRecognizer!
    var currentCell: MainCell? = nil
    var longLocation: CGPoint!
    var newestIndexPath: IndexPath!
    var oldIndexPath: IndexPath!
    var snapshotView: UIView!
    var scrollType: LYFTableViewType!
    var scrollTimer: CADisplayLink!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 66, right: 0)
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width-30, height: 104)
        layout.scrollDirection = .vertical
        
        collectionView.collectionViewLayout = layout
        
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongGesture(_:)))
        longPressGesture.minimumPressDuration = 0.2
    }
    
    @IBAction func editClick(_ sender: UIBarButtonItem) {
        
        if isEdit {
            sender.image = UIImage(named: "edit")
            collectionView.removeGestureRecognizer(longPressGesture)
        } else {
            sender.image = UIImage(named: "完成")
            collectionView.addGestureRecognizer(longPressGesture)
        }
        isEdit = !isEdit
        collectionView.reloadData()
    }
    
    @objc func handleLongGesture(_ longPress: UILongPressGestureRecognizer) {
        
        longLocation = longPress.location(in: collectionView)
        newestIndexPath = collectionView.indexPathForItem(at: longLocation)
        
        switch longPress.state {
        case .began:
            AudioServicesPlaySystemSound(1520)
            
            oldIndexPath = collectionView.indexPathForItem(at: longLocation)
            
            if oldIndexPath != nil {
                
                snapshotCellAtIndexPath(oldIndexPath)
            }
        case .changed:
            var center = snapshotView.center
            center.y = longLocation.y
            
            self.snapshotView.center = center
            
            if checkIfSnapshotMeetsEdge() {
                
                startAutoScrollTimer()
            } else {
                
                stopAutoScrollTimer()
            }
            
            newestIndexPath = collectionView.indexPathForItem(at: longLocation)
            
            if self.newestIndexPath != nil && self.newestIndexPath != oldIndexPath {
                cellRelocatedToNewIndexPath(newestIndexPath)
            }
        default:
            AudioServicesPlaySystemSound(1519)
            stopAutoScrollTimer()
            didEndDraging()
        }
    }
    
    func didEndDraging() {
        
        let cell = collectionView.cellForItem(at: oldIndexPath)!
        cell.isHidden = false
        cell.alpha = 0
        
        UIView.animate(withDuration: 0.2, animations: {
            
            self.snapshotView.center = cell.center
            self.snapshotView.alpha = 0
            self.snapshotView.transform = CGAffineTransform.identity
            cell.alpha = 1
        }) { (finished) in
            
            cell.isHidden = false
            self.snapshotView.removeFromSuperview()
            self.snapshotView = nil
            self.oldIndexPath = nil
            self.newestIndexPath = nil
            
            self.collectionView.reloadData()
        }
    }
    
    func checkIfSnapshotMeetsEdge() -> Bool {
        
        let minY = snapshotView.frame.minY
        let maxY = snapshotView.frame.maxY
        
        if minY < collectionView.contentOffset.y {
            
            scrollType = .top;
            return true
        }
        if maxY > (collectionView.bounds.size.height + collectionView.contentOffset.y) {
            scrollType = .bottom;
            return true
        }
        
        return false
    }
    
    func cellRelocatedToNewIndexPath(_ indexPath: IndexPath) {
        
        let id1 = areaData[oldIndexPath.row].value(forKey: "id") as! Int
        let id2 = areaData[indexPath.row].value(forKey: "id") as! Int
        
        CoreDataConnect.shared.change(predicate: "id", id1: id1, id2: id2)
        
        let objc1 = areaData[oldIndexPath.row]
        areaData[oldIndexPath.row] = areaData[indexPath.row]
        areaData[indexPath.row] = objc1

        collectionView.moveItem(at: oldIndexPath, to: indexPath)
        oldIndexPath = indexPath
    }
    
    func startAutoScrollTimer() {
        
        if scrollTimer == nil {
            
            scrollTimer = CADisplayLink(target: self, selector: #selector(startAutoScroll))
            scrollTimer.add(to: RunLoop.main, forMode: RunLoop.Mode.common)
        }
    }
    
    @objc func startAutoScroll() {
        
        let pixelSpeed = 4
        
        if scrollType == .top {
            
            if collectionView.contentOffset.y > 0 {
                
                collectionView.setContentOffset(CGPoint(x: 0, y: collectionView.contentOffset.y-CGFloat(pixelSpeed)), animated: false)
                snapshotView.center = CGPoint(x: snapshotView.center.x, y: snapshotView.center.y - CGFloat(pixelSpeed))
            }
        } else {
            
            if collectionView.contentOffset.y + collectionView.bounds.size.height < collectionView.contentSize.height {
                collectionView.setContentOffset(CGPoint(x: 0, y: collectionView.contentOffset.y+CGFloat(pixelSpeed)), animated: false)
                snapshotView.center = CGPoint(x: snapshotView.center.x, y: snapshotView.center.y + CGFloat(pixelSpeed))
            }
        }
        
        newestIndexPath = collectionView.indexPathForItem(at: snapshotView.center)
        if newestIndexPath != nil && newestIndexPath != oldIndexPath {
            cellRelocatedToNewIndexPath(newestIndexPath)
        }
    }
    
    func stopAutoScrollTimer() {
        
        if scrollTimer != nil {
            scrollTimer.invalidate()
            scrollTimer = nil;
        }
    }
    
    func snapshotCellAtIndexPath(_ indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath)!
        let snapshot = snapshotView(cell)
        
        collectionView.addSubview(snapshot)
        snapshotView = snapshot
        
        cell.isHidden = true
        
        var center = snapshotView.center
        center.y = longLocation.y
        
        UIView.animate(withDuration: 0.2) {
            self.snapshotView.transform = CGAffineTransform(scaleX: 1.03, y: 1.03)
            self.snapshotView.alpha = 0.9
            self.snapshotView.center = center
        }
    }
    
    func snapshotView(_ inputView: UIView) -> UIView {
        
        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0)
        inputView.layer.render(in: UIGraphicsGetCurrentContext()!)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let snapshot = UIImageView(image: image)
        snapshot.center = inputView.center
        snapshot.layer.masksToBounds = false
        snapshot.layer.cornerRadius = 0.0
        snapshot.layer.shadowOffset = CGSize(width: -5.0, height: 0.0)
        snapshot.layer.shadowRadius = 5.0
        snapshot.layer.shadowOpacity = 0.4
        
        return snapshot
    }
}

extension MainVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return areaData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var dic: Dictionary<String, Any> = [:]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCell", for: indexPath) as! MainCell
        
        cell.isEdit = isEdit
        cell.name.text = areaData[indexPath.row].value(forKey: "name") as? String
        cell.area.text = areaData[indexPath.row].value(forKey: "area") as? String
        dic["name"] = areaData[indexPath.row].value(forKey: "name") as? String
        dic["area"] = areaData[indexPath.row].value(forKey: "area") as? String
        
        let lat = areaData[indexPath.row].value(forKey: "lat") as! String
        let lon = areaData[indexPath.row].value(forKey: "lon") as! String
        let url = "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(lon)&apikey=5777a715d3b69dba2f196271765e6404&units=metric&lang=zh_tw"
        
        AlamofireManager.shared.requestAPI(url: url, onSuccess: { (response) in
            
            dic["response"] = response
            self.toDayAreaData["\(indexPath.row)"] = dic
            
            let current = response["current"] as! Dictionary<String, Any>
            let weatherAry = current["weather"] as! Array<Any>
            let weather = weatherAry[0] as! Dictionary<String, Any>
            cell.weather.text = weather["description"] as? String
            
            let icon = weather["icon"] as! String
            cell.weatherImageView.image = UIImage(named: icon)
            
            let timezone = response["timezone"] as! String
            let timeZone = TimeZone(identifier: timezone)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH：mm"
            dateFormatter.timeZone = timeZone
            cell.time.text = dateFormatter.string(from: Date())
            
            let temp = (current["temp"] as! NSNumber).intValue
            cell.temp.text = "\(temp)º"
            
        }) { (error) in
            
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if isEdit {
            return
        }
        
        let weatherDetailsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WeatherDetailsVC") as! WeatherDetailsVC
        
        if let areaData = toDayAreaData["\(indexPath.row)"] as? Dictionary<String, Any> {
            weatherDetailsVC.areaData = areaData
        } else {
            return
        }
        
        navigationController?.pushViewController(weatherDetailsVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
        
        let name = "name = '\(areaData[indexPath.row].value(forKey: "name")!)'"
        CoreDataConnect.shared.delete(predicate: name)
        
        areaData.remove(at: indexPath.row)
        collectionView.deleteItems(at: [indexPath])
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        var item1 = sourceIndexPath.item
        var item2 = destinationIndexPath.item
        let item3 = item1
        item1 = item2
        item2 = item3
    }
}
