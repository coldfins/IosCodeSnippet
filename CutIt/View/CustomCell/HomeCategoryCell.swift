//
//  CollectionViewCell.swift
//  PinterestLayout
//
//  Created by Shrikar Archak on 12/21/14.
//  Copyright (c) 2014 Shrikar Archak. All rights reserved.
//

import UIKit

class HomeCategoryCell: UICollectionViewCell {
    
    @IBOutlet weak var lblCategoryName: UILabel!
    @IBOutlet weak var lblCategoryDesc: UILabel!
    @IBOutlet weak var imgCategory: UIImageView!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
}
