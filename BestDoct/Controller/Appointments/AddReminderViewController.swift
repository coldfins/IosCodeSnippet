//
//  AddReminderViewController.swift
//  
//
//  Created by Coldfin Lab on 02/03/16.
//
//

import UIKit

class AddReminderViewController: UIViewController,UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UITextViewDelegate
{
    var pickerView = UIPickerView()
    var app : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var appointmentTime = "" , convertedDate = "" , converteddate = "" , firstname = "" , apptTime = "" , strPicker = ""
    var attend = NSNumber()
    var clinicname = "" , reason = ""
    var dateObj = Date() , dateTime = Date()
    var arrDays  = ["1","2","3","4","5","6","7","8","9","10"]
    

    @IBOutlet weak var viewAddReminder: UIView!
    @IBOutlet weak var viewReminder: UIView!
    @IBOutlet weak var imgHour: UIImageView!
    @IBOutlet weak var txtReminder: UITextView!
    @IBOutlet weak var txtDate: UITextField!
    @IBOutlet weak var btnBack: UIButton!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setpickerView()
        self.txtDate.delegate = self
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor.white,
                NSFontAttributeName: UIFont(name: "Helvetica Neue", size: 16)!]
        self.viewAddReminder.layer.cornerRadius = 5.0
        self.viewAddReminder.clipsToBounds = true
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        self.dateTime = dateFormatter.date(from: apptTime)!
        self.dateObj = dateFormatter.date(from: appointmentTime)!
        dateFormatter.dateFormat = "EEE, dd MMM yyyy"
        self.convertedDate = dateFormatter.string(from: self.dateObj)
        dateFormatter.dateFormat = "HH:mm:ss a"
        self.converteddate = dateFormatter.string(from: self.dateObj)
        let userName : String = UserDefaults.standard.object(forKey: "UserName") as! String
        self.txtReminder.text = "Hello \(userName), Your appointment has been scheduled for \(reason) at the \(clinicname), with Dr. \(firstname) at \(converteddate), \(convertedDate)."
        self.navigationController?.isNavigationBarHidden = false
        self.txtReminder.delegate = self
    }
    func donePicker()
    {
        self.strPicker = pickerView(self.pickerView, titleForRow: pickerView.selectedRow(inComponent: 0), forComponent: 0)!
        self.txtDate.text = self.strPicker
        UIView.animate(withDuration: 1.0, animations:
        { () -> Void in
            
            let angle = CGFloat(180 * M_PI / 90)
            self.imgHour.transform = CGAffineTransform(rotationAngle: angle)
        })
        txtDate.resignFirstResponder()
    }
    func cancelPicker()
    {
        UIView.animate(withDuration: 1.0, animations:
        { () -> Void in
            
            let angle = CGFloat(180 * M_PI / 90)
            self.imgHour.transform = CGAffineTransform(rotationAngle: angle)
        })
        txtDate.resignFirstResponder()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    func setpickerView()
    {
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = false
        toolBar.barTintColor = UIColor.colorApplication()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(AddReminderViewController.donePicker))
        doneButton.tintColor = UIColor.white
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(AddReminderViewController.cancelPicker))
        cancelButton.tintColor = UIColor.white
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        pickerView.frame = CGRect(x: 200, y: 200.0, width: 0, height: 162.0)
        pickerView.delegate = self
        pickerView.backgroundColor = UIColor.white
        txtDate.inputView = pickerView
        txtDate.inputAccessoryView = toolBar
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return self.arrDays.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return self.arrDays[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        self.strPicker = self.arrDays[row]
        self.txtDate.text = self.arrDays[row]
        UIView.animate(withDuration: 1.0, animations:
        { () -> Void in
            
            let angle = CGFloat(180 * M_PI / 90)
            self.imgHour.transform = CGAffineTransform(rotationAngle: angle)
        })
        self.view.endEditing(true)
    }
    @IBAction func btnSetReminder(_ sender: UIButton)
    {
        if self.txtDate.text == ""
        {
            self.imgHour.image = UIImage(named: "passwordmismatch.png")
        }
        else
        {
            self.imgHour.image = UIImage(named: "Drop.png")
            let userCalendar = Calendar.current
            var periodComponents = DateComponents()
            periodComponents.hour = Int(self.txtDate.text!)
            let firedate = (userCalendar as NSCalendar).date(byAdding: periodComponents, to: self.dateObj, options: NSCalendar.Options(rawValue: 0))!
            var localNotification = UILocalNotification()
            localNotification.fireDate = firedate
            localNotification.alertBody = self.txtReminder.text
            localNotification.timeZone = TimeZone.current
            localNotification.soundName = UILocalNotificationDefaultSoundName
            UIApplication.shared.scheduleLocalNotification(localNotification)
            self.app.strStart = "yipee"
            var alert : SCLAlertView = SCLAlertView()
            alert.labelTitle.textColor = UIColor(red: 81.0/255.0, green: 210.0/255.0, blue: 80.0/255.0, alpha: 1.0)
            alert.backgroundType = .Blur
            alert.showAnimationType = .SlideInFromTop
            alert.hideAnimationType = .SlideOutToBottom
            alert.tintTopCircle = true
            alert.showWaiting(self, title: "Yippeee!!", subTitle: "Reminder for your appointment is set!!!." , closeButtonTitle: "OK", duration: 3.0)
        }
    }
    @IBAction func btnBack(_ sender: AnyObject)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        if textField == self.txtDate
        {
            setpickerView()
            self.imgHour.image = UIImage(named: "Drop.png")
            UIView.animate(withDuration: 1.0, animations:
            { () -> Void in
                
                let angle = CGFloat(90 * M_PI / 90)
                self.imgHour.transform = CGAffineTransform(rotationAngle: angle)
            })
        }
        return true
    }
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool
    {
        return false
    }
}
