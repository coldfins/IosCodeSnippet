//
//  AppointmentsViewController.swift
//  
//
//  Created by Coldfin Lab on 27/02/16.
//
//

import UIKit

class AppointmentsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,SWTableViewCellDelegate
{

    @IBOutlet weak var imgNoSignIn: UIImageView!
    @IBOutlet weak var btnFindDoctor: UIButton!
    @IBOutlet weak var viewnoAppointment: UIView!
    @IBOutlet weak var btnPast: UIButton!
    @IBOutlet weak var btnFuture: UIButton!
    @IBOutlet weak var btnToday: UIButton!
    @IBOutlet weak var tblAppointments: UITableView!
    @IBOutlet weak var viewNodata: UIView!
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var viewSlider: UIView!
    @IBOutlet weak var viewNavigation: UIView!
    @IBOutlet weak var viewSignIn: UIView!
    @IBOutlet weak var viewAppointment: UIView!
    
    var activityIndicatorView : NVActivityIndicatorView!
    
    var appObj : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var objfuture = FutureAppointmentModel()
    var objpast = FutureAppointmentModel()
    var arrCurrent1 = NSMutableArray()
    var attend: NSNumber = NSNumber()
    var arrCurrent = NSMutableArray()
    var count = NSNumber()
    var strId = NSNumber()
    
