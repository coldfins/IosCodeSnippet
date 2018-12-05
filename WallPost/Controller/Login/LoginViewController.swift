//
//  LoginViewController.swift
//  WallPost
//
//  Created by Ved on 23/02/17.
//  Copyright © 2017 Ved. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController,NVActivityIndicatorViewable, UITextFieldDelegate {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var txtEmail: MKTextField!
    @IBOutlet weak var txtPassword: MKTextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnRegistration: UIButton!
    
    let gradientLayer = CAGradientLayer()
    var appDelegate = AppDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.serGradientView()
        appDelegate = UIApplication.shared.delegate as! AppDelegate

        self.btnLogin.layer.cornerRadius = 28
        self.btnLogin.layer.masksToBounds = true
        
        self.addBottomLineToTextField(textField: self.txtEmail)
        self.addBottomLineToTextField(textField: self.txtPassword)
        
        self.setTexfieldTitle(textField: self.txtEmail, title: "Email")
        self.setTexfieldTitle(textField: self.txtPassword, title: "Password")
        
        //KeyBoard Observer
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        
        // Do any additional setup after loading the view.
    }
    
    //MARK: - KeyBoard Observer Method
    func keyboardWillShow(_ notification:Notification){
        
        scrollView.isScrollEnabled = true
        var userInfo = (notification as NSNotification).userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height+10
        scrollView.contentInset = contentInset
    }
    
    
    func keyboardWillHide(_ notification:Notification){
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
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

    func serGradientView(){
     
        gradientLayer.frame = self.viewMain.bounds
        
        let color1 = UIColor.white.cgColor as CGColor
        let color2 = UIColor(red: 231/255, green: 252/255, blue: 253/255, alpha: 1.0).cgColor as CGColor
        let color3 = UIColor(red: 113/255, green: 221/255, blue: 234/255, alpha: 1.0).cgColor as CGColor
        let color4 = UIColor(red: 63/255, green: 199/255, blue: 216/255, alpha: 1.0).cgColor as CGColor
        
        gradientLayer.colors = [color1,color2,color3,color4]
        gradientLayer.locations = [0.0, 0.25, 0.75, 1.0]
        self.viewMain.layer.superlayer?.insertSublayer(gradientLayer, below: self.viewMain.layer)
    }
    
    @IBAction func btnSignInClicked(sender: UIButton) {
        
        self.txtPassword.resignFirstResponder()
        self.txtEmail.resignFirstResponder()
        
        if(ValidateTextField())
        {
            if(!(validateEmailWithString(testStr: txtEmail.text!)))
            {
                self.appDelegate.ShowAlert(AlertTitle as NSString, alertMessage: "Invalid email address.")
            }
            else{
                let objRegistration = RegistrationModel()
                objRegistration.EmailId = self.txtEmail.text as NSString!
                objRegistration.Password = self.txtPassword.text as NSString!
               
                self.backgroundAPIForLogin(objReg: objRegistration)
            }
        }
    }

    // Sign Up API calling
    func backgroundAPIForLogin(objReg:RegistrationModel){
        
        self.ShowActivityIndicator()
        
        let url = NSString(format : "%@%@", BASE_URL, LOGIN_URL)
        print("url\(url)");
        let manager = AFHTTPRequestOperationManager()
        
        let parameters = NSMutableDictionary()
        parameters.setObject(objReg.EmailId, forKey: "Email" as NSCopying)
        parameters.setObject(objReg.Password, forKey: "Password" as NSCopying)
        
        print(parameters)
        
        manager.post(url as String!, parameters: parameters, success: { (operation, responseObject) in
            
            print("Response Object :\(responseObject)")
            let element : NSDictionary = responseObject as! NSDictionary
            let error_code = element.value(forKey: "error_code") as! NSNumber
            let message : String = element.value(forKey: "msg") as! String
            
            if(error_code == 0)
            {
                let dictResponse = element.value(forKey: "user") as! NSDictionary
                
                let defaults = UserDefaults.standard
                
                if let strBday = dictResponse.object(forKey: "BirthDate") as? String {
                    defaults.set(strBday, forKey: keyBirthDate)
                }
                else{
                    defaults.set("", forKey: keyBirthDate)
                }
                
                if let strContact = dictResponse.object(forKey: "Contact") as? String {
                    defaults.set(strContact, forKey: keyContact)
                }
                else{
                    defaults.set("", forKey: keyContact)
                }
                
                if let strUserID = dictResponse.object(forKey: "UserId") as? Int {
                    defaults.set(strUserID, forKey: keyUserId)
                }
                else{
                    defaults.set("", forKey: keyUserId)
                }
                
                if let strFirstName = dictResponse.object(forKey: "FirstName") as? String {
                    defaults.set(strFirstName, forKey: keyFirstName)
                }
                else{
                    defaults.set("", forKey: keyFirstName)
                }
                
                if let strLastName = dictResponse.object(forKey: "LastName") as? String {
                    defaults.set(strLastName, forKey: keyLastName)
                }
                else{
                    defaults.set("", forKey: keyLastName)
                }
                
                if let strProfilePic = dictResponse.object(forKey: "ProfilePic") as? String {
                    defaults.set(strProfilePic, forKey: keyProfilePic)
                }
                else{
                    defaults.set("", forKey: keyProfilePic)
                }
                
                if let strEmail = dictResponse.object(forKey: "Email") as? String {
                    defaults.set(strEmail, forKey: keyEmail)
                }
                else{
                    defaults.set("", forKey: keyEmail)
                }
                
                if let strIsPublic = dictResponse.object(forKey: "IsPublic") as? Bool {
                    defaults.set(strIsPublic, forKey: keyIsPublic)
                }
                else{
                    defaults.set(true, forKey: keyIsPublic)
                }

                
                defaults.synchronize()
                self.RemoveActivityIndicator()
                self.NavigateHome()
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
    
    func NavigateHome(){
        let storyboard=UIStoryboard(name: "Main", bundle: nil)
        let homeVC = storyboard.instantiateViewController(withIdentifier: IdentifireHomeView) as! HomeViewController
        self.navigationController?.pushViewController(homeVC, animated: false)
    }
    
    @IBAction func btnForgotPwdClicked(sender: UIButton) {
        let storyboard=UIStoryboard(name: "Main", bundle: nil)
        let forgotVC = storyboard.instantiateViewController(withIdentifier: IdentifireForgotPwdView) as! ForgotPasswordViewController
        self.navigationController?.pushViewController(forgotVC, animated: false)
    }
    
    @IBAction func btnSignUpClicked(sender: UIButton) {
        let storyboard=UIStoryboard(name: "Main", bundle: nil)
        let RegistrationVC = storyboard.instantiateViewController(withIdentifier: IdentifireRegistrationView) as! RegistrationViewController
        self.navigationController?.pushViewController(RegistrationVC, animated: false)
    }

    func ValidateTextField() -> Bool
    {
        if(txtEmail.text == "" || txtPassword.text == "")
        {
            emptyFieldValidation(textField: txtEmail)
            emptyFieldValidation(textField: txtPassword)
            return false;
        }
        return true;
    }
    
    func addBottomLineToTextField(textField : UITextField) {
        let border = CALayer()
        let borderWidth = CGFloat(1.0)
        border.borderColor = UIColor.MKColor.DarkGrey.cgColor
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
        
        if(textField == txtEmail)
        {
            self.setBorderToTextboxWhileLooseFocus(txtEmail)
        }
        else if(textField == txtPassword)
        {
            self.setBorderToTextboxWhileLooseFocus(textField)
        }
    }
    
    func setBorderToTextboxWhileFocus(_ textField : UITextField){
        textField.layer.borderColor = UIColor.darkGray.cgColor
        textField.layer.borderWidth = 1.5
        
    }
    
    func setBorderToTextboxWhileLooseFocus(_ textField : UITextField){
        self.addBottomLineToTextField(textField: textField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        var scrollpoint : CGPoint
        scrollpoint = CGPoint.zero
        
        if(textField == txtEmail)
        {
            self.setBorderToTextboxWhileLooseFocus(txtEmail)
            txtPassword.becomeFirstResponder()
        }
        else if(textField == txtPassword)
        {
            self.setBorderToTextboxWhileLooseFocus(textField)
            txtPassword.resignFirstResponder()
            scrollView.setContentOffset(scrollpoint,animated: true)
        }
        
        return true
    }
    
    func validateEmailWithString(testStr:String) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
        
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
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
