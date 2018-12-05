//
//  ForgotPasswordViewController.swift
//  WallPost
//
//  Created by Ved on 17/03/17.
//  Copyright © 2017 Ved. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController,NVActivityIndicatorViewable,UITextFieldDelegate {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var txtEmail: MKTextField!
    @IBOutlet weak var btnSave: UIButton!
    
    let gradientLayer = CAGradientLayer()
    var appDelegate = AppDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.serGradientView()
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        self.btnSave.layer.cornerRadius = 28
        self.btnSave.layer.masksToBounds = true
        
        self.addBottomLineToTextField(textField: self.txtEmail)
        self.setTexfieldTitle(textField: self.txtEmail, title: "Email")
        
        //KeyBoard Observer
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnSaveClicked(sender: UIButton) {
        
        self.txtEmail.resignFirstResponder()
        
        if(ValidateTextField())
        {
            if(!(validateEmailWithString(testStr: txtEmail.text!)))
            {
                self.appDelegate.ShowAlert(AlertTitle as NSString, alertMessage: "Invalid email address.")
            }
            else{
                self.backgroundAPIForForgotPwd()
            }
        }
    }
    
    //Forgot Password API calling
    func backgroundAPIForForgotPwd(){
        
        self.ShowActivityIndicator()
        
        let url = NSString(format : "%@%@", BASE_URL, FORGOT_PASSWORD)
        print("url\(url)");
        let manager = AFHTTPRequestOperationManager()
        
        let struserID = UserDefaults.standard.value(forKey: keyUserId) as! Int
        
        let parameters = NSMutableDictionary()
        parameters.setObject(self.txtEmail.text! as String, forKey: "Email" as NSCopying)
        
        print(parameters)
        
        manager.post(url as String!, parameters: parameters, success: { (operation, responseObject) in
            
            print("Response Object :\(responseObject)")
            let element : NSDictionary = responseObject as! NSDictionary
            let error_code = element.value(forKey: "error_code") as! NSNumber
            let message : String = element.value(forKey: "msg") as! String
            
            if(error_code == 0)
            {
                self.RemoveActivityIndicator()
                let storyboard=UIStoryboard(name: "Main", bundle: nil)
                let mailConfirmationVC = storyboard.instantiateViewController(withIdentifier: IdentifireMailSentView) as! MailConfirmationViewController
                self.navigationController?.pushViewController(mailConfirmationVC, animated: false)
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
        if(txtEmail.text == "")
        {
            emptyFieldValidation(textField: txtEmail)
            return false;
        }
        return true;
    }
    
    //MARK: - KeyBoard Observer Method
    func keyboardWillShow(_ notification:Notification){
        
        scrollView.isScrollEnabled = true
        var userInfo = (notification as NSNotification).userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height+80
        scrollView.contentInset = contentInset
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

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        var scrollpoint : CGPoint
        scrollpoint = CGPoint.zero
        self.setBorderToTextboxWhileLooseFocus(txtEmail)
        textField.resignFirstResponder()
        scrollView.setContentOffset(scrollpoint,animated: true)
        
        return true
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
        self.setBorderToTextboxWhileLooseFocus(txtEmail)
    }
    
    func setBorderToTextboxWhileFocus(_ textField : UITextField){
        textField.layer.borderColor = UIColor.darkGray.cgColor
        textField.layer.borderWidth = 1.5
        
    }
    
    func setBorderToTextboxWhileLooseFocus(_ textField : UITextField){
        self.addBottomLineToTextField(textField: textField)
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
    
    @IBAction func btnBackClicked(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
