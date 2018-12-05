//
//  ChangePasswordViewController.swift
//  WallPost
//
//  Created by Ved on 15/03/17.
//  Copyright © 2017 Ved. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController,UITextFieldDelegate,NVActivityIndicatorViewable {

    @IBOutlet weak var txtOldPwd: MKTextField!
    @IBOutlet weak var txtNewPwd: MKTextField!
    @IBOutlet weak var txtConfirmPwd: MKTextField!
    @IBOutlet weak var btnSave: UIButton!
    var appDelegate = AppDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        self.addBottomLineToTextField(textField: self.txtOldPwd)
        self.addBottomLineToTextField(textField: self.txtNewPwd)
        self.addBottomLineToTextField(textField: self.txtConfirmPwd)
        
        self.setTexfieldTitle(textField: self.txtOldPwd, title: "Old Password")
        self.setTexfieldTitle(textField: self.txtNewPwd, title: "New Password")
        self.setTexfieldTitle(textField: self.txtConfirmPwd, title: "Confirm Password")
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnSave_Click(sender: UIButton)
    {
        if(self.ValidateTextField()){
            if(self.txtNewPwd.text!.utf16.count < 6){
                self.appDelegate.ShowAlert(AlertTitle as NSString, alertMessage: "Enter atleast 6 character password.")
            }
            else if(self.txtNewPwd.text! != self.txtConfirmPwd.text){
                self.appDelegate.ShowAlert(AlertTitle as NSString, alertMessage: "Confirm password is not match.")
            }
            else{
                self.backgroundRequestForChangePassword()
            }
        }
    }
    
    
    // Sign Up API calling
    func backgroundRequestForChangePassword(){
        
        self.ShowActivityIndicator()
        
        let url = NSString(format : "%@%@", BASE_URL, CHANGE_PWD)
        print("url\(url)");
        let manager = AFHTTPRequestOperationManager()
        
         let struserID = UserDefaults.standard.value(forKey: keyUserId) as! Int
        
        let parameters = NSMutableDictionary()
        parameters.setObject(struserID, forKey: "UserId" as NSCopying)
        parameters.setObject(self.txtOldPwd.text! as String, forKey: "OldPassword" as NSCopying)
        parameters.setObject(self.txtNewPwd.text! as String, forKey: "NewPassword" as NSCopying)
        
        print(parameters)
        
        manager.post(url as String!, parameters: parameters, success: { (operation, responseObject) in
            
            print("Response Object :\(responseObject)")
            let element : NSDictionary = responseObject as! NSDictionary
            let error_code = element.value(forKey: "error_code") as! NSNumber
            let message : String = element.value(forKey: "msg") as! String
            
            if(error_code == 0)
            {
                self.RemoveActivityIndicator()
                self.appDelegate.ShowAlert(AlertTitle as NSString, alertMessage: message as NSString)
            }
            else{
                self.RemoveActivityIndicator()
                self.appDelegate.ShowAlert(AlertTitle as NSString, alertMessage: message as NSString)
            }
            
        },
                     failure: { (operation, error) in
                        let err = error as! NSError
                        print("We got an error here.. \(err.localizedDescription)")
                        self.RemoveActivityIndicator()
                        self.appDelegate.ShowAlert(AlertTitle as NSString, alertMessage: INTERNET_CONNECTION as NSString)
                        
        })
        
    }

    
    func ValidateTextField() -> Bool
    {
        if(txtNewPwd.text == "" || txtConfirmPwd.text == "" || txtOldPwd.text == "")
        {
            emptyFieldValidation(textField: txtNewPwd)
            emptyFieldValidation(textField: txtConfirmPwd)
            emptyFieldValidation(textField: txtOldPwd)
            return false;
        }
        return true;
    }
    
    func setTexfieldTitle(textField : MKTextField, title : NSString){
        
        textField.layer.borderColor = UIColor.clear.cgColor
        textField.floatingPlaceholderEnabled = true
        textField.bottomBorderEnabled = false
        textField.placeholder = title as String
        textField.tintColor = UIColor.MKColor.DarkGrey
        textField.rippleLocation = .right
        textField.cornerRadius = 0
    }
    func addBottomLineToTextField(textField : UITextField) {
        let border = CALayer()
        let borderWidth = CGFloat(1.0)
        border.borderColor =  UIColor.MKColor.DarkGrey.cgColor
        border.frame = CGRect(x : 0, y : textField.frame.size.height - borderWidth, width : textField.frame.size.width, height : textField.frame.size.height)
        border.borderWidth = borderWidth
        textField.layer.addSublayer(border)
        textField.layer.masksToBounds = true
    }
    
    
    func emptyFieldValidation(textField: UITextField!)
    {
        if(textField.text == ""){
            
            let border = CALayer()
            let borderWidth = CGFloat(1.0)
            border.borderColor = UIColor.red.cgColor
            border.frame = CGRect(x : 0, y : textField.frame.size.height - borderWidth, width : textField.frame.size.width, height : textField.frame.size.height)
            border.borderWidth = borderWidth
            textField.layer.addSublayer(border)
            textField.layer.masksToBounds = true
        }
        
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        self.setBorderToTextboxWhileLooseFocus(textField)
        
        if(textField.text != "")
        {
            self.setBorderToTextboxWhileLooseFocus(textField)
        }
    }
    
    
    func setBorderToTextboxWhileLooseFocus(_ textField : UITextField){
        self.addBottomLineToTextField(textField: textField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.setBorderToTextboxWhileLooseFocus(textField)
        
        if(textField == txtOldPwd)
        {
            txtNewPwd.becomeFirstResponder()
        }
        else if(textField == txtNewPwd)
        {
            txtConfirmPwd.becomeFirstResponder()
        }
        else if(textField == txtConfirmPwd)
        {
            txtConfirmPwd.resignFirstResponder()
        }
    
        return true
    }
    //Show activity indicator while downloading data from API
    func ShowActivityIndicator(){
        
        let size = CGSize(width: 50, height:50)
        startAnimating(size, message: nil, type: NVActivityIndicatorType(rawValue: 6)!)
    }
    
    //Remove activity indicator after downloading data from API
    func RemoveActivityIndicator(){
        stopAnimating()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    @IBAction func btnBackClicked(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
}
