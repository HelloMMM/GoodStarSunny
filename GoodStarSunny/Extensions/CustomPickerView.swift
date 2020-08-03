//
//  CustomPickerView.swift
//  JPWApp
//
//  Created by HellöM on 2020/2/11.
//  Copyright © 2020 HellöM. All rights reserved.
//

import UIKit

let fullScreenSize = UIScreen.main.bounds.size

open class CustomPickerView: UIView {

    var baseView: UIView!
    var pickView: UIPickerView!
    var currentSelect = ""
    var lastSelect: Int = 0 {
        didSet {
            currentSelect = pickData[lastSelect]
            pickView.selectRow(lastSelect, inComponent: 0, animated: false)
            selectNumber = lastSelect
        }
    }
    
    var selectNumber = 0
    var pickData: [String]!
    var successSelect: ((Int) -> Void)!
    
    public init(_ pickData: [String], successSelect: @escaping (Int) -> Void) {
        super.init(frame: CGRect(x: 0, y: 0, width: fullScreenSize.width, height: fullScreenSize.height))
        
        self.successSelect = successSelect
        self.pickData = pickData
        
        alpha = 0
        currentSelect = pickData[0]
        
        initUI()
    }
    
    func initUI() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap(tap:)))
        addGestureRecognizer(tapGesture)
        
        backgroundColor = UIColor(white: 0, alpha: 0.4)
        baseView = UIView(frame: CGRect(x: 10, y: fullScreenSize.height, width: fullScreenSize.width-20, height: fullScreenSize.height/3.5))
        baseView.backgroundColor = .white
        baseView.layer.cornerRadius = 10
        addSubview(baseView)
        
        pickView = UIPickerView(frame: CGRect(x: 0, y: 50, width: baseView.frame.width, height: baseView.frame.height-50))
        pickView.backgroundColor = .clear
        pickView.delegate = self
        pickView.dataSource = self
        baseView.addSubview(pickView)
        
        let confirm = UIButton(frame: CGRect(x: baseView.frame.width-55, y: 10, width: 45, height: 36))
        confirm.setTitle("確定", for: .normal)
        confirm.setTitleColor(UIColor(red: 20/255, green: 117/255, blue: 1, alpha: 1), for: .normal)
        confirm.addTarget(self, action: #selector(confirmClick(_:)), for: .touchUpInside)
        baseView.addSubview(confirm)
        
        let cancel = UIButton(frame: CGRect(x: 10, y: 10, width: 45, height: 36))
        cancel.setTitle("取消", for: .normal)
        cancel.setTitleColor(UIColor(red: 20/255, green: 117/255, blue: 1, alpha: 1), for: .normal)
        cancel.addTarget(self, action: #selector(cancelClick(_:)), for: .touchUpInside)
        baseView.addSubview(cancel)
        
        UIApplication.shared.keyWindow?.addSubview(self)
        
        showPicker()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    func tap(tap: UITapGestureRecognizer) {
        hidePicker()
    }
    
    func showPicker() {
        
        UIView.animate(withDuration: 0.3) {
            self.baseView.frame = CGRect(x: 10, y: fullScreenSize.height-self.baseView.frame.height-10, width: self.frame.width-20, height: self.baseView.frame.height)
            self.alpha = 1
        }
    }
    
    func hidePicker() {
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.baseView.frame = CGRect(x: 10, y: fullScreenSize.height, width: self.frame.width-20, height: self.baseView.frame.height)
            self.alpha = 0
        }) { (Bool) in
            
            self.removeFromSuperview()
        }
    }
    
    @objc
    func confirmClick(_ sender: UIButton) {
        
        successSelect(selectNumber)
        hidePicker()
    }
    
    @objc
    func cancelClick(_ sender: UIButton) {
        
        hidePicker()
    }
}

extension CustomPickerView: UIPickerViewDelegate, UIPickerViewDataSource {
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickData.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return pickData[row]
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        selectNumber = row
        currentSelect = pickData[row]
    }
    
    public func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let attributedString = NSAttributedString(string: pickData[row], attributes: [NSAttributedString.Key.foregroundColor : UIColor.black])
        
        return attributedString
    }
}
