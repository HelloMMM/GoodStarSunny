//
//  AddVC.swift
//  GoodStarSunny
//
//  Created by HellöM on 2020/7/15.
//  Copyright © 2020 HellöM. All rights reserved.
//

import UIKit

class AddVC: UIViewController {

    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var areaTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameTextField.addTarget(self, action: #selector(textFieldChange(_:)), for: .editingChanged)
    }
    
    @objc func textFieldChange(_ textField: UITextField) {
        
        var newText = textField.text!

        if newText.count > 5 {
            newText.removeLast()
            textField.shake()
            showToast("最多五位數")
        }
        
        textField.text = newText
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func areaClick(_ sender: UIButton) {
        
        let searchVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
        
        DispatchQueue.main.async {
            self.present(searchVC, animated: true, completion: nil)
        }
        
    }
    
}

extension AddVC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == areaTextField {
            
            textField.resignFirstResponder()
            
            let searchVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
            
            present(searchVC, animated: true, completion: nil)
        }
    }
}
