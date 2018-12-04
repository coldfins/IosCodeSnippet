//
//  CustomPastCell.swift
//  
//
//  Created by Coldfin Lab on 29/02/16.
//
//

import UIKit

class CustomPastCell: SWTableViewCell
{

    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var imgAttend: UIImageView!
    @IBOutlet weak var btnAddReminder: UIButton!
    @IBOutlet weak var lblAppointmentTime: UILabel!
    @IBOutlet weak var imgDoctor: UIImageView!
    @IBOutlet weak var lblFirstName: UILabel!
    @IBOutlet weak var btnCancelAppointment: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
