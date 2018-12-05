//
//  CustomAlertViewController.swift
//  MapMyDiet
//
//  Created by Coldfin Lab on 01/04/16.
//  Copyright © 2016 Coldfin Lab. All rights reserved.
//

import UIKit

protocol CustomAlertViewControllerDelegate {
    func sendDelegateOnYesBtn()
}

class CustomAlertViewController: UIViewController {

    @IBOutlet weak var btnClose: UIButton!
    var type : String = ""
    var delegate : CustomAlertViewControllerDelegate!
    @IBOutlet weak var btnNo: UIButton!
    @IBOutlet weak var btnYes: UIButton!
    @IBOutlet weak var viewAlertBackground: UIView!
    @IBOutlet weak var imgViewStatus: UIImageView!
    var strMessage : String = ""
    @IBOutlet weak var lblMessage: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lblMessage.text = strMessage
        
        viewAlertBackground.layer.borderColor = UIColor.clear.cgColor
        viewAlertBackground.layer.borderWidth = 1.0
        viewAlertBackground.layer.cornerRadius = 5
        let shadowPath: UIBezierPath = UIBezierPath(rect: viewAlertBackground.bounds)
        viewAlertBackground.layer.masksToBounds = false
        viewAlertBackground.layer.shadowColor = UIColor.white.cgColor
        viewAlertBackground.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        viewAlertBackground.layer.shadowOpacity = 0.5
        viewAlertBackground.layer.shadowPath = shadowPath.cgPath
        
        btnYes.layer.cornerRadius = 5.0
        btnYes.clipsToBounds = true
        
        btnNo.layer.cornerRadius = 5.0
        btnNo.clipsToBounds = true
        
        btnClose.layer.cornerRadius = 5.0
        btnClose.clipsToBounds = true
        
        if type == "daysLeft" {
            btnYes.isHidden = true
            btnNo.isHidden = true
            btnClose.isHidden = false
        }else{
            btnYes.isHidden = false
            btnNo.isHidden = false
            btnClose.isHidden = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onClick_closeView(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
   
    @IBAction func onClick_yesBtn(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
        delegate.sendDelegateOnYesBtn()
    }
    
    @IBAction func onClick_noBtn(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }

}
