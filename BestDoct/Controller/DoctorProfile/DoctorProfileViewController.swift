//
//  DoctorProfileViewController.swift
//  
//
//  Created by Coldfin Lab on 26/02/16.
//
//

import UIKit

class DoctorProfileViewController: UIViewController,MKMapViewDelegate,UICollectionViewDataSource, UICollectionViewDelegate,ELCImagePickerControllerDelegate,UITextFieldDelegate,JTCalendarDelegate,UITextViewDelegate,RateDelegate
{
    
    var dateselected = Date()
    var objDoctorProfile : DoctorProfileModel = DoctorProfileModel()
    let reuseIdentifier = "cell"
    var images : NSMutableArray = NSMutableArray()
    var elcPicker = ELCImagePickerController()
    var image1: UIImage = UIImage()
    var image = UIImage(named: "RadioCheck.png") as UIImage?
    var appObj : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var arrReason = NSMutableArray()
    var arrReasonId = NSMutableArray()
    let regionRadius: CLLocationDistance = 350
    var latitudedoubleValue : Double = Double()
    var longitudedoubleValue : Double = Double()
    var collectionViewArray: AnyObject = "" as AnyObject , collectionViewArrayEndTime: AnyObject = "" as AnyObject
    var strStartTime = "" , strEndTime = "", convertedDate = "" ,convertedDateEnd = ""
    var jpegImage : Data = Data()
    var arrAppointmentTime = NSMutableArray()
    var arrAppointmentStartTime = NSMutableArray()
    var arrAppointmentEndTime = NSMutableArray()
    var strCollection = ""
    var convertedDate1 = ""
    var arrtime: NSArray = NSArray()
    var arrEndtime: NSArray = NSArray()
    var strPicker = String()
    var strDatePicker = String()
    var strDoctorSeen = String()
    var pickerView = UIPickerView()
    let datePickerView:UIDatePicker = UIDatePicker()
    var arr : NSArray = NSArray()
    var strCompleteDate = ""
    var calenderView = Registration()
    var viewCalender: UIView!
    var imageProfilePath : URL!
    
    var imagearray = NSMutableArray()
    var imageName = NSString()
    var activityIndicatorView : NVActivityIndicatorView!
    
    @IBOutlet weak var btnImg: UIButton!
    @IBOutlet weak var txtDescription: UITextView!
    @IBOutlet weak var lblAvailableToday: UILabel!
    @IBOutlet weak var lblAvailableTime: UILabel!
    @IBOutlet weak var viewVisiting: UIView!
    @IBOutlet weak var viewChooseImage: UIView!
    @IBOutlet weak var viewLast: UIView!
    @IBOutlet weak var viewTimeSlot: UIView!
    @IBOutlet weak var btnTimeSlot: UIButton!
    @IBOutlet weak var collctionviewTimeSlot: UICollectionView!
    @IBOutlet weak var lblFees: UILabel!
    @IBOutlet weak var scrollViewProfile: UIScrollView!
    @IBOutlet weak var collectionView1: UICollectionView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var imgDoctor: UIImageView!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblDegree: UILabel!
    @IBOutlet weak var lblExperience: UILabel!
    @IBOutlet weak var lblAppointmentDate: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnNewPatient: UIButton!
    @IBOutlet weak var btnBookAppointment: UIButton!
    @IBOutlet weak var btnVisitedBefore: UIButton!
    @IBOutlet weak var txtDate: UITextField!
    @IBOutlet weak var viewAddress: UIView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        design()
        loadData()
        UserDefaults.standard.removeObject(forKey: "Finaldate")
        UserDefaults.standard.removeObject(forKey: "StartTime")
        UserDefaults.standard.removeObject(forKey: "EndTime")
        if IS_IPHONE_4_OR_LESS
        {
            viewCalender = UIView(frame: CGRect(x: 0, y: 250, width: 320, height: 300))
            self.view.addSubview(self.viewCalender)
        }
        else
        {
            viewCalender = UIView(frame: CGRect(x: 0, y: 323, width: 320, height: 300))
            self.view.addSubview(viewCalender)

        }
        self.viewCalender.isHidden = true
        self.btnNewPatient.setImage(self.image, for: UIControlState())
        self.strDoctorSeen = "false"
        self.mapView.delegate = self
        self.txtDescription.delegate = self
        self.latitudedoubleValue = self.objDoctorProfile.DoctorLatitude.doubleValue
        self.longitudedoubleValue = self.objDoctorProfile.DoctorLongitude.doubleValue
       
        let annotation = Annotation(title: self.objDoctorProfile.DoctorProfileName as String, subTitle: self.objDoctorProfile.DoctorProfileAddress as String,image: UIImage(named: "Marker.png")!, coordinate: CLLocationCoordinate2D(latitude: latitudedoubleValue, longitude: longitudedoubleValue))
        mapView.addAnnotation(annotation)
        let initlocation = CLLocation(latitude: self.latitudedoubleValue, longitude: self.longitudedoubleValue)
        
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(initlocation.coordinate,regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
        mapView.isUserInteractionEnabled = false
        let nib = UINib(nibName: "CollectionCellImage", bundle: nil)
        self.collectionView1.register(nib, forCellWithReuseIdentifier: "cellImage")
        self.txtDate.delegate = self
    }
    
