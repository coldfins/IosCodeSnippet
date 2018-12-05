//
//  LikeUsersCell.swift
//  WallPost
//
//  Created by Ved on 04/03/17.
//  Copyright © 2017 Ved. All rights reserved.
//

import UIKit

class LikeUsersCell: UITableViewCell {

     @IBOutlet weak var imgProfilePic: UIImageView!
     @IBOutlet weak var lblUserName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
