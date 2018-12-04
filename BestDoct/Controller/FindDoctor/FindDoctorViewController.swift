//
//  FindDoctorViewController.swift
//  
//
//  Created by Coldfin Lab on 09/02/16.
//
//

import UIKit


class FindDoctorViewController: UIViewController,UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate,JTCalendarDelegate,CLLocationManagerDelegate,UIPickerViewDataSource, UIPickerViewDelegate,CNPPopupControllerDelegate
{
    @IBOutlet weak var viewError: UIView!
    var blurEffectView  = UIVisualEffectView()
    var pickerView = UIPickerView()
    var pickerViewReason = UIPickerView()
    var strSpeciality = String()
    var strReason = String()
    var latitude = ""
    var longitude = ""
    var calenderView = Registration()
    var dateselected = Date()
    var searchResultPlaces : NSArray = []
    var objDoctorList : DoctorListModel = DoctorListModel()
    var appObj : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var tableView: UITableView  =   UITableView()
    var app : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var obj = SpecialityTableViewController()
    var searchQuery : SPGooglePlacesAutocompleteQuery =  SPGooglePlacesAutocompleteQuery()
    var view1 = UIView(frame: UIScreen.main.bounds)
    let toolBar1 = UIToolbar()
    
    var alert : SCLAlertView = SCLAlertView()
    var obj1 = SCLAlertView()
    var index = NSNumber()
    var popupController : CNPPopupController = CNPPopupController()
  
