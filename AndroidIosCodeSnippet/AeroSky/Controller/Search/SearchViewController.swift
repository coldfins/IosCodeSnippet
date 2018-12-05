//
//  SearchViewController.swift
//  AeroSky
//
//  Created by Coldfin Lab on 20-7-2017.
//  Copyright © 2017 Coldfin Lab. All rights reserved.
//

import UIKit

@objc protocol sendSearchResultData
{
    @objc optional func sendSearchResult(_ arrSearchResult:NSMutableArray)
}

class SearchViewController: UIViewController,MLPAutoCompleteTextFieldDelegate,UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate,ViewPagerIndicatorDelegate {
    
    var delegate:sendSearchResultData?
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var txtLocality: MLPAutoCompleteTextField!
    @IBOutlet weak var btnBedOne: UIButton!
    @IBOutlet weak var btnBedTwo: UIButton!
    @IBOutlet weak var btnBedThree: UIButton!
    @IBOutlet weak var btnBedFour: UIButton!
    @IBOutlet weak var btnBedFive: UIButton!
    @IBOutlet weak var btnBedAny: UIButton!
    @IBOutlet weak var btnBathOne: UIButton!
    @IBOutlet weak var btnBathTwo: UIButton!
    @IBOutlet weak var btnBathThree: UIButton!
    @IBOutlet weak var btnBathFour: UIButton!
    @IBOutlet weak var btnBathFive: UIButton!
    @IBOutlet weak var btnBathAny: UIButton!
    @IBOutlet weak var rangeSlider : RangeSlider?
    @IBOutlet weak var lowerLabel : UILabel!
    @IBOutlet weak var upperLabel: UILabel!
    @IBOutlet var tblPropertyType: UICollectionView!
    @IBOutlet weak var viewPagerIndicator: ViewPagerIndicator!
    @IBOutlet weak var viewRooms: UIView!
    @IBOutlet weak var viewPG: UIView!
    @IBOutlet weak var viewProperty: UIView!
    @IBOutlet weak var btnPgGirl: UIButton!
    @IBOutlet weak var btnPgBoy: UIButton!
    @IBOutlet weak var btnPgBoth: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    
    var indicatorIndex: Int = 0
    var scrollViewHeight: CGFloat!
    var appDel : AppDelegate!
    var arrAllCities = NSMutableArray()
    var arrAllPropertyType = NSMutableArray()
    var arrSelectedProperty = NSMutableArray()
    var arrSelectedPg = NSMutableArray()
    var arrSelectedBathroom = NSMutableArray()
    var arrSelectedBedroom = NSMutableArray()
    var selectedIndexPath =  IndexPath()
    var arrSearch = NSMutableArray()
    var dictSelectedPropertyData = NSMutableDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDel = UIApplication.shared.delegate as! AppDelegate
        self.navigationController?.navigationItem.title = "Search"
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.setHorizontalTabbar()
        
        if(self.appDel.isShortcut == true){
            btnBack.isHidden = true
        }
        else{
            btnBack.isHidden = false
        }

        
        if(IS_IPHONE_4_OR_LESS){
            mainScrollView.contentSize = CGSize(width: self.mainScrollView.frame.size.width, height: self.mainScrollView.frame.size.height+80)
        }
        
        self.txtLocality.layer.sublayerTransform = CATransform3DMakeTranslation(30, 0, 0);
        self.txtLocality.registerAutoCompleteCellClass(DEMOCustomAutoCompleteCell.self, forCellReuseIdentifier: "CustomCellId")
        
        self.viewPG.isHidden = true
        self.viewRooms.isHidden = false
        rangeSlider!.trackHighlightTintColor = UIColor.colorLikeNavigationBackground()
        self.lowerLabel.text = NSString(format: "\u{20B9} 5 L") as String
        self.upperLabel.text = NSString(format: "\u{20B9} 4 Cr") as String
        
        rangeSlider!.addTarget(self, action: #selector(SearchViewController.rangeSliderValueChanged(_:)), for: .valueChanged)
        self.BackgroundRequestForGetListAllCity()
        self.BackgroundRequestForGetListOfAllPropertyType()
    }
    
    @IBAction func btnSearch(){
        
        let lowerLable: String = self.lowerLabel.text!
        let lowerValue = lowerLable.components(separatedBy: NSString(format: "\u{20B9} ") as String)
        let min_value: String? = lowerValue[1]
        NSLog("min_value.....%@",  min_value!)
        
        let upperLable: String = self.upperLabel.text!
        let upperValue = upperLable.components(separatedBy: NSString(format: "\u{20B9} ") as String)
        let max_value: String? = upperValue[1]
        NSLog("max_value.....%@",  max_value!)
        
        if(self.indicatorIndex == 0){
            self.BackgroundRequestForPostSearchingData(self.txtLocality.text! as NSString, property_for: "sell", min_price: min_value! as NSString, max_price: max_value! as NSString)
        }
        else if(self.indicatorIndex == 1){
            self.BackgroundRequestForPostSearchingData(self.txtLocality.text! as NSString, property_for: "rent", min_price: min_value! as NSString, max_price: max_value! as NSString)
        }
        else{
            self.BackgroundRequestForPostSearchingData(self.txtLocality.text! as NSString, property_for: "pg", min_price: min_value! as NSString, max_price: max_value! as NSString)
        }
        
    }
    
