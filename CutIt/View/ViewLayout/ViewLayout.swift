//
//  ViewLayout.swift
//  HairEctApp
//
//  Created by Coldfin lab

//  Copyright © 2017 Coldfin lab. All rights reserved.

import UIKit

class ViewLayout: UIView {
    
    //Search View
     @IBOutlet weak var btnNearestBarber: UIButton!
     @IBOutlet weak var btnNewestBarber: UIButton!
     @IBOutlet weak var btnHashtag: UIButton!
     @IBOutlet weak var lblHashtag: UILabel!
     @IBOutlet weak var btnApply: UIButton!
     @IBOutlet weak var viewMain: UIView!
     @IBOutlet weak var viewBlurr: UIView!
    
     //Map View
     @IBOutlet weak var viewMap: UIView!
     @IBOutlet weak var imgShop: UIImageView!
     @IBOutlet weak var lblShopName: UILabel!
     @IBOutlet weak var lblShopAddress: UILabel!
}

