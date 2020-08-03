//
//  AppModel.swift
//  GoodStarSunny
//
//  Created by HellöM on 2020/7/14.
//  Copyright © 2020 HellöM. All rights reserved.
//

import Foundation
import UIKit
import CoreData

enum AppStyle: Int {
    case blue
    case yellow
    case pink
}

var appStyle = 0
var areaData: Array<NSManagedObject> = []
var isRemoveAD = false
var bgColor: UIColor!
var basicColor: UIColor!
