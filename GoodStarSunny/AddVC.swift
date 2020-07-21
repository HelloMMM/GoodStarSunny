//
//  AddVC.swift
//  GoodStarSunny
//
//  Created by HellöM on 2020/7/15.
//  Copyright © 2020 HellöM. All rights reserved.
//

import UIKit

protocol AddVCDelegate {
    func addRegion(_ addressDic: Dictionary<String, Any>)
}

class AddVC: UIViewController {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var areaTextField: UITextField!
    var addressDic: Dictionary<String, Any> = [:]
    var delegate: AddVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        topView.backgroundColor = basicColor
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func areaClick(_ sender: UIButton) {
        
        presentSearchVC()
    }
    
    @IBAction func addClick(_ sender: UIButton) {
        
        view.endEditing(true)
        
        if nameTextField.text == "" {
            nameTextField.shake()
            showToast("請輸入姓名")
            return
        }
        
        if areaTextField.text == "" {
            areaTextField.shake()
            showToast("請選擇地區")
            return
        }
        
        addressDic["name"] = nameTextField.text!
        delegate?.addRegion(addressDic)
        
        dismiss(animated: true, completion: nil)
    }
    
    func presentSearchVC() {
        
        let searchVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
        searchVC.delegate = self
        present(searchVC, animated: true, completion: nil)
    }
}

extension AddVC: SearchVCDelegate {
    
    func chooseRegion(_ addressDic: Dictionary<String, Any>) {
        
        self.addressDic = addressDic
        
        let area = addressDic["area"] as! String
        areaTextField.text = area
    }
}
 
extension AddVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        let numberOfChars = newText.count
        
        if textField == nameTextField {
            if numberOfChars > 5 {
                showToast("最多5個字")
                textField.shake()
            }
            return numberOfChars <= 5
        } else {
            return true
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == areaTextField {
            
            textField.resignFirstResponder()
            
            presentSearchVC()
        }
    }
}
