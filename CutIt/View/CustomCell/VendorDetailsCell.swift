//
//  CollectionViewCell.swift
//  PinterestLayout
//
//  Created by Shrikar Archak on 12/21/14.
//  Copyright (c) 2014 Shrikar Archak. All rights reserved.
//

import UIKit

class VendorDetailsCell: UICollectionViewCell {
    
    //Vendor Detail Cell
    @IBOutlet weak var lblVendorName: UILabel!
    @IBOutlet weak var lblShopName: UILabel!
    @IBOutlet weak var viewRating: UIView!
    @IBOutlet weak var lblReviewCount: UILabel!
    @IBOutlet weak var lblPhotoCount: UILabel!
    @IBOutlet weak var imgShop: UIImageView!
    @IBOutlet weak var imgRating: UIImageView!
    
    //Word Library Cell
     @IBOutlet weak var btnHashTag: UIButton!
     @IBOutlet weak var lblHashTag: UILabel!
    @IBOutlet weak var viewHashtag: UIView!
    
     //Pick Date & Time Cell
     @IBOutlet weak var lblTime: UILabel!
     @IBOutlet weak var viewMain: UIView!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
}
