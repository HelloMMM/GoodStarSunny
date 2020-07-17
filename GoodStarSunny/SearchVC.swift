//
//  SearchVC.swift
//  GoodStarSunny
//
//  Created by HellöM on 2020/7/15.
//  Copyright © 2020 HellöM. All rights reserved.
//

import UIKit
import MapKit

protocol SearchVCDelegate {
    func chooseRegion(_ addressDic: Dictionary<String, Any>)
}

class SearchVC: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var address: Array<Dictionary<String, Any>> = []
    @IBOutlet weak var notFoundView: UIView!
    var delegate: SearchVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.becomeFirstResponder()
        tableView.tableFooterView = UIView()
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        
        searchBar.resignFirstResponder()
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension SearchVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return address.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as! SearchCell
        
        let addressName = address[indexPath.row]["addressName"] as! String
        cell.addressName.text = addressName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        view.endEditing(true)
        
        
        
        dismiss(animated: true) {
            
            self.delegate?.chooseRegion(self.address[indexPath.row])
        }
    }
}

extension SearchVC: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(searchBar.text ?? "", completionHandler: {
            (placemarks:[CLPlacemark]?, error:Error?) -> Void in

            if error != nil {
                self.showNotFoundView()
                return
            }
            if let placemark = placemarks?[0]{
                
                let lat = placemark.location!.coordinate.latitude
                let lon = placemark.location!.coordinate.longitude
                let currentLocation = CLLocation(latitude: lat, longitude: lon)
                
                geocoder.reverseGeocodeLocation(currentLocation, completionHandler: {
                (placemarks:[CLPlacemark]?, error:Error?) in
                    
                    if error != nil {
                        
                        self.showNotFoundView()
                        return
                    }
                     
                    if let placemark = placemarks?[0]{

                        var add = ""

                        add.append(placemark.country ?? "")
                        add.append(placemark.administrativeArea ?? "")
                        add.append(placemark.subAdministrativeArea ?? "")
                        add.append(placemark.locality ?? "")
                        
                        
                        
                        let dic: Dictionary<String, Any> = ["addressName": add,
                                                            "lon": "\(lon)",
                                                            "lat": "\(lat)",
                                                            "area": placemark.locality ?? placemark.subAdministrativeArea ?? ""]
                        
                        self.address.removeAll()
                        self.address.append(dic)
                        self.tableView.reloadData()
                        self.notFoundView.alpha = 0
                    } else {
                        self.showNotFoundView()
                    }
                })
            } else {
                self.showNotFoundView()
            }
        })
    }
    
    func showNotFoundView() {
        
        self.address.removeAll()
        self.tableView.reloadData()
        notFoundView.alpha = 1
    }
}

extension SearchVC: CLLocationManagerDelegate {
    
}
