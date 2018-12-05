//
//  TableCell.swift
//  
//
//  Created by ved on 12/04/16.
//  Copyright (c) 2016 ved. All rights reserved.
//
import UIKit
class PostCellFourImages: UITableViewCell {
    
    @IBOutlet weak var View: UIView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblPostContent: UILabel!
    @IBOutlet weak var imgUserProfile: UIImageView!
    @IBOutlet weak var imgPost1: UIImageView!
    @IBOutlet weak var imgPost2: UIImageView!
    @IBOutlet weak var imgPost3: UIImageView!
    @IBOutlet weak var imgPost4: UIImageView!
    @IBOutlet weak var btnViewMore: UIButton!
    @IBOutlet weak var btnPost1: UIButton!
    @IBOutlet weak var btnPost2: UIButton!
    @IBOutlet weak var btnPost3: UIButton!
    @IBOutlet weak var btnComment: UIButton!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var btnLikeCount: UIButton!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var activityIndi: UIActivityIndicatorView!
    @IBInspectable var cornerRadius: CGFloat = 2
    @IBOutlet weak var btnReport: UIButton!
    @IBOutlet weak var lblComment: UIButton!
    @IBOutlet weak var btnUser: UIButton!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        self.activityIndi.hidesWhenStopped = true
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        self.contentView.layer.cornerRadius = cornerRadius
    }
}
