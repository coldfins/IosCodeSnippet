//
//  Customcell.swift
//  
//
//  Created by Coldfin Lab on 11/02/16.
//
//

import UIKit

class Customcell: UITableViewCell {

    @IBOutlet weak var viewCollectionTime: UICollectionView!
    @IBOutlet weak var imgview: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblFees: UILabel!
    @IBOutlet weak var lblDegree: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var viewButton: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var viewMessage: UIView!
    @IBOutlet weak var lblMessage: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
            }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
