//
//  RegistrationViewController.swift
//  WallPost
//
//  Created by Ved on 23/02/17.
//  Copyright © 2017 Ved. All rights reserved.
//

import UIKit
import MobileCoreServices

class RegistrationViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextFieldDelegate,NVActivityIndicatorViewable {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var viewProfile: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var txtFirstName: MKTextField!
    @IBOutlet weak var txtLastName: MKTextField!
    @IBOutlet weak var txtEmail: MKTextField!
    @IBOutlet weak var txtPassword: MKTextField!
    @IBOutlet weak var txtBirthday: MKTextField!
    @IBOutlet weak var txtMobileNo: MKTextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnRegistration: UIButton!
    @IBOutlet weak var btnProfilePic: UIButton!
    
    let gradientLayer = CAGradientLayer()
    let imagePicker = UIImagePickerController()
    var imageProfilePath : NSURL!
    var appDelegate = AppDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        imagePicker.delegate = self

        self.btnProfilePic.layer.cornerRadius = self.btnProfilePic.frame.size.height/2
        self.btnProfilePic.clipsToBounds = true
        
        self.serGradientView()
        self.setTexfieldLayout()
        self.setToolbarToMobile()
        self.setToolbarForBirthdatePcker()
        
        //KeyBoard Observer
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        // Do any additional setup after loading the view.
    }
    
    func setTexfieldLayout(){
        self.addBottomLineToTextField(textField: self.txtFirstName)
        self.addBottomLineToTextField(textField: self.txtLastName)
        self.addBottomLineToTextField(textField: self.txtEmail)
        self.addBottomLineToTextField(textField: self.txtPassword)
        self.addBottomLineToTextField(textField: self.txtBirthday)
        self.addBottomLineToTextField(textField: self.txtMobileNo)
        
        self.btnRegistration.layer.cornerRadius = 28
        self.btnRegistration.layer.masksToBounds = true
        
        self.viewProfile.layer.cornerRadius = self.viewProfile.frame.size.height/2
        self.viewProfile.layer.masksToBounds = true
        
        self.setTexfieldTitle(textField: self.txtFirstName, title: "First Name")
        self.setTexfieldTitle(textField: self.txtLastName, title: "Last Name")
        self.setTexfieldTitle(textField: self.txtEmail, title: "Email")
        self.setTexfieldTitle(textField: self.txtPassword, title: "Password")
        self.setTexfieldTitle(textField: self.txtBirthday, title: "Birthday")
        self.setTexfieldTitle(textField: self.txtMobileNo, title: "Mobile Number")
    }
    
    func setToolbarToMobile(){
        let keyboardNextButtonView : UIToolbar = UIToolbar()
        keyboardNextButtonView.sizeToFit()
        let nextButton1 : UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(RegistrationViewController.btnDoneClicked))
        keyboardNextButtonView.setItems([nextButton1], animated: true)
        txtMobileNo.inputAccessoryView = keyboardNextButtonView

    }
    
    func setToolbarForBirthdatePcker(){
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        
        datePickerView.maximumDate = Calendar.current.date(byAdding: .year, value: -16, to: Date())
        self.txtBirthday.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(self.datePickerValueChanged), for: UIControlEvents.valueChanged)
        
        let keyboardNextButtonView : UIToolbar = UIToolbar()
        keyboardNextButtonView.sizeToFit()
        let nextButton1 : UIBarButtonItem = UIBarButtonItem(title: "Next", style: UIBarButtonItemStyle.done, target: self, action: #selector(RegistrationViewController.btnDoneClickedForBday))
        keyboardNextButtonView.setItems([nextButton1], animated: true)
        txtBirthday.inputAccessoryView = keyboardNextButtonView
        
    }
    
    func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        dateFormatter.dateFormat =  "yyyy-MM-dd"
        self.txtBirthday.text = dateFormatter.string(from: sender.date)
    }
    
    func btnDoneClickedForBday() {
        txtBirthday.resignFirstResponder()
        txtMobileNo.becomeFirstResponder()
    }
    
    func btnDoneClicked() {
        txtMobileNo.resignFirstResponder()
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
        self.navigationController?.popViewController(animated: true)
    }
    
    func resignAllTextfield(){
        self.txtFirstName.resignFirstResponder()
        self.txtLastName.resignFirstResponder()
        self.txtEmail.resignFirstResponder()
        self.txtPassword.resignFirstResponder()
        self.txtBirthday.resignFirstResponder()
        self.txtMobileNo.resignFirstResponder()
    }
    
    @IBAction func btnSignUpClicked(sender: UIButton) {
       
        self.resignAllTextfield()
        
        if(ValidateTextField())
        {
            if(imageProfilePath  == nil){
                self.appDelegate.ShowAlert(AlertTitle as NSString, alertMessage: "Please upload photo.")
            }
            else if(!(validateEmailWithString(testStr: txtEmail.text!)))
            {
                self.appDelegate.ShowAlert(AlertTitle as NSString, alertMessage: "Invalid email address.")
            }
            else if(self.txtPassword.text!.utf16.count < 6){
                self.appDelegate.ShowAlert(AlertTitle as NSString, alertMessage: "Please choose a password with at least 6 characters.")
            }
            else
            {
                let objRegistration = RegistrationModel()
                objRegistration.firstName = self.txtFirstName.text as NSString!
                objRegistration.lastName = self.txtLastName.text as NSString!
                objRegistration.EmailId = self.txtEmail.text as NSString!
                objRegistration.Password = self.txtPassword.text as NSString!
                objRegistration.dateOfBirth = self.txtBirthday.text as NSString!
                objRegistration.mobile = self.txtMobileNo.text as NSString!
                
                self.backgroundAPIForRegistration(objReg: objRegistration)
            }
        }
    }

    // Sign Up API calling
    func backgroundAPIForRegistration(objReg:RegistrationModel){
        
        self.ShowActivityIndicator()
        
        let url = NSString(format : "%@%@", BASE_URL, REGISTRATION_URL)
        print("url\(url)");
        let manager = AFHTTPRequestOperationManager()
        
        let parameters = NSMutableDictionary()
        parameters.setObject(objReg.firstName, forKey: "FirstName" as NSCopying)
        parameters.setObject(objReg.lastName, forKey: "LastName" as NSCopying)
        parameters.setObject(objReg.EmailId, forKey: "Email" as NSCopying)
        parameters.setObject(objReg.Password, forKey: "Password" as NSCopying)
        parameters.setObject(objReg.dateOfBirth, forKey: "BirthDate" as NSCopying)
        parameters.setObject(objReg.mobile, forKey: "Contact" as NSCopying)
        
        print(parameters)
        
        manager.post(url as String!, parameters: parameters,
                     constructingBodyWith: { (data) in
                        if self.imageProfilePath != nil{
                            let profilePhoto = try! data?.appendPart(withFileURL: self.imageProfilePath as URL!, name: "ProfilePic")
                        }
        },
                     success: { (operation, responseObject) in
                        
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
                      
                        self.RemoveActivityIndicator()
                        print(error?.localizedDescription)
                        self.appDelegate.ShowAlert(AlertTitle as NSString, alertMessage: INTERNET_CONNECTION as NSString)
            })
    }

    func NavigateHome(){
        let storyboard=UIStoryboard(name: "Main", bundle: nil)
        let homeVC = storyboard.instantiateViewController(withIdentifier: IdentifireHomeView) as! HomeViewController
        self.navigationController?.pushViewController(homeVC, animated: false)
    }
    
    @IBAction func btnChoosePhoto_Click(sender: UIButton)
    {
        sender.isSelected = true
        
        let optionMenu = UIAlertController(title: nil, message: "Choose option", preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Take a New Photo", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
            {
                self.imagePicker.sourceType = UIImagePickerControllerSourceType.camera
                self.imagePicker.allowsEditing = false
                self.imagePicker.mediaTypes = [kUTTypeImage as String]
                self.present(self.imagePicker, animated: true, completion: nil)
            }
            
        })
        let saveAction = UIAlertAction(title: "Upload From Camera Roll", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .photoLibrary
            
            self.present(self.imagePicker, animated: true, completion: nil)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            
        })
        
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(saveAction)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    @IBAction func btnPhotoMenuClick(sender:AnyObject)
    {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func btnTakePhotoClick(sender:AnyObject)
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.allowsEditing = false
            imagePicker.mediaTypes = [kUTTypeImage as String]
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        if (info[UIImagePickerControllerOriginalImage] as? UIImage) != nil {
            self.btnProfilePic.setImage(info[UIImagePickerControllerOriginalImage] as? UIImage, for: UIControlState.normal)
            
            let data:NSData = UIImageJPEGRepresentation((info[UIImagePickerControllerOriginalImage] as? UIImage)!,1.0)! as NSData
            
            //path for save image
            let imageName = NSString(format: "%.0f.png", NSDate().timeIntervalSince1970) as NSString
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent(imageName as String)
            let path = fileURL.path
            
            if(data.write(toFile: path as String, atomically: true))
            {
                NSLog("Save local sucessfully")
            }
            else{
                NSLog("Problem to save file in directory")
            }
            
            imageProfilePath = fileURL as NSURL!
            
            dismiss(animated: true, completion: nil)
        }
    }

   
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func ValidateTextField() -> Bool
    {
        if(txtFirstName.text == "" || txtLastName.text == "" || txtMobileNo.text == "" || txtBirthday.text == "" || txtEmail.text == "" || txtPassword.text == "")
        {
            emptyFieldValidation(textField: txtFirstName)
            emptyFieldValidation(textField: txtLastName)
            emptyFieldValidation(textField: txtMobileNo)
            emptyFieldValidation(textField: txtBirthday)
            emptyFieldValidation(textField: txtEmail)
            emptyFieldValidation(textField: txtPassword)
            return false;
        }
        return true;
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
        
        self.setBorderToTextboxWhileLooseFocus(txtEmail)
        
        if(textField.text != "")
        {
            self.setBorderToTextboxWhileLooseFocus(textField)
        }
    }
    
    
    func setBorderToTextboxWhileLooseFocus(_ textField : UITextField){
        self.addBottomLineToTextField(textField: textField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.setBorderToTextboxWhileLooseFocus(txtEmail)
        
        if(textField == txtFirstName)
        {
            txtLastName.becomeFirstResponder()
        }
        else if(textField == txtLastName)
        {
            txtEmail.becomeFirstResponder()
        }
        else if(textField == txtEmail)
        {
            txtPassword.becomeFirstResponder()
        }
        else if(textField == txtPassword)
        {
            txtBirthday.becomeFirstResponder()
        }
        else if(textField == txtBirthday)
        {
            txtMobileNo.becomeFirstResponder()
        }
        else if(textField == txtMobileNo)
        {
            txtMobileNo.resignFirstResponder()
        }

        
        return true
    }
    
    func validateEmailWithString(testStr:String) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(textField == self.txtMobileNo){
                guard let text = textField.text else { return true }
            
                let newLength = text.characters.count + string.characters.count - range.length
                return newLength <= 10 // Bool
        }
        return true
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
