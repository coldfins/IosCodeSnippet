//
//  Registration.swift
//  
//
//  Created by Coldfin Lab on 08/02/16.
//
//

import UIKit

class Registration: UIView {

    
    //Form 1
     @IBOutlet weak var viewGender: UIView!
     @IBOutlet weak var txtUserName: UITextField!
     @IBOutlet weak var txtUserType: UITextField!
     @IBOutlet weak var txtName: UITextField!
     @IBOutlet weak var txtLastName: UITextField!
     
     @IBOutlet weak var viewPicker: UIView!
     @IBOutlet weak var btnBackContinue: UIButton!
     @IBOutlet weak var btnSignIN: UIButton!
    
    //Form 2
     @IBOutlet weak var imgUserImage: UIImageView!
     @IBOutlet weak var txtEmail: UITextField!
     @IBOutlet weak var btnChooseImage: UIButton!
     @IBOutlet weak var btnBack: UIButton!
    //Form 3
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var txtPassword: UITextField!
   
    @IBOutlet weak var txtCountryCode: UITextField!
    
    //Form 4
    @IBOutlet weak var btnMale: UIButton!
   
    @IBOutlet weak var btnFemale: UIButton!
    
    //Form 5
   
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var btnRegistration: UIButton!
   
    //Calender
    
    @IBOutlet weak var calendarMenuView: JTCalendarMenuView!
    @IBOutlet weak var calendarContentView: JTHorizontalCalendarView!
    var calendarManager : JTCalendarManager = JTCalendarManager()
    @IBOutlet weak var btnCalenderNext: UIButton!
    @IBOutlet weak var btnCalenderPrevious: UIButton!
    
       
    
    /*
    @IBOutlet weak var lblu: UILabel!
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
