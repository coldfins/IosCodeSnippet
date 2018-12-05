//
//  TableCell.swift
//
//
//  Created by ved on 28/02/17.
//  Copyright (c) 2016 ved. All rights reserved.
//
import UIKit
class ReplyCommentWithImageCell: UITableViewCell {
    
    
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblCommentText: UILabel!
    @IBOutlet weak var imgUserProfile: UIImageView!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var imgComment: UIImageView!
    @IBOutlet weak var btnUser: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
  
}
