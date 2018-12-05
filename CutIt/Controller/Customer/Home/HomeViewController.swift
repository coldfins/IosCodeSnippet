//
//  HomeViewController.swift
//  CutIt
//
//  Created by Coldfin lab

//  Copyright © 2017 Coldfin lab. All rights reserved.

import UIKit
import iAd
import GoogleMobileAds

class HomeViewController: UIViewController,UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var tblAllService: UICollectionView!
    let manager = AFHTTPRequestOperationManager()
    var appDelegate = AppDelegate()
    var arrAllCategory = NSMutableArray()
    var preventAnimation = Set<IndexPath>()
    var imageDownloadsInProgress : NSMutableDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageDownloadsInProgress = NSMutableDictionary()
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.BackgroundRequestForGetListOfCategory()
        if(IS_IPHONE_4_OR_LESS)
        {
            self.tblAllService.frame = CGRect(x:self.tblAllService.frame.origin.x,y:self.tblAllService.frame.origin.y, width: self.tblAllService.frame.size.width, height: self.tblAllService.frame.size.height - 50)
        }
    }
    
 
    func BackgroundRequestForGetListOfCategory(){
        
        appDelegate.ShowActivityIndicator()
        let strUrl = NSString(format: "%@%@",BASE_URL,ALL_CATEGORY)        
        let manager = AFHTTPRequestOperationManager()
        manager.responseSerializer.acceptableContentTypes = NSSet(objects: "application/json","text/html") as Set<NSObject>
        //******
        manager.get(strUrl as String!, parameters: nil, success: { (operation, responseObject) in
            
                        let element : NSDictionary = responseObject as! NSDictionary
                        if(((element.object(forKey: "error_code") as! Int)) == 1)
                        {
                            let CategoryList : NSArray = element.object(forKey: "data") as! NSArray
                            
                            for categoryData : Any in CategoryList {
                                
                                let category = CategoryModel()
                                
                                if let categoryId = (categoryData as AnyObject).object(forKey: "id") as? Int {
                                    category.categoryId = categoryId
                                }
                                else{
                                    category.categoryId = 0
                                }
                                if let categoryName = (categoryData as AnyObject).object(forKey: "name") as? NSString {
                                    category.categoryName = categoryName
                                }
                                else{
                                    category.categoryName = ""
                                }
                                if let categoryDesc = (categoryData as AnyObject).object(forKey: "description") as? NSString {
                                    category.categoryDesc = categoryDesc
                                }
                                else{
                                    category.categoryDesc = ""
                                }
                                if let categoryImage = (categoryData as AnyObject).object(forKey: "img_1") as? NSString {
                                    category.categoryImage = categoryImage
                                }
                                else{
                                    category.categoryImage = ""
                                }
                                category.imageModel = ImageModel()
                                category.imageModel.imageURLString = category.categoryImage
                                self.arrAllCategory.add(category)
                            }
                            self.tblAllService.reloadData()
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
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath){
        if !preventAnimation.contains(indexPath) {
            preventAnimation.insert(indexPath)
            CellAnimator.animate(cell)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrAllCategory.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCategoryCell", for: indexPath) as! HomeCategoryCell
        
        let objCategory = self.arrAllCategory.object(at: (indexPath as NSIndexPath).row) as! CategoryModel
        cell.lblCategoryName.text = objCategory.categoryName as String
        cell.lblCategoryDesc.numberOfLines = 0
        cell.lblCategoryDesc.lineBreakMode = .byWordWrapping
        let font: UIFont = UIFont.systemFont(ofSize: 14.0)
        let strCategoryDesc = objCategory.categoryDesc as NSString
        cell.lblCategoryDesc.text = strCategoryDesc as String
        
        let expectedLabelSize = cell.lblCategoryDesc.text!.boundingRect(
            with: CGSize(width: cell.lblCategoryDesc.frame.size.width, height: CGFloat.infinity),
            options: NSStringDrawingOptions.usesLineFragmentOrigin,
            attributes: [NSFontAttributeName: font],
            context: nil).size
        
        cell.lblCategoryDesc.frame.size.height = expectedLabelSize.height
        
        if objCategory.imageModel != nil
        {
            let objImageCell: ImageModel! = objCategory.imageModel
            if objImageCell.imageURLString != nil
            {
                if !(objImageCell.itemImage != nil)
                {
                    if self.tblAllService.isDragging == false && self.tblAllService.isDecelerating == false
                    {
                        startIconDownload(objImageCell, indexPath: indexPath as IndexPath)
                    }
                    cell.imgCategory.image = UIImage(named: "default_cutitEvent.png")
                }
                else
                {
                    cell.imgCategory.image = objImageCell.itemImage
                }
            }
            else
            {
                cell.imgCategory.image = UIImage(named: "default_cutitEvent.png")
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var objCategory = CategoryModel()
        objCategory = arrAllCategory[(indexPath as NSIndexPath).row] as! CategoryModel
        let storyboard=UIStoryboard(name: "Main", bundle: nil)
        let optionVC = storyboard.instantiateViewController(withIdentifier: IdentifireHomeDetailsView) as! HomeDetailViewController
        optionVC.category = objCategory
        UserDefaults.standard.setValue(objCategory.categoryId, forKey: keyCategoryId)
        self.navigationController?.pushViewController(optionVC, animated: false)
    }
    
    func startIconDownload(_ imageRecord : ImageModel! ,indexPath :IndexPath!)
    {
        var iconDownloader : ImageDownloader = ImageDownloader()
        iconDownloader = ImageDownloader()
        iconDownloader.objImages = imageRecord;
        
        //call after complete download
        iconDownloader.completionHandler={() -> Void in
            
            if self.tblAllService.cellForItem(at: indexPath) != nil
            {
                let cellview : HomeCategoryCell = self.tblAllService.cellForItem(at: indexPath) as! HomeCategoryCell
                
                //Display the newly loaded image
                if imageRecord.itemImage == nil
                {
                    cellview.imgCategory.image = UIImage(named: "default_cutitEvent.png")
                }
                else
                {
                    cellview.imgCategory.image = imageRecord.itemImage
                }
                // Remove the IconDownloader from the in progress list.
                self.imageDownloadsInProgress.removeObject(forKey: indexPath)
            }
        }
        if imageRecord != nil
        {
            imageDownloadsInProgress.setObject(iconDownloader, forKey:indexPath as NSCopying)
            iconDownloader.startDownload()
        }
    }
    
    func loadImagesForOnscreenRows()
    {
        if arrAllCategory.count > 0
        {
            let visiblePaths : NSArray = tblAllService.indexPathsForVisibleItems as NSArray
            for indexPath in visiblePaths
            {
                var objCategory = CategoryModel()
                objCategory = arrAllCategory[(indexPath as AnyObject).row] as! CategoryModel
                let imageRecord :ImageModel = objCategory.imageModel as ImageModel
                startIconDownload(imageRecord, indexPath: indexPath as! IndexPath)
            }
        }
    }
    
    //  Scrollview Delegate
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
    {
        if !decelerate
        {
            loadImagesForOnscreenRows()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        loadImagesForOnscreenRows()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
