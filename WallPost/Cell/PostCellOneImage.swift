//
//  TableCell.swift
//  
//
//  Created by ved on 12/04/16.
//  Copyright (c) 2016 ved. All rights reserved.
//
import UIKit
class PostCellOneImage: UITableViewCell {
    
    @IBOutlet weak var View: UIView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblPostContent: UILabel!
    @IBOutlet weak var imgUserProfile: UIImageView!
    @IBOutlet weak var imgPost: UIImageView!
    @IBOutlet weak var btnPost: UIButton!
    @IBOutlet weak var btnComment: UIButton!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var btnLikeCount: UIButton!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var activityIndi: UIActivityIndicatorView!
    @IBOutlet weak var btnReport: UIButton!
    @IBOutlet weak var lblComment: UIButton!
    @IBOutlet weak var btnUser: UIButton!
       
    @IBInspectable var cornerRadius: CGFloat = 2
    
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
