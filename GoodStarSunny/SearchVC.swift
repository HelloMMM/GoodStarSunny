//
//  SearchVC.swift
//  GoodStarSunny
//
//  Created by HellöM on 2020/7/15.
//  Copyright © 2020 HellöM. All rights reserved.
//

import UIKit

class SearchVC: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.becomeFirstResponder()
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        
        searchBar.resignFirstResponder()
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension SearchVC: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
    }
}
