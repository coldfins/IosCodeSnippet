//
//  DoctorListViewController.swift
//  
//
//  Created by Coldfin Lab on 13/02/16.
//
//

import UIKit

class DoctorListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate
{
    var arr1 = NSMutableArray()
    var position : Int = Int()
    var arr : Int = Int()
    var array : String = String()
    var str : String = String()
    var strEndTime = String()
    var strAppointmentDate = String()
    var convertedDate : String = String()
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    var imageDownloadsInProgress : NSMutableDictionary = NSMutableDictionary()
    var objDoctorList : DoctorListModel = DoctorListModel()
    var appObj : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var collectionViewArray1 : AnyObject = "" as AnyObject
    var collectionViewArrayDate : AnyObject = "" as AnyObject
    var collectionViewArray : AnyObject = "" as AnyObject
    var activityIndicatorView : NVActivityIndicatorView!
    
    @IBOutlet weak var tblDoctorlist: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let sendButton = UIBarButtonItem(title: "Map", style: UIBarButtonItemStyle.plain, target: self, action: #selector(DoctorListViewController.sendMap))
        self.navigationItem.rightBarButtonItem = sendButton
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Helvetica Neue", size: 14)!], for: UIControlState())
        let button: UIButton = UIButton(type:UIButtonType.custom)
        button.setImage(UIImage(named: "Back_arrow.png"), for: UIControlState())
        button.addTarget(self, action: #selector(DoctorListViewController.Cancelbtn), for: UIControlEvents.touchUpInside)
        button.frame = CGRect(x: 8,y: 22,width: 68,height: 30)
        button.contentEdgeInsets = UIEdgeInsetsMake(0, -40, 0, 0)
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.tintColor = UIColor.white
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = barButton
        self.navigationItem.title = "Search Results"
        var nib = UINib(nibName: "Customcell", bundle: nil)
        self.tblDoctorlist.register(nib, forCellReuseIdentifier: self.objDoctorList.str)
        let app = UIApplication.shared.delegate as! AppDelegate
        self.tblDoctorlist.reloadData()
        self.navigationController?.view.backgroundColor = UIColor.colorApplication()
       
    }
    func Cancelbtn()
    {
        self.navigationController?.popViewController(animated: true)
    }
    override func viewWillAppear(_ animated: Bool)
    {
        
         activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: self.view.center.y/2,y: self.view.center.x,width: 50,height: 50), type: NVActivityIndicatorType.ballClipRotatePulse, color: UIColor.colorApplication(), padding: NVActivityIndicatorView.DEFAULT_PADDING)
         self.view.addSubview(self.activityIndicatorView)
        self.navigationController?.isNavigationBarHidden = false
        self.animateTableFuture()
        callSearchresultApi()
    }
    func sendMap()
    {
        let MapController = storyboard?.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        UIView.animate(withDuration: 0.75, animations:
        { () -> Void in
            UIView.setAnimationCurve(UIViewAnimationCurve.easeInOut)
            self.navigationController!.pushViewController(MapController, animated: false)
            UIView.setAnimationTransition(UIViewAnimationTransition.flipFromRight, for: self.navigationController!.view!, cache: false)
        })
    }
    func callSearchresultApi()
    {
        self.activityIndicatorView.startAnimating()
        self.appObj.arrName.removeAllObjects()
        self.appObj.arrDegree.removeAllObjects()
        self.appObj.arrFees.removeAllObjects()
        self.appObj.arrAddress.removeAllObjects()
        self.appObj.arrLatitude.removeAllObjects()
        self.appObj.arrLongitude.removeAllObjects()
        self.objDoctorList.arrTimeslot1.removeAllObjects()
        self.appObj.arrEndTime.removeAllObjects()
        self.appObj.arrAppointmentDate.removeAllObjects()
        self.appObj.arrImage.removeAllObjects()

        var params =
        [
            "Latitude" : self.objDoctorList.latitude,
            "Longitude" : self.objDoctorList.longitude,
            "appointmentDate" : self.objDoctorList.appointmentDate,
            "CategoryId" : self.objDoctorList.catId,
            "SubCategoryId": self.objDoctorList.subCatId
        ] as [String : Any]
            let manager = AFHTTPRequestOperationManager()
            manager.responseSerializer.acceptableContentTypes = NSSet(objects: "application/json","text/html") as Set<NSObject>
        
            manager.post(self.appObj.baseUrl+"SearchDoctor",
            parameters: params,
            success: { (operation,responseObject) in
                
                let element : NSDictionary = responseObject as! NSDictionary
                
                var status : NSString = element.object(forKey:"status") as! NSString
                if status == "Success"
                {
                    self.activityIndicatorView.stopAnimating()
                    let arr : NSArray = element.object(forKey:"searchLocationDetails") as! NSArray
                    for dict in arr
                    {
                        self.appObj.arrName.add((dict as AnyObject).value(forKey: "Name") as! String)
                        self.appObj.arrAddress.add((dict as AnyObject).value(forKey: "ClinicAddress") as! String)
                        self.appObj.arrDegree.add((dict as AnyObject).value(forKey: "DegreeName") as! String)
                        self.appObj.arrLatitude.add((dict as AnyObject).value(forKey: "Latitude") as! NSNumber)
                        self.appObj.arrLongitude.add((dict as AnyObject).value(forKey: "Longitude") as! NSNumber)
                        self.appObj.arrImage.add((dict as AnyObject).value(forKey: "UserImage") as! String)
                        self.appObj.arrDocInfoId.add((dict as AnyObject).value(forKey: "DocInfoId") as! NSNumber)
                        self.appObj.arrExperience.add((dict as AnyObject).value(forKey: "ExperienceYear") as! String)
                        self.appObj.arrFees.add((dict as AnyObject).value(forKey: "ConsultationFees") as! NSNumber)
                        
                        
                        var stTime = ((dict as AnyObject).value(forKey:"appointmentStartTimes"))
                        
                        if let val: AnyObject? = stTime as AnyObject??
                        {
                            if let x: AnyObject = val
                            {
                                self.objDoctorList.arrTimeslot.add(x)
                            }
                        }
                    }
                    if self.objDoctorList.arrTimeslot.count != 0
                    {
                        for dictTime in self.objDoctorList.arrTimeslot
                        {
                    
                            if let val1 : AnyObject? = (dictTime as AnyObject).value(forKey: "StartTime") as AnyObject??
                            {
                                if let x: AnyObject = val1
                                {
                                    self.objDoctorList.arrTimeslot1.add(x)
                                }
                            }
                            if let val1 : AnyObject? = (dictTime as AnyObject).value(forKey: "EndTime") as AnyObject??
                            {
                                if let x: AnyObject = val1
                                {
                                    self.appObj.arrEndTime.add(x)
                                }
                            }
                            if let val1 : AnyObject? = (dictTime as AnyObject).value(forKey: "appointmentDate") as AnyObject??
                            {
                                if let x: AnyObject = val1
                                {
                                    self.appObj.arrAppointmentDate.add(x)
                                }
                            }
                        }
                    }
                    
                    for i in 0  ..< self.objDoctorList.arrTimeslot1.count
                    {
                        if(self.objDoctorList.arrTimeslot1.object(at: i) as! NSObject == NSNull())
                        {
                            self.objDoctorList.arrTimeslot1.replaceObject(at: i, with: 0)
                        }
                    }
                    self.tblDoctorlist.reloadData()
                    self.animateTableFuture()
                }
                else
                {
                    self.activityIndicatorView.stopAnimating()
                    self.tblDoctorlist.isHidden = true
                }
            },
            failure:
            {
                (operation,
                error) in
               // println("Error: " + error.localizedDescription)
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
        )

    }
    
    func animateTableFuture()
    {
        tblDoctorlist.reloadData()
        
        let cells = tblDoctorlist.visibleCells
        let tableHeight: CGFloat = tblDoctorlist.bounds.size.height
        
        for i in cells
        {
            let cell: UITableViewCell = i as! Customcell
            cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
        }
        
        var index = 0
        for a in cells
        {
            let cell: UITableViewCell = a as! Customcell
            UIView.animate(withDuration: 1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: UIViewAnimationOptions.curveEaseIn, animations:
            {
               cell.transform = CGAffineTransform(translationX: 0, y: 0);
            }, completion: nil)
            
            index += 1
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 85
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.appObj.arrName.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell:Customcell! = tableView.dequeueReusableCell(withIdentifier: self.objDoctorList.str) as! Customcell
        if cell == nil
        {
            cell = tableView.dequeueReusableCell(withIdentifier: self.objDoctorList.str) as! Customcell
        }
   
        cell.lblName.text = (self.appObj.arrName[indexPath.row] as? String)! 
        cell.lblDegree.text = (self.appObj.arrDegree[indexPath.row] as! String) 
        cell.lblAddress.text = self.appObj.arrAddress[indexPath.row] as? String
        let fees = self.appObj.arrFees[indexPath.row] as! NSNumber
        let strFees:String = String(format:"%d", fees.int32Value)
        let rupee = "\u{0024}"
        cell.lblFees.text = rupee + " " + strFees
        cell.imgview.setImageWith(URL(string: self.appObj.arrImage.object(at: indexPath.row) as! String), placeholderImage:UIImage(named: "user_blank.png"))
        cell.imgview.layer.cornerRadius = cell.imgview.frame.size.height/2
        cell.imgview.clipsToBounds = true
        cell.imgview.layer.borderWidth = 0.5
        cell.imgview.layer.borderColor = UIColor.lightGray.cgColor
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let controller = storyboard?.instantiateViewController(withIdentifier: "DoctorProfileViewController") as! DoctorProfileViewController
        controller.objDoctorProfile.DoctorProfileName = self.appObj.arrName.object(at: indexPath.row) as! String
        controller.objDoctorProfile.DoctorProfileDegree = self.appObj.arrDegree.object(at: indexPath.row) as! String
        controller.objDoctorProfile.DoctorProfileAddress = self.appObj.arrAddress.object(at: indexPath.row) as! String
        controller.objDoctorProfile.DoctorProfileImage = self.appObj.arrImage.object(at: indexPath.row) as! String
        controller.objDoctorProfile.DoctorProfileExperience = self.appObj.arrExperience.object(at: indexPath.row) as! String
        controller.objDoctorProfile.DoctorProfileAppointmentDateP = self.objDoctorList.appointmentDate
        controller.objDoctorProfile.DoctorProfileFees = self.appObj.arrFees.object(at: indexPath.row) as! NSNumber
        controller.objDoctorProfile.DoctorLatitude = self.appObj.arrLatitude.object(at: indexPath.row) as! NSNumber
        controller.objDoctorProfile.DoctorLongitude = self.appObj.arrLongitude.object(at: indexPath.row) as! NSNumber
        controller.objDoctorProfile.DoctorInfoId = self.appObj.arrDocInfoId.object(at: indexPath.row) as! NSNumber
        if self.objDoctorList.arrTimeslot.object(at: indexPath.row)as! NSObject == NSNull()
        {
             let dateFormatter = DateFormatter()
             dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
             let dateObj = dateFormatter.date(from: self.objDoctorList.appointmentDate)
             dateFormatter.dateFormat = "dd-MM-yyyy"
             let convertedDate1 = dateFormatter.string(from: dateObj!)
             controller.objDoctorProfile.DoctorProfileAppointmentDate = convertedDate1
        }
        else
        {
            var arr = NSArray()
            arr = self.appObj.arrAppointmentDate[indexPath.row] as! NSArray
            let strDate = arr.object(at: indexPath.row) as! String
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            let dateObj = dateFormatter.date(from: strDate)
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let convertedDate1 = dateFormatter.string(from: dateObj!)
            controller.objDoctorProfile.DoctorProfileAppointmentDate = convertedDate1
            controller.objDoctorProfile.collectionViewArray = self.objDoctorList.arrTimeslot1.object(at: indexPath.row) as! NSArray
            controller.objDoctorProfile.collectionViewArrayEndTime = self.appObj.arrEndTime.object(at: indexPath.row) as! NSArray
        }
        self.navigationController?.pushViewController(controller, animated: true)
    }
}


