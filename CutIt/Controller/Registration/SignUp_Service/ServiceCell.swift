//
//  CollectionViewCell.swift
//  PinterestLayout
//
//  Created by Shrikar Archak on 12/21/14.
//  Copyright (c) 2014 Shrikar Archak. All rights reserved.
//

import UIKit

class ExploreShindigCell: UICollectionViewCell {
    
    @IBOutlet weak var lblEventName: UILabel!
    @IBOutlet weak var lblNoGuests: UILabel!
    @IBOutlet weak var lblDescTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var imgEvent: UIImageView!
    @IBOutlet weak var btnSelectedEvent: UIButton!
    @IBOutlet weak var btnFavourite: UIButton!
    @IBOutlet weak var lblRoleName: UILabel!
    
    //Invite Friends
    @IBOutlet weak var lblFriendName: UILabel!
    @IBOutlet weak var imgFriend: UIImageView!
    
    //Upcoming events
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var btnRoles: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnSettings: UIButton!
    @IBOutlet weak var viewSettings: UIView!
    
    //Profile events
    @IBOutlet weak var imgProfile: UIImageView!
   

    
    var dropMenuRoles : UIDropDownMenu!
           
    var radius: CGFloat = 2
    
    override func layoutSubviews() {
        
//        layer.cornerRadius = 4
//        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: radius)
//        
//        layer.masksToBounds = false
//        layer.shadowColor = UIColor.blackColor().CGColor
//        layer.shadowOffset = CGSize(width: 0, height: 4);
//        layer.shadowOpacity = 0.4
//        layer.shadowPath = shadowPath.CGPath
    }
    
        
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    

}
