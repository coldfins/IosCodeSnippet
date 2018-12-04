//
//  CustomMedicalCell.swift
//  
//
//  Created by Coldfin Lab on 29/02/16.
//
//

import UIKit

class CustomMedicalCell: UITableViewCell
{
    
    @IBOutlet weak var imgDoctor: UIImageView!
    @IBOutlet weak var lblExperience: UILabel!
    @IBOutlet weak var btnViewProfile: UIButton!
    @IBOutlet weak var lblDoctorCategory: UILabel!
    @IBOutlet weak var lblDoctorName: UILabel!
    @IBOutlet weak var lblClinicAddress: UILabel!
    @IBOutlet weak var lblFees: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