    override func viewDidLoad()
    {
        
         activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: self.view.center.y/2,y: self.view.center.x,width: 50,height: 50), type: NVActivityIndicatorType.ballClipRotatePulse, color: UIColor.colorApplication(), padding: NVActivityIndicatorView.DEFAULT_PADDING)
        
        super.viewDidLoad()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white,NSFontAttributeName: UIFont(name: "Helvetica Neue", size: 16)!]
        btnToday.isSelected = true
        btnToday.tintColor = UIColor.clear
        btnToday.setTitleColor(UIColor.white, for: UIControlState.selected)
        var nib1 = UINib(nibName: "CustomCurrentCell", bundle: nil)
        self.tblAppointments.register(nib1, forCellReuseIdentifier: "cellCurrent")
        self.tblAppointments.reloadData()
        self.view.addSubview(activityIndicatorView)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        if IS_IPHONE_4_OR_LESS
        {
            self.tblAppointments.contentInset = UIEdgeInsetsMake(0, 0, 100, 0)
           // self.viewAppointment.frame = CGRectMake(31, 64, 258, 500)
            
        }

   }
   func animateTableCurrent()
   {
        tblAppointments.reloadData()
        
        let cells = tblAppointments.visibleCells
        let tableHeight: CGFloat = tblAppointments.bounds.size.height
        
        for i in cells
        {
            let cell: UITableViewCell = i as! CustomCurrentCell
            cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
        }
        
        var index = 0
        for a in cells
        {
            let cell: UITableViewCell = a as! CustomCurrentCell
            UIView.animate(withDuration: 1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: UIViewAnimationOptions.curveEaseIn,animations:
            {
               cell.transform = CGAffineTransform(translationX: 0, y: 0);
            }, completion: nil)
            
            index += 1
        }
    }
    func animateTablePast()
    {
        tblAppointments.reloadData()
        
        let cells = tblAppointments.visibleCells
        let tableHeight: CGFloat = tblAppointments.bounds.size.height
        
        for i in cells
        {
            let cell: UITableViewCell = i as! CustomPastCell
            cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
        }
        
        var index = 0
        
        for a in cells
        {
            let cell: UITableViewCell = a as! CustomPastCell
            UIView.animate(withDuration: 1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: UIViewAnimationOptions.curveEaseIn, animations:
            {
               cell.transform = CGAffineTransform(translationX: 0, y: 0);
            }, completion: nil)
            
            index += 1
        }
    }
    func animateTableFuture()
    {
        tblAppointments.reloadData()
        
        let cells = tblAppointments.visibleCells
        let tableHeight: CGFloat = tblAppointments.bounds.size.height
        
        for i in cells
        {
            let cell: UITableViewCell = i as! CustomFutureCell
            cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
        }
        
        var index = 0
        for a in cells
        {
            let cell: UITableViewCell = a as! CustomFutureCell
            UIView.animate(withDuration: 1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: UIViewAnimationOptions.curveEaseIn, animations:
            {
               cell.transform = CGAffineTransform(translationX: 0, y: 0);
            }, completion: nil)
            
            index += 1
        }
    }
    @IBAction func btnFindDoctor(_ sender: UIButton)
    {
       tabBarController?.selectedIndex = 0
    }
    override func viewWillAppear(_ animated: Bool)
    {
        
        self.tabBarController?.tabBar.isHidden = false
        self.viewnoAppointment.isHidden = true
        
        
            callApi()
            self.tblAppointments.reloadData()
            self.navigationController?.setNavigationBarHidden(true, animated: false)
            self.viewNavigation.isHidden = false
            self.viewAppointment.isHidden = false
            self.tblAppointments.isHidden = false
            self.viewSignIn.isHidden = true
       
       
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    func callApi()
    {
                self.activityIndicatorView.startAnimating()
                self.view.isUserInteractionEnabled = false
                self.strId = 12187
                let manager = AFHTTPRequestOperationManager()
                manager.responseSerializer.acceptableContentTypes = NSSet(objects: "application/json","text/html") as Set<NSObject>

                manager.get(self.appObj.baseUrl+"PatientAppointmentlist?UserId=\(self.strId)",
                parameters: nil,
                success: { (operation,
                    responseObject) in
                    self.activityIndicatorView.stopAnimating()
                    self.view.isUserInteractionEnabled = true
                    self.tblAppointments.isHidden = false

                    var arrResponse : NSDictionary = responseObject as! NSDictionary
                    
                    if((arrResponse.object(forKey: "error_code") as! Int) == 0)
                    {
                        
                        self.tblAppointments.isHidden = false
                        if let strResponse = arrResponse.object(forKey: "customerAppointmentData") as? NSArray
                        {
                            self.appObj.arrPastAppointment.removeAllObjects()
                            self.appObj.arrCurrentAppointment.removeAllObjects()
                            self.appObj.arrFutureAppointment.removeAllObjects()
                            for dict in strResponse
                            {
                                var v = (dict as AnyObject).value(forKey: "AppointmentDate") as! String
                                self.arrCurrent.add(v)
                                
                                let datef = DateFormatter()
                                datef.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                                var p = v.components(separatedBy: "T")
                                var strApi = datef.date(from: v)
                                var dateApi : String = p[0]
                                let curr = Date()
                                var t = datef.string(from: curr)
                                var p1 = t.components(separatedBy: "T")
                                var currentDate : String = p1[0]
                                if dateApi.compare(currentDate) == ComparisonResult.orderedDescending
                                {
                                    var objFutureAppointment : FutureAppointmentModel = FutureAppointmentModel()
                                    objFutureAppointment.futurefirstName = (dict as AnyObject).value(forKey: "FirstName") as! String
                                    objFutureAppointment.futurelastName = (dict as AnyObject).value(forKey: "LastName") as! String
                                    objFutureAppointment.futureEmail = (dict as AnyObject).value(forKey: "Email") as! String
                                    objFutureAppointment.futureStartTime = (dict as AnyObject).value(forKey: "StartTime") as! String
                                    objFutureAppointment.futureEndTime = (dict as AnyObject).value(forKey: "EndTime") as! String
                                    objFutureAppointment.futureAppointmentDate = (dict as AnyObject).value(forKey: "AppointmentDate") as! String
                                    objFutureAppointment.futureAttend = (dict as AnyObject).value(forKey: "Attend") as! NSNumber
                                    objFutureAppointment.futureClinicName = (dict as AnyObject).value(forKey: "ClinicName") as! String
                                    objFutureAppointment.futureSubCategory = (dict as AnyObject).value(forKey: "SubCategoryName") as! String
                                    objFutureAppointment.futureAddress = (dict as AnyObject).value(forKey: "ClinicAddress") as! String
                                    objFutureAppointment.futureImage = (dict as AnyObject).value(forKey: "UserImage") as! String
                                    objFutureAppointment.futureAppointmentId = (dict as AnyObject).value(forKey: "AppointmentId") as! NSNumber
                                    objFutureAppointment.futureDiseasesImage = (dict as AnyObject).value(forKey: "DiseasesImage") as! String
                                    self.appObj.arrFutureAppointment.add(objFutureAppointment)
                                }
                                else
                                    if dateApi.compare(currentDate) == ComparisonResult.orderedAscending
                                    {
                                        var objFutureAppointment :FutureAppointmentModel = FutureAppointmentModel()
                                        objFutureAppointment.pastfirstName = (dict as AnyObject).value(forKey: "FirstName") as! String
                                        objFutureAppointment.pastlastName = (dict as AnyObject).value(forKey: "LastName") as! String
                                        objFutureAppointment.pastFees = (dict as AnyObject).value(forKey: "ConsultationFees") as! NSNumber
                                        objFutureAppointment.pastStartTime = (dict as AnyObject).value(forKey: "StartTime") as! String
                                        objFutureAppointment.pastClinicName = (dict as AnyObject).value(forKey: "ClinicName") as! String
                                        objFutureAppointment.pastSubCategory = (dict as AnyObject).value(forKey: "SubCategoryName") as! String
                                        objFutureAppointment.pastEndTime = (dict as AnyObject).value(forKey: "EndTime") as! String
                                        objFutureAppointment.pastAppointmentDate = (dict as AnyObject).value(forKey: "AppointmentDate") as! String
                                        objFutureAppointment.pastAttend = (dict as AnyObject).value(forKey: "Attend") as! NSNumber
                                        objFutureAppointment.pastAddress = (dict as AnyObject).value(forKey: "ClinicAddress") as! String
                                        objFutureAppointment.pastImage = (dict as AnyObject).value(forKey: "UserImage") as! String
                                        objFutureAppointment.pastAppointmentId = (dict as AnyObject).value(forKey: "AppointmentId") as! NSNumber
                                        objFutureAppointment.pastDiseasesImage = (dict as AnyObject).value(forKey: "DiseasesImage") as! String
                                        self.appObj.arrPastAppointment.add(objFutureAppointment)
                                    }
                                    else
                                    {
                                        var objFutureAppointment :FutureAppointmentModel = FutureAppointmentModel()
                                        objFutureAppointment.currentfirstName = (dict as AnyObject).value(forKey: "FirstName") as! String
                                        objFutureAppointment.currentlastName = (dict as AnyObject).value(forKey: "LastName") as! String
                                        objFutureAppointment.currentEmail = (dict as AnyObject).value(forKey: "Email") as! String
                                        objFutureAppointment.currentStartTime = (dict as AnyObject).value(forKey: "StartTime") as! String
                                        objFutureAppointment.currentEndTime = (dict as AnyObject).value(forKey: "EndTime") as! String
                                        objFutureAppointment.currentClinicName = (dict as AnyObject).value(forKey: "ClinicName") as! String
                                        objFutureAppointment.currentSubCategory = (dict as AnyObject).value(forKey: "SubCategoryName") as! String
                                        objFutureAppointment.currentAppointmentDate = (dict as AnyObject).value(forKey: "AppointmentDate") as! String
                                        objFutureAppointment.currentAddress = (dict as AnyObject).value(forKey: "ClinicAddress") as! String
                                        objFutureAppointment.currentAppointmentId = (dict as AnyObject).value(forKey: "AppointmentId") as! NSNumber
                                        objFutureAppointment.currentImage = (dict as AnyObject).value(forKey: "UserImage") as! String
                                        objFutureAppointment.currentAttend = (dict as AnyObject).value(forKey: "Attend") as! NSNumber
                                        objFutureAppointment.currentDiseasesImage = (dict as AnyObject).value(forKey: "DiseasesImage") as! String
                                        self.appObj.arrCurrentAppointment.add(objFutureAppointment)
                                   }
                                self.tblAppointments.reloadData()
                                if self.btnToday.isSelected == true
                                {
                                    if self.appObj.arrCurrentAppointment.count == 0
                                    {
                                        self.viewnoAppointment.isHidden = false
                                    }
                                    else
                                    {
                                        self.viewnoAppointment.isHidden = true
                                    }
                                }
                                else if self.btnPast.isSelected == true
                                {
                                    if self.appObj.arrPastAppointment.count == 0
                                    {
                                        self.viewnoAppointment.isHidden = false
                                    }
                                    else
                                    {
                                        self.viewnoAppointment.isHidden = true
                                    }
                                }
                                else if self.btnFuture.isSelected == true
                                {
                                    if self.appObj.arrFutureAppointment.count == 0
                                    {
                                        self.viewnoAppointment.isHidden = false
                                    }
                                    else
                                    {
                                        self.viewnoAppointment.isHidden = true
                                    }
                                }
                            }
                        }
                        else
                        {
                            self.viewAppointment.isHidden = true
                            self.tblAppointments.isHidden = true
                            self.viewnoAppointment.isHidden = false
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
                    }
                    else
                    {
                        self.activityIndicatorView.stopAnimating()
                        self.view.isUserInteractionEnabled = true
                        self.tblAppointments.isHidden = true
                        self.viewnoAppointment.isHidden = false
                    }
                },
                failure:
                {
                    (operation,
                    error) in
                    //println("Error: " + error.localizedDescription)
                    self.activityIndicatorView.stopAnimating()
                    self.appObj.strStart = "oopss"
                    
                    self.view.isUserInteractionEnabled = true
                    var alert : SCLAlertView = SCLAlertView()
                    alert.labelTitle.textColor = UIColor.red
                    alert.labelTitle.alpha = 0.8
                    alert.backgroundType = .Blur
                    alert.showAnimationType = .SlideInFromTop
                    alert.hideAnimationType = .SlideOutToBottom
                    alert.tintTopCircle = true
                    alert.showWaiting(self, title: "Oops!!", subTitle: "Something's not right here. Please try again after a while. We appreciate your patience." , closeButtonTitle: "OK", duration: 3.0)
                    self.viewAppointment.isHidden = true
                    self.tblAppointments.isHidden = true
                    //self.viewnoAppointment.hidden = false
            })
    }
   
    @IBAction func PastAppointments(_ sender: UIButton)
    {
        self.btnPast.isSelected = true
        self.btnToday.isSelected = false
        self.btnFuture.isSelected = false
        if btnPast.isSelected == true
        {
            btnFuture.isSelected = false
            btnToday.isSelected = false
            if self.appObj.arrPastAppointment.count == 0
            {
                self.viewnoAppointment.isHidden = false
            }
            else
            {
                self.viewnoAppointment.isHidden = true
            }
        }
        let nib1 = UINib(nibName: "CustomPastCell", bundle: nil)
        self.tblAppointments.register(nib1, forCellReuseIdentifier: "cellPast")
        self.tblAppointments.reloadData()
        animateTablePast()
        btnPast.tintColor = UIColor.clear
        btnPast.setTitleColor(UIColor.white, for: UIControlState.selected)
       
        UIView.animate(withDuration: 0.5,
        animations:
        {
            self.viewSlider.frame = CGRect(x: 225,y: 35,width: 90,height: 3)
        },
        completion: { finished in
        })
        
    }
    @IBAction func CurrentAppointments(_ sender: UIButton)
    {
        self.btnPast.isSelected = false
        self.btnToday.isSelected = true
        self.btnFuture.isSelected = false
        btnToday.tintColor = UIColor.clear
        btnToday.setTitleColor(UIColor.white, for: UIControlState.selected)
        if self.appObj.arrCurrentAppointment.count == 0
        {
            self.viewnoAppointment.isHidden = false
        }
        else
        {
            self.viewnoAppointment.isHidden = true
        }
        self.tblAppointments.reloadData()
        animateTableCurrent()
        
        UIView.animate(withDuration: 0.5,
        animations:
        {
            self.viewSlider.frame = CGRect(x: 9,y: 35,width: 90,height: 3)
        },
        completion: { finished in
        })
    }
    
    @IBAction func FutureAppointments(_ sender: UIButton)
    {
        self.btnFuture.isSelected = true
        self.btnPast.isSelected = false
        self.btnToday.isSelected = false
        if btnFuture.isSelected == true
        {
            btnToday.isSelected = false
            btnPast.isSelected = false
            if self.appObj.arrFutureAppointment.count == 0
            {
                self.viewnoAppointment.isHidden = false
            }
            else
            {
                self.viewnoAppointment.isHidden = true
            }
        }
        let nib2 = UINib(nibName: "CustomFutureCell", bundle: nil)
        self.tblAppointments.register(nib2, forCellReuseIdentifier: "cellFuture")
        self.tblAppointments.reloadData()
        animateTableFuture()
        btnFuture.tintColor = UIColor.clear
        btnFuture.setTitleColor(UIColor.white, for: UIControlState.selected)
        UIView.animate(withDuration: 0.5,
        animations:
        {
            self.viewSlider.frame = CGRect(x: 118,y: 35,width: 90,height: 3)
        },
        completion: { finished in
        })
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if self.btnToday.isSelected == true
        {
            return self.appObj.arrCurrentAppointment.count
        }
        if self.btnPast.isSelected == true
        {
            return self.appObj.arrPastAppointment.count
        }
        if self.btnFuture.isSelected == true
        {
            return self.appObj.arrFutureAppointment.count
        }
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 83
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell1 = UITableViewCell()
        if btnToday.isSelected == true
        {
                var cell:CustomCurrentCell! = tableView.dequeueReusableCell(withIdentifier: "cellCurrent") as! CustomCurrentCell
                
                if cell == nil
                {
                    cell = tableView.dequeueReusableCell(withIdentifier: "cellCurrent") as! CustomCurrentCell
                }
                
                cell.tag = indexPath.row
                let objcurrent = self.appObj.arrCurrentAppointment.object(at: indexPath.row) as! FutureAppointmentModel
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                let dateObj = dateFormatter.date(from: objcurrent.currentStartTime as String)
                let dateObj2 = dateFormatter.date(from: objcurrent.currentAppointmentDate as String)
                dateFormatter.dateFormat = "EEE, MMM dd, yyyy"
                let convertedAppointmentTime = dateFormatter.string(from: dateObj2!)
                dateFormatter.dateFormat = "HH:mm a"
                let converteddate = dateFormatter.string(from: dateObj!)
                cell.lblFirstName.text = "Appointment with Dr." + " " + (objcurrent.currentfirstName + " " + objcurrent.currentlastName) as String
                cell.lblAppointmentTime.text = convertedAppointmentTime + " " + converteddate
                cell.lblAddress.text = objcurrent.currentAddress as String
                cell.imgDoctor.layer.cornerRadius = cell.imgDoctor.frame.size.height/2
                cell.imgDoctor.clipsToBounds = true
                cell.imgDoctor.layer.borderWidth = 0.5
                cell.imgDoctor.layer.borderColor = UIColor.lightGray.cgColor
                cell.imgDoctor.setImageWith(URL(string: objcurrent.currentImage as String), placeholderImage:UIImage(named: "user_blank.png"))
                self.attend = objcurrent.currentAttend as NSNumber
                if self.attend == 1
                {
                    cell.imgAttend.image = UIImage(named: "Accepted.png")
                    let rightUtilityButtons = NSMutableArray()
                    rightUtilityButtons.sw_addUtilityButton(with: UIColor(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0), icon: UIImage(named: "Delete60.png"))
                    cell.rightUtilityButtons = rightUtilityButtons as [AnyObject]
                }
                else if self.attend == 0
                {
                    cell.imgAttend.image = UIImage(named: "Panding.png")
                    let rightUtilityButtons = NSMutableArray()
                    rightUtilityButtons.sw_addUtilityButton(with: UIColor(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0), icon: UIImage(named: "Delete60.png"))
                    cell.rightUtilityButtons = rightUtilityButtons as [AnyObject]
                }
                else if self.attend == 2
                {
                    cell.rightUtilityButtons = nil
                    cell.imgAttend.image = UIImage(named: "Rejected.png")
                }
                cell.selectionStyle = UITableViewCellSelectionStyle.none
                cell.delegate = self
                return cell
        }
        if btnPast.isSelected == true
        {
                var cell:CustomPastCell! = tableView.dequeueReusableCell(withIdentifier: "cellPast") as! CustomPastCell
                
                if cell == nil
                {
                    cell = tableView.dequeueReusableCell(withIdentifier: "cellPast") as! CustomPastCell
                }
            
                cell.tag = indexPath.row
                objpast = self.appObj.arrPastAppointment.object(at: indexPath.row) as! FutureAppointmentModel
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                let dateObj = dateFormatter.date(from: objpast.pastStartTime as String)
                let dateObj2 = dateFormatter.date(from: objpast.pastAppointmentDate as String)
                dateFormatter.dateFormat = "EEE, MMM dd, yyyy"
                let convertedAppointmentTime = dateFormatter.string(from: dateObj2!)
                dateFormatter.dateFormat = "HH:mm a"
                let converteddate = dateFormatter.string(from: dateObj!)
                cell.lblFirstName.text = "Appointment with Dr." + " " + (objpast.pastfirstName + " " + objpast.pastlastName) as String
                cell.lblAppointmentTime.text = convertedAppointmentTime + " " + converteddate
                cell.lblAddress.text = objpast.pastAddress as String
                cell.imgDoctor.layer.cornerRadius = cell.imgDoctor.frame.size.height/2
                cell.imgDoctor.clipsToBounds = true
                cell.imgDoctor.layer.borderWidth = 0.5
                cell.imgDoctor.layer.borderColor = UIColor.lightGray.cgColor
                cell.imgDoctor.setImageWith(URL(string: objpast.pastImage as String), placeholderImage:UIImage(named: "user_blank.png"))
            
                let attendpast = objpast.pastAttend as NSNumber
                if attendpast == 1
                {
                    cell.imgAttend.image = UIImage(named: "Accepted.png")
                    let rightUtilityButtons = NSMutableArray()
                    rightUtilityButtons.sw_addUtilityButton(with: UIColor(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0), icon: UIImage(named: "Delete60.png"))
                    cell.rightUtilityButtons = rightUtilityButtons as [AnyObject]
                }
                else if attendpast == 0
                {
                    cell.imgAttend.image = UIImage(named: "Panding.png")
                    let rightUtilityButtons = NSMutableArray()
                    rightUtilityButtons.sw_addUtilityButton(with: UIColor(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0), icon: UIImage(named: "Delete60.png"))
                    cell.rightUtilityButtons = rightUtilityButtons as [AnyObject]
                }
                else if attendpast == 2
                {
                    cell.imgAttend.image = UIImage(named: "Rejected.png")
                    let rightUtilityButtons = NSMutableArray()
                    rightUtilityButtons.sw_addUtilityButton(with: UIColor(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0), icon: UIImage(named: "Delete60.png"))
                    cell.rightUtilityButtons = rightUtilityButtons as [AnyObject]
                }
               
                cell.selectionStyle = UITableViewCellSelectionStyle.none
                cell.delegate = self
                return cell
        }
        if btnFuture.isSelected == true
        {
                var cell:CustomFutureCell! = tableView.dequeueReusableCell(withIdentifier: "cellFuture") as! CustomFutureCell
                
                if cell == nil
                {
                    cell = tableView.dequeueReusableCell(withIdentifier: "cellFuture") as! CustomFutureCell
                }
                cell.tag = indexPath.row
                
                objfuture = self.appObj.arrFutureAppointment.object(at: indexPath.row) as! FutureAppointmentModel
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                let dateObj = dateFormatter.date(from: objfuture.futureStartTime as String)
                let dateObj2 = dateFormatter.date(from: objfuture.futureAppointmentDate as String)
                dateFormatter.dateFormat = "EEE, MMM dd, yyyy"
                let convertedAppointmentTime = dateFormatter.string(from: dateObj2!)
                dateFormatter.dateFormat = "HH:mm a"
                let converteddate = dateFormatter.string(from: dateObj!)
                cell.lblFirstName.text = "Appointment with Dr." + " " + (objfuture.futurefirstName + " " + objfuture.futurelastName) as String
                cell.lblAppointmentTime.text = convertedAppointmentTime + " " + converteddate
                cell.lblAddress.text = objfuture.futureAddress as String
                cell.imgDoctor.layer.cornerRadius = cell.imgDoctor.frame.size.height/2
                cell.imgDoctor.clipsToBounds = true
                cell.imgDoctor.layer.borderWidth = 0.5
                cell.imgDoctor.layer.borderColor = UIColor.lightGray.cgColor
                cell.imgDoctor.setImageWith(URL(string: objfuture.futureImage as String), placeholderImage:UIImage(named: "user_blank.png"))
                let attend = objfuture.futureAttend as NSNumber
                if attend == 1
                {
                    cell.imgAttend.image = UIImage(named: "Accepted.png")
                    let rightUtilityButtons = NSMutableArray()
                    rightUtilityButtons.sw_addUtilityButton(with: UIColor(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0), icon: UIImage(named: "Delete60.png"))
                    rightUtilityButtons.sw_addUtilityButton(with: UIColor(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0), icon: UIImage(named: "Reminder60.png"))
                    cell.rightUtilityButtons = rightUtilityButtons as [AnyObject]
                }
                else if attend == 0
                {
                    cell.imgAttend.image = UIImage(named: "Panding.png")
                    let rightUtilityButtons = NSMutableArray()
                    rightUtilityButtons.sw_addUtilityButton(with: UIColor(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0), icon: UIImage(named: "Delete60.png"))
                    cell.rightUtilityButtons = rightUtilityButtons as [AnyObject]
                }
                else if attend == 2
                {
                    cell.rightUtilityButtons = nil
                    cell.imgAttend.image = UIImage(named: "Rejected.png")
                }
                cell.selectionStyle = UITableViewCellSelectionStyle.none
                cell.delegate = self
                return cell
        }
           return cell1
    }
    func swipeableTableViewCell(_ cell: SWTableViewCell!, didTriggerRightUtilityButtonWith index: Int)
    {
        if btnPast.isSelected == true
        {
            switch(index)
            {
            case 0:
            
                var model = self.appObj.arrPastAppointment.object(at: cell.tag) as! FutureAppointmentModel
                var alertController = UIAlertController(title:"\n\nDo you really want to delete this appointment??\n\n", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
                
                let margin:CGFloat = 8.0
                let rect = CGRect(x: margin, y: margin, width: alertController.view.bounds.size.width - margin * 4.0, height: 100.0)
                var customView = UIView(frame: rect)
                
                customView.alpha = 0.5
                customView.tintColor = UIColor.colorApplication()
            
                alertController.view.addSubview(customView)
                
                let somethingAction = UIAlertAction(title: "\u{2713} Delete", style: UIAlertActionStyle.default, handler: {(alert: UIAlertAction!) in
                                            self.activityIndicatorView.startAnimating()
                                            self.view.isUserInteractionEnabled = false
                                            let manager = AFHTTPRequestOperationManager()
                                            manager.responseSerializer.acceptableContentTypes = NSSet(objects: "application/json","text/html") as Set<NSObject>
                    
                                            manager.get(self.appObj.baseUrl+"DeleteAppointment?AppointmentId=\(model.pastAppointmentId)",
                                                parameters: nil,
                                                success: { (operation,
                                                    responseObject) in
                                                   // print(responseObject.description)
                                                    self.activityIndicatorView.stopAnimating()
                                                    self.view.isUserInteractionEnabled = true
                                                    var alert : SCLAlertView = SCLAlertView()
                                                    self.appObj.strStart = "yipee"
                                                    alert.labelTitle.textColor = UIColor(red: 81.0/255.0, green: 210.0/255.0, blue: 80.0/255.0, alpha: 1.0)
                                                    alert.backgroundType = .Blur
                                                    alert.showAnimationType = .SlideInFromTop
                                                    alert.hideAnimationType = .SlideOutToBottom
                                                    alert.tintTopCircle = true
                                                    alert.showWaiting(self, title: "DoctFin", subTitle: "Appointment no longer exists...Deleted successfully!!" , closeButtonTitle: "OK", duration: 3.0)
                                                 
                                                    
                                                    self.appObj.arrPastAppointment.removeObject(at: cell.tag)
                                                    self.tblAppointments.reloadData()
                                                },
                                                failure: {
                                                    (operation,
                                                    error) in
                                                   // println("Error: " + error.localizedDescription)
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
                                            )
                })
                
                let cancelAction = UIAlertAction(title: "\u{2717} Cancel", style: UIAlertActionStyle.cancel, handler: {(alert: UIAlertAction!) in })
                alertController.addAction(somethingAction)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion:{})
                break
                
            default:
                break
            }

        }
        if btnFuture.isSelected == true
        {
            switch(index)
            {
            case 0:
                var model = self.appObj.arrFutureAppointment.object(at: cell.tag) as! FutureAppointmentModel
                var alertController = UIAlertController(title:"\n\nDo you really want to delete this appointment??\n\n", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
                
                let margin:CGFloat = 8.0
                let rect = CGRect(x: margin, y: margin, width: alertController.view.bounds.size.width - margin * 4.0, height: 100.0)
                var customView = UIView(frame: rect)
                
                customView.alpha = 0.5
                customView.tintColor = UIColor.colorApplication()
                
                alertController.view.addSubview(customView)
                
                                let somethingAction = UIAlertAction(title: "\u{2713} Delete", style: UIAlertActionStyle.default, handler: {(alert: UIAlertAction!) in
                                    self.activityIndicatorView.startAnimating()
                                    self.view.isUserInteractionEnabled = false
                                    let manager = AFHTTPRequestOperationManager()
                                    manager.responseSerializer.acceptableContentTypes = NSSet(objects: "application/json","text/html") as Set<NSObject>
                                    manager.get(self.appObj.baseUrl+"DeleteAppointment?AppointmentId=\(model.futureAppointmentId)",
                                        parameters: nil,
                                        success:
                                        {
                                            (operation,
                                            responseObject) in
                                            self.activityIndicatorView.stopAnimating()
                                            self.view.isUserInteractionEnabled = true
                                            self.appObj.strStart = "yipee"
                                            var alert : SCLAlertView = SCLAlertView()
                                            alert.labelTitle.textColor = UIColor(red: 81.0/255.0, green: 210.0/255.0, blue: 80.0/255.0, alpha: 1.0)
                                            alert.backgroundType = .Blur
                                            alert.showAnimationType = .SlideInFromTop
                                            alert.hideAnimationType = .SlideOutToBottom
                                            alert.tintTopCircle = true
                                            alert.showWaiting(self, title: "DoctFin", subTitle: "Appointment no longer exists...Deleted successfully!!" , closeButtonTitle: "OK", duration: 3.0)
                                            self.appObj.arrFutureAppointment.removeObject(at: cell.tag)
                                            self.tblAppointments.reloadData()
                                        },
                                        failure:
                                        {
                                            (operation,
                                            error) in
                                           // println("Error: " + error.localizedDescription)
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
                                    )
                                 })
                let cancelAction = UIAlertAction(title: "\u{2717} Cancel", style: UIAlertActionStyle.cancel, handler: {(alert: UIAlertAction!) in })
                alertController.addAction(somethingAction)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion:{})
                break
                
            case 1:
                
                var model = self.appObj.arrFutureAppointment.object(at: cell.tag) as! FutureAppointmentModel
                var alertController1 = UIAlertController(title:"\n\nDo you really want to add reminder??\n\n", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
                
                let margin:CGFloat = 1.0
                let rect = CGRect(x: margin, y: margin, width: alertController1.view.bounds.size.width - margin * 4.0, height: 50.0)
                var customView = UIView(frame: rect)
                customView.alpha = 0.5
                customView.tintColor = UIColor.white
                alertController1.view.addSubview(customView)
                
                let somethingAction1 = UIAlertAction(title: "Add Reminder", style: UIAlertActionStyle.default, handler:
                {(alert: UIAlertAction!) in
                 
                    let controller = self.storyboard?.instantiateViewController(withIdentifier: "AddReminderViewController") as! AddReminderViewController
                    controller.apptTime = model.futureAppointmentDate as String
                    controller.appointmentTime = model.futureStartTime as String
                    controller.firstname = model.futurefirstName
                    controller.attend = model.futureAttend
                    controller.clinicname = model.futureClinicName
                    controller.reason = model.futureSubCategory
                    controller.modalPresentationStyle = UIModalPresentationStyle.custom
                    controller.providesPresentationContextTransitionStyle = true
                    controller.definesPresentationContext = true
                    self.present(controller, animated: true, completion: nil)
                })
               
                let cancelAction1 = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: {(alert: UIAlertAction!) in print("cancel")})
                 alertController1.addAction(somethingAction1)
                alertController1.addAction(cancelAction1)
                self.present(alertController1, animated: true, completion:{})
                break
                
                
            default:
                break
            }

        }
        else if btnToday.isSelected == true
        {
            switch(index)
            {
            case 0:
                
                var model = self.appObj.arrCurrentAppointment.object(at: cell.tag) as! FutureAppointmentModel
                var alertController = UIAlertController(title:"\n\nDo you really want to delete this appointment??\n\n", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
                
                let margin:CGFloat = 8.0
                let rect = CGRect(x: margin, y: margin, width: alertController.view.bounds.size.width - margin * 4.0, height: 100.0)
                var customView = UIView(frame: rect)
                
                customView.alpha = 0.5
                customView.tintColor = UIColor.colorApplication()
                
                alertController.view.addSubview(customView)
                
                let somethingAction = UIAlertAction(title: "\u{2713} Delete", style: UIAlertActionStyle.default, handler: {(alert: UIAlertAction!) in
                    self.activityIndicatorView.startAnimating()
                    self.view.isUserInteractionEnabled = false
                    let manager = AFHTTPRequestOperationManager()
                    manager.responseSerializer.acceptableContentTypes = NSSet(objects: "application/json","text/html") as Set<NSObject>
                    manager.get(self.appObj.baseUrl+"DeleteAppointment?AppointmentId=\(model.currentAppointmentId)",
                        parameters: nil,
                        success:
                        {
                            (operation,
                            responseObject) in
                            self.activityIndicatorView.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                            self.appObj.strStart = "yipee"
                            var alert : SCLAlertView = SCLAlertView()
                            alert.labelTitle.textColor = UIColor(red: 81.0/255.0, green: 210.0/255.0, blue: 80.0/255.0, alpha: 1.0)
                            alert.backgroundType = .Blur
                            alert.showAnimationType = .SlideInFromTop
                            alert.hideAnimationType = .SlideOutToBottom
                            alert.tintTopCircle = true
                            alert.showWaiting(self, title: "DoctFin", subTitle: "Appointment no longer exists...Deleted successfully!!" , closeButtonTitle: "OK", duration: 3.0)
                            self.appObj.arrCurrentAppointment.removeObject(at: cell.tag)
                            self.tblAppointments.reloadData()
                        },
                        failure:
                        {
                            (operation,
                            error) in
                           // println("Error: " + error.localizedDescription)
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
                    )
                })
                
                let cancelAction = UIAlertAction(title: "\u{2717} Cancel", style: UIAlertActionStyle.cancel, handler: {(alert: UIAlertAction!) in })
                alertController.addAction(somethingAction)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion:{})
                break
                
            default:
                break
            }
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if btnFuture.isSelected == true
        {
            let model = self.appObj.arrFutureAppointment.object(at: indexPath.row) as! FutureAppointmentModel
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "AppointmentDetailViewController") as! AppointmentDetailViewController
            controller.apptdetailobj.name = model.futurefirstName + " " + model.futurelastName
            controller.apptdetailobj.address = model.futureAddress
            controller.apptdetailobj.clinic = model.futureClinicName
            controller.apptdetailobj.date = model.futureAppointmentDate
            controller.apptdetailobj.starttime = model.futureStartTime
            controller.apptdetailobj.endtime = model.futureEndTime
            controller.apptdetailobj.reason = model.futureSubCategory
            controller.apptdetailobj.image = model.futureImage
            controller.imagearr.add(model.futureDiseasesImage)
            controller.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
            self.present(controller, animated: true, completion: nil)
        }
        if btnToday.isSelected == true
        {
            let model = self.appObj.arrCurrentAppointment.object(at: indexPath.row) as! FutureAppointmentModel
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "AppointmentDetailViewController") as! AppointmentDetailViewController
            controller.apptdetailobj.name = model.currentfirstName + " " + model.currentlastName
            controller.apptdetailobj.address = model.currentAddress
            controller.apptdetailobj.clinic = model.currentClinicName
            controller.apptdetailobj.date = model.currentAppointmentDate
            controller.apptdetailobj.starttime = model.currentStartTime
            controller.apptdetailobj.endtime = model.currentEndTime
            controller.apptdetailobj.reason = model.currentSubCategory
            controller.apptdetailobj.image = model.currentImage
            controller.imagearr.add(model.currentDiseasesImage)
            controller.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
            self.present(controller, animated: true, completion: nil)
        }
        
        if btnPast.isSelected == true
        {
            let model = self.appObj.arrPastAppointment.object(at: indexPath.row) as! FutureAppointmentModel
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "AppointmentDetailViewController") as! AppointmentDetailViewController
            controller.apptdetailobj.name = model.pastfirstName + " " + model.pastlastName
            controller.apptdetailobj.address = model.pastAddress
            controller.apptdetailobj.clinic = model.pastClinicName
            controller.apptdetailobj.date = model.pastAppointmentDate
            controller.apptdetailobj.starttime = model.pastStartTime
            controller.apptdetailobj.endtime = model.pastEndTime
            controller.apptdetailobj.reason = model.pastSubCategory
            controller.apptdetailobj.image = model.pastImage
            controller.imagearr.add(model.pastDiseasesImage)
            controller.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
            self.present(controller, animated: true, completion: nil)
        }
    }
    
}

