//
//  HomeDetailViewController.swift
//  CutIt
//
//  Created by Coldfin lab

//  Copyright © 2017 Coldfin lab. All rights reserved.


import UIKit
import CoreLocation

class HomeDetailViewController: UIViewController,UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate, CLLocationManagerDelegate,UITextFieldDelegate {

    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var viewSalon: UIView!
    @IBOutlet weak var tblVendor: UICollectionView!
    @IBOutlet weak var txtCity: UITextField!
    
    var locationManager = CLLocationManager()
    var appDelegate = AppDelegate()
    var category = CategoryModel()
    var salon = SalonModel()
    var arrAllVendor = NSMutableArray()
    var arrFilteredVendor = NSMutableArray()
    var arrFilteredCity = NSMutableArray()
    var preventAnimation = Set<IndexPath>()
    var viewSearch : ViewLayout!
    let imageDownloadsInProgress = NSMutableDictionary()
    let imageRatingDownloadsInProgress = NSMutableDictionary()
    var latitude = Double(), longitude = Double()
    var arrSocialMedia = NSMutableArray()
    var reviewCount = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.BackgroundRequestForGetListOfSalonsOfCategory()
        self.viewSalon.isHidden = true
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        self.lblMessage.frame = CGRect(x: self.lblMessage.frame.origin.x, y: self.lblMessage.frame.origin.y + 10, width: self.lblMessage.frame.size.width, height: self.lblMessage.frame.size.height)
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            
            locationManager.startUpdatingLocation()
        }
        if(IS_IPHONE_4_OR_LESS)
        {
            self.tblVendor.frame = CGRect(x:self.tblVendor.frame.origin.x,y:self.tblVendor.frame.origin.y, width: self.tblVendor.frame.size.width, height: self.tblVendor.frame.size.height - 90)
        }
    }
    
      
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if !preventAnimation.contains(indexPath) {
            preventAnimation.insert(indexPath)
            CellAnimator.animate(cell)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        let currentLocation = locations.last
        self.latitude = currentLocation!.coordinate.latitude
        self.longitude = currentLocation!.coordinate.longitude
    }
    
    func BackgroundRequestForGetListOfSalonsOfCategory(){
        self.arrFilteredVendor.removeAllObjects()
        self.arrFilteredCity.removeAllObjects()
        self.arrAllVendor.removeAllObjects()

        appDelegate.ShowActivityIndicator()
        let strUrl = NSString(format: "%@%@",BASE_URL,GET_Salon_OfCategory+"\(category.categoryId!)")
        let manager = AFHTTPRequestOperationManager()
        manager.responseSerializer.acceptableContentTypes = NSSet(objects: "application/json","text/html") as Set<NSObject>
        //********
        manager.get(strUrl as String!, parameters: nil, success: { (operation, responseObject) in
            
                        let element : NSDictionary = responseObject as! NSDictionary
                        if(((element.object(forKey: "error_code") as! Int)) == 1)
                        {
                            let SalonList : NSArray = element.object(forKey: "data") as! NSArray
                            if SalonList.count != 0
                            {
                                for salonData:Any in SalonList
                                {
                                    let salon = SalonModel()
                                    
                                    if let vendorId = (salonData as AnyObject).object(forKey: "vendor_id") as? Int {
                                        salon.vendorId = vendorId
                                    }
                                    else{
                                        salon.vendorId = 0
                                    }
                                    if let salonId = (salonData as AnyObject).object(forKey: "id") as? Int {
                                        salon.salonId = salonId
                                    }
                                    else{
                                        salon.salonId = 0
                                    }
                                    if let salonName = (salonData as AnyObject).object(forKey: "name") as? NSString {
                                        salon.salonName = salonName
                                    }
                                    else{
                                        salon.salonName = ""
                                    }
                                    if let salonCity = (salonData as AnyObject).object(forKey: "city") as? String {
                                        salon.salonCity = salonCity as NSString!
                                    }
                                    else{
                                        salon.salonCity = ""
                                    }
                                    if let salonDescription = (salonData as AnyObject).object(forKey: "description") as? String {
                                        salon.salonDescription = salonDescription
                                    }
                                    else{
                                        salon.salonDescription = ""
                                    }
                                    if let salonAddress = (salonData as AnyObject).object(forKey: "address") as? String {
                                        salon.salonAddress = salonAddress
                                    }
                                    else{
                                        salon.salonAddress = ""
                                    }
                                    if let salonPhone = (salonData as AnyObject).object(forKey: "phone") as? String {
                                        salon.salonPhone = salonPhone
                                    }
                                    else{
                                        salon.salonPhone = ""
                                    }
                                    if let salonLatitude = (salonData as AnyObject).object(forKey: "latitude") as? String {
                                        salon.salonLatitude = salonLatitude
                                    }
                                    else{
                                        salon.salonLatitude = ""
                                    }
                                    if let salonLongitude = (salonData as AnyObject).object(forKey: "longitude") as? String {
                                        salon.salonLongitude = salonLongitude
                                    }
                                    else{
                                        salon.salonLongitude = ""
                                    }
                                    if let salonGalleryCount = (salonData as AnyObject).object(forKey: "gallery_count") as? Int {
                                        salon.salonGallerycount = salonGalleryCount
                                    }
                                    else{
                                        salon.salonGallerycount = 0
                                    }
                                    if let salonImage = (salonData as AnyObject).object(forKey: "shop_logo") as? NSString {
                                        salon.salonImage = salonImage
                                    }
                                    else{
                                        salon.salonImage = ""
                                    }
                                    if let salonImages = (salonData as AnyObject).object(forKey: "shop_gallery") as? NSArray {
                                        salon.salonImages = salonImages
                                    }
                                    else{
                                        salon.salonImages = []
                                    }
                                    if let vendorDetails : NSDictionary = (salonData as AnyObject).object(forKey: "vendor") as? NSDictionary {
                                        
                                        if let vendorFirstName = (vendorDetails as AnyObject).object(forKey: "first_name") as? String {
                                            salon.vendorFirstName = vendorFirstName
                                        }
                                        else{
                                            salon.vendorFirstName = ""
                                        }
                                        if let vendorLastName = (vendorDetails as AnyObject).object(forKey: "last_name") as? String {
                                            salon.vendorLastName = vendorLastName
                                        }
                                        else{
                                            salon.vendorLastName = ""
                                        }
                                        if let vendorImage = (vendorDetails as AnyObject).object(forKey: "img_url") as? NSString {
                                            salon.vendorImage = vendorImage
                                        }
                                        else{
                                            salon.vendorImage = ""
                                        }
                                        if let reviewCount = (vendorDetails as AnyObject).object(forKey: "ratings") as? NSDictionary
                                        {
                                            if let reviewCount = (reviewCount as AnyObject).object(forKey: "review_count") as? Int {
                                                salon.reviewCount = reviewCount
                                            }
                                            else{
                                                salon.reviewCount = 0
                                            }
                                            if let ratingCount = (reviewCount as AnyObject).object(forKey: "rating_img_url") as? String {
                                                salon.ratingCount = ratingCount
                                            }
                                            else{
                                                salon.ratingCount = ""
                                            }
                                        }
                                        if let vendorFbUrl = (vendorDetails as AnyObject).object(forKey: "facebook_url") as? String {
                                            salon.vendorFbUrl = vendorFbUrl
                                        }
                                        else{
                                            salon.vendorFbUrl = ""
                                        }
                                        if let vendorTwitterUrl = (vendorDetails as AnyObject).object(forKey: "twitter_url") as? String {
                                            salon.vendorTwitterUrl = vendorTwitterUrl
                                        }
                                        else{
                                            salon.vendorTwitterUrl = ""
                                        }
                                        if let vendorWebUrl = (vendorDetails as AnyObject).object(forKey: "website_url") as? String {
                                            salon.vendorWebUrl = vendorWebUrl
                                        }
                                        else{
                                            salon.vendorWebUrl = ""
                                        }
                                        if let vendorYelpUrl = (vendorDetails as AnyObject).object(forKey: "yelp_url") as? String {
                                            salon.vendorYelpUrl = vendorYelpUrl
                                        }
                                        else{
                                            salon.vendorYelpUrl = ""
                                        }
                                        if let vendorInstagramUrl = (vendorDetails as AnyObject).object(forKey: "instagram_url") as? String {
                                            salon.vendorInstagramUrl = vendorInstagramUrl
                                        }
                                        else{
                                            salon.vendorInstagramUrl = ""
                                        }
                                    }
                                    salon.imageModel = ImageModel()
                                    salon.imageModel.imageURLString = salon.salonImage
                                    salon.imageModel.ratingURLString = salon.ratingCount as NSString!
                                    
                                    self.arrAllVendor.add(salon)
                                    self.tblVendor.isHidden = false
                                    self.viewSalon.isHidden = true
                                    self.tblVendor.reloadData()
                                    self.appDelegate.RemoveActivityIndicator()
                                }
                            }
                            else
                            {
                                self.appDelegate.RemoveActivityIndicator()
                                self.tblVendor.isHidden = true
                                self.viewSalon.isHidden = false
                                self.lblMessage.text = "No salon is available for \(self.category.categoryName!) right now."
                                self.lblHeading.text = "Oops!"
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
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if arrAllVendor.count != 0
        {
            if arrFilteredCity.count != 0{
                return arrFilteredCity.count
            }
            else{
                 return arrAllVendor.count
            }
        }
        else
        {
            if arrFilteredCity.count != 0{
                return arrFilteredCity.count
            }
            else{
                return arrFilteredVendor.count
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VendorDetailsCell", for: indexPath) as! VendorDetailsCell
        
        if arrFilteredCity.count != 0
        {
            salon = arrFilteredCity[(indexPath as NSIndexPath).row] as! SalonModel
        }
        else if arrFilteredVendor.count != 0
        {
            salon = arrFilteredVendor[(indexPath as NSIndexPath).row] as! SalonModel
        }
        else if arrAllVendor.count != 0
        {
            salon = arrAllVendor[(indexPath as NSIndexPath).row] as! SalonModel
        }
       
        cell.lblShopName.text = salon.salonName as String
        cell.lblVendorName.text = salon.vendorFirstName + " " + salon.vendorLastName
        cell.lblPhotoCount.text = String(salon.salonGallerycount)
        if salon.reviewCount > 1
        {
            cell.lblReviewCount.text = String(salon.reviewCount) + " Reviews "
        }
        else
        {
            cell.lblReviewCount.text = String(salon.reviewCount) + " Review "
        }
        cell.imgRating.sd_setImage(with: URL(string: salon.ratingCount), placeholderImage: UIImage(named: "default_rating.png"))
        cell.imgShop.sd_setImage(with: URL(string: salon.salonImage as String), placeholderImage: UIImage(named: "default_cutitEvent.png"))
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if arrAllVendor.count != 0
        {
            if arrFilteredCity.count != 0{
                salon = arrFilteredCity[(indexPath as NSIndexPath).row] as! SalonModel
            }
            else{
               salon = arrAllVendor[(indexPath as NSIndexPath).row] as! SalonModel
            }
        }
        else
        {
            if arrFilteredCity.count != 0{
                salon = arrFilteredCity[(indexPath as NSIndexPath).row] as! SalonModel
            }
            else{
                salon = arrFilteredVendor[(indexPath as NSIndexPath).row] as! SalonModel
            }
        }
        let storyboard=UIStoryboard(name: "Main", bundle: nil)
        let searchVC = storyboard.instantiateViewController(withIdentifier: IdentifireSearchDetailView) as! SearchDetailViewController
        searchVC.category = category
        searchVC.salon = salon
        searchVC.indexPath = (indexPath as NSIndexPath).row
        searchVC.arrAllInfo.removeAllObjects()
        if salon.vendorFbUrl != ""
        {
            let dictFB : NSDictionary = ["FB" : 1, "FBUrl" : salon.vendorFbUrl] as NSDictionary
            searchVC.arrAllInfo.add(dictFB)
        }
        if salon.vendorWebUrl != ""
        {
            let dictWeb : NSDictionary = ["WEB" : 1, "WebUrl" : salon.vendorWebUrl] as NSDictionary
            searchVC.arrAllInfo.add(dictWeb)
        }
        if salon.vendorYelpUrl != ""
        {
            let dictYelp : NSDictionary = ["YELP" : 1, "YelpUrl" : salon.vendorYelpUrl] as NSDictionary
            searchVC.arrAllInfo.add(dictYelp)
        }
        if salon.vendorTwitterUrl != ""
        {
            let dictTwitter : NSDictionary = ["TWITTER" : 1, "TwitterUrl" : salon.vendorTwitterUrl] as NSDictionary
            searchVC.arrAllInfo.add(dictTwitter)
        }
        if salon.vendorInstagramUrl != ""
        {
            let dictInstagram : NSDictionary = ["INSTAGRAM" : 1, "InstagramUrl" : salon.vendorInstagramUrl] as NSDictionary
            searchVC.arrAllInfo.add(dictInstagram)
        }

        self.navigationController?.pushViewController(searchVC, animated: false)
    }
    
    @IBAction func btnNearestBarber_Click(_ sender: UIButton)
    {
      
        if(sender.isSelected == true){
            sender.isSelected = false
        }
        else{
            sender.isSelected = true
        }
    }
    
    @IBAction func btnNewestBarber_Click(_ sender: UIButton)
    {
        
        if(sender.isSelected == true){
            sender.isSelected = false
        }
        else{
            sender.isSelected = true
        }
    }
    
    
    func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        if(self.viewSearch != nil){
            self.viewSearch.removeFromSuperview()
        }
    }
  
    @IBAction func btnMap_Click(_ sender: UIButton)
    {
        let storyboard=UIStoryboard(name: "Main", bundle: nil)
        let hashtagVC = storyboard.instantiateViewController(withIdentifier: IdentifireMapView) as! MapViewController
        
        if arrAllVendor.count != 0
        {
            if arrFilteredCity.count != 0
            {
                for i in 0..<arrFilteredCity.count
                {
                    salon = arrFilteredCity[i] as! SalonModel
                    hashtagVC.arrLatLong.add(salon)
                }
            }
            else
            {
                for i in 0..<arrAllVendor.count
                {
                    salon = arrAllVendor[i] as! SalonModel
                    hashtagVC.arrLatLong.add(salon)
                }
            }
        }
        else
        {
            if arrFilteredCity.count != 0
            {
                for i in 0..<arrFilteredCity.count
                {
                    salon = arrFilteredCity[i] as! SalonModel
                    hashtagVC.arrLatLong.add(salon)
                }
            }
            else
            {
                for i in 0..<arrFilteredVendor.count
                {
                    salon = arrFilteredVendor[i] as! SalonModel
                    hashtagVC.arrLatLong.add(salon)
                }
            }
        }
        self.navigationController?.pushViewController(hashtagVC, animated: false)
    }
    
    func passHashTagLibToPreviousVC(_ arrWordLib: NSMutableArray) {
       
        self.viewSearch.isHidden =  false
        
        var strHashTag : NSString = ""
        
        for i in 0...arrWordLib.count-1 {
            
            let hashTag = arrWordLib[i] as? String
            strHashTag = strHashTag.appendingFormat(",%@", hashTag!)
        }
        
        let hashTag = strHashTag.substring(from: 1)
        self.viewSearch.lblHashtag.text = hashTag as String
    }
    
    func showSearchViewToPreviousVC() {
        self.viewSearch.isHidden =  false
    }
    
    @IBAction func btnBack_Click(_ sender: UIButton)
    {
        _ = navigationController?.popViewController(animated: true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       
        self.arrFilteredCity.removeAllObjects()

        if(textField == txtCity)
        {
            if txtCity.text != ""
            {
                if arrFilteredVendor.count == 0
                {
                    if arrAllVendor.count != 0
                    {
                        for i in 0..<arrAllVendor.count
                        {
                            salon = arrAllVendor[i] as! SalonModel
                            let city = (txtCity.text)!.trimmingCharacters(in: .whitespacesAndNewlines)
                            let salonCity = (salon.salonCity as String).trimmingCharacters(in: .whitespacesAndNewlines)
                            if city.caseInsensitiveCompare(salonCity) == .orderedSame{
                                self.arrFilteredCity.add(salon)
                            }
                            if self.arrFilteredCity.count != 0
                            {
                                self.viewSalon.isHidden = true
                                self.tblVendor.isHidden = false
                            }
                            else
                            {
                                self.tblVendor.isHidden = true
                                self.viewSalon.isHidden = false
                                self.lblMessage.text = "No matches found in your location. Please try another search."
                                self.lblHeading.text = "Sorry!"
                            }
                        }
                    }
                }
                else
                {
                    if arrFilteredVendor.count != 0
                    {
                        for i in 0..<arrFilteredVendor.count
                        {
                            salon = arrFilteredVendor[i] as! SalonModel
                            let city = (txtCity.text)!.trimmingCharacters(in: .whitespacesAndNewlines)
                            let salonCity = (salon.salonCity as String).trimmingCharacters(in: .whitespacesAndNewlines)
                            if city.caseInsensitiveCompare(salonCity) == .orderedSame
                            {
                                self.arrFilteredCity.add(salon)
                            }
                            if self.arrFilteredCity.count != 0
                            {
                                self.viewSalon.isHidden = true
                                self.tblVendor.isHidden = false
                            }
                            else
                            {
                                self.tblVendor.isHidden = true
                                self.viewSalon.isHidden = false
                                self.lblMessage.text = "No matches found in your location. Please try another search."
                                self.lblHeading.text = "Sorry!"
                            }
                        }
                    }
                }
            }
            else
            {
                self.tblVendor.reloadData()
            }
        }
        self.tblVendor.reloadData()
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func btnRefresh(_ sender: AnyObject) {
        
        self.txtCity.text = ""
        self.viewSalon.isHidden = true
        self.tblVendor.isHidden = false
        self.BackgroundRequestForGetListOfSalonsOfCategory()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
