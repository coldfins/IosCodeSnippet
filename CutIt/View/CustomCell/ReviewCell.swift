//
//  CollectionViewCell.swift
//  PinterestLayout
//
//  Created by Shrikar Archak on 12/21/14.
//  Copyright (c) 2014 Shrikar Archak. All rights reserved.
//

import UIKit

class ReviewCell: UICollectionViewCell {
    
    @IBOutlet weak var lblReviewUserName: UILabel!
    @IBOutlet weak var lblReviewDesc: UILabel!
    @IBOutlet weak var lblReviewDate: UILabel!
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var viewBottom: UIView!
    @IBOutlet var floatRatingView: FloatRatingView!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
}
