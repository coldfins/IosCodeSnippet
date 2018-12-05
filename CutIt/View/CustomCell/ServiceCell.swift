//
//  CollectionViewCell.swift
//  PinterestLayout
//
//  Created by Shrikar Archak on 12/21/14.
//  Copyright (c) 2014 Shrikar Archak. All rights reserved.
//

import UIKit

class ServiceCell: UICollectionViewCell {
    
    //Service
    @IBOutlet weak var lblServiceName: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var btnBookNow: UIButton!
    
    //Availability
    @IBOutlet weak var lblDayName: UILabel!
    @IBOutlet weak var btnFrom: UIButton!
    @IBOutlet weak var btnTo: UIButton!
    @IBOutlet weak var btnCheck: UIButton!
    @IBOutlet weak var viewDay: UIView!
    
    //TimeZone
    @IBOutlet weak var lblTimezone: UILabel!
    @IBOutlet weak var lblTimeZoneTime: UILabel!
        
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    

}