    func SubmitCall()
    {
        print("Call function")
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        
        activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: self.view.center.y/2,y: self.view.center.x,width: 50,height: 50), type: NVActivityIndicatorType.ballClipRotatePulse, color: UIColor.colorApplication(), padding: NVActivityIndicatorView.DEFAULT_PADDING)
         self.view.addSubview(activityIndicatorView)
        elcPicker = ELCImagePickerController(imagePicker: ())
        if(self.objDoctorProfile.collectionViewArray.count == 0)
        {
            if(self.objDoctorProfile.collectionViewArray.count == 0 && self.images.count == 0)
            {
                self.scrollViewProfile.contentSize = CGSize(width: 320, height: 1000)
                if IS_IPHONE_4_OR_LESS
                {
                    self.scrollViewProfile.contentSize = CGSize(width: 320, height: 1150)
                }
            }
            if(self.objDoctorProfile.collectionViewArray.count == 0 && self.images.count != 0)
            {
                self.scrollViewProfile.contentSize = CGSize(width: 320, height: 1100)
                if IS_IPHONE_4_OR_LESS
                {
                    self.scrollViewProfile.contentSize = CGSize(width: 320, height: 1150)
                }
            }
            if self.arrtime.count == 0
            {
               
                self.lblAvailableToday.text = "Doctor is not Available"
                self.lblAvailableToday.textColor = UIColor.red
                self.viewTimeSlot.isHidden = true
                self.scrollViewProfile.contentSize = CGSize(width: 320, height: 800)
                if IS_IPHONE_4_OR_LESS
                {
                    self.scrollViewProfile.contentSize = CGSize(width: 320, height: 1150)
                }
                
                self.viewLast.frame = CGRect(x: 0, y: 180, width: 272, height: 292)
               
            }
            else
            {
                if IS_IPHONE_4_OR_LESS
                {
                    self.scrollViewProfile.contentSize = CGSize(width: 320, height: 1250)
                }
                self.lblAvailableToday.text = "Available Today"
                self.lblAvailableToday.textColor = UIColor(red: 0.0/255.0, green: 128.0/255.0, blue: 00/255.0, alpha: 1.0)
                self.viewTimeSlot.isHidden = false
                self.lblAvailableTime.text = UserDefaults.standard.object(forKey: "Finaldate") as? String
                self.scrollViewProfile.contentSize = CGSize(width: 320, height: 1000)
                
                
                self.viewLast.frame = CGRect(x: 0, y: 230, width: 272, height: 292)
                
                if (UserDefaults.standard.object(forKey: "StartTime") as? String) != nil
                {
                    if IS_IPHONE_4_OR_LESS
                    {
                        self.scrollViewProfile.contentSize = CGSize(width: 320, height: 1150)
                    }
                    self.strStartTime = UserDefaults.standard.object(forKey: "StartTime") as! String
                    self.strEndTime = UserDefaults.standard.object(forKey: "EndTime") as! String
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                    let dateObj = dateFormatter.date(from: self.strStartTime)
                    let dateObjEnd = dateFormatter.date(from: self.strEndTime)
                    dateFormatter.dateFormat = "HH:mm a"
                    self.convertedDate = dateFormatter.string(from: dateObj!)
                    self.convertedDateEnd = dateFormatter.string(from: dateObjEnd!)
                    self.lblAvailableTime.text = self.convertedDate + " - " + self.convertedDateEnd
                }
                else
                {
                    if IS_IPHONE_4_OR_LESS
                    {
                        self.scrollViewProfile.contentSize = CGSize(width: 320, height: 1150)
                    }
                    self.collectionViewArray = self.arrAppointmentStartTime
                    self.arrtime = self.collectionViewArray.object(at: 0) as! NSArray
                    self.collectionViewArrayEndTime = self.arrAppointmentEndTime
                    self.arrEndtime = self.collectionViewArrayEndTime.object(at: 0) as! NSArray
                    self.strStartTime = self.arrtime.object(at: 0) as! String
                    self.strEndTime = self.arrEndtime.object(at: 0) as! String
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                    let dateObj = dateFormatter.date(from: self.strStartTime)
                    let dateObjEnd = dateFormatter.date(from: self.strEndTime)
                    dateFormatter.dateFormat = "HH:mm a"
                    self.convertedDate = dateFormatter.string(from: dateObj!)
                    self.convertedDateEnd = dateFormatter.string(from: dateObjEnd!)
                    self.lblAvailableTime.text = self.convertedDate + " - " + self.convertedDateEnd
                }
            }
        }
        else
        {
            if(self.objDoctorProfile.collectionViewArray.count != 0 && self.images.count == 0)
            {
                if IS_IPHONE_4_OR_LESS
                {
                    
                    self.scrollViewProfile.contentSize = CGSize(width: 320, height: 1080)
                }
                else
                {
                    self.scrollViewProfile.contentSize = CGSize(width: 320, height: 1020)
                }
            }
            if(self.objDoctorProfile.collectionViewArray.count != 0 && self.images.count != 0)
            {
                self.scrollViewProfile.contentSize = CGSize(width: 320, height: 1100)
                if IS_IPHONE_4_OR_LESS
                {
                    self.scrollViewProfile.contentSize = CGSize(width: 320, height: 1150)
                }
            }
           
            self.lblAvailableToday.text = "Available Today"
            self.lblAvailableToday.textColor = UIColor(red: 0.0/255.0, green: 128.0/255.0, blue: 00/255.0, alpha: 1.0)
            self.collectionViewArray = self.objDoctorProfile.collectionViewArray
            if (UserDefaults.standard.object(forKey: "StartTime") as? String) != nil
            {
                
                if IS_IPHONE_4_OR_LESS
                {
                    self.scrollViewProfile.contentSize = CGSize(width: 320, height: 1150)
                }
                else
                {
                    self.scrollViewProfile.contentSize = CGSize(width: 320, height: 1100)
                }
                self.strStartTime = UserDefaults.standard.object(forKey: "StartTime") as! String
                self.strEndTime = UserDefaults.standard.object(forKey: "EndTime") as! String
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                let dateObj = dateFormatter.date(from: self.strStartTime)
                let dateObjEnd = dateFormatter.date(from: self.strEndTime)
                dateFormatter.dateFormat = "HH:mm a"
                self.convertedDate = dateFormatter.string(from: dateObj!)
                self.convertedDateEnd = dateFormatter.string(from: dateObjEnd!)
                self.lblAvailableTime.text = self.convertedDate + " - " + self.convertedDateEnd
            }
            else
            {
                if IS_IPHONE_4_OR_LESS
                {
                    self.scrollViewProfile.contentSize = CGSize(width: 320, height: 1080)
                }
                else
                {
                    self.scrollViewProfile.contentSize = CGSize(width: 320, height: 1080)
                }
                self.strStartTime = collectionViewArray.object(at: 0) as! String
                self.collectionViewArrayEndTime = self.objDoctorProfile.collectionViewArrayEndTime
                self.strEndTime = collectionViewArrayEndTime.object(at: 0) as! String
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                let dateObj = dateFormatter.date(from: self.strStartTime)
                let dateObjEnd = dateFormatter.date(from: self.strEndTime)
                dateFormatter.dateFormat = "HH:mm a"
                self.convertedDate = dateFormatter.string(from: dateObj!)
                self.convertedDateEnd = dateFormatter.string(from: dateObjEnd!)
                self.lblAvailableTime.text = self.convertedDate + " - " + self.convertedDateEnd
            }
            self.viewLast.frame = CGRect(x: 0, y: 230, width: 272, height: 292)
        }
    }
    func design()
    {
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationController?.isNavigationBarHidden = true
    }
    func loadData()
    {
        self.lblName.text = self.objDoctorProfile.DoctorProfileName
        self.lblDegree.text = self.objDoctorProfile.DoctorProfileDegree
        self.lblAddress.text = self.objDoctorProfile.DoctorProfileAddress
        self.lblAddress.sizeToFit()
        let h = self.lblAddress.frame.size.height + self.lblAddress.frame.origin.y
        self.viewAddress.frame = CGRect(x: self.viewAddress.frame.origin.x, y: h+12, width: 319, height: 538)
        if self.objDoctorProfile.DoctorProfileExperience == "Fresher"
        {
            self.lblExperience.text = self.objDoctorProfile.DoctorProfileExperience
        }
        else
        {
            self.lblExperience.text = self.objDoctorProfile.DoctorProfileExperience + " " + "Year Experience"
        }
        
        self.txtDate.text = self.objDoctorProfile.DoctorProfileAppointmentDate
        let strFee = self.objDoctorProfile.DoctorProfileFees
        let strFees:String = String(format:"%d", strFee.int32Value)
        let rupee = "\u{0024}"
        self.lblFees.text = rupee + " " + strFees + " " + "consultation fees"
        self.imgDoctor.layer.cornerRadius = self.imgDoctor.frame.size.height/2
        self.imgDoctor.clipsToBounds = true
        self.imgDoctor.layer.borderWidth = 0.5
        self.imgDoctor.layer.borderColor = UIColor.lightGray.cgColor
        self.imgDoctor.setImageWith(URL(string: self.objDoctorProfile.DoctorProfileImage), placeholderImage:UIImage(named: "user_blank.png"))
       
    }
    @IBAction func btnBack(_ sender: UIButton!)
    {
       self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnNewPatient(_ sender: UIButton!)
    {
        self.strDoctorSeen = "false"
        self.btnNewPatient.setImage(image, for: UIControlState())
        let image1 = UIImage(named: "RadioUncheck.png") as UIImage?
        self.btnVisitedBefore.setImage(image1, for: UIControlState())
    }
    @IBAction func btnVisitedBefore(_ sender: UIButton!)
    {
        self.strDoctorSeen = "true"
        self.btnVisitedBefore.setImage(image, for: UIControlState())
        let image1 = UIImage(named: "RadioUncheck.png") as UIImage?
        self.btnNewPatient.setImage(image1, for: UIControlState())
    }
    func centerMapOnLocation(_ location: CLLocation)
    {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        if let annotation = annotation as? Annotation
        {
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
            {
                dequeuedView.annotation = annotation
                view = dequeuedView
            }
            else
            {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.image = UIImage(named:"Marker.png")!
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type:UIButtonType.detailDisclosure) as UIView
            }
            return view
        }
        return nil
    }
    func callSearchresultApi()
    {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let dateObj = dateFormatter.date(from: self.txtDate.text!)
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        convertedDate1 = dateFormatter.string(from: dateObj!)
       
        let manager = AFHTTPRequestOperationManager()
        manager.responseSerializer.acceptableContentTypes = NSSet(objects: "application/json","text/html") as Set<NSObject>

        manager.get(self.appObj.baseUrl+"appointmentTimeListOfDoctor?DocInfoId=\(self.objDoctorProfile.DoctorInfoId)&AppointmentDate=\(convertedDate1)",
        parameters: nil,
        success: { (operation,responseObject) in
            let element : NSDictionary = responseObject as! NSDictionary
                
            if((element.object(forKey: "error_code") as! Int) == 0)
            {
                        self.arr = element.object(forKey:"DoctorDetailWithAppointmentTime") as! NSArray
                        let dict : NSDictionary = self.arr[0] as! NSDictionary
                        if let val: AnyObject? = dict.object(forKey:"appointmentStartTimes") as AnyObject??
                        {
                            if let x: AnyObject = val
                            {
                                self.arrAppointmentTime.removeAllObjects()
                                self.arrAppointmentTime.add(x)
                            }
                        }
                
                    for dictTime in self.arrAppointmentTime
                    {
                        
                        let dictTimeArray : NSDictionary = dictTime as! NSDictionary
                        
                        if let val1 : AnyObject? = dictTimeArray.value(forKey: "StartTime") as AnyObject??
                        {
                            if let x: AnyObject = val1
                            {
                                self.arrAppointmentStartTime.removeAllObjects()
                                self.arrAppointmentStartTime.add(x)
                            }
                        }
                        if let val1 : AnyObject? = dictTimeArray.value(forKey: "EndTime") as AnyObject??
                        {
                            if let x: AnyObject = val1
                            {
                                self.arrAppointmentEndTime.removeAllObjects()
                                self.arrAppointmentEndTime.add(x)
                            }
                        }
                    }
                        self.repeatActivity()
                }
                else
                {}
            },
            failure:
            {
                (operation,
                error) in
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
    
    @IBAction func btnAllTimings(_ sender: UIButton)
    {
        if self.strCollection == "Time Changed"
        {
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "TimeViewController") as! TimeViewController
            self.collectionViewArray = self.arrAppointmentStartTime
            self.arrtime = self.collectionViewArray.object(at: 0) as! NSArray
            self.collectionViewArrayEndTime = self.arrAppointmentEndTime
            self.arrEndtime = self.collectionViewArrayEndTime.object(at: 0) as! NSArray
            controller.objDoctorModel.tblStartTime = self.arrtime
            controller.objDoctorModel.tblEndTime = self.arrEndtime
            self.performSegue(withIdentifier: "segue", sender: self)
            controller.definesPresentationContext = true;
            self.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
            self.present(controller, animated: true, completion: nil)
        }
        else
        {
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "TimeViewController") as! TimeViewController
            controller.objDoctorModel.tblStartTime = self.objDoctorProfile.collectionViewArray
            controller.objDoctorModel.tblEndTime = self.objDoctorProfile.collectionViewArrayEndTime
            self.performSegue(withIdentifier: "segue", sender: self)
            controller.definesPresentationContext = true;
            self.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
            self.present(controller, animated: true, completion: nil)
        }
    }
    func repeatActivity()
    {
        if ((self.arrAppointmentTime[0] as AnyObject).count != nil)
        {
            self.lblAvailableToday.text = "Available Today"
             self.lblAvailableToday.textColor = UIColor(red: 0.0/255.0, green: 128.0/255.0, blue: 00/255.0, alpha: 1.0)
            self.viewTimeSlot.isHidden = false
            self.scrollViewProfile.contentSize = CGSize(width: 320, height: 1020)
            if IS_IPHONE_4_OR_LESS
            {
                self.scrollViewProfile.contentSize = CGSize(width: 320, height: 1060)
            }
            self.viewLast.frame = CGRect(x: 0, y: 230, width: 320, height: 292)
            self.collectionViewArray = self.arrAppointmentStartTime
            self.arrtime = self.collectionViewArray.object(at: 0) as! NSArray
            self.collectionViewArrayEndTime = self.arrAppointmentEndTime
            self.arrEndtime = self.collectionViewArrayEndTime.object(at: 0) as! NSArray
            self.strStartTime = self.arrtime.object(at: 0) as! String
            self.strEndTime = self.arrEndtime.object(at: 0) as! String
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            let dateObj = dateFormatter.date(from: self.strStartTime)
            let dateObjEnd = dateFormatter.date(from: self.strEndTime)
            dateFormatter.dateFormat = "HH:mm a"
            self.convertedDate = dateFormatter.string(from: dateObj!)
            self.convertedDateEnd = dateFormatter.string(from: dateObjEnd!)
            self.lblAvailableTime.text = self.convertedDate + " - " + self.convertedDateEnd
        }
        else
        {
            self.lblAvailableToday.text = "Doctor is not Available"
            self.lblAvailableToday.textColor = UIColor.red
            self.strStartTime = ""
            self.strEndTime = ""
            self.viewTimeSlot.isHidden = true
            self.scrollViewProfile.contentSize = CGSize(width: 320, height: 1000)
            if IS_IPHONE_4_OR_LESS
            {
                self.scrollViewProfile.contentSize = CGSize(width: 320, height: 1050)
            }
            self.viewLast.frame = CGRect(x: 0, y: 180, width: 320, height: 292)
            self.objDoctorProfile.collectionViewArray = []
        }

    }
    @IBAction func btnChooseImage(_ sender: AnyObject)
    {
        if self.images.count == 0
        {
            elcPicker.maximumImagesCount = 5
        }
        else if self.images.count == 1
        {
            elcPicker.maximumImagesCount = 4
        }
        else if self.images.count == 2
        {
            elcPicker.maximumImagesCount = 3
        }
        else if self.images.count == 3
        {
            elcPicker.maximumImagesCount = 2
        }
        else if self.images.count == 4
        {
            elcPicker.maximumImagesCount = 1
        }
        else if self.images.count == 0
        {
            elcPicker.maximumImagesCount = 5
        }
        
        elcPicker.returnsOriginalImage = true
        //Only return the fullScreenImage, not the fullResolutionImage
        elcPicker.returnsImage = true
        //Return UIimage if YES. If NO, only return asset location information
        elcPicker.onOrder = false
        elcPicker.imagePickerDelegate = self
        self.present(elcPicker, animated: true, completion: nil)
    }
    
    public func elcImagePickerController(_ picker: ELCImagePickerController!, didFinishPickingMediaWithInfo info: [Any]!){
       
        self.dismiss(animated: true, completion: nil)
        
        for dict in info
        {
            
            self.imageName = NSString(format: "%.0f.png", Foundation.Date().timeIntervalSince1970)
            
            let dictionary = dict as? [String: AnyObject]
            self.image1 = (dictionary?[UIImagePickerControllerOriginalImage] as! UIImage)

            let data:Data = UIImageJPEGRepresentation(self.image1,1.0)!
            
            //path for save image
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] 
            let fileURL = documentsURL.appendingPathComponent(imageName as String)
            
            let path = fileURL.path
            
            do {
                try data.write(to: fileURL, options: .atomic)
            } catch {
                print(error)
            }
            
            imageProfilePath = fileURL
            self.imagearray.add(imageProfilePath)
            self.images.add(self.image1)
            
        }
        self.collectionView1.reloadData()
    }
    func elcImagePickerControllerDidCancel(_ picker: ELCImagePickerController!)
    {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func btnBookAppointment(_ sender: UIButton!)
    {
        
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let dateObj = dateFormatter.date(from: self.txtDate.text!)
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            let dateObj1 = dateFormatter.date(from: self.strStartTime)
            convertedDate1 = dateFormatter.string(from: dateObj!)
            let current = Date()
            if current.compare(dateObj1!) == ComparisonResult.orderedSame
            {
               callBookAppointmentAPI()
            }
            else if current.compare(dateObj1!) == ComparisonResult.orderedAscending
            {
               callBookAppointmentAPI()
            }
            else if current.compare(dateObj1!) == ComparisonResult.orderedDescending
            {
                self.appObj.strStart = "oopss"
                let alert : SCLAlertView = SCLAlertView()
                alert.labelTitle.textColor = UIColor.red
                alert.labelTitle.alpha = 0.8
                alert.backgroundType = .Blur
                alert.showAnimationType = .SlideInFromTop
                alert.hideAnimationType = .SlideOutToBottom
                alert.tintTopCircle = true
                alert.showWaiting(self, title: "Oops!!", subTitle: "Valid time is not selected" , closeButtonTitle: "OK", duration: 3.0)
            }
        
    }
    func callBookAppointmentAPI()
    {
    if convertedDate1 == "" || self.strStartTime == "" || self.strEndTime == "" || self.txtDescription.text == "" || self.strDoctorSeen == ""
    {
        self.appObj.strStart = "oopss"
        var alert : SCLAlertView = SCLAlertView()
        alert.labelTitle.textColor = UIColor.red
        alert.labelTitle.alpha = 0.8
        alert.backgroundType = .Blur
        alert.showAnimationType = .SlideInFromTop
        alert.hideAnimationType = .SlideOutToBottom
        alert.tintTopCircle = true
        alert.showWaiting(self, title: "Oops!!", subTitle: "Incomplete data will not let you to book an appointment" , closeButtonTitle: "OK", duration: 3.0)
    }
    else
    {
                            self.activityIndicatorView.startAnimating()
                            self.view.isUserInteractionEnabled = false
        
                            let params = NSMutableDictionary()
                            params.setObject(12187, forKey: "UserId" as NSCopying)
                            params.setObject(self.objDoctorProfile.DoctorInfoId, forKey: "DocInfoId" as NSCopying)
                            params.setObject(convertedDate1, forKey: "AppointmentDate" as NSCopying)
                            params.setObject(self.strStartTime, forKey: "StartTime" as NSCopying)
                            params.setObject(self.strEndTime, forKey: "EndTime" as NSCopying)
                            params.setObject(self.appObj.subcategoryId, forKey: "SubCategoryId" as NSCopying)
                            params.setObject(self.strDoctorSeen, forKey: "DoctorSeen" as NSCopying)
                            params.setObject(self.txtDescription.text, forKey: "DiseasesDescription" as NSCopying)
                         
                            let manager = AFHTTPRequestOperationManager()
                            manager.responseSerializer.acceptableContentTypes = NSSet(objects: "application/json","text/html") as Set<NSObject>
        
        let url = self.appObj.baseUrl+"addAppointment"
        manager.post( url, parameters: params,
                      constructingBodyWith: { (data) in
                        do{
                            if(self.imageName != ""){
                                for i in 0  ..< self.imagearray.count
                                {
                                    
                                    try data?.appendPart(withFileURL: self.imagearray[i] as! URL, name: "DiseasesImage")
                                }
                               
                            }
                        }catch{
                        }
        },
                      success: { (operation, responseObject) in
                        print("\(responseObject)")
                        self.activityIndicatorView.stopAnimating()
                        self.view.isUserInteractionEnabled = true
                        
                        let element : NSDictionary = responseObject as! NSDictionary
                        
                        if((element.object(forKey: "error_code") as! Int) == 0)
                        {
                            self.appObj.strStart = "yipee"
                            var alert : SCLAlertView = SCLAlertView()
                            alert.labelTitle.textColor = UIColor(red: 81.0/255.0, green: 210.0/255.0, blue: 80.0/255.0, alpha: 1.0)
                            alert.backgroundType = .Blur
                            alert.showAnimationType = .SlideInFromTop
                            alert.hideAnimationType = .SlideOutToBottom
                            alert.tintTopCircle = true
                            alert.showWaiting(self, title: "Yippeee!!", subTitle: "Appointment booked successfully." , closeButtonTitle: "OK", duration: 3.0)
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                self.tabBarController?.selectedIndex = 2
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
                      failure: { (operation, error) in
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
        })

        }
        
    }
    func collectionView(_ cv: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if  cv == self.collectionView1
        {
            if self.images.count == 0
            {
                if IS_IPHONE_4_OR_LESS
                {
                    self.btnImg.frame = CGRect(x: 220, y: 400, width: 90, height: 80)
                    self.scrollViewProfile.contentSize = CGSize(width: 320, height: 1080)
                }
                else
                {
                    self.btnImg.frame = CGRect(x: 220, y: 480, width: 90, height: 80)
                    self.scrollViewProfile.contentSize = CGSize(width: 320, height: 1000)
                }
                
                self.viewChooseImage.isHidden = true
                self.viewVisiting.frame = CGRect(x: 4, y: 95, width: 261, height: 86)
                self.btnBookAppointment.frame = CGRect(x: 29, y: 200, width: 263, height: 40)
            }
            else
            {
                if IS_IPHONE_4_OR_LESS
                {
                    self.btnImg.frame = CGRect(x: 220, y: 400, width: 90, height: 80)
                    self.scrollViewProfile.contentSize = CGSize(width: 320, height: 1180)
                }
                else
                {
                    self.btnImg.frame = CGRect(x: 220, y: 480, width: 90, height: 80)
                    self.scrollViewProfile.contentSize = CGSize(width: 320, height: 1150)
                }
              
                self.viewVisiting.frame = CGRect(x: 4, y: 150, width: 261, height: 86)
                self.btnBookAppointment.frame = CGRect(x: 29, y: 250, width: 263, height: 40)
                self.viewChooseImage.isHidden = false
                return self.images.count
            }
        }
        else if cv == self.collctionviewTimeSlot
        {
            if(self.objDoctorProfile.collectionViewArray.count == 0)
            {
                if self.arrtime.count == 0
                {
                    self.lblAvailableToday.text = "Doctor is not Available"
                    self.lblAvailableToday.textColor = UIColor.red
                  
                    self.viewTimeSlot.isHidden = true
                    self.viewLast.frame = CGRect(x: 20, y: 482, width: 284, height: 292)
                }
                else
                {
                    
                    self.lblAvailableToday.text = "Available Today"
                    self.lblAvailableToday.textColor = UIColor(red: 0.0/255.0, green: 128.0/255.0, blue: 0.0/255.0, alpha: 1.0)
                 
                    self.viewTimeSlot.isHidden = false
                    self.viewLast.frame = CGRect(x: 18, y: 558, width: 284, height: 292)
                    return self.arrtime.count
                }
            }
            else
            {
                return  self.objDoctorProfile.collectionViewArray.count
            }
        }
        return 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(_ cv: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell1 = UICollectionViewCell()
        if  cv == self.collectionView1
        {
            let cell = cv.dequeueReusableCell(withReuseIdentifier: "cellImage", for: indexPath) as! CollectionCellImage
            if self.images.count == 0
            {
            }
            else
            {
                cell.imgDisease.image = self.images.object(at: indexPath.row) as? UIImage
                cell.btnClose.addTarget(self, action: #selector(DoctorProfileViewController.Delete(_:)), for: UIControlEvents.touchUpInside)
                cell.btnClose.layer.setValue(indexPath.row, forKey: "index")
            }
            
            return cell
        }
        else if cv == self.collctionviewTimeSlot
        {
            if self.strCollection == "Time Changed"
            {
               
                let cell = cv.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MyCollectionViewCell
                self.strStartTime = self.arrtime.object(at: indexPath.row) as! String
                self.strEndTime = self.arrEndtime.object(at: indexPath.row) as! String
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                let dateObj = dateFormatter.date(from: self.strStartTime)
                let dateObjEnd = dateFormatter.date(from: self.strEndTime)
                dateFormatter.dateFormat = "HH:mm a"
                self.convertedDate = dateFormatter.string(from: dateObj!)
                self.convertedDateEnd = dateFormatter.string(from: dateObjEnd!)
                self.strCompleteDate = self.convertedDate + " - " + self.convertedDateEnd
                cell.myButton.setTitle(self.strCompleteDate, for: UIControlState())
                cell.myButton.tag = indexPath.row
                cell.myButton.removeTarget(self, action: #selector(DoctorProfileViewController.btnTimeSlotClicked(_:)), for: UIControlEvents.touchUpInside)
                cell.myButton.addTarget(self, action: #selector(DoctorProfileViewController.btnTimeSlotClicked1(_:)), for: UIControlEvents.touchUpInside)
                return cell

            }
            else
            {
                    let cell = cv.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MyCollectionViewCell
                    self.collectionViewArray = self.objDoctorProfile.collectionViewArray
                    self.strStartTime = collectionViewArray.object(at: indexPath.row) as! String
                    self.collectionViewArrayEndTime = self.objDoctorProfile.collectionViewArrayEndTime
                    self.strEndTime = collectionViewArrayEndTime.object(at: indexPath.row) as! String
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                    let dateObj = dateFormatter.date(from: self.strStartTime)
                    let dateObjEnd = dateFormatter.date(from: self.strEndTime)
                    dateFormatter.dateFormat = "HH:mm a"
                    self.convertedDate = dateFormatter.string(from: dateObj!)
                    self.convertedDateEnd = dateFormatter.string(from: dateObjEnd!)
                    strCompleteDate = self.convertedDate + " - " + self.convertedDateEnd
                    cell.myButton.setTitle(strCompleteDate, for: UIControlState())
                    cell.myButton.tag = indexPath.row
                    cell.myButton.removeTarget(self, action: #selector(DoctorProfileViewController.btnTimeSlotClicked1(_:)), for: UIControlEvents.touchUpInside)
                    cell.myButton.addTarget(self, action: #selector(DoctorProfileViewController.btnTimeSlotClicked(_:)), for: UIControlEvents.touchUpInside)
                    return cell
            }
        }
        return cell1
    }
    func Delete(_ sender:UIButton!)
    {
        let i = sender.layer.value(forKey: "index") as! Int
        self.images.removeObject(at: i)
        self.collectionView1.reloadData()
    }
    func btnTimeSlotClicked(_ sender:UIButton!)
    {
        self.lblAvailableToday.text = "Available Today : " + " " + sender.titleLabel!.text!
        self.objDoctorProfile.DoctorStartTime = self.collectionViewArray.object(at: sender.tag) as! String
        self.objDoctorProfile.DoctorEndTime = self.collectionViewArrayEndTime.object(at: sender.tag) as! String
    }
    func btnTimeSlotClicked1(_ sender:UIButton!)
    {
        self.lblAvailableToday.text = "Available Today : " + " " + sender.titleLabel!.text!
        self.objDoctorProfile.DoctorStartTime = self.arrtime.object(at: sender.tag) as! String
        self.objDoctorProfile.DoctorEndTime = self.arrEndtime.object(at: sender.tag) as! String
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        var scrollpoint : CGPoint
        scrollpoint = CGPoint.zero
        if(textField == self.txtDate)
        {
            scrollpoint = CGPoint(x: 0.0, y: self.txtDate.center.y - 20)
            self.viewCalender.isHidden = false
            calenderView = Bundle.main.loadNibNamed("Registration", owner: self, options: nil)?[1] as! Registration
            calenderView.btnCalenderNext.addTarget(self, action: #selector(DoctorProfileViewController.NextMonth(_:)), for: UIControlEvents.touchUpInside)
            calenderView.btnCalenderPrevious.addTarget(self, action: #selector(DoctorProfileViewController.PreviousMonth(_:)), for: UIControlEvents.touchUpInside)
            calenderView.calendarManager = JTCalendarManager()
            calenderView.calendarManager.delegate = self
            calenderView.calendarManager.menuView = calenderView.calendarMenuView
            calenderView.calendarManager.contentView = calenderView.calendarContentView
            calenderView.calendarManager.setDate(Date())
            self.viewCalender.addSubview(calenderView)
            return false
        }
        self.scrollViewProfile.setContentOffset(scrollpoint,animated: true)
        return true
    }
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool
    {
        var scrollpoint : CGPoint
        scrollpoint = CGPoint.zero

        if(textView == self.txtDescription)
        {
            scrollpoint = CGPoint(x: 0.0, y: self.txtDescription.center.y + 220)
            self.scrollViewProfile.setContentOffset(scrollpoint,animated: true)
            //return true
        }
        if IS_IPHONE_4_OR_LESS
        {
            if(textView == self.txtDescription)
            {
                scrollpoint = CGPoint(x: 0.0, y: self.txtDescription.center.y + 350)
                self.scrollViewProfile.setContentOffset(scrollpoint,animated: true)
                //return true
            }
        }
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        if(text == "\n")
        {
            textView.resignFirstResponder()
            var scrollpoint : CGPoint
            scrollpoint = CGPoint.zero
            self.scrollViewProfile.setContentOffset(scrollpoint,animated: true)
            return false
        }
        return true
    }
    func NextMonth(_ sender:UIButton!)
    {
        calenderView.calendarContentView.loadNextPageWithAnimation()
    }
    func PreviousMonth(_ sender:UIButton!)
    {
        calenderView.calendarContentView.loadPreviousPageWithAnimation()
    }
    func calendarBuildMenuItemView(_ calendar: JTCalendarManager!) -> UIView!
    {
        let label : UILabel = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.white
        return label
    }
    //calender delegate methods
    func calendar(_ calendar: JTCalendarManager!, didTouchDayView dayView: UIView!)
    {
        if let myVeryOwnDayView = dayView as? JTCalendarDayView
        {
            var cal = JTCalendarManager()
            dateselected = myVeryOwnDayView.date
            var currentDate = Date()
            if cal.dateHelper.date(dateselected, isEqualOrAfter: currentDate)
            {
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd-MM-yyyy"
                myVeryOwnDayView.circleView.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
                myVeryOwnDayView.circleView.isHidden = false
                UIView.transition(with: dayView, duration: 0.3, options: UIViewAnimationOptions.curveEaseIn, animations:
                { () -> Void in
                    myVeryOwnDayView.circleView.transform = CGAffineTransform.identity
                    self.txtDate.text = dateFormatter.string(from: self.dateselected)
                    
                }, completion: nil)
                let delayTime = DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                DispatchQueue.main.asyncAfter(deadline: delayTime)
                {
                    self.calenderView.isHidden = true
                    self.viewCalender.isHidden = true
                    var scrollpoint : CGPoint
                    scrollpoint = CGPoint.zero
                    scrollpoint = CGPoint(x: 0.0, y: 0.0)
                    self.scrollViewProfile.setContentOffset(scrollpoint,animated: true)
                }
            }
            else
            {
                self.appObj.strStart = "oopss"
                var alert : SCLAlertView = SCLAlertView()
                alert.labelTitle.textColor = UIColor.red
                alert.labelTitle.alpha = 0.8
                alert.backgroundType = .Blur
                alert.showAnimationType = .SlideInFromTop
                alert.hideAnimationType = .SlideOutToBottom
                alert.tintTopCircle = true
                alert.showWaiting(self, title: "Oops!!", subTitle: "Valid date is not selected yet." , closeButtonTitle: "OK", duration: 3.0)
            }
            
            self.strCollection = "Time Changed"
            callSearchresultApi()
        }
    }
    func calendar(_ calendar: JTCalendarManager!, prepareDayView dayView: UIView!)
    {
        
        let cal = JTCalendarManager()
        if cal.dateHelper.date(calenderView.calendarContentView.date, isTheSameMonthThan: Date())
        {}
        //
        if let myVeryOwnDayView = dayView as? JTCalendarDayView
        {
            
            cal.delegate = self
            
            if cal.dateHelper.date(Date(), isTheSameDayThan: myVeryOwnDayView.date)
            {
                myVeryOwnDayView.circleView.isHidden = false
                myVeryOwnDayView.circleView.backgroundColor = UIColor.red
                myVeryOwnDayView.dotView.backgroundColor = UIColor.blue
                myVeryOwnDayView.textLabel.textColor = UIColor.white
            }
        }
    }
    func datePickerValueChanged(_ sender:UIDatePicker)
    {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        self.strDatePicker = dateFormatter.string(from: sender.date)
        //self.view.endEditing(true)
    }
  
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if (segue.identifier == "segue")
        {
            if self.strCollection == "Time Changed"
            {
                let controller = segue.destination as! TimeViewController
                controller.objDoctorModel.tblStartTime = self.arrtime
                controller.objDoctorModel.tblEndTime = self.arrEndtime
                controller.delegate = self
            }
            else
            {
                let controller = segue.destination as! TimeViewController
                controller.objDoctorModel.tblStartTime = self.objDoctorProfile.collectionViewArray
                controller.objDoctorModel.tblEndTime = self.objDoctorProfile.collectionViewArrayEndTime
                controller.delegate = self
            }
        }
    }
}
