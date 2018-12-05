//
//  SearchDetailViewController.swift
//  CutIt
//
//  Created by Coldfin lab

//  Copyright © 2017 Coldfin lab. All rights reserved.

import UIKit

class SearchDetailViewController: UIViewController,KIImagePagerDelegate, KIImagePagerDataSource,UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate,CLLocationManagerDelegate {

    //View Top
    @IBOutlet var imagePager: KIImagePager!
    @IBOutlet var imgUser: UIImageView!
    @IBOutlet var lblUserName: UILabel!
    @IBOutlet var imgRating: UIImageView!
    @IBOutlet var viewTop: UIView!
    @IBOutlet var btnService: UIButton!
    @IBOutlet var btnReview: UIButton!
    @IBOutlet var btnInfo: UIButton!
    @IBOutlet var scrollview : UIScrollView!
    @IBOutlet weak var viewPrevious: UIView!
    @IBOutlet weak var viewNext: UIView!
    
    //View Service
    @IBOutlet weak var tblService: UICollectionView!
    @IBOutlet weak var viewService: UIView!
    @IBOutlet weak var viewNoService: UIView!
    
    //View Review
    @IBOutlet weak var tblReview: UICollectionView!
    @IBOutlet weak var viewReview: UIView!
    @IBOutlet weak var viewNoReview: UIView!
    @IBOutlet weak var lblReview: UILabel!
    
    //View Info
    @IBOutlet weak var viewInfo: UIView!
    @IBOutlet weak var viewInfoBottom: UIView!
    @IBOutlet weak var lblShopName: UILabel!
    @IBOutlet weak var lblShopAddress: UILabel!
    @IBOutlet weak var lblShopPhoneNo: UILabel!
    @IBOutlet weak var lblShopDesc: UILabel!
    @IBOutlet weak var lblReviewCount: UILabel!
    @IBOutlet weak var lblMail: UILabel!
    @IBOutlet weak var lblFb: UILabel!
    @IBOutlet weak var lblGoogle: UILabel!
    @IBOutlet weak var lblTwitter: UILabel!
    @IBOutlet weak var lblYelp: UILabel!
    @IBOutlet weak var viewMap: GMSMapView!
    @IBOutlet weak var viewReviewCount: UIView!
    @IBOutlet weak var tblInfo: UICollectionView!
    @IBOutlet weak var lblContactInfo: UILabel!
    @IBOutlet weak var lblInfoReview: UILabel!
    
