//
//  ProjectsViewController.swift
//  AeroSky
//
//  Created by Coldfin Lab on 20-7-2017.
//  Copyright © 2017 Coldfin Lab. All rights reserved.
//

import UIKit
import CoreData

class ProjectsViewController: UIViewController,UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate,sendSearchResultData {

    @IBOutlet weak var viewNoData: UIView!
    @IBOutlet weak var tblAllProjects: UICollectionView!
    @IBOutlet weak var btnMap: UIButton!
    
    var images_cache = [String:UIImage]()
    var images = [String]()
    var imageCache = [String:UIImage]()
    var preventAnimation = Set<IndexPath>()
    var arrAllProject = NSMutableArray()
    var appDel : AppDelegate!
    var projects = [NSManagedObject]()
    var isLoad : Bool!
    var isSearchProject : Bool = false
    var imageDownloadsInProgress : NSMutableDictionary!
    var arrAllImages = NSMutableArray()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDel = UIApplication.shared.delegate as! AppDelegate
        
        if(IS_IPHONE_4_OR_LESS){
            self.tblAllProjects.frame = CGRect(x: self.tblAllProjects.frame.origin.x, y: self.tblAllProjects.frame.origin.y, width: self.tblAllProjects.frame.size.width, height: self.tblAllProjects.frame.size.height-100)
            self.btnMap.frame = CGRect(x: self.btnMap.frame.origin.x, y: self.btnMap.frame.origin.y-100, width: self.btnMap.frame.size.width, height: self.btnMap.frame.size.height)
        }
        
        imageDownloadsInProgress = NSMutableDictionary()
        
        self.fetchAllProjectData()
        
