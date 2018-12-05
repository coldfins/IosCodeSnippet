//
//  CollectionViewCell.swift
//  PinterestLayout
//
//  Created by Shrikar Archak on 12/21/14.
//  Copyright (c) 2014 Shrikar Archak. All rights reserved.
//

import UIKit

class ProjectCell: UICollectionViewCell {
    
    @IBOutlet weak var lblProjectName: UILabel!
    @IBOutlet weak var lblCountry: UILabel!
    @IBOutlet weak var lblPhoneNumber: UILabel!
    @IBOutlet weak var imgProperty: UIImageView!
    @IBOutlet weak var lblRs: UILabel!
    @IBOutlet weak var viewBottom: UIView!
    @IBOutlet weak var lblPropertytype: UILabel!
    
    @IBOutlet weak var lblSqFt: UILabel!
    @IBOutlet weak var lblOwnerName: UILabel!
    @IBOutlet weak var lblUserType: UILabel!
    @IBOutlet weak var btnFavourite: UIButton!
    @IBOutlet weak var btnMessage: UIButton!
    @IBOutlet weak var btnCall: UIButton!
    @IBOutlet weak var scrollview: UIScrollView!
    
       
    var radius: CGFloat = 2
    
    override func layoutSubviews() {
        
        layer.cornerRadius = 4
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: radius)
        
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 4);
        layer.shadowOpacity = 0.4
        layer.shadowPath = shadowPath.cgPath
    }
    
        
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    

}
