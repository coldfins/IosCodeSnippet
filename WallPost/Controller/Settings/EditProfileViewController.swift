//
//  EditProfileViewController.swift
//  WallPost
//
//  Created by Ved on 15/03/17.
//  Copyright © 2017 Ved. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController ,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextFieldDelegate,NVActivityIndicatorViewable,UIPickerViewDelegate, UIPickerViewDataSource{

    @IBOutlet weak var viewProfile: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var txtFirstName: MKTextField!
    @IBOutlet weak var txtLastName: MKTextField!
    @IBOutlet weak var txtEmail: MKTextField!
    @IBOutlet weak var txtBirthday: MKTextField!
    @IBOutlet weak var txtMobileNo: MKTextField!
    @IBOutlet weak var txtIsPublic: MKTextField!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnProfilePic: UIButton!
    
    var muteForPicker: UIPickerView = UIPickerView()
    let imagePicker = UIImagePickerController()
    var imageProfilePath : NSURL!
    var appDelegate = AppDelegate()
    let muteForPickerData = ["Only Me","Everyone"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        muteForPicker.delegate = self
        muteForPicker.dataSource = self
        imagePicker.delegate = self
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        self.setPrefilledDataToForm()
        self.setTexfieldLayout()
        self.setKeyboardObserverAndToolbar()
        
        // Do any additional setup after loading the view.
    }
    
    func setPrefilledDataToForm(){
        let isPublic = UserDefaults.standard.value(forKey: keyIsPublic) as! Bool
        print(isPublic)
        
        if(isPublic == true){
            self.txtIsPublic.text = "Everyone"
        }
        else{
            self.txtIsPublic.text = "Only Me"
        }
        
        let strFirstName = UserDefaults.standard.value(forKey: keyFirstName) as! NSString
        let strLastName = UserDefaults.standard.value(forKey: keyLastName) as! NSString
        let strEmail = UserDefaults.standard.value(forKey: keyEmail) as! NSString
        let strBirthDay = UserDefaults.standard.value(forKey: keyBirthDate) as! NSString
        let strMobile = UserDefaults.standard.value(forKey: keyContact) as! NSString
        
        self.lblName.text = NSString(format:"%@ %@", strFirstName, strLastName) as String
        self.lblEmail.text = strEmail as String
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"//this your string date format
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        let date = dateFormatter.date(from: strBirthDay as String)
        print(date as Any)
        
        let df = DateFormatter()
        df.dateStyle = DateFormatter.Style.medium
        df.timeStyle = DateFormatter.Style.none
        df.dateFormat =  "yyyy-MM-dd"
        self.txtBirthday.text = df.string(from: date!)
        print(df.string(from: date!))
        
        self.txtEmail.text = strEmail as String
        self.txtFirstName.text = strFirstName as String
        self.txtLastName.text = strLastName as String
        self.txtMobileNo.text = strMobile as String
        
        self.btnProfilePic.layer.cornerRadius = self.btnProfilePic.frame.size.height/2
        self.btnProfilePic.clipsToBounds = true
        
        let strImageURL = UserDefaults.standard.value(forKey: keyProfilePic) as! NSString
        
        let imgURL = NSURL(string: strImageURL as String)
        
        let imageRequest = NSURLRequest(url: imgURL as! URL, cachePolicy: NSURLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 600)
        
        self.btnProfilePic.setImageFor(UIControlState.normal, with: imageRequest as URLRequest!, placeholderImage: UIImage(named: "unknown_user.png"), success: nil, failure: nil)
    }
    
    func setTexfieldLayout(){
        self.addBottomLineToTextField(textField: self.txtFirstName)
        self.addBottomLineToTextField(textField: self.txtLastName)
        self.addBottomLineToTextField(textField: self.txtEmail)
        self.addBottomLineToTextField(textField: self.txtBirthday)
        self.addBottomLineToTextField(textField: self.txtMobileNo)
        self.addBottomLineToTextField(textField: self.txtIsPublic)
        self.viewProfile.layer.cornerRadius = self.viewProfile.frame.size.height/2
        self.viewProfile.layer.masksToBounds = true
        
        self.setTexfieldTitle(textField: self.txtFirstName, title: "First Name")
        self.setTexfieldTitle(textField: self.txtLastName, title: "Last Name")
        self.setTexfieldTitle(textField: self.txtEmail, title: "Email")
        self.setTexfieldTitle(textField: self.txtBirthday, title: "Birthday")
        self.setTexfieldTitle(textField: self.txtMobileNo, title: "Mobile Number")
        self.setTexfieldTitle(textField: self.txtIsPublic, title: "Who can see your profile?")
    }
    
    func setKeyboardObserverAndToolbar(){
        
        //KeyBoard Observer
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        self.setToolbarToMobile()
        self.setToolbarForBirthdatePcker()
        
        self.txtIsPublic.inputView = muteForPicker
        let keyboardDoneButtonView : UIToolbar = UIToolbar()
        keyboardDoneButtonView.sizeToFit()
        let nextButton1 : UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(EditProfileViewController.btnDoneClickedForIsPublic))
        keyboardDoneButtonView.setItems([nextButton1], animated: true)
        txtIsPublic.inputAccessoryView = keyboardDoneButtonView
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return muteForPickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return muteForPickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.txtIsPublic.text = muteForPickerData[row]
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
    
    func btnDoneClickedForIsPublic() {
        txtIsPublic.resignFirstResponder()
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
   
    func resignAllTextfield(){
        self.txtFirstName.resignFirstResponder()
        self.txtLastName.resignFirstResponder()
        self.txtEmail.resignFirstResponder()
        self.txtBirthday.resignFirstResponder()
        self.txtMobileNo.resignFirstResponder()
    }
    
    @IBAction func btnSave_Click(sender: UIButton)
    {
        self.resignAllTextfield()
        
        if(ValidateTextField())
        {
            if(!(validateEmailWithString(testStr: txtEmail.text!)))
            {
                self.appDelegate.ShowAlert(AlertTitle as NSString, alertMessage: "Invalid email address.")
            }
            else
            {
                let objRegistration = RegistrationModel()
                objRegistration.firstName = self.txtFirstName.text as NSString!
                objRegistration.lastName = self.txtLastName.text as NSString!
                objRegistration.EmailId = self.txtEmail.text as NSString!
                objRegistration.dateOfBirth = self.txtBirthday.text as NSString!
                objRegistration.mobile = self.txtMobileNo.text as NSString!
                
                self.backgroundAPIForEditProfile(objReg: objRegistration)
            }
        }

    }
    
    // Edit Profile API calling
    func backgroundAPIForEditProfile(objReg:RegistrationModel){
        
        self.ShowActivityIndicator()
        
        let url = NSString(format : "%@%@", BASE_URL, EDIT_PROFILE)
        print("url\(url)");
        let manager = AFHTTPRequestOperationManager()
        
        let struserID = UserDefaults.standard.value(forKey: keyUserId) as! Int
        
        let parameters = NSMutableDictionary()
        parameters.setObject(struserID, forKey: "UserId" as NSCopying)
        parameters.setObject(objReg.firstName, forKey: "FirstName" as NSCopying)
        parameters.setObject(objReg.lastName, forKey: "LastName" as NSCopying)
        parameters.setObject(objReg.EmailId, forKey: "Email" as NSCopying)
        parameters.setObject(objReg.dateOfBirth, forKey: "BirthDate" as NSCopying)
        parameters.setObject(objReg.mobile, forKey: "Contact" as NSCopying)
        
        if(self.txtIsPublic.text == "Everyone"){
            parameters.setObject("true", forKey: "IsPublic" as NSCopying)
        }
        else{
            parameters.setObject("false", forKey: "IsPublic" as NSCopying)
        }
        
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
                            self.appDelegate.ShowAlert(AlertTitle as NSString, alertMessage: message as NSString)
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
        if(txtFirstName.text == "" || txtLastName.text == "" || txtMobileNo.text == "" || txtBirthday.text == "" || txtEmail.text == "")
        {
            emptyFieldValidation(textField: txtFirstName)
            emptyFieldValidation(textField: txtLastName)
            emptyFieldValidation(textField: txtMobileNo)
            emptyFieldValidation(textField: txtBirthday)
            emptyFieldValidation(textField: txtEmail)
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
    
    override func viewWillDisappear(_ animated: Bool) {
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
