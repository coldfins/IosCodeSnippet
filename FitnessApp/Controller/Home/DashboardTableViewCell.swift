//
//  DashboardTableViewCell.swift
//  MapMyDiet
//
//  Created by Coldfin Lab on 14/03/16.
//  Copyright © 2016 Coldfin Lab. All rights reserved.
//

import UIKit

class DashboardTableViewCell: UITableViewCell {

    @IBOutlet weak var constraintValueWidth: NSLayoutConstraint!
    @IBOutlet weak var imgview: UIImageView!
    @IBOutlet weak var lblValue: UILabel!
    @IBOutlet weak var lblName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