    let locationManager = CLLocationManager()
    var category = CategoryModel()
    var salon = SalonModel()
    var arrAllService = NSMutableArray()
    var arrAllReview = NSMutableArray()
    var arrAllInfo = NSMutableArray()
    var appDelegate = AppDelegate()
    var strLeftTime : NSString!
    var strLength = String()
    var indexPath = Int()
    var rating = Float()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.lblReview.isHidden = true
        self.setBasicProperty()
        self.tblInfo.reloadData()
        BackgroundRequestForServiceList()
    }
    
    override func viewWillAppear(_ animated: Bool) {

        if(IS_IPHONE_4_OR_LESS)
        {
            self.tblService.frame = CGRect(x:self.tblService.frame.origin.x,y:self.tblService.frame.origin.y, width: self.tblService.frame.size.width, height: self.tblService.frame.size.height - 80)
            
            self.tblReview.frame = CGRect(x:self.tblReview.frame.origin.x,y:self.tblReview.frame.origin.y, width: self.tblReview.frame.size.width, height: self.tblReview.frame.size.height - 80)
        
            scrollview.contentSize = CGSize(width: self.scrollview.frame.size.width, height: self.scrollview.frame.size.height+80)
        }
    }
    
    func setScrollInfo()
    {
        if salon.salonDescription != ""
        {
            self.lblShopDesc.text = salon.salonDescription
            let font: UIFont = UIFont.systemFont(ofSize: 13.0)
            
            let expectedLabelSize = self.lblShopDesc.text!.boundingRect(
                with: CGSize(width: 304, height: CGFloat.infinity),
                options: NSStringDrawingOptions.usesLineFragmentOrigin,
                attributes: [NSFontAttributeName: font],
                context: nil).size
            
            self.lblShopDesc.frame.size.height = expectedLabelSize.height
            self.viewInfoBottom.frame = CGRect(x: self.viewInfoBottom.frame.origin.x, y: expectedLabelSize.height + self.lblShopDesc.frame.origin.y + 5, width: self.viewInfoBottom.frame.size.width, height: self.viewInfoBottom.frame.size.height)
            
            if(IS_IPHONE_4_OR_LESS)
            {
                scrollview.contentSize = CGSize(width: self.scrollview.frame.size.width, height: self.scrollview.frame.size.height+300)
            }
        }
        else
        {
            self.lblShopDesc.text = ""
            self.viewInfoBottom.frame = CGRect(x: self.viewInfoBottom.frame.origin.x, y: self.lblShopPhoneNo.frame.size.height + self.lblShopPhoneNo.frame.origin.y + 15, width: self.viewInfoBottom.frame.size.width, height: self.viewInfoBottom.frame.size.height)
            scrollview.contentSize = CGSize(width: self.scrollview.frame.size.width, height: self.scrollview.frame.size.height+self.viewInfoBottom.frame.size.height-20)
        }
        if self.arrAllInfo.count == 0
        {
            self.lblContactInfo.isHidden = true
            scrollview.contentSize = CGSize(width: self.scrollview.frame.size.width, height: self.scrollview.frame.size.height + 60)
            if(IS_IPHONE_4_OR_LESS)
            {
                scrollview.contentSize = CGSize(width: self.scrollview.frame.size.width, height: self.scrollview.frame.size.height+100)
            }
        }
        else
        {
            self.lblContactInfo.isHidden = false
            if self.arrAllInfo.count == 1
            {
                scrollview.contentSize = CGSize(width: self.scrollview.frame.size.width, height: self.scrollview.frame.size.height+100)
            }
            else if self.arrAllInfo.count == 2
            {
                scrollview.contentSize = CGSize(width: self.scrollview.frame.size.width, height: self.scrollview.frame.size.height+120)
            }
            else if self.arrAllInfo.count == 3
            {
                scrollview.contentSize = CGSize(width: self.scrollview.frame.size.width, height: self.scrollview.frame.size.height+160)
            }
            else if self.arrAllInfo.count == 4
            {
                scrollview.contentSize = CGSize(width: self.scrollview.frame.size.width, height: self.scrollview.frame.size.height+185)
            }
            else if self.arrAllInfo.count == 5
            {
                scrollview.contentSize = CGSize(width: self.scrollview.frame.size.width, height: self.scrollview.frame.size.height+220)
            }
        }
        if(IS_IPHONE_4_OR_LESS)
        {
            scrollview.contentSize = CGSize(width: self.scrollview.frame.size.width, height: self.scrollview.frame.size.height+300)
        }
    }
    func setBasicProperty(){
    
        self.lblUserName.text = salon.vendorFirstName + " " + salon.vendorLastName
        self.lblShopName.text = salon.salonName as String
        self.lblShopAddress.text = salon.salonAddress
        self.lblShopPhoneNo.text = salon.salonPhone
        
        self.imgUser.sd_setImage(with: URL(string: salon.vendorImage as String), placeholderImage: UIImage(named: "imguser.png"))
        self.imgRating.sd_setImage(with: URL(string: salon.ratingCount as String), placeholderImage: UIImage(named: "default_rating.png"))
        
        self.viewTop.layer.cornerRadius = 4
        self.viewTop.layer.masksToBounds = true
        
        self.imagePager.slideshowTimeInterval = 5
        self.imagePager.delegate = self
        self.imagePager.dataSource = self
        self.imagePager.slideshowShouldCallScrollToDelegate = true
        
        self.imgUser.layer.cornerRadius =  self.imgUser.frame.size.height/2
        self.imgUser.layer.masksToBounds = true
        
        self.setButtonTextRedColor(btnService)
        self.viewNoReview.isHidden = true
        self.viewNoService.isHidden = true

        self.btnService.isSelected = true
        self.viewService.isHidden = false
        self.viewReview.isHidden = true
        self.viewInfo.isHidden = true
        
        self.viewMap.mapType = kGMSTypeNormal
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        self.setRadiusToView(self.viewReviewCount)
        
        if salon.salonImages.count > 1
        {
            self.viewNext.isHidden = false
            self.viewPrevious.isHidden = false
        }
        else{
            self.viewNext.isHidden = true
            self.viewPrevious.isHidden = true
        }
        if(IS_IPHONE_4_OR_LESS)
        {
            scrollview.contentSize = CGSize(width: self.scrollview.frame.size.width, height: self.scrollview.frame.size.height+280)
        }
    }
    func BackgroundRequestForServiceList(){
        
        self.viewNoService.isHidden = true
        self.arrAllService.removeAllObjects()
        appDelegate.ShowActivityIndicator()
        let strUrl = NSString(format: "%@%@",BASE_URL,GET_Service_ByVendor+"\(category.categoryId!)"+"/"+"\(salon.vendorId!)")        
        let manager = AFHTTPRequestOperationManager()
        manager.responseSerializer.acceptableContentTypes = NSSet(objects: "application/json","text/html") as Set<NSObject>
        //******
        manager.get(strUrl as String!, parameters: nil, success: { (operation, responseObject) in
            
            let element : NSDictionary = responseObject as! NSDictionary
            if(((element.object(forKey: "error_code") as! Int)) == 1)
            {
                            let ServiceList : NSArray = element.object(forKey: "data") as! NSArray
                            if ServiceList.count != 0
                            {                                
                                for serviceData : Any in ServiceList {
                                    
                                    let service = ServiceModel()
                                    
                                    if let serviceId = (serviceData as AnyObject).object(forKey: "id") as? Int {
                                        service.serviceId = serviceId
                                    }
                                    else{
                                        service.serviceId = 0
                                    }
                                    if let serviceName = (serviceData as AnyObject).object(forKey: "name") as? String {
                                        service.serviceName = serviceName as NSString!
                                    }
                                    else{
                                        service.serviceName = ""
                                    }
                                    if let serviceTime = (serviceData as AnyObject).object(forKey: "time") as? Int {
                                        service.serviceTime = serviceTime
                                    }
                                    else{
                                        service.serviceTime = 0
                                    }
                                    if let servicePrice = (serviceData as AnyObject).object(forKey: "price") as? Int {
                                        service.servicePrice = servicePrice
                                    }
                                    else{
                                        service.servicePrice = 0
                                    }
                                    self.arrAllService.add(service)
                                }
                                self.tblService.isHidden = false
                                self.tblService.reloadData()
                                self.viewNoService.isHidden = true
                                self.appDelegate.RemoveActivityIndicator()
                            }
                            else
                            {
                                self.tblService.isHidden = true
                                self.viewNoService.isHidden = false
                                self.appDelegate.RemoveActivityIndicator()
                            }
                        }
                        else
                        {
                            let strMessage = element.object(forKey: "message") as! NSString
                            self.appDelegate.ShowAlert(AlertTitle as NSString, alertMessage: strMessage)
                        }
                        self.appDelegate.RemoveActivityIndicator()
            },
            failure: { (operation,error) in
                        
                    let err = error as! NSError
                    print("We got an error here.. \(err.localizedDescription)")
                    print("We got an error here.. \(err.userInfo)")
                    self.appDelegate.ShowAlert(AlertTitle as NSString, alertMessage: INTERNET_CONNECTION as NSString)
                    self.appDelegate.RemoveActivityIndicator()
            })
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
            self.viewMap.isMyLocationEnabled = true
            self.viewMap.settings.myLocationButton = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            
            let latitude = salon.salonLatitude
            let longitude = salon.salonLongitude
            if latitude != ""
            {
                let camera : GMSCameraPosition = GMSCameraPosition.camera(withLatitude: Double(latitude!)!,longitude: Double(longitude!)!, zoom: 10.0)
                self.viewMap.camera = camera

            }
            let marker = GMSMarker()
            if latitude != ""
            {
                marker.position = CLLocationCoordinate2DMake(Double(latitude!)!,Double(longitude!)!)
            }
            marker.map = self.viewMap
            locationManager.stopUpdatingLocation()
        }
    }
    
    func setButtonTextRedColor(_ btn : UIButton){
        btn.layer.borderWidth = 1.0
        btn.layer.borderColor = UIColor.colorRedText().cgColor
        btn.setTitleColor(UIColor.colorRedText(), for: UIControlState())
    }
    
    func setButtonTextBlackColor(_ btn : UIButton){
        btn.layer.borderWidth = 0.0
        btn.layer.borderColor = UIColor.clear.cgColor
        btn.setTitleColor(UIColor.black, for: UIControlState())
    }
    
    public func array(withImages pager: KIImagePager!) -> [Any]! {
       
        return salon.salonImages as [AnyObject]
    }
    
    func placeHolderImage(for pager: KIImagePager!) -> UIImage! {
        return UIImage(named: "default_cutitEvent.png")
    }
    
    func contentMode(forImage image: UInt, in pager: KIImagePager!) -> UIViewContentMode {
        return UIViewContentMode.scaleToFill
    }
    
    func imagePager(_ imagePager: KIImagePager!, didScrollTo index: UInt) {
    }
    
    func imagePager(_ imagePager: KIImagePager!, didSelectImageAt index: UInt) {
    }
    
    @IBAction func btnPrevious_Click(_ sender: UIButton)
    {
        self.imagePager.previous()
    }
    
    @IBAction func btnNext_Click(_ sender: UIButton)
    {
     
        self.imagePager.next()
    }
    
    @IBAction func btnBack_Click(_ sender: UIButton)
    {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnService_Click(_ sender: UIButton)
    {

        if(self.btnService.isSelected == false){
            self.btnService.isSelected = true
            self.btnReview.isSelected = false
            self.btnInfo.isSelected = false
            self.setButtonTextRedColor(btnService)
            self.setButtonTextBlackColor(btnReview)
            self.setButtonTextBlackColor(btnInfo)
            self.viewNoReview.isHidden = true
            self.viewService.isHidden = false
            self.viewInfo.isHidden = true
            self.viewReview.isHidden = true
            if self.arrAllService.count != 0
            {
                self.viewNoService.isHidden = true
            }
            else
            {
                self.viewNoService.isHidden = false
            }
            scrollview.contentSize = CGSize(width: self.scrollview.frame.size.width, height: 50)
            BackgroundRequestForServiceList()
        }
    }
    
    @IBAction func btnReviews_Click(_ sender: UIButton)
    {
        if(self.btnReview.isSelected == false){
            self.btnReview.isSelected = true
            self.btnService.isSelected = false
            self.btnInfo.isSelected = false
            self.setButtonTextRedColor(btnReview)
            self.setButtonTextBlackColor(btnService)
            self.setButtonTextBlackColor(btnInfo)
            self.viewNoService.isHidden = true
            self.viewInfo.isHidden = true
            self.viewService.isHidden = true
            self.viewReview.isHidden = false
            if self.arrAllReview.count != 0
            {
                self.viewNoReview.isHidden = true
            }
            else
            {
                self.viewNoReview.isHidden = false
            }
            scrollview.contentSize = CGSize(width: self.scrollview.frame.size.width, height: 180)
        }
    }
    
    @IBAction func btnInfo_Click(_ sender: UIButton)
    {
        
        if(self.btnInfo.isSelected == false){
            self.arrAllReview.removeAllObjects()
            self.arrAllService.removeAllObjects()
            self.btnInfo.isSelected = true
            self.btnService.isSelected = false
            self.btnReview.isSelected = false
            self.setButtonTextRedColor(btnInfo)
            self.setButtonTextBlackColor(btnService)
            self.setButtonTextBlackColor(btnReview)
            self.viewNoService.isHidden = true
            self.viewNoReview.isHidden = true
            self.viewInfo.isHidden = false
            self.viewService.isHidden = true
            self.viewReview.isHidden = true
            self.tblInfo.reloadData()
            setScrollInfo()
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        if self.btnService.isSelected == true{
            return arrAllService.count
        }
        else if self.btnReview.isSelected == true
        {
            return arrAllReview.count
        }
        else if self.btnInfo.isSelected == true
        {
            return arrAllInfo.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:UICollectionViewCell = UICollectionViewCell()
        if(self.btnService.isSelected == true)
        {
            let  cell = tblService.dequeueReusableCell(withReuseIdentifier: "ServiceCell", for: indexPath) as! ServiceCell
            let objService = self.arrAllService[(indexPath as NSIndexPath).row] as! ServiceModel
            cell.lblServiceName.text = objService.serviceName as String
            if objService.serviceTime == 60
            {
                self.strLength = "1 Hour"
            }
            else if objService.serviceTime == 120
            {
                self.strLength = "2 Hour"
            }
            else if objService.serviceTime == 180
            {
                self.strLength = "3 Hour"
            }
            else if objService.serviceTime == 240
            {
                self.strLength = "4 Hour"
            }
            else
            {
                self.strLength = String(objService.serviceTime) + " Minutes"
            }

            cell.lblPrice.text = "$" + String(objService.servicePrice) + " for " + self.strLength
            
            self.setRadiusToView(cell.viewMain)
            return cell
        }
        else if(self.btnReview.isSelected == true)
        {
            let cell = tblReview.dequeueReusableCell(withReuseIdentifier: "ReviewCell", for: indexPath) as! ReviewCell
            cell.floatRatingView.editable = false
            self.setRadiusToView(cell.contentView)
            
            let objReview = self.arrAllReview[(indexPath as NSIndexPath).row] as! ReviewModel
            cell.lblReviewUserName.text = NSString(format: "%@ %@",objReview.customerFName, objReview.customerLName) as String
            cell.floatRatingView.rating = Float(objReview.reviewRate)
            
            self.getLeftTime(objReview.reviewDate as NSString)
            
            cell.lblReviewDate.text = self.strLeftTime as String
                        
            cell.lblReviewDesc.text = objReview.customerReview
            
            cell.lblReviewDesc.numberOfLines = 0
            cell.lblReviewDesc.lineBreakMode = .byWordWrapping
            let font: UIFont = UIFont.systemFont(ofSize: 13.0)
            
            let expectedLabelSize = cell.lblReviewDesc.text!.boundingRect(
                with: CGSize(width: cell.lblReviewDesc.frame.size.width, height: CGFloat.infinity),
                options: NSStringDrawingOptions.usesLineFragmentOrigin,
                attributes: [NSFontAttributeName: font],
                context: nil).size
            
            cell.lblReviewDesc.frame.size.height = expectedLabelSize.height + 10
            cell.viewMain.frame.size.height = cell.lblReviewDesc.frame.size.height + 80
            
            cell.viewBottom.frame = CGRect(x: cell.viewBottom.frame.origin.x, y: expectedLabelSize.height + cell.lblReviewDesc.frame.origin.y + 10, width: cell.viewBottom.frame.size.width, height: cell.viewBottom.frame.size.height)
            
            return cell
        }
        else if(self.btnInfo.isSelected == true)
        {
            let cell = tblInfo.dequeueReusableCell(withReuseIdentifier: "SocialMediaInfoCell", for: indexPath) as! SocialMediaInfoCell
            let dict : NSDictionary = arrAllInfo[(indexPath as NSIndexPath).row] as! NSDictionary
        
                if dict["FB"] != nil
                {
                    if dict["FB"] as! Int == 1
                    {
                        cell.lblSocialMediaInfoUrl.text = dict.object(forKey: "FBUrl") as? String
                        cell.imgSocialMedia.image = UIImage(named: "fb_25.png")
                    }
                }
            
                if dict["WEB"] != nil
                {
                    if dict["WEB"] as! Int == 1
                    {
                        cell.lblSocialMediaInfoUrl.text = dict.object(forKey: "WebUrl") as? String
                        cell.imgSocialMedia.image = UIImage(named: "Business-website.png")
                    }
                }
                if dict["YELP"] != nil
                {
                    if dict["YELP"] as! Int == 1
                    {
                        cell.lblSocialMediaInfoUrl.text = dict.object(forKey: "YelpUrl") as? String
                        cell.imgSocialMedia.image = UIImage(named: "Yelp-URL.png")
                    }
                }
            
                if dict["TWITTER"] != nil
                {
                    if dict["TWITTER"] as! Int == 1
                    {
                        cell.lblSocialMediaInfoUrl.text = dict.object(forKey: "TwitterUrl") as? String
                        cell.imgSocialMedia.image = UIImage(named: "twitter_25.png")
                    }
                }
            
                if dict["INSTAGRAM"] != nil
                {
                    if dict["INSTAGRAM"] as! Int == 1
                    {
                        cell.lblSocialMediaInfoUrl.text = dict.object(forKey: "InstagramUrl") as? String
                        cell.imgSocialMedia.image = UIImage(named: "insta_25.png")
                    }
                }
            return cell
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if(self.viewReview.isHidden != true){
            
           let font: UIFont = UIFont.systemFont(ofSize: 13.0)
           let objReview = self.arrAllReview[(indexPath as NSIndexPath).row] as! ReviewModel
            
           let expectedLabelSize = objReview.customerReview!.boundingRect(
                with: CGSize(width: 289, height: CGFloat.infinity),
                options: NSStringDrawingOptions.usesLineFragmentOrigin,
                attributes: [NSFontAttributeName: font],
                context: nil).size
            return CGSize(width:306 ,height: 95 + expectedLabelSize.height - 26)
        }
        else if(self.viewInfo.isHidden != true)
        {
            return CGSize(width:300 ,height: 20)
        }
        return CGSize(width:306 ,height: 61)
    }
    
    func getLeftTime(_ strDate : NSString){
        
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        let fullDate = dateFormatter.date(from: strDate as String)
        
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let strCurrentDate = formatter.string(from: Foundation.Date())
        
        let fmt: DateFormatter = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let currentDate = fmt.date(from: strCurrentDate as String)
        
        let diff = getCurrentTimeMillis(currentDate!) - getCurrentTimeMillis(fullDate!)
        let second = diff / 1000
        let minute = second / 60
        let hours = minute / 60
        let days = hours / 24
        
        if (days < 1) {
            if (second >= 0 || second < 0) {
                if (second == 1) {
                    strLeftTime = NSString(format: "%d second ago", second)
                } else if (second > 1) {
                    strLeftTime = NSString(format: "%d seconds ago", second)
                } else {
                    strLeftTime = "few second ago";
                }
            }
            if (minute > 0) {
                if (minute == 1) {
                    strLeftTime = NSString(format: "%d minute ago", minute)
                } else {
                    strLeftTime = NSString(format: "%d minutes ago", minute)
                }
            }
            if (hours > 0) {
                if (hours == 1) {
                    strLeftTime = NSString(format: "%d hour ago", hours)
                } else {
                    strLeftTime = NSString(format: "%d hours ago", hours)
                }
            }
        } else
        {
            dateFormatter.dateFormat = "MMM dd"
            strLeftTime = dateFormatter.string(from: fullDate!) as NSString!
        }
    }
    
    func getCurrentTimeMillis(_ date: Foundation.Date)->Int64{
        return  Int64(date.timeIntervalSince1970 * 1000)
    }
    
    
    func setRadiusToView(_ view : UIView){
        view.layer.cornerRadius = 2.0
        if(view ==  self.viewReviewCount){
            view.layer.borderColor = UIColor.colorRedText().cgColor
            view.layer.cornerRadius = view.frame.size.height/2
            view.layer.masksToBounds = true
        }
        else{
            view.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        }
        view.layer.borderWidth = 1.0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