    func setHorizontalTabbar(){
        
        viewPagerIndicator.titles = ["FOR BUY","FOR RENT","FOR PG"]
        viewPagerIndicator.delegate = self
        scrollViewHeight = self.view.bounds.height - viewPagerIndicator.bounds.height - 20
        
        for i in 0 ..< viewPagerIndicator.count{
            let title = viewPagerIndicator.titles[i] as! String
        }
        viewPagerIndicator.indicatorDirection = .bottom
        
    }
    
    func indicatorChange(_ indicatorIndex: Int){
        
        self.indicatorIndex = indicatorIndex
        
        if(indicatorIndex == 0){
            self.viewPG.isHidden = true
            self.viewRooms.isHidden = false
            
            self.viewProperty.frame.origin.y = 259
            rangeSlider?.lowerValue = 0
            rangeSlider?.upperValue = 100
            
            rangeSlider!.trackHighlightTintColor = UIColor.colorLikeNavigationBackground()
            
            self.lowerLabel.text = NSString(format: "\u{20B9} 5 L") as String
            self.upperLabel.text = NSString(format: "\u{20B9} 4 Cr") as String
            rangeSlider!.addTarget(self, action: #selector(SearchViewController.rangeSliderValueChanged(_:)), for: .valueChanged)
        }
        else if(indicatorIndex == 1){
            self.viewPG.isHidden = true
            self.viewRooms.isHidden = false
            self.viewProperty.frame.origin.y = 259
            
            rangeSlider?.lowerValue = 0
            rangeSlider?.upperValue = 100
            
            rangeSlider!.trackHighlightTintColor = UIColor.colorLikeNavigationBackground()
            self.lowerLabel.text = NSString(format: "\u{20B9} 10 K") as String
            self.upperLabel.text = NSString(format: "\u{20B9} 5 L") as String
            rangeSlider!.addTarget(self, action: #selector(SearchViewController.rangeSliderValueChanged(_:)), for: .valueChanged)
        }
        else if(indicatorIndex == 2){
            self.viewPG.isHidden = false
            self.viewRooms.isHidden = true
            self.viewProperty.frame.origin.y = self.viewPG.frame.origin.y+self.viewPG.frame.size.height
            
            rangeSlider?.lowerValue = 0
            rangeSlider?.upperValue = 100
            
            rangeSlider!.trackHighlightTintColor = UIColor.colorLikeNavigationBackground()
            self.lowerLabel.text = NSString(format: "\u{20B9} 10 K") as String
            self.upperLabel.text = NSString(format: "\u{20B9} 90 K") as String
            rangeSlider!.addTarget(self, action: #selector(SearchViewController.rangeSliderValueChanged(_:)), for: .valueChanged)
        }
        
    }
    
    func BackgroundRequestForPostSearchingData(_ city : NSString, property_for : NSString, min_price : NSString, max_price : NSString){
        
        appDel.ShowActivityIndicator()
        
        let strUrl = NSString(format: "%@%@",BASE_URL,POST_SEARCH_DATA)
        
        print("URL: " + (strUrl as String))
        
        let parameters = NSMutableDictionary()
        
        if(self.indicatorIndex == 0 || self.indicatorIndex == 1){
            if(self.btnBedOne.isSelected == true){
                self.arrSelectedBedroom.add("1")
            }
            if(self.btnBedTwo.isSelected == true){
                self.arrSelectedBedroom.add("2")
            }
            if(self.btnBedThree.isSelected == true){
                self.arrSelectedBedroom.add("3")
            }
            if(self.btnBedFour.isSelected == true){
                self.arrSelectedBedroom.add("4")
            }
            if(self.btnBedFive.isSelected == true){
                self.arrSelectedBedroom.add("5")
            }
            if(self.btnBedAny.isSelected == true){
                self.arrSelectedBedroom.add("any")
            }
            parameters.setObject(self.arrSelectedBedroom, forKey: "bhk_type" as NSCopying)
            
            if(self.btnBathOne.isSelected == true){
                self.arrSelectedBathroom.add("1")
            }
            if(self.btnBathTwo.isSelected == true){
                self.arrSelectedBathroom.add("2")
            }
            if(self.btnBathThree.isSelected == true){
                self.arrSelectedBathroom.add("3")
            }
            if(self.btnBathFour.isSelected == true){
                self.arrSelectedBathroom.add("4")
            }
            if(self.btnBathFive.isSelected == true){
                self.arrSelectedBathroom.add("5")
            }
            if(self.btnBathAny.isSelected == true){
                self.arrSelectedBathroom.add("any")
            }
            
            parameters.setObject(self.arrSelectedBathroom, forKey: "bathroom" as NSCopying)
        }
        else{
            if(self.btnPgBoth.isSelected == true){
                self.arrSelectedPg.add("both")
            }
            else if(self.btnPgBoy.isSelected == true){
                self.arrSelectedPg.add("boy")
            }
            else if(self.btnPgGirl.isSelected == true){
                self.arrSelectedPg.add("girl")
            }
            parameters.setObject(self.arrSelectedPg, forKey: "bhk_type" as NSCopying)
        }
        
        parameters.setObject(city, forKey: "city" as NSCopying)
        parameters.setObject(property_for, forKey: "property_for" as NSCopying)
        parameters.setObject(min_price, forKey: "min_price" as NSCopying)
        parameters.setObject(max_price, forKey: "max_price" as NSCopying)
        parameters.setObject("600 sqft", forKey: "min_build_area" as NSCopying)
        parameters.setObject("15000 sqft", forKey: "max_build_area" as NSCopying)
        parameters.setObject(self.arrSelectedProperty, forKey: "property_type" as NSCopying)
        
        NSLog("Parameters......%@", parameters.description)
        
        let manager = AFHTTPRequestOperationManager()
        manager.responseSerializer.acceptableContentTypes = NSSet(objects: "application/json","text/html") as Set<NSObject>
        
        manager.post(strUrl as String,
            parameters: parameters,
            success: { (operation,responseObject) in
                print("JSON: " + responseObject.debugDescription)
                
                let element : NSDictionary = responseObject as! NSDictionary
                
                let status = element.object(forKey: "code") as AnyObject?
                
                if(status?.intValue == 0){
                    let propertyList : NSArray = element.object(forKey: "properties_lists") as! NSArray
                    NSLog("Meta Data.....%@", propertyList)
                    
                    for propetyData in propertyList {
                        
                        let project = ProjectsModel()
                        
                        if let id = (propetyData as AnyObject).object(forKey: "id") as? Int {
                            project.id = id
                        }
                        else{
                            project.id = 0
                        }
                        
                        if let user_first_name = (propetyData as AnyObject).object(forKey: "user_first_name") as? String {
                            project.firstName = user_first_name as NSString!
                        }
                        else{
                            project.firstName = ""
                        }
                        
                        if let user_last_name = (propetyData as AnyObject).object(forKey: "user_last_name") as? String {
                            project.lastName = user_last_name as NSString!
                        }
                        else{
                            project.lastName = ""
                        }
                        
                        if let addedby = (propetyData as AnyObject).object(forKey: "addedby") as? String {
                            project.usertype = addedby as NSString!
                        }
                        else{
                            project.usertype = ""
                        }
                        
                        
                        if let address = (propetyData as AnyObject).object(forKey: "address") as? String {
                            project.address = address as NSString!
                        }
                        else{
                            project.address = ""
                        }
                        
                        if let area = (propetyData as AnyObject).object(forKey: "area") as? String {
                            project.area = area as NSString!
                        }
                        else{
                            project.area = ""
                        }
                        
                        if let rate = (propetyData as AnyObject).object(forKey: "rate") as? Int {
                            project.rate = rate
                        }
                        else{
                            project.rate = 0
                        }
                        
                        if let bathroom = (propetyData as AnyObject).object(forKey: "bathroom") as? Int {
                            project.bathroom = bathroom
                        }
                        else{
                            project.bathroom = 0
                        }
                        
                        if let latitude = (propetyData as AnyObject).object(forKey: "latitude") as? Double {
                            project.latitude = latitude
                        }
                        else{
                            project.latitude = 0.0
                        }
                        
                        if let longitude = (propetyData as AnyObject).object(forKey: "longitude") as? Double {
                            project.longitude = longitude
                        }
                        else{
                            project.longitude = 0.0
                        }
                        
                        if let contact_no = (propetyData as AnyObject).object(forKey: "user_contact_no") as? CLong {
                            project.user_contact_no = contact_no
                        }
                        else{
                            project.user_contact_no = 0000000000
                        }
                        
                        if let city = (propetyData as AnyObject).object(forKey: "city") as? NSString {
                            project.city = city
                        }
                        else{
                            project.city = ""
                        }
                        
                        if let bhktype = (propetyData as AnyObject).object(forKey: "bhktype") as? NSString {
                            project.bhktype = bhktype
                        }
                        else{
                            project.bhktype = ""
                        }
                        
                        if let propertyphoto_url = (propetyData as AnyObject).object(forKey: "propertyphoto_url") as? NSString {
                            project.propertyphoto_url = propertyphoto_url
                            project.imageModel = ImageModel()
                            project.imageModel.imageURLString = propertyphoto_url
                           
                        }
                        else{
                            project.propertyphoto_url = ""
                            project.imageModel = ImageModel()
                            project.imageModel.imageURLString = ""
                        }
                        
                        if let propertytypes = (propetyData as AnyObject).object(forKey: "propertytypes") as? NSString {
                            project.propertytypes = propertytypes
                        }
                        else{
                            project.propertytypes = ""
                        }
                        
                        if let propertyFor = (propetyData as AnyObject).object(forKey: "property_for") as? NSString {
                            project.property_for = propertyFor
                        }
                        else{
                            project.property_for = ""
                        }
                        
                        self.arrSearch.add(project)
                        
                    }
                    
                    if let myDelegate = self.delegate {
                        self.delegate?.sendSearchResult!(self.arrSearch)
                    }
                    
                    if(self.appDel.isShortcut == true){
                        
                        self.appDel.isShortcut = false
                        
                        UITabBar.appearance().barTintColor = UIColor.white
                        //To change the image/text color on selection
                        UITabBar.appearance().tintColor = UIColor.colorLikeNavigationBackground()
                        
                        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "tabBarcontroller") as! UITabBarController
                        UIApplication.shared.keyWindow?.rootViewController = viewController;
                        
                    }
                    else{
                        self.navigationController?.popViewController(animated: true)
                    }
                  
                    
                }
                else if(status?.intValue == 1)
                {
                    let strMessage = element.object(forKey: "msg") as! NSString
                    self.appDel.ShowAlert(TitleAeroSky as NSString, alertMessage: strMessage)
                }
                else{
                    self.appDel.ShowAlert(TitleAeroSky as NSString, alertMessage: API_ERROR as NSString)
                }
                
                self.appDel.RemoveActivityIndicator()
                
            },
            failure: { (operation,error) in
                print("Error: " + (error?.localizedDescription)!)
                self.appDel.RemoveActivityIndicator()
                self.appDel.ShowAlert(TitleAeroSky as NSString, alertMessage: INTERNET_CONNECTION as NSString)
        })
        
    }
    
    
    func BackgroundRequestForGetListOfAllPropertyType(){
        
        appDel.ShowActivityIndicator()
        
        let strUrl = NSString(format: "%@%@",BASE_URL,GET_ALL_PROPERTY_TYPE)
        
        print("URL: " + (strUrl as String))
        
        let manager = AFHTTPRequestOperationManager()
        manager.responseSerializer.acceptableContentTypes = NSSet(objects: "application/json","text/html") as Set<NSObject>
        
        manager.get(strUrl as String,
            parameters: nil,
            success: { (operation,responseObject) in
                print("JSON: " + responseObject.debugDescription)
                
                let element : NSDictionary = responseObject as! NSDictionary
                let status = element.object(forKey: "code") as AnyObject?
                
                if(status?.intValue == 0)
                {
                    let propertyList : NSArray = element.object(forKey: "propertytypes") as! NSArray
                    NSLog("Meta Data.....%@", propertyList)
                    
                    for propetyData:AnyObject in propertyList as [AnyObject]{
                        
                        let project = ProjectsModel()
                        
                        if let propertytypes = (propetyData as AnyObject).object(forKey: "name") as? String {
                            project.propertytypes = propertytypes as NSString!
                        }
                        else{
                            project.propertytypes = ""
                        }
                        
                        if let propertyId = propetyData.object(forKey: "id") as? Int {
                            project.propertytype_id = propertyId
                        }
                        else{
                            project.propertytype_id = 0
                        }
                        
                        self.arrAllPropertyType.add(project)
                        
                    }
                    
                    self.tblPropertyType!.reloadData()
                    
                }
                else if(status?.intValue == 1)
                {
                    let strMessage = element.object(forKey: "msg") as! NSString
                    self.appDel.ShowAlert(TitleAeroSky as NSString, alertMessage: strMessage)
                }
                else{
                    self.appDel.ShowAlert(TitleAeroSky as NSString, alertMessage: API_ERROR as NSString)
                }
                
                self.appDel.RemoveActivityIndicator()
                
            },
            failure: { (operation,error) in
                print("Error: " + (error?.localizedDescription)!)
                self.appDel.RemoveActivityIndicator()
                self.appDel.ShowAlert(TitleAeroSky as NSString, alertMessage: INTERNET_CONNECTION as NSString)
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrAllPropertyType.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProjectAmenityCell", for: indexPath) as! ProjectAmenityCell
        
        var objProject = ProjectsModel()
        objProject = arrAllPropertyType[indexPath.row] as! ProjectsModel
        
        if(self.selectedIndexPath == indexPath){
            cell.btnPropertyType.setImage(UIImage(named: "Checked.png"), for: UIControlState())
        }else{
            cell.btnPropertyType.setImage(UIImage(named: "uncheck.png"), for: UIControlState())
        }
        
        cell.lblAmenities.text = objProject.propertytypes as String
        
        cell.btnPropertyType.addTarget(self, action: #selector(SearchViewController.btnPropertyType(_:)), for: UIControlEvents.touchUpInside)
        
        let str = NSString(format: "%d%d", indexPath.section, indexPath.row)
        if(self.dictSelectedPropertyData.value(forKey: str as String) != nil){
            cell.btnPropertyType.setImage(UIImage(named: "Checked.png"), for: UIControlState())
        }
        
        return cell
    }
    
    @IBAction func btnPropertyType(_ sender: UIButton)
    {
        
        let buttonPosition :CGPoint = sender.convert(CGPoint.zero, to: self.tblPropertyType)
        let indexPath : IndexPath = self.tblPropertyType.indexPathForItem(at: buttonPosition)!
        
        self.selectedIndexPath = indexPath
        
        var objProject = ProjectsModel()
        objProject = arrAllPropertyType[indexPath.row] as! ProjectsModel
        
        self.dictSelectedPropertyData.setObject("selected", forKey: NSString(format: "%d%d", indexPath.section, indexPath.row))
        
        let cell: ProjectAmenityCell! = self.tblPropertyType.cellForItem(at: indexPath) as! ProjectAmenityCell!
        if(cell.btnPropertyType.isSelected == true){
            cell.btnPropertyType.isSelected = false
            cell.btnPropertyType.setImage(UIImage(named: "uncheck.png"), for: UIControlState())
            
            for i in 0 ..< self.arrSelectedProperty.count {
                let pId : Int = self.arrSelectedProperty.object(at: i) as! Int
                
                if(pId == objProject.propertytype_id){
                    self.arrSelectedProperty.removeObject(at: i)
                }
            }
            
        }
        else{
            cell.btnPropertyType.isSelected = true
            cell.btnPropertyType.setImage(UIImage(named: "Checked.png"), for: UIControlState())
            self.arrSelectedProperty.add(objProject.propertytype_id)
        }
        
    }
    
    
    func autoCompleteTextField(_ textField: MLPAutoCompleteTextField!, didSelectAutoComplete selectedString: String!, withAutoComplete selectedObject: MLPAutoCompletionObject!, forRowAt indexPath: IndexPath!) {
        if((selectedObject) != nil){
            NSLog("selected object from autocomplete menu with string %@", selectedObject.autocompleteString());
        } else {
            NSLog("selected string '%@' from autocomplete menu", selectedString);
        }
        
    }
    
    func autoCompleteTextField(_ textField: MLPAutoCompleteTextField!, shouldConfigureCell cell: UITableViewCell!, withAutoComplete autocompleteString: String!, with boldedString: NSAttributedString!, forAutoComplete autocompleteObject: MLPAutoCompletionObject!, forRowAt indexPath: IndexPath!) -> Bool {
        return true
    }
    
    func rangeSliderValueChanged(_ rangeSlider: RangeSlider) {
        
        if(self.indicatorIndex == 0){
            if(rangeSlider.lowerValue >= 0 && rangeSlider.lowerValue <= 5){
                self.lowerLabel.text = NSString(format: "\u{20B9} 5 L") as String
            }
            else if(rangeSlider.lowerValue >= 6 && rangeSlider.lowerValue <= 10){
                self.lowerLabel.text = NSString(format: "\u{20B9} 15 L") as String
            }
            else if(rangeSlider.lowerValue >= 11 && rangeSlider.lowerValue <= 15){
                self.lowerLabel.text = NSString(format: "\u{20B9} 20 L") as String
            }
            else if(rangeSlider.lowerValue >= 16 && rangeSlider.lowerValue <= 20){
                self.lowerLabel.text = NSString(format: "\u{20B9} 30 L") as String
            }
            else if(rangeSlider.lowerValue >= 21 && rangeSlider.lowerValue <= 25){
                self.lowerLabel.text = NSString(format: "\u{20B9} 40 L") as String
            }
            else if(rangeSlider.lowerValue >= 26 && rangeSlider.lowerValue <= 30){
                self.lowerLabel.text = NSString(format: "\u{20B9} 50 L") as String
            }
            else if(rangeSlider.lowerValue >= 31 && rangeSlider.lowerValue <= 35){
                self.lowerLabel.text = NSString(format: "\u{20B9} 60 L") as String
            }
            else if(rangeSlider.lowerValue >= 36 && rangeSlider.lowerValue <= 40){
                self.lowerLabel.text = NSString(format: "\u{20B9} 70 L") as String
            }
            else if(rangeSlider.lowerValue >= 41 && rangeSlider.lowerValue <= 50){
                self.lowerLabel.text = NSString(format: "\u{20B9} 80 L") as String
            }
            else if(rangeSlider.lowerValue >= 51 && rangeSlider.lowerValue <= 60){
                self.lowerLabel.text = NSString(format: "\u{20B9} 90 L") as String
            }
            else if(rangeSlider.lowerValue >= 61 && rangeSlider.lowerValue <= 70){
                self.lowerLabel.text = NSString(format: "\u{20B9} 1 Cr") as String
            }
            else if(rangeSlider.lowerValue >= 71 && rangeSlider.lowerValue <= 80){
                self.lowerLabel.text = NSString(format: "\u{20B9} 2 Cr") as String
            }
            else if(rangeSlider.lowerValue >= 81 && rangeSlider.lowerValue <= 85){
                self.lowerLabel.text = NSString(format: "\u{20B9} 3 Cr") as String
            }
            else if(rangeSlider.lowerValue >= 86 && rangeSlider.lowerValue <= 90){
                self.lowerLabel.text = NSString(format: "\u{20B9} 4 Cr") as String
            }
            
            print("Range slider value changed: (\(rangeSlider.lowerValue) , \(rangeSlider.upperValue))")
            
            
            if(rangeSlider.upperValue >= 0 && rangeSlider.upperValue <= 5){
                self.upperLabel.text = NSString(format: "\u{20B9} 5 L") as String
            }
            else if(rangeSlider.upperValue >= 6 && rangeSlider.upperValue <= 10){
                self.upperLabel.text = NSString(format: "\u{20B9} 15 L") as String
            }
            else if(rangeSlider.upperValue >= 11 && rangeSlider.upperValue <= 15){
                self.upperLabel.text = NSString(format: "\u{20B9} 20 L") as String
            }
            else if(rangeSlider.upperValue >= 16 && rangeSlider.upperValue <= 20){
                self.upperLabel.text = NSString(format: "\u{20B9} 30 L") as String
            }
            else if(rangeSlider.upperValue >= 21 && rangeSlider.upperValue <= 25){
                self.upperLabel.text = NSString(format: "\u{20B9} 40 L") as String
            }
            else if(rangeSlider.upperValue >= 26 && rangeSlider.upperValue <= 30){
                self.upperLabel.text = NSString(format: "\u{20B9} 50 L") as String
            }
            else if(rangeSlider.upperValue >= 31 && rangeSlider.upperValue <= 35){
                self.upperLabel.text = NSString(format: "\u{20B9} 60 L") as String
            }
            else if(rangeSlider.upperValue >= 36 && rangeSlider.upperValue <= 40){
                self.upperLabel.text = NSString(format: "\u{20B9} 70 L") as String
            }
            else if(rangeSlider.upperValue >= 41 && rangeSlider.upperValue <= 50){
                self.upperLabel.text = NSString(format: "\u{20B9} 80 L") as String
            }
            else if(rangeSlider.upperValue >= 51 && rangeSlider.upperValue <= 60){
                self.upperLabel.text = NSString(format: "\u{20B9} 90 L") as String
            }
            else if(rangeSlider.upperValue >= 61 && rangeSlider.upperValue <= 70){
                self.upperLabel.text = NSString(format: "\u{20B9} 1 Cr") as String
            }
            else if(rangeSlider.upperValue >= 71 && rangeSlider.upperValue <= 80){
                self.upperLabel.text = NSString(format: "\u{20B9} 2 Cr") as String
            }
            else if(rangeSlider.upperValue >= 81 && rangeSlider.upperValue <= 85){
                self.upperLabel.text = NSString(format: "\u{20B9} 3 Cr") as String
            }
            else if(rangeSlider.upperValue >= 86 && rangeSlider.upperValue <= 90){
                self.upperLabel.text = NSString(format: "\u{20B9} 4 Cr") as String
            }
        }
        else if(self.indicatorIndex == 1 || self.indicatorIndex == 2){
            if(rangeSlider.lowerValue >= 0 && rangeSlider.lowerValue <= 5){
                self.lowerLabel.text = NSString(format: "\u{20B9} 10 K") as String
            }
            else if(rangeSlider.lowerValue >= 6 && rangeSlider.lowerValue <= 10){
                self.lowerLabel.text = NSString(format: "\u{20B9} 20 K") as String
            }
            else if(rangeSlider.lowerValue >= 11 && rangeSlider.lowerValue <= 15){
                self.lowerLabel.text = NSString(format: "\u{20B9} 30 K") as String
            }
            else if(rangeSlider.lowerValue >= 16 && rangeSlider.lowerValue <= 20){
                self.lowerLabel.text = NSString(format: "\u{20B9} 40 K") as String
            }
            else if(rangeSlider.lowerValue >= 21 && rangeSlider.lowerValue <= 25){
                self.lowerLabel.text = NSString(format: "\u{20B9} 50 K") as String
            }
            else if(rangeSlider.lowerValue >= 26 && rangeSlider.lowerValue <= 30){
                self.lowerLabel.text = NSString(format: "\u{20B9} 60 K") as String
            }
            else if(rangeSlider.lowerValue >= 31 && rangeSlider.lowerValue <= 35){
                self.lowerLabel.text = NSString(format: "\u{20B9} 70 K") as String
            }
            else if(rangeSlider.lowerValue >= 36 && rangeSlider.lowerValue <= 40){
                self.lowerLabel.text = NSString(format: "\u{20B9} 80 K") as String
            }
            else if(rangeSlider.lowerValue >= 41 && rangeSlider.lowerValue <= 50){
                self.lowerLabel.text = NSString(format: "\u{20B9} 90 K") as String
            }
            else if(rangeSlider.lowerValue >= 51 && rangeSlider.lowerValue <= 60){
                self.lowerLabel.text = NSString(format: "\u{20B9} 1 L") as String
            }
            else if(rangeSlider.lowerValue >= 61 && rangeSlider.lowerValue <= 70){
                self.lowerLabel.text = NSString(format: "\u{20B9} 2 L") as String
            }
            else if(rangeSlider.lowerValue >= 71 && rangeSlider.lowerValue <= 80){
                self.lowerLabel.text = NSString(format: "\u{20B9} 3 L") as String
            }
            else if(rangeSlider.lowerValue >= 81 && rangeSlider.lowerValue <= 85){
                self.lowerLabel.text = NSString(format: "\u{20B9} 4 L") as String
            }
            else if(rangeSlider.lowerValue >= 86 && rangeSlider.lowerValue <= 90){
                self.lowerLabel.text = NSString(format: "\u{20B9} 5 L") as String
            }
            
            print("Range slider value changed: (\(rangeSlider.lowerValue) , \(rangeSlider.upperValue))")
            
            
            if(rangeSlider.upperValue >= 0 && rangeSlider.upperValue <= 5){
                self.upperLabel.text = NSString(format: "\u{20B9} 20 K") as String
            }
            else if(rangeSlider.upperValue >= 6 && rangeSlider.upperValue <= 10){
                self.upperLabel.text = NSString(format: "\u{20B9} 30 K") as String
            }
            else if(rangeSlider.upperValue >= 11 && rangeSlider.upperValue <= 15){
                self.upperLabel.text = NSString(format: "\u{20B9} 40 K") as String
            }
            else if(rangeSlider.upperValue >= 16 && rangeSlider.upperValue <= 20){
                self.upperLabel.text = NSString(format: "\u{20B9} 50 K") as String
            }
            else if(rangeSlider.upperValue >= 21 && rangeSlider.upperValue <= 25){
                self.upperLabel.text = NSString(format: "\u{20B9} 60 K") as String
            }
            else if(rangeSlider.upperValue >= 26 && rangeSlider.upperValue <= 30){
                self.upperLabel.text = NSString(format: "\u{20B9} 70 K") as String
            }
            else if(rangeSlider.upperValue >= 31 && rangeSlider.upperValue <= 35){
                self.upperLabel.text = NSString(format: "\u{20B9} 80 K") as String
            }
            else if(rangeSlider.upperValue >= 36 && rangeSlider.upperValue <= 40){
                self.upperLabel.text = NSString(format: "\u{20B9} 90 K") as String
            }
            else if(rangeSlider.upperValue >= 41 && rangeSlider.upperValue <= 50){
                self.upperLabel.text = NSString(format: "\u{20B9} 1 L") as String
            }
            else if(rangeSlider.upperValue >= 51 && rangeSlider.upperValue <= 60){
                self.upperLabel.text = NSString(format: "\u{20B9} 2 L") as String
            }
            else if(rangeSlider.upperValue >= 61 && rangeSlider.upperValue <= 70){
                self.upperLabel.text = NSString(format: "\u{20B9} 3 L") as String
            }
            else if(rangeSlider.upperValue >= 71 && rangeSlider.upperValue <= 80){
                self.upperLabel.text = NSString(format: "\u{20B9} 4 L") as String
            }
            else if(rangeSlider.upperValue >= 81 && rangeSlider.upperValue <= 85){
                self.upperLabel.text = NSString(format: "\u{20B9} 5 L") as String
            }
            else if(rangeSlider.upperValue >= 86 && rangeSlider.upperValue <= 90){
                self.upperLabel.text = NSString(format: "\u{20B9} 6 L") as String
            }
        }
        
    }
    
    
    func BackgroundRequestForGetListAllCity(){
        
        appDel.ShowActivityIndicator()
        
        let strUrl = NSString(format: "%@%@",BASE_URL,GET_ALL_CITY)
        
        print("URL: " + (strUrl as String))
        
        let manager = AFHTTPRequestOperationManager()
        manager.responseSerializer.acceptableContentTypes = NSSet(objects: "application/json","text/html") as Set<NSObject>
        
        manager.get(strUrl as String,
            parameters: nil,
            success: { (operation,responseObject) in
                print("JSON: " + responseObject.debugDescription)
                
                let element : NSDictionary = responseObject as! NSDictionary
                let status = element.object(forKey: "code") as AnyObject?
                
                if(status?.intValue == 0)
                {
                    let citiesList : NSArray = element.object(forKey: "cities") as! NSArray
                    NSLog("Meta Data.....%@", citiesList)
                    
                    self.appDel.arrAllCity.removeAllObjects()
                    
                    for CityData:AnyObject in citiesList as [AnyObject]{
                        
                        var strCity : NSString!
                        if let cityName = CityData.object(forKey: "name") as? NSString {
                            strCity = cityName
                        }
                        else{
                            strCity = ""
                        }
                        
                        self.appDel.arrAllCity.add(strCity)
                        
                    }
                    
                }
                else if(status?.intValue == 1)
                {
                    let strMessage = element.object(forKey: "msg") as! NSString
                    self.appDel.ShowAlert(TitleAeroSky as NSString, alertMessage: strMessage)
                }
                else{
                    self.appDel.ShowAlert(TitleAeroSky as NSString, alertMessage: API_ERROR as NSString)
                }
                
                self.appDel.RemoveActivityIndicator()
                
            },
            failure: { (operation,error) in
                print("Error: " + (error?.localizedDescription)!)
                self.appDel.RemoveActivityIndicator()
                self.appDel.ShowAlert(TitleAeroSky as NSString, alertMessage: INTERNET_CONNECTION as NSString)
        })
        
    }
    
    @IBAction func btnBedRoomSelected(_ sender : AnyObject){
        
        let btnSender : UIButton = sender as! UIButton
        
        if(btnSender == self.btnBedAny){
            self.btnBedOne.isSelected = false
            self.btnBedTwo.isSelected = false
            self.btnBedThree.isSelected = false
            self.btnBedFour.isSelected = false
            self.btnBedFive.isSelected = false
            self.btnBedOne.setTitleColor(UIColor.lightGray, for: UIControlState())
            self.btnBedTwo.setTitleColor(UIColor.lightGray, for: UIControlState())
            self.btnBedThree.setTitleColor(UIColor.lightGray, for: UIControlState())
            self.btnBedFour.setTitleColor(UIColor.lightGray, for: UIControlState())
            self.btnBedFive.setTitleColor(UIColor.lightGray, for: UIControlState())
        }
        else{
            if(self.btnBedAny.isSelected == true){
                self.btnBedAny.isSelected = false
                self.btnBedAny.setTitleColor(UIColor.lightGray, for: UIControlState())
            }
        }
        
        
        if(btnSender.isSelected == true){
            btnSender.isSelected = false
            btnSender.setTitleColor(UIColor.lightGray, for: UIControlState())
        }
        else{
            btnSender.isSelected = true
            btnSender.setTitleColor(UIColor.colorLikeNavigationBackground(), for: UIControlState())
        }
        
    }
    
    @IBAction func btnBathRoomSelected(_ sender : AnyObject){
        let btnSender : UIButton = sender as! UIButton
        
        if(btnSender == self.btnBathAny){
            self.btnBathOne.isSelected = false
            self.btnBathTwo.isSelected = false
            self.btnBathThree.isSelected = false
            self.btnBathFour.isSelected = false
            self.btnBathFive.isSelected = false
            self.btnBathOne.setTitleColor(UIColor.lightGray, for: UIControlState())
            self.btnBathTwo.setTitleColor(UIColor.lightGray, for: UIControlState())
            self.btnBathThree.setTitleColor(UIColor.lightGray, for: UIControlState())
            self.btnBathFour.setTitleColor(UIColor.lightGray, for: UIControlState())
            self.btnBathFive.setTitleColor(UIColor.lightGray, for: UIControlState())
        }
        else{
            if(self.btnBathAny.isSelected == true){
                self.btnBathAny.isSelected = false
                self.btnBathAny.setTitleColor(UIColor.lightGray, for: UIControlState())
            }
        }
        
        if(btnSender.isSelected == true){
            btnSender.isSelected = false
            btnSender.setTitleColor(UIColor.lightGray, for: UIControlState())
        }
        else{
            btnSender.isSelected = true
            btnSender.setTitleColor(UIColor.colorLikeNavigationBackground(), for: UIControlState())
        }
    }
    
    @IBAction func btnPgSelected(_ sender : AnyObject){
        
        let btnSender : UIButton = sender as! UIButton
        
        if(btnSender == self.btnPgBoth){
            self.btnPgBoy.isSelected = false
            self.btnPgGirl.isSelected = false
            self.btnPgBoy.setTitleColor(UIColor.lightGray, for: UIControlState())
            self.btnPgGirl.setTitleColor(UIColor.lightGray, for: UIControlState())
        }
        else if(btnSender == self.btnPgBoy){
            self.btnPgBoth.isSelected = false
            self.btnPgGirl.isSelected = false
            self.btnPgBoth.setTitleColor(UIColor.lightGray, for: UIControlState())
            self.btnPgGirl.setTitleColor(UIColor.lightGray, for: UIControlState())
        }
        else if(btnSender == self.btnPgGirl){
            self.btnPgBoth.isSelected = false
            self.btnPgBoy.isSelected = false
            self.btnPgBoth.setTitleColor(UIColor.lightGray, for: UIControlState())
            self.btnPgBoy.setTitleColor(UIColor.lightGray, for: UIControlState())
        }
        
        
        if(btnSender.isSelected == true){
            btnSender.isSelected = false
            btnSender.setTitleColor(UIColor.lightGray, for: UIControlState())
        }
        else{
            btnSender.isSelected = true
            btnSender.setTitleColor(UIColor.colorLikeNavigationBackground(), for: UIControlState())
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    @IBAction func btnBack(_ sender: AnyObject){
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
