//
//  NVLoadingView.swift
//  JPWApp
//
//  Created by HellöM on 2020/2/26.
//  Copyright © 2020 HellöM. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class NVLoadingView: UIView {

    class func startBlockLoadingView() {
        
        let activityData = ActivityData(size: nil, message: nil, messageFont: nil, messageSpacing: nil, type: .ballPulseSync, color: nil, padding: nil, displayTimeThreshold: nil, minimumDisplayTime: nil, backgroundColor: nil, textColor: nil)

        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
    }
    
    class func stopBlockLoadingView() {
        
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
    }
}

//extension NVLoadingView: NVActivityIndicatorViewable {
//
//
//}