        self.viewNoData.isHidden = true
        // Do any additional setup after loading the view.
    }

    
    func fetchAllProjectData(){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
       // let managedContext = appDel.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Project")
        do {
            let results :NSArray? = try! self.getContext().fetch(fetchRequest) as NSArray?
            if(results!.count > 0){
                projects = results as! [NSManagedObject]
               
                for i in 0 ..< projects.count
                {
                    let strImageURL : String!
                    let project = projects[i]
                    strImageURL = project.value(forKey: "propertyphoto_url") as? String
                    
                    let objProject = ProjectsModel()
                    objProject.imageModel = ImageModel()
                    objProject.imageModel.imageURLString = strImageURL as NSString!
                    
                    self.arrAllImages.add(objProject)
                }
            
            }
            
            if(projects.count > 0){
                self.tblAllProjects.reloadData()
                
                let qualityOfServiceClass = DispatchQoS.QoSClass.background
                let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
                backgroundQueue.async(execute: {
                    print("This is run on the background queue")
                    self.isLoad = true
                    DispatchQueue.main.async(execute: { () -> Void in
                        print("This is run on the main queue, after the previous code in outer block")
                        self.BackgroundRequestForGetListOfAllProjects()
                    })
                })
                
            }
            else{
                let qualityOfServiceClass = DispatchQoS.QoSClass.background
                let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
                backgroundQueue.async(execute: {
                    print("This is run on the background queue")
                    self.isLoad = false
                    DispatchQueue.main.async(execute: { () -> Void in
                        print("This is run on the main queue, after the previous code in outer block")
                        self.BackgroundRequestForGetListOfAllProjects()
                    })
                })
            }
        }
        catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    @IBAction func btnRefresh(_ sender :AnyObject){
         self.isLoad = false
         self.isSearchProject = false
         self.BackgroundRequestForGetListOfAllProjects()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Roboto-Bold", size: 15)!,  NSForegroundColorAttributeName: UIColor.white]
    }
    
    func sendSearchResult(_ arrSearchResult: NSMutableArray) {
     
        self.arrAllProject = arrSearchResult
        self.isSearchProject = true
        if(self.arrAllProject.count > 0){
            self.tblAllProjects.reloadData()
            self.viewNoData.isHidden = true
            self.tblAllProjects.isHidden = false
        }
        else{
            self.viewNoData.isHidden = false
            self.tblAllProjects.isHidden = true
        }
       
    }
    
    @IBAction func btnSearch(_ sender: AnyObject){
        let storyboard=UIStoryboard(name: "Main", bundle: nil)
        let searchVC = storyboard.instantiateViewController(withIdentifier: IdentifireSearchView) as! SearchViewController
        searchVC.delegate = self
        self.navigationController?.pushViewController(searchVC, animated: false)
    }
    
    @IBAction func btnSwitchMapList(_ sender: AnyObject){
        
        let storyboard=UIStoryboard(name: "Main", bundle: nil)
        let MapVC = storyboard.instantiateViewController(withIdentifier: IdentifireMapView) as! MapsViewController
        if(self.isSearchProject == true){
            MapVC.arrAllProject = arrAllProject
            MapVC.isLocal = false
        }
        else{
            MapVC.projects = self.projects
            MapVC.isLocal = true
        }
        
        UIView.animate(withDuration: 0.75, animations: { () -> Void in
            self.navigationController?.pushViewController(MapVC, animated: false)
            UIView.setAnimationTransition(UIViewAnimationTransition.flipFromLeft, for: self.navigationController!.view!, cache: false)
        })
    }
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func BackgroundRequestForGetListOfAllProjects(){
        
        if(self.isLoad == false){
            appDel.ShowActivityIndicator()
        }
        
        let strUrl = NSString(format: "%@%@",BASE_URL,GET_ALL_PROJECTS_URL)
        
        print("URL: " + (strUrl as String))
        
        let manager = AFHTTPRequestOperationManager()
        manager.responseSerializer.acceptableContentTypes = NSSet(objects: "application/json","text/html") as Set<NSObject>
        
        manager.get(strUrl as String,
            parameters: nil,
            success: { (operation,responseObject) in
               // print("JSON: " + responseObject.description)
                
                let element : NSDictionary = responseObject as! NSDictionary
                let status = element.object(forKey: "code") as AnyObject?
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                //let managedContext = self.appDel.managedObjectContext
                
                if(status?.intValue == 0)
                {
                    let propertyList : NSArray = element.object(forKey: "properties_lists") as! NSArray
                    NSLog("Meta Data.....%@", propertyList)
                    
                    if(propertyList.count > 0){
                        
                        
                        //Fetch all Category list from core data and display it in collection view if data exists.
                       // let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Project")
                        
                        
                        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Project")
                        
                        do {
                            let results :NSArray? = try self.getContext().fetch(fetchRequest) as NSArray
                            if(results!.count > 0){
                                if let tblCat = self.tblAllProjects {
                                    var resultOfCategory : NSManagedObject!
                                    
                                    for resultOfCategory in results!{
                                        self.getContext().delete(resultOfCategory as! NSManagedObject)
                                    }
                                    
                                    try! self.getContext().save()
                                }
                            }
                            
                        } catch let error as NSError {
                            print("Could not fetch \(error), \(error.userInfo)")
                        }
                    }
                    
                    for propetyData:AnyObject in propertyList as [AnyObject] {
                        
                        let project = ProjectsModel()
                        
                        if let id = propetyData.object(forKey: "id") as? Int {
                            project.id = id
                        }
                        else{
                            project.id = 0
                        }
                        
                        if let user_id = propetyData.object(forKey: "user_id") as? Int {
                            project.user_id = user_id
                        }
                        else{
                            project.user_id = 0
                        }
                        
                        if let user_first_name = propetyData.object(forKey: "user_first_name") as? String {
                            project.firstName = user_first_name as NSString!
                        }
                        else{
                            project.firstName = ""
                        }
                        
                        if let user_last_name = propetyData.object(forKey: "user_last_name") as? String {
                            project.lastName = user_last_name as NSString!
                        }
                        else{
                            project.lastName = ""
                        }
                        
                        if let addedby = propetyData.object(forKey: "addedby") as? String {
                            project.usertype = addedby as NSString!
                        }
                        else{
                            project.usertype = ""
                        }
                        
                        
                        if let address = propetyData.object(forKey: "address") as? String {
                            project.address = address as NSString!
                        }
                        else{
                            project.address = ""
                        }
                        
                        if let area = propetyData.object(forKey: "area") as? String {
                            project.area = area as NSString!
                        }
                        else{
                            project.area = ""
                        }
                        
                        if let rate = propetyData.object(forKey: "rate") as? Int {
                            project.rate = rate
                        }
                        else{
                            project.rate = 0
                        }
                        
                        if let bathroom = propetyData.object(forKey: "bathroom") as? Int {
                            project.bathroom = bathroom
                        }
                        else{
                            project.bathroom = 0
                        }
                        
                        if let latitude = propetyData.object(forKey: "latitude") as? Double {
                            project.latitude = latitude
                        }
                        else{
                            project.latitude = 0.0
                        }
                        
                        if let longitude = propetyData.object(forKey: "longitude") as? Double {
                            project.longitude = longitude
                        }
                        else{
                            project.longitude = 0.0
                        }
                        
                        if let contact_no = propetyData.object(forKey: "user_contact_no") as? CLong {
                            project.user_contact_no = contact_no
                        }
                        else{
                            project.user_contact_no = 0000000000
                        }
                        
                        if let city = propetyData.object(forKey: "city") as? NSString {
                            project.city = city
                        }
                        else{
                            project.city = ""
                        }
                        
                        if let bhktype = propetyData.object(forKey: "bhktype") as? NSString {
                            project.bhktype = bhktype
                        }
                        else{
                            project.bhktype = ""
                        }
                        
                        if let propertyphoto_url = propetyData.object(forKey: "propertyphoto_url") as? NSString {
                            project.propertyphoto_url = propertyphoto_url
                        }
                        else{
                            project.propertyphoto_url = ""
                        }
                        
                        if let propertytypes = propetyData.object(forKey: "propertytypes") as? NSString {
                            project.propertytypes = propertytypes
                        }
                        else{
                            project.propertytypes = ""
                        }
                        
                        if let propertyFor = propetyData.object(forKey: "property_for") as? NSString {
                            project.property_for = propertyFor
                        }
                        else{
                            project.property_for = ""
                        }
                        
                        if let shortlist = propetyData.object(forKey: "p_shortlist") as? Int {
                            project.shortlist = shortlist
                        }
                        else{
                            project.shortlist = 0
                        }
                        
                        self.saveProjectData(project.id, user_id: project.user_id, firstName: project.firstName, lastName: project.lastName, usertype: project.usertype, address: project.address, area: project.area, rate: project.rate, bathroom: project.bathroom, latitude: project.latitude, longitude: project.longitude, user_contact_no: project.user_contact_no, city: project.city, bhktype: project.bhktype, propertyphoto_url: project.propertyphoto_url, propertytypes: project.propertytypes, property_for: project.property_for, shortlist: project.shortlist)
                    }
                    
                    
                    let fetchRq = NSFetchRequest<NSFetchRequestResult>(entityName: "Project")
                    do {
                        let results :NSArray? = try! self.getContext().fetch(fetchRq) as NSArray
                        if(results!.count > 0){
                            self.projects = results as! [NSManagedObject]
                            NSLog("Core DATA.....%@",  self.projects)
                            
                            for i in 0 ..< self.projects.count
                            {
                                let strImageURL : String!
                                let project = self.projects[i]
                                strImageURL = project.value(forKey: "propertyphoto_url") as? String
                                
                                let objProject = ProjectsModel()
                                objProject.imageModel = ImageModel()
                                objProject.imageModel.imageURLString = strImageURL as NSString!
                                
                                self.arrAllImages.add(objProject)
                            }
                            
                        }
                        
                        if(self.projects.count > 0){
                            self.tblAllProjects.reloadData()
                            self.viewNoData.isHidden = true
                            self.tblAllProjects.isHidden = false
                        }
                        else{
                            self.viewNoData.isHidden = false
                            self.tblAllProjects.isHidden = true
                        }
                     
                    }
                    catch let error as NSError {
                        print("Could not fetch \(error), \(error.userInfo)")
                    }
                    
                }
                else if(status?.intValue == 1)
                {
                    if(self.isLoad == false){
                        let strMessage = element.object(forKey: "msg") as! NSString
                        self.appDel.ShowAlert(TitleAeroSky as NSString, alertMessage: strMessage)
                    }
                }
                else{
                    if(self.isLoad == false){
                        self.appDel.ShowAlert(TitleAeroSky as NSString, alertMessage: API_ERROR as NSString)
                    }
                }
                
                if(self.isLoad == false){
                    self.appDel.RemoveActivityIndicator()
                }
                
            },
            failure: { (operation,error) in
                print("Error: " + (error?.localizedDescription)!)
                self.appDel.RemoveActivityIndicator()
                self.appDel.ShowAlert(TitleAeroSky as NSString, alertMessage: INTERNET_CONNECTION as NSString)
        })
        
    }
    
    /**
     * Save Project data in core data.
     *
     * Example usage:
     * @code
     *
     * @endcode
     * @param
     * @return nil
     */
    func saveProjectData(_ id: Int, user_id : Int, firstName:NSString, lastName:NSString, usertype:NSString, address:NSString, area:NSString, rate:Int, bathroom:Int, latitude:Double, longitude:Double, user_contact_no:CLong, city:NSString, bhktype:NSString, propertyphoto_url:NSString, propertytypes:NSString, property_for:NSString, shortlist:Int) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //let managedContext = appDelegate.managedObjectContext
        
        let entity =  NSEntityDescription.entity(forEntityName: "Project", in:self.getContext())
        
        let category = NSManagedObject(entity: entity!,insertInto: self.getContext())
        
        category.setValue(id, forKey: "id")
        category.setValue(user_id, forKey: "user_id")
        category.setValue(firstName, forKey: "firstName")
        category.setValue(lastName, forKey: "lastName")
        category.setValue(usertype, forKey: "usertype")
        category.setValue(address, forKey: "address")
        category.setValue(area, forKey: "area")
        category.setValue(rate, forKey: "rate")
        category.setValue(bathroom, forKey: "bathroom")
        category.setValue(latitude, forKey: "latitude")
        category.setValue(longitude, forKey: "longitude")
        category.setValue(user_contact_no, forKey: "user_contact_no")
        category.setValue(city, forKey: "city")
        category.setValue(bhktype, forKey: "bhktype")
        category.setValue(propertyphoto_url, forKey: "propertyphoto_url")
        category.setValue(propertytypes, forKey: "propertytypes")
        category.setValue(property_for, forKey: "property_for")
        category.setValue(shortlist, forKey: "shortlist")
        
        do {
            try! self.getContext().save()
            projects.append(category)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }

    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if !preventAnimation.contains(indexPath) {
            preventAnimation.insert(indexPath)
            CellAnimator.animate(cell)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(self.isSearchProject == true){
            return arrAllProject.count
        }
        else{
            return projects.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProjectCell", for: indexPath) as! ProjectCell
        
        var imgURL : URL!
        let strImageURL : String!
        
        if(self.isSearchProject == false){
            
            let project = projects[indexPath.row]
            
            let bhkType =  project.value(forKey: "bhktype") as? String
            let propertytypes =  project.value(forKey: "propertytypes") as? String
            let area =  project.value(forKey: "area") as? String
            let property_for =  project.value(forKey: "property_for") as? String
            
            cell.lblPhoneNumber.text = String(format: "%ld", (project.value(forKey: "user_contact_no") as? NSInteger)!)
            cell.lblCountry.text = String(format: "%@", (project.value(forKey: "city") as? String)!)
            cell.lblProjectName.text = String(format: "%@ %@ - %@", bhkType!, propertytypes!, area!)
            cell.lblRs.text = String(format: "\u{20B9} %d", (project.value(forKey: "rate") as? NSInteger)!)
            
            if(property_for == "sell"){
                cell.lblPropertytype.text = String(format: "FOR SELL")
            }
            else if(property_for == "rent"){
                cell.lblPropertytype.text = String(format: "FOR RENT")
            }
            else{
                cell.lblPropertytype.text = String(format: "FOR PG")
            }
            
            strImageURL = project.value(forKey: "propertyphoto_url") as? String
            imgURL = URL(string: strImageURL! as String)
            
            
            var objProject = ProjectsModel()
            objProject = arrAllImages[indexPath.row] as! ProjectsModel
            
            if objProject.imageModel != nil
            {
                let objImageCell: ImageModel! = objProject.imageModel
                if objImageCell.imageURLString != nil
                {
                    if !(objImageCell.itemImage != nil)
                    {
                        if self.tblAllProjects.isDragging == false && self.tblAllProjects.isDecelerating == false
                        {
                            startIconDownload(objImageCell, indexPath: indexPath as IndexPath)
                        }
                        cell.imgProperty.image = UIImage(named: "no_results.png")
                    }
                    else
                    {
                        cell.imgProperty.image = objImageCell.itemImage
                    }
                }
                else
                {
                    cell.imgProperty.image = UIImage(named: "no_results.png")
                }
            }
            
        }
        else{
            
            var objProject = ProjectsModel()
            objProject = arrAllProject[indexPath.row] as! ProjectsModel
            
            cell.lblPhoneNumber.text = String(format: "%d", objProject.user_contact_no)
            cell.lblCountry.text = String(format: "%@", objProject.city)
            cell.lblProjectName.text = String(format: "%@ %@ - %@", objProject.bhktype, objProject.propertytypes, objProject.area)
            cell.lblRs.text = String(format: "\u{20B9} %d", objProject.rate)
            
            if(objProject.property_for == "sell"){
                cell.lblPropertytype.text = String(format: "FOR SELL")
            }
            else if(objProject.property_for == "rent"){
                cell.lblPropertytype.text = String(format: "FOR RENT")
            }
            else{
                cell.lblPropertytype.text = String(format: "FOR PG")
            }
            
            strImageURL = objProject.propertyphoto_url as NSString as String
            imgURL = URL(string: strImageURL as String)
            
            if objProject.imageModel != nil
            {
                let objImageCell: ImageModel! = objProject.imageModel
                if objImageCell.imageURLString != nil
                {
                    if !(objImageCell.itemImage != nil)
                    {
                        if self.tblAllProjects.isDragging == false && self.tblAllProjects.isDecelerating == false
                        {
                            startIconDownload(objImageCell, indexPath: indexPath as IndexPath)
                        }
                        cell.imgProperty.image = UIImage(named: "no_results.png")
                    }
                    else
                    {
                        cell.imgProperty.image = objImageCell.itemImage
                    }
                }
                else
                {
                    cell.imgProperty.image = UIImage(named: "no_results.png")
                }
            }

            
        }
        
        return cell
    }
    
    
    func startIconDownload(_ imageRecord : ImageModel! ,indexPath :IndexPath!)
    {
        var imageRecord = imageRecord, indexPath = indexPath
      //  NSLog("index path: %@", indexPath)
        var iconDownloader : ImageDownloader = ImageDownloader()
     
        iconDownloader = ImageDownloader()
        iconDownloader.objImages = imageRecord;
        
        //call after complete download
        iconDownloader.completionHandler={() -> Void in
            
            if self.tblAllProjects.cellForItem(at: indexPath!) != nil
            {
                let cellview : ProjectCell = self.tblAllProjects.cellForItem(at: indexPath!) as! ProjectCell
                // Display the newly loaded image
                
                if imageRecord?.itemImage == nil
                {
                    cellview.imgProperty.image = UIImage(named: "no_results.png")
                }
                else
                {
                    cellview.imgProperty.image = imageRecord?.itemImage
                }
                // Remove the IconDownloader from the in progress list.
                self.imageDownloadsInProgress.removeObject(forKey: indexPath)
            }
        }
        
        // start downloading image
        if imageRecord != nil
        {
            imageDownloadsInProgress.setObject(iconDownloader, forKey:indexPath as! NSCopying)
            iconDownloader.startDownload()
        }
       
    }
    
    
    func loadImagesForOnscreenRows()
    {
        if arrAllProject.count > 0
        {
            let visiblePaths : NSArray = tblAllProjects.indexPathsForVisibleItems as NSArray
            for indexPath in visiblePaths
            {
                
                var objProject = ProjectsModel()
                objProject = arrAllProject[(indexPath as AnyObject).row] as! ProjectsModel
                
                let imageRecord :ImageModel = objProject.imageModel as ImageModel
               
                startIconDownload(imageRecord, indexPath: indexPath as! IndexPath)
               
            }
        }
    }
    
    func loadImagesForOnscreenRowsForCoreData()
    {
        if arrAllImages.count > 0
        {
            let visiblePaths : NSArray = tblAllProjects.indexPathsForVisibleItems as NSArray
            for indexPath in visiblePaths
            {

                var objProject = ProjectsModel()
                objProject = arrAllImages[(indexPath as AnyObject).row] as! ProjectsModel
                
                let imageRecord :ImageModel = objProject.imageModel as ImageModel
               
                startIconDownload(imageRecord, indexPath: indexPath as! IndexPath)
               
            }
        }
    }

    //  Scrollview Delegate
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
    {
        if !decelerate
        {
            if(self.isSearchProject == false){
                loadImagesForOnscreenRowsForCoreData()
            }
            else{
                loadImagesForOnscreenRows()
            }
        }
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        if(self.isSearchProject == false){
            loadImagesForOnscreenRowsForCoreData()
        }
        else{
            loadImagesForOnscreenRows()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
}