    @IBOutlet weak var viewLocation: UIView!
    @IBOutlet weak var btnFindDoctor: UIButton!
    @IBOutlet weak var btnStart: UIButton!
    @IBOutlet weak var imgReason: UIImageView!
    @IBOutlet weak var imgspeciality: UIImageView!
    @IBOutlet weak var txtSpeciality: UITextField!
    @IBOutlet weak var txtReason: UITextField!
    @IBOutlet weak var viewCalender: UIView!
    @IBOutlet weak var viewStart: UIView!
    @IBOutlet weak var viewFindDoctor: UIView!
    @IBOutlet weak var viewSpeciality: UIView!
    @IBOutlet weak var lblSpeciality: UILabel!
    @IBOutlet weak var lblReason: UILabel!
    @IBOutlet weak var txtLocation: UITextField!
    @IBOutlet weak var txtDatePicker: UITextField!
    @IBOutlet weak var barbtnSidePanel: UIBarButtonItem!
    @IBOutlet var scrollview: UIScrollView!
    var activityIndicatorView : NVActivityIndicatorView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.viewCalender.isHidden = true
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white,NSFontAttributeName: UIFont(name: "Helvetica Neue", size: 16)!]
        searchQuery = SPGooglePlacesAutocompleteQuery(apiKey: "AIzaSyClWRJb276Y012NGP4-hCuUHTeil-Xl7tA")
        self.txtReason.delegate = self
        self.txtSpeciality.delegate = self
        self.txtLocation.delegate = self
        self.txtDatePicker.delegate = self
        self.viewError.isHidden = true
       
    }
    override func viewWillAppear(_ animated: Bool)
    {
        activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: self.view.center.y/2,y: self.view.center.x,width: 50,height: 50), type: NVActivityIndicatorType.ballClipRotatePulse, color: UIColor.colorApplication(), padding: NVActivityIndicatorView.DEFAULT_PADDING)
        
        if IS_IPHONE_4_OR_LESS
        {
            self.scrollview.contentSize = CGSize(width: 320,height: 500)
            self.scrollview.addSubview(self.btnFindDoctor)
        }
        self.view.addSubview(activityIndicatorView)
        callCategoryApi()
    }
   
    func setpickerView()
    {
       
        let toolBar = UIToolbar()
        toolBar.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
        toolBar.isTranslucent = false
        toolBar.barTintColor = UIColor.colorApplication()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(FindDoctorViewController.donePicker))
        doneButton.tintColor = UIColor.white
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(FindDoctorViewController.cancelPicker))
        cancelButton.tintColor = UIColor.white
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        pickerView.delegate = self
        pickerView.frame = CGRect(x: 200.0, y: 200.0, width: 0, height: 162.0)
        pickerView.tag = 1
        pickerView.backgroundColor = UIColor.white
        txtSpeciality.inputView = pickerView
        txtSpeciality.inputAccessoryView = toolBar
        
        toolBar1.barStyle = UIBarStyle.default
        toolBar1.isTranslucent = false
        toolBar1.barTintColor = UIColor.colorApplication()
        toolBar1.sizeToFit()
        
        let doneButton1 = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(FindDoctorViewController.donePicker1))
        doneButton1.tintColor = UIColor.white
        let spaceButton1 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton1 = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(FindDoctorViewController.cancelPicker1))
        cancelButton1.tintColor = UIColor.white
        
        toolBar1.setItems([cancelButton1, spaceButton1, doneButton1], animated: false)
        toolBar1.isUserInteractionEnabled = true

        pickerViewReason.delegate = self
        pickerViewReason.tag = 2
        pickerViewReason.frame = CGRect(x: 0, y: 0, width: 0, height: 162.0)
        pickerViewReason.backgroundColor = UIColor.white
    }
    func donePicker()
    {
        UIView.animate(withDuration: 1.0, animations:
        { () -> Void in
            
            let angle = CGFloat(180 * M_PI / 90)
            self.imgspeciality.transform = CGAffineTransform(rotationAngle: angle)
        })
        
        if self.objDoctorList.arrSpecialty.count == 0
        {
            txtSpeciality.resignFirstResponder()
        }
        else
        {
            self.strSpeciality  = pickerView(self.pickerView, titleForRow: pickerView.selectedRow(inComponent: 0), forComponent: 0)!
            self.app.categoryId = self.objDoctorList.arrIdSpeciality.object(at: 0) as! NSNumber
            self.objDoctorList.arrId.removeAllObjects()
            callApiReason()
            self.txtSpeciality.text = self.strSpeciality
            self.txtLocation.isUserInteractionEnabled = true
            self.txtReason.isUserInteractionEnabled = true
            self.txtDatePicker.isUserInteractionEnabled = true
        }
        txtSpeciality.resignFirstResponder()
    }
    func donePicker1()
    {
        UIView.animate(withDuration: 1.0, animations:
        { () -> Void in
            
            let angle = CGFloat(180 * M_PI / 90)
            self.imgReason.transform = CGAffineTransform(rotationAngle: angle)
        })
        if self.objDoctorList.arrReason.count == 0
        {
             txtReason.resignFirstResponder()
            self.txtLocation.isUserInteractionEnabled = true
            self.txtSpeciality.isUserInteractionEnabled = true
            self.txtDatePicker.isUserInteractionEnabled = true
        }
        else
        {
            self.strReason  = pickerView(self.pickerViewReason, titleForRow: pickerViewReason.selectedRow(inComponent: 0), forComponent: 0)!
            self.app.subcategoryId = self.objDoctorList.arrId.object(at: 0) as! NSNumber
            self.txtReason.text = self.strReason
            txtReason.resignFirstResponder()
            self.txtLocation.isUserInteractionEnabled = true
            self.txtSpeciality.isUserInteractionEnabled = true
            self.txtDatePicker.isUserInteractionEnabled = true
        }
        txtReason.resignFirstResponder()
    }
    func cancelPicker()
    {
        UIView.animate(withDuration: 1.0, animations:
        { () -> Void in
            
            let angle = CGFloat(180 * M_PI / 90)
            self.imgspeciality.transform = CGAffineTransform(rotationAngle: angle)
        })
        if pickerView.tag == 1
        {
            
            UIView.animate(withDuration: 1.0, animations: { () -> Void in
                
                let angle = CGFloat(180 * M_PI / 90)
                self.imgspeciality.transform = CGAffineTransform(rotationAngle: angle)
            })
            
            txtSpeciality.resignFirstResponder()
            self.txtLocation.isUserInteractionEnabled = true
            self.txtReason.isUserInteractionEnabled = true
            self.txtDatePicker.isUserInteractionEnabled = true
        }
    }
    func cancelPicker1()
    {
        UIView.animate(withDuration: 1.0, animations:
        { () -> Void in
            
            let angle = CGFloat(180 * M_PI / 90)
            self.imgReason.transform = CGAffineTransform(rotationAngle: angle)
        })
        if pickerViewReason.tag == 2
        {
            txtReason.resignFirstResponder()
            self.txtLocation.isUserInteractionEnabled = true
            self.txtSpeciality.isUserInteractionEnabled = true
            self.txtDatePicker.isUserInteractionEnabled = true
        }
    }
    func callCategoryApi()
    {

        activityIndicatorView.startAnimating()
        self.view.isUserInteractionEnabled = false
 
        let manager = AFHTTPRequestOperationManager()
        manager.responseSerializer.acceptableContentTypes = NSSet(objects: "application/json","text/html") as Set<NSObject>

        manager.get(self.app.baseUrl+"categoryList",
            parameters: nil,
            success: { (operation,
                responseObject) in
                 self.activityIndicatorView.stopAnimating()
                 self.view.isUserInteractionEnabled = true
                
                let element : NSDictionary = responseObject as! NSDictionary
                var status : NSString = element.object(forKey:"status") as! NSString
              
                if status == "Success"
                {
                    self.txtSpeciality.isUserInteractionEnabled = true
                    self.txtReason.isUserInteractionEnabled = true
                    self.txtDatePicker.isUserInteractionEnabled = true
                    self.txtLocation.isUserInteractionEnabled = true

                    self.setpickerView()
                    let arrCategory : NSArray = element.object(forKey:"categoryList") as! NSArray
                    self.objDoctorList.arrSpecialty.removeAllObjects()
                    for dict in arrCategory
                    {
                        self.objDoctorList.arrSpecialty.add((dict as AnyObject).value(forKey: "CategoryName") as! String)
                        self.objDoctorList.arrIdSpeciality.add((dict as AnyObject).value(forKey: "CategoryId") as! NSNumber)
                    }
                }
                else
                {
                    self.activityIndicatorView.stopAnimating()
                    self.view.isUserInteractionEnabled = true
                    self.appObj.strStart = "oopss"
                    var alert : SCLAlertView = SCLAlertView()
                    alert.labelTitle.textColor = UIColor.red
                    alert.labelTitle.alpha = 0.8
                    alert.backgroundType = .Blur
                    alert.showAnimationType = .SlideInFromTop
                    alert.hideAnimationType = .SlideOutToBottom
                    alert.tintTopCircle = true
                    alert.showWaiting(self, title: "Oops!!", subTitle: "Something's not right here. Please try again after a while. We appreciate your patience." , closeButtonTitle: "OK", duration: 3.0)
                }
            },
            failure: { (operation,
                error) in
                
                self.activityIndicatorView.stopAnimating()
                self.view.isUserInteractionEnabled = false
                self.appObj.strStart = "oopss"
                var alert : SCLAlertView = SCLAlertView()
                alert.labelTitle.textColor = UIColor.red
                alert.labelTitle.alpha = 0.8
                alert.backgroundType = .Blur
                alert.showAnimationType = .SlideInFromTop
                alert.hideAnimationType = .SlideOutToBottom
                alert.tintTopCircle = true
                alert.showWaiting(self, title: "Oops!!", subTitle: "Something's not right here. Please try again after a while. We appreciate your patience." , closeButtonTitle: "OK", duration: 3.0)
              
                self.txtSpeciality.isUserInteractionEnabled = false
                self.txtReason.isUserInteractionEnabled = false
                self.txtDatePicker.isUserInteractionEnabled = false
                self.txtLocation.isUserInteractionEnabled = false
            }
        )
    }
    func callApiReason()
    {
           let manager = AFHTTPRequestOperationManager()
            manager.responseSerializer.acceptableContentTypes = NSSet(objects: "application/json","text/html") as Set<NSObject>

            manager.get(self.app.baseUrl+"subCategoryList?Id=\(self.app.categoryId)",
                parameters: nil,
                success: { (operation,
                    responseObject) in
                    self.txtReason.isUserInteractionEnabled = true
                    self.activityIndicatorView.stopAnimating()
                    
                    let element : NSDictionary = responseObject as! NSDictionary
                    
                    var status : NSString = element.object(forKey:"status") as! NSString
                    if status == "Success"
                    {
                        self.activityIndicatorView.stopAnimating()
                        let arrCategory : NSArray = element.object(forKey:"subCategoryList") as! NSArray
                        self.objDoctorList.arrReason.removeAllObjects()
                        for dict in arrCategory
                        {
                            self.objDoctorList.arrId.add((dict as AnyObject).value(forKey: "SubCategoryId") as! NSNumber)
                            self.objDoctorList.arrReason.add((dict as AnyObject).value(forKey: "SubCategoryName") as! String)
                        }
                        self.pickerViewReason.reloadAllComponents()
                    }
                    else
                    {
                        self.activityIndicatorView.stopAnimating()
                        self.appObj.strStart = "oopss"
                        var alert : SCLAlertView = SCLAlertView()
                        alert.labelTitle.textColor = UIColor.red
                        alert.labelTitle.alpha = 0.8
                        alert.backgroundType = .Blur
                        alert.showAnimationType = .SlideInFromTop
                        alert.hideAnimationType = .SlideOutToBottom
                        alert.tintTopCircle = true
                        alert.showWaiting(self, title: "Oops!!", subTitle: "Something's not right here. Please try again after a while. We appreciate your patience." , closeButtonTitle: "OK", duration: 3.0)
                    }
                },
                failure:
                {
                    (operation,
                    error) in
                    self.appObj.strStart = "start"
                  
                    self.activityIndicatorView.stopAnimating()
                    self.appObj.strStart = "oopss"
                    var alert : SCLAlertView = SCLAlertView()
                    alert.labelTitle.textColor = UIColor.red
                    alert.labelTitle.alpha = 0.8
                    alert.backgroundType = .Blur
                    alert.showAnimationType = .SlideInFromTop
                    alert.hideAnimationType = .SlideOutToBottom
                    alert.tintTopCircle = true
                    alert.showWaiting(self, title: "Oops!!", subTitle: "Something's not right here. Please try again after a while. We appreciate your patience." , closeButtonTitle: "OK", duration: 3.0)
                        self.txtReason.isUserInteractionEnabled = false
                }
            )
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if pickerView.tag == 1
        {
            return self.objDoctorList.arrSpecialty.count
        }
        else if pickerViewReason.tag == 2
        {
            return self.objDoctorList.arrReason.count
        }
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        if pickerView == self.pickerView
        {
            return self.objDoctorList.arrSpecialty.object(at: row) as? String
        }
        else if pickerView == self.pickerViewReason
        {
            return self.objDoctorList.arrReason.object(at: row) as? String
        }
        return ""
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if pickerView == self.pickerView
        {
            self.txtSpeciality.text = self.objDoctorList.arrSpecialty.object(at: row) as! String
            self.strSpeciality = self.objDoctorList.arrSpecialty.object(at: row) as! String
            self.app.categoryId = self.objDoctorList.arrIdSpeciality.object(at: row) as! NSNumber
            pickerViewReason.reloadAllComponents()
            self.objDoctorList.arrId.removeAllObjects()
            callApiReason()
            self.txtLocation.isUserInteractionEnabled = true
            self.txtReason.isUserInteractionEnabled = true
            self.txtDatePicker.isUserInteractionEnabled = true
            self.view.endEditing(true)
            UIView.animate(withDuration: 1.0, animations:
            { () -> Void in
            
                let angle = CGFloat(180 * M_PI / 90)
                self.imgspeciality.transform = CGAffineTransform(rotationAngle: angle)
            })
        }
        else if pickerView == self.pickerViewReason
        {
            self.txtReason.text = self.objDoctorList.arrReason.object(at: row) as! String
            self.strReason = self.objDoctorList.arrReason.object(at: row) as! String
            self.app.subcategoryId = self.objDoctorList.arrId.object(at: row) as! NSNumber
            self.view.endEditing(true)
            self.txtLocation.isUserInteractionEnabled = true
            self.txtSpeciality.isUserInteractionEnabled = true
            self.txtDatePicker.isUserInteractionEnabled = true
            UIView.animate(withDuration: 1.0, animations:
            { () -> Void in
                
                let angle = CGFloat(180 * M_PI / 90)
                self.imgReason.transform = CGAffineTransform(rotationAngle: angle)
            })
         }
    }
    @IBAction func btnFindDoctor(_ sender: AnyObject)
    {
        self.txtLocation.resignFirstResponder()
        var scrollpoint : CGPoint
        scrollpoint = CGPoint.zero
        scrollpoint = CGPoint(x: 0.0, y: 0.0)
        self.scrollview.setContentOffset(scrollpoint,animated: true)

        if self.txtSpeciality.text == "" || self.txtReason.text == "" || self.txtDatePicker.text == "" || self.txtLocation.text == ""
        {
            self.appObj.strStart = "oopss"
            var alert : SCLAlertView = SCLAlertView()
            alert.labelTitle.textColor = UIColor.red
            alert.labelTitle.alpha = 0.8
            alert.labelTitle.textColor = UIColor.red
            alert.labelTitle.alpha = 0.8
            alert.backgroundType = .Blur
            alert.showAnimationType = .SlideInFromTop
            alert.hideAnimationType = .SlideOutToBottom
            alert.tintTopCircle = true
            alert.showWaiting(self, title: "Oooppss!!!", subTitle: "Unable to search doctor without search details." , closeButtonTitle: "OK", duration: 3.0)
        }
        else
        {
            self.activityIndicatorView.startAnimating()
            var geocoder = CLGeocoder()
            geocoder.geocodeAddressString(self.txtLocation.text!, completionHandler : { (placemarks, error) -> Void in
                if (error != nil)
                {
                    self.activityIndicatorView.stopAnimating()
                    var alert : SCLAlertView = SCLAlertView()
                    alert.labelTitle.textColor = UIColor.red
                    alert.labelTitle.alpha = 0.8
                    alert.backgroundType = .Blur
                    alert.showAnimationType = .SlideInFromTop
                    alert.hideAnimationType = .SlideOutToBottom
                    alert.tintTopCircle = true
                    alert.showWaiting(self, title: "Oops!!", subTitle: "Something's not right here. Please try again after a while. We appreciate your patience." , closeButtonTitle: "OK", duration: 3.0)
                }
                else
                {
                  //  let placemark : CLPlacemark = placemarks!.last as! CLPlacemark
                    
                    var placemark : CLPlacemark = CLPlacemark(placemark: (placemarks!.last! as CLPlacemark))
                    
                    var region : MKCoordinateRegion = MKCoordinateRegion()
                    region.center.latitude = (placemark.location?.coordinate.latitude)!
                    region.center.longitude = (placemark.location?.coordinate.longitude)!
                    region.span = MKCoordinateSpanMake(0.00725, 0.00725)
                    self.app.latitudeApp = String(stringInterpolationSegment: region.center.latitude)
                    self.app.longitudeApp = String(stringInterpolationSegment: region.center.longitude)
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd-MM-yyyy"
                    let dateObj = dateFormatter.date(from: self.txtDatePicker.text!)
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                    let dateObj1 = dateFormatter.string(from: dateObj!)
                    self.objDoctorList.appointmentDate = dateObj1

                    var params =
                    
                    [   "Latitude" : self.app.latitudeApp,
                        "Longitude" : self.app.longitudeApp,
                        "appointmentDate" : self.objDoctorList.appointmentDate,
                        "CategoryId" : self.app.categoryId,
                        "SubCategoryId": self.app.subcategoryId
                    ] as [String : Any]
                    
                    print(params)
                    let manager = AFHTTPRequestOperationManager()
                    manager.responseSerializer.acceptableContentTypes = NSSet(objects: "application/json","text/html") as Set<NSObject>

                    manager.post(self.appObj.baseUrl+"SearchDoctor",
                        parameters: params,
                        success: { (operation,responseObject) in
                            
                            let element : NSDictionary = responseObject as! NSDictionary
                            
                            var msg : NSString = element.object(forKey:"msg") as! NSString
                            if(((element.object(forKey:"error_code") as AnyObject) as! Int) == 0)
                            {
                                var geocoder = CLGeocoder()
                                geocoder.geocodeAddressString(self.txtLocation.text!, completionHandler : { (placemarks, error) -> Void in
                                    if (error != nil)
                                    {
                                        self.activityIndicatorView.stopAnimating()
                                        var alert : SCLAlertView = SCLAlertView()
                                        alert.labelTitle.textColor = UIColor.red
                                        alert.labelTitle.alpha = 0.8
                                        alert.backgroundType = .Blur
                                        alert.showAnimationType = .SlideInFromTop
                                        alert.hideAnimationType = .SlideOutToBottom
                                        alert.tintTopCircle = true
                                        alert.showWaiting(self, title: "Oops!!", subTitle: "Something's not right here. Please try again after a while. We appreciate your patience." , closeButtonTitle: "OK", duration: 3.0)
                                    }
                                    else
                                    {
                                        
                                        var placemark : CLPlacemark = CLPlacemark(placemark: (placemarks!.last! as CLPlacemark))
                                        
                                       // var placemark : CLPlacemark = placemarks!.last as! CLPlacemark
                                        var region : MKCoordinateRegion = MKCoordinateRegion()
                                        region.center.latitude = (placemark.location?.coordinate.latitude)!
                                        region.center.longitude = (placemark.location?.coordinate.longitude)!
                                        region.span = MKCoordinateSpanMake(0.00725, 0.00725)
                                        self.latitude = String(stringInterpolationSegment: region.center.latitude)
                                        self.longitude = String(stringInterpolationSegment: region.center.longitude)
                                        self.app.latitudeApp = self.latitude
                                        self.app.longitudeApp = self.longitude
                                    
                                        let cell = self.storyboard?.instantiateViewController(withIdentifier: "DoctorViewController") as! DoctorListViewController
                                        let dateFormatter = DateFormatter()
                                        dateFormatter.dateFormat = "dd-MM-yyyy"
                                        let dateObj = dateFormatter.date(from: self.txtDatePicker.text!)
                                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                                        let dateObj1 = dateFormatter.string(from: dateObj!)
                                        cell.objDoctorList.appointmentDate = dateObj1
                                        cell.objDoctorList.subCatId = self.app.subcategoryId
                                        cell.objDoctorList.catId = self.app.categoryId
                                        cell.objDoctorList.latitude = self.app.latitudeApp
                                        cell.objDoctorList.longitude = self.app.longitudeApp
                                        self.activityIndicatorView.stopAnimating()
                                        self.viewSpeciality.isUserInteractionEnabled = true
                                        self.navigationController?.pushViewController(cell, animated: true)
                                    }
                                })
                            }
                            else
                            {
                                self.activityIndicatorView.stopAnimating()
                                self.viewSpeciality.isUserInteractionEnabled  = true
                                self.appObj.strStart = "oopss"
                                var alert : SCLAlertView = SCLAlertView()
                                alert.labelTitle.textColor = UIColor.red
                                alert.labelTitle.alpha = 0.8
                                alert.customViewColor = UIColor.colorApplication()
                                alert.backgroundType = .Blur
                                alert.showAnimationType = .SlideInFromTop
                                alert.hideAnimationType = .SlideOutToBottom
                                alert.tintTopCircle = true
                                alert.showWaiting(self, title: "Sorryyy!!!", subTitle: msg as String , closeButtonTitle: "OK", duration: 3.0)
                            }
                        },
                        failure:
                        {
                            (operation,
                            error) in
                          
                            self.activityIndicatorView.stopAnimating()
                            self.viewSpeciality.isUserInteractionEnabled  = true
                            self.appObj.strStart = "oopss"
                            var alert : SCLAlertView = SCLAlertView()
                            alert.labelTitle.textColor = UIColor.red
                            alert.labelTitle.alpha = 0.8
                            alert.backgroundType = .Blur
                            alert.showAnimationType = .SlideInFromTop
                            alert.hideAnimationType = .SlideOutToBottom
                            alert.tintTopCircle = true
                            alert.showWaiting(self, title: "Oops!!", subTitle: "Something's not right here. Please try again after a while. We appreciate your patience." , closeButtonTitle: "OK", duration: 3.0)
                            
                          }
                    )
                }
            })
        }
    }
    @IBAction func btnCalender(_ sender: AnyObject)
    {
        print("sdsd")
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        
        var strLocation = NSString(format:"%@",self.txtLocation.text!)
        self.handleSearchForSearchString(strLocation)
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        var scrollpoint : CGPoint
        scrollpoint = CGPoint.zero
        if textField == self.txtLocation
        {
            self.txtSpeciality.isUserInteractionEnabled = true
            self.txtReason.isUserInteractionEnabled = true
            self.txtDatePicker.isUserInteractionEnabled = true
            self.btnFindDoctor.isUserInteractionEnabled = true

            tableView.frame  =   CGRect(x: 18, y: 305, width: 268, height: 140)
            textField.resignFirstResponder()
            scrollpoint = CGPoint(x: 0.0, y: 0.0)
        }
        self.scrollview.setContentOffset(scrollpoint,animated: true)
        return true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        var scrollpoint : CGPoint
        scrollpoint = CGPoint.zero
        
        if(textField == self.txtLocation)
        {
            scrollpoint = CGPoint(x: 0.0, y: self.txtLocation.center.y - 48)
            self.txtSpeciality.isUserInteractionEnabled = false
            self.txtReason.isUserInteractionEnabled = false
            self.txtDatePicker.isUserInteractionEnabled = false
            self.btnFindDoctor.isUserInteractionEnabled = false
        }
        else if(textField == self.txtDatePicker)
        {
            self.viewCalender.isHidden = false
            calenderView = Bundle.main.loadNibNamed("Registration", owner: self, options: nil)?[1] as! Registration
            calenderView.btnCalenderNext.addTarget(self, action: #selector(FindDoctorViewController.NextMonth(_:)), for: UIControlEvents.touchUpInside)
            calenderView.btnCalenderPrevious.addTarget(self, action: #selector(FindDoctorViewController.PreviousMonth(_:)), for: UIControlEvents.touchUpInside)
            calenderView.calendarManager = JTCalendarManager()
            calenderView.calendarManager.delegate = self
            calenderView.calendarManager.menuView = calenderView.calendarMenuView
            calenderView.calendarManager.contentView = calenderView.calendarContentView
            calenderView.calendarManager.setDate(Date())
            self.viewCalender.addSubview(calenderView)
            if IS_IPHONE_4_OR_LESS
            {
                self.scrollview.addSubview(self.viewCalender)
            }
            self.txtSpeciality.isUserInteractionEnabled = false
            self.txtReason.isUserInteractionEnabled = false
            self.txtLocation.isUserInteractionEnabled = false
            return false
        }
        else if textField == self.txtReason
        {
            if txtSpeciality.text != ""
            {
                UIView.animate(withDuration: 1.0, animations:
                { () -> Void in
                    
                    let angle = CGFloat(90 * M_PI / 90)
                    self.imgReason.transform = CGAffineTransform(rotationAngle: angle)
                })
                txtReason.inputView = pickerViewReason
                txtReason.inputAccessoryView = toolBar1
                self.txtSpeciality.isUserInteractionEnabled = false
                self.txtLocation.isUserInteractionEnabled = false
                self.txtDatePicker.isUserInteractionEnabled = false
                return true
            }
            else
            {
                if txtSpeciality.isUserInteractionEnabled == false
                {
                    self.txtReason.isUserInteractionEnabled = false
                }
                else
                {
                    self.imgspeciality.image = UIImage(named: "passwordmismatch.png")
                    self.imgspeciality.frame = CGRect(x: self.imgspeciality.frame.origin.x, y: self.imgspeciality.frame.origin.y, width: 11, height: 11)
                }
                return false
            }
        }
        else if textField == self.txtSpeciality
        {
            self.imgspeciality.image = UIImage(named: "Drop.png")
            self.imgspeciality.frame = CGRect(x: self.imgspeciality.frame.origin.x, y: self.imgspeciality.frame.origin.y, width: 11, height: 11)
            UIView.animate(withDuration: 1.0, animations:
            { () -> Void in
                
                let angle = CGFloat(90 * M_PI / 90)
                self.imgspeciality.transform = CGAffineTransform(rotationAngle: angle)
            })
            self.txtLocation.isUserInteractionEnabled = false
            self.txtReason.isUserInteractionEnabled = false
            self.txtDatePicker.isUserInteractionEnabled = false
            return true
        }
        self.scrollview.setContentOffset(scrollpoint,animated: true)
        return true
    }
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 35
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView
    {
        let viewEmpty = UIView()
        if pickerView == self.pickerView
        {
            
            let pickerLabel = UILabel()
            let titleData: AnyObject = self.objDoctorList.arrSpecialty[row] as AnyObject
            let myTitle = NSAttributedString(string: titleData as! String, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 18.0)!,NSForegroundColorAttributeName:UIColor.black])
            pickerLabel.attributedText = myTitle
            pickerLabel.textAlignment = .center
            return pickerLabel
        }
        else if pickerView == self.pickerViewReason
        {
            let pickerLabel = UILabel()
            let titleData: AnyObject = self.objDoctorList.arrReason[row] as AnyObject
            let myTitle = NSAttributedString(string: titleData as! String, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 18.0)!,NSForegroundColorAttributeName:UIColor.black])
            pickerLabel.attributedText = myTitle
            pickerLabel.textAlignment = .center
            return pickerLabel
        }
        return viewEmpty
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat
    {
        return 20.0
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
     }
   
    func NextMonth(_ sender:UIButton!)
    {
        calenderView.calendarContentView.loadNextPageWithAnimation()
    }
    func PreviousMonth(_ sender:UIButton!)
    {
        var dayView = JTCalendarDayView()
        let cal = JTCalendarManager()
        cal.delegate = self
        if cal.dateHelper.date(calenderView.calendarContentView.date, isTheSameMonthThan: Date())
        {}
        else{
            calenderView.calendarContentView.loadPreviousPageWithAnimation()
        }
    }
    func handleSearchForSearchString(_ searchString : NSString)
    {
        self.activityIndicatorView.startAnimating()
        searchQuery.input = searchString as String
        
        searchQuery.fetchPlaces { (places, error) in
        
        if (error != nil)
        {
            self.tableView.isHidden = true
            self.activityIndicatorView.stopAnimating()
            self.txtLocation.resignFirstResponder()
            var scrollpoint : CGPoint
            scrollpoint = CGPoint.zero
            self.scrollview.setContentOffset(scrollpoint,animated: true)
            
            let INTERNET_CONNECTION = "Something's not right here. Please try again after a while. We appreciate your patience."
            self.appObj.strStart = "oopss"
            var alert : SCLAlertView = SCLAlertView()
            alert.labelTitle.textColor = UIColor.red
            alert.labelTitle.alpha = 0.8
            alert.backgroundType = .Blur
            alert.showAnimationType = .SlideInFromTop
            alert.hideAnimationType = .SlideOutToBottom
            alert.tintTopCircle = true
            alert.showWaiting(self, title: "Caution!!", subTitle: INTERNET_CONNECTION , closeButtonTitle: "OK", duration: 3.0)
        }
        else
        {
            self.searchResultPlaces = places! as NSArray
            if self.searchResultPlaces.count == 0
            {
                if IS_IPHONE_4_OR_LESS
                {
                    if self.tableView.isHidden == false
                    {
                        self.btnFindDoctor.isHidden = true
                    }
                }
                
               // self.tableView.frame         =   CGRectMake(18, 62, 268, 140)
                self.tableView.frame         =   CGRect(x: 18, y: self.viewLocation.frame.origin.y+2, width: 268, height: 140)
                self.tableView.delegate      =   self
                self.tableView.dataSource    =   self
                self.tableView.layer.masksToBounds = true
                self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
                self.scrollview.addSubview(self.tableView)
                self.tableView.isHidden = true
                self.activityIndicatorView.stopAnimating()
            }
            else
            {
                self.activityIndicatorView.stopAnimating()
                self.tableView.reloadData()
                self.tableView.isHidden = false
            }
        }
      }
    }
    func placeAtIndexPath(_ indexPath : IndexPath) -> SPGooglePlacesAutocompletePlace
    {
        return self.searchResultPlaces[indexPath.row] as! SPGooglePlacesAutocompletePlace
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.searchResultPlaces.count;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) 
        cell.textLabel!.text = placeAtIndexPath(indexPath).name
        cell.textLabel?.font = UIFont.systemFont(ofSize: 12.0)
        return cell;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
       self.btnFindDoctor.isHidden = false
       self.txtLocation.text = placeAtIndexPath(indexPath).name
       self.tableView.isHidden = true
       self.txtSpeciality.isUserInteractionEnabled = true
       self.txtReason.isUserInteractionEnabled = true
       self.txtDatePicker.isUserInteractionEnabled = true
       self.btnFindDoctor.isUserInteractionEnabled = true
    }
    //calender delegate methods
    func calendarBuildMenuItemView(_ calendar: JTCalendarManager!) -> UIView!
    {
        let label : UILabel = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.white
        return label
    }
    func calendar(_ calendar: JTCalendarManager!, didTouchDayView dayView: UIView)
    {
        var DynamicView=UIView(frame: CGRect(x: 0, y: -20, width: 320, height: 30))
        if let myVeryOwnDayView = dayView as? JTCalendarDayView
        {
            var cal = JTCalendarManager()
            dateselected = myVeryOwnDayView.date
            var currentDate = Date()
            if cal.dateHelper.date(dateselected, isEqualOrAfter: currentDate)
            {
                    myVeryOwnDayView.circleView.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
                    myVeryOwnDayView.circleView.isHidden = false
                    UIView.transition(with: dayView, duration: 0.3, options: UIViewAnimationOptions.curveEaseIn, animations: { () -> Void in
                    myVeryOwnDayView.circleView.transform = CGAffineTransform.identity
                    cal.reload()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd-MM-yyyy"
                    self.txtDatePicker.text = dateFormatter.string(from: self.dateselected)
                
                }, completion: nil)
                UIView.animate(withDuration: 1.5, delay: 0.5, options: UIViewAnimationOptions.transitionCurlUp, animations:
                {
                    self.viewError.alpha = 0.0
                    
                }, completion: nil)

                let delayTime = DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                DispatchQueue.main.asyncAfter(deadline: delayTime)
                {
                    self.calenderView.isHidden = true
                    self.viewCalender.isHidden = true
                    self.txtSpeciality.isUserInteractionEnabled = true
                    self.txtReason.isUserInteractionEnabled = true
                    self.txtLocation.isUserInteractionEnabled = true
                    DynamicView.removeFromSuperview()
                }
            }
            else
            {
                UIView.animate(withDuration: 0.5, delay: 0.5, options: UIViewAnimationOptions.curveEaseIn, animations:
                {
                    self.viewError.alpha = 1.0
                    self.viewError.isHidden = false
                                
                }, completion: nil)
            }
        }
    }
    func calendar(_ calendar: JTCalendarManager!, prepareDayView dayView: UIView!)
    {
        let cal = JTCalendarManager()
        if cal.dateHelper.date(calenderView.calendarContentView.date, isTheSameMonthThan: Date())
        {}
        if let myVeryOwnDayView = dayView as? JTCalendarDayView
        {
            cal.delegate = self
            if cal.dateHelper.date(Date(), isTheSameDayThan: myVeryOwnDayView.date)
            {
                myVeryOwnDayView.circleView.isHidden = false
                myVeryOwnDayView.circleView.backgroundColor = UIColor.red
                myVeryOwnDayView.dotView.backgroundColor = UIColor.colorApplication()
                myVeryOwnDayView.textLabel.textColor = UIColor.white
            }

        }
        
    }
}
