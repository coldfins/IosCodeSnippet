//
//  HomeViewController.swift
//  WallPost
//
//  Created by Ved on 23/02/17.
//  Copyright © 2017 Ved. All rights reserved.
//

import UIKit
import Photos

class HomeViewController: UIViewController,NVActivityIndicatorViewable, UITableViewDelegate, UITableViewDataSource, createMyPostProtocol, UITextFieldDelegate, updateCommentProtocol{

    @IBOutlet weak var tblPost: UITableView!
    let gradientLayer = CAGradientLayer()
    var appDelegate = AppDelegate()
    var offset : Int = 0
    var strLeftTime : NSString!
    var arrAllPost : NSMutableArray = NSMutableArray()
    var postHeaderview : PostHeaderView! = PostHeaderView()
    var dictLikeData = NSMutableDictionary()
    var dictIndicatorData = NSMutableDictionary()
    var viewTopMenu: ViewLayout!
    var viewReport: ViewLayout!
    var viewMainReport:ViewLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        self.tblPost.addInfiniteScrolling { 
             self.getAllPost(offset: self.offset)
        }
        
        self.getAllPost(offset: offset)
    }
    
    func sendNewPostObjectToPreviousVC(myPost: PostModel) {
        self.arrAllPost.insert(myPost, at: 0)
        self.tblPost.reloadData()
    }
   
    func updateExistingCommentObject(commentCount: Int, index: Int) {
        let objPost = arrAllPost.object(at: index) as! PostModel
        objPost.CommentCount = commentCount
        self.tblPost.reloadData()
    }
    
    func getAllPost(offset : Int){
        
        let struserID = UserDefaults.standard.value(forKey: keyUserId) as! Int
        let url = NSString(format : "%@%@%d&limit=10&UserId=%d", BASE_URL, POSTLIST_URL,offset,struserID)
        print("url\(url)")
        
        let manager = AFHTTPRequestOperationManager()
        manager.requestSerializer.timeoutInterval = 120
        manager.requestSerializer.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
        
            manager.get(url as String!, parameters: nil, success: { (operation, responseObject) in
                
                print("Response Object :\(responseObject)")
                let element : NSDictionary = responseObject as! NSDictionary
                let error_code = element.value(forKey: "error_code") as! NSNumber
                let message : String = element.value(forKey: "msg") as! String
                
                if(error_code == 0)
                {
                    print(element)
                    
                    let postElement = element["posts"] as! NSArray
                    
                    if postElement.count > 0{
                        
                        self.offset = offset + postElement.count
                        
                        for dict in postElement{
                            let objPostModel = PostModel()
                            objPostModel.arrImageVideo = NSMutableArray()
                            
                            //Post
                            let post = (dict as AnyObject).value(forKey: "post") as! NSDictionary
                            
                            if let PostId = (post as AnyObject).value(forKey: "PostId") as? Int {
                                objPostModel.PostId = PostId
                            }
                            else{
                                objPostModel.PostId = 0
                            }
                            
                            if let IsLike = (post as AnyObject).value(forKey: "IsLike") as? Bool {
                                objPostModel.IsLike = IsLike
                            }
                            else{
                                objPostModel.IsLike = false
                            }
                            
                            if let commentCount = (post as AnyObject).value(forKey: "CommentCount") as? Int {
                                objPostModel.CommentCount = commentCount
                            }
                            else{
                                objPostModel.CommentCount = 0
                            }
                            
                            if let LikeCount = (post as AnyObject).value(forKey: "LikeCount") as? Int {
                                objPostModel.LikeCount = LikeCount
                            }
                            else{
                                objPostModel.LikeCount = 0
                            }
                            
                            if let PostText = (post as AnyObject).value(forKey: "PostText") as? NSString {
                                objPostModel.PostText = PostText
                            }
                            else{
                                objPostModel.PostText = ""
                            }
                            
                            if let PostedDate = (post as AnyObject).value(forKey: "PostedDate") as? NSString {
                                objPostModel.PostedDate = PostedDate
                            }
                            else{
                                objPostModel.PostedDate = ""
                            }
                            
                            
                            if let UserId = (post as AnyObject).value(forKey: "UserId") as? Int {
                                objPostModel.UserId = UserId
                            }
                            else{
                                objPostModel.UserId = 0
                            }
                            
                            
                            //postImageVideos
                            let postImageVideos = (dict as AnyObject).value(forKey: "postImageVideos") as! NSArray
                            if postImageVideos.count > 0{
                                for dictImageVideo in postImageVideos{
                                    let objImageModel = ImageModel()
                                    objImageModel.IsImageVideo = (dictImageVideo as AnyObject).value(forKey: "IsImageVideo") as! Int
                                    objImageModel.PostContent = (dictImageVideo as AnyObject).value(forKey: "PostContent") as! NSString
                                    objImageModel.PostId = (dictImageVideo as AnyObject).value(forKey: "PostId") as! Int
                                    objImageModel.VideoThumbnail = (dictImageVideo as AnyObject).value(forKey: "VideoThumbnail") as! NSString
                                    objPostModel.arrImageVideo.add(objImageModel)
                                }
                            }
                            
                            //User
                            if let user = (dict as AnyObject).value(forKey: "user") as? NSDictionary {
                                objPostModel.BirthDate = (user as AnyObject).value(forKey: "BirthDate") as! NSString
                                objPostModel.Contact = (user as AnyObject).value(forKey: "Contact") as! NSString
                                objPostModel.Email = (user as AnyObject).value(forKey: "Email") as! NSString
                                objPostModel.FirstName = (user as AnyObject).value(forKey: "FirstName") as! NSString
                                objPostModel.LastName = (user as AnyObject).value(forKey: "LastName") as! NSString
                                objPostModel.ProfilePic = (user as AnyObject).value(forKey: "ProfilePic") as! NSString
                                if let isPublic = (user as AnyObject).value(forKey: "IsPublic") as? Bool {
                                    objPostModel.isPublic = isPublic
                                }
                                else{
                                    objPostModel.isPublic = false
                                }

                            }
                            else{
                                objPostModel.BirthDate = ""
                                objPostModel.Contact = ""
                                objPostModel.Email = ""
                                objPostModel.FirstName = ""
                                objPostModel.LastName = ""
                                objPostModel.ProfilePic = ""
                                objPostModel.isPublic = false
                            }

                            self.arrAllPost.add(objPostModel)
                            
                        }
                        
                        self.tblPost.infiniteScrollingView.stopAnimating()
                        self.tblPost.reloadData()
                    }
                    else{
                      
                        self.tblPost.infiniteScrollingView.stopAnimating()
                        if self.arrAllPost.count == 0{
                        }
                        else{
                          //  self.collectionView.infiniteScrollingView.stopAnimating()
                        }
                    }
                    
                    
                }
                else{
                   
                    self.appDelegate.ShowAlert(AlertTitle as NSString, alertMessage: message as NSString)
                }
                  self.tblPost.infiniteScrollingView.stopAnimating()
                
            },
            failure: { (operation, error) in
                let err = error as! NSError
                print("We got an error here.. \(err.localizedDescription)")
                print("Error Info.. \(err.userInfo)")
                print("Error desc.. \(err.description)")
                self.appDelegate.ShowAlert(AlertTitle as NSString, alertMessage: INTERNET_CONNECTION as NSString)
                
                self.tblPost.infiniteScrollingView.stopAnimating()
                
            })
    }
    
    func serGradientView(){
        
        gradientLayer.frame = self.view.bounds
        
        let color1 = UIColor.white.cgColor as CGColor
        let color2 = UIColor(red: 231/255, green: 252/255, blue: 253/255, alpha: 1.0).cgColor as CGColor
        let color3 = UIColor(red: 113/255, green: 221/255, blue: 234/255, alpha: 1.0).cgColor as CGColor
        let color4 = UIColor(red: 63/255, green: 199/255, blue: 216/255, alpha: 1.0).cgColor as CGColor
        
        gradientLayer.colors = [color1,color2,color3,color4]
        gradientLayer.locations = [0.0, 0.25, 0.75, 1.0]
        self.view.layer.insertSublayer(gradientLayer, below: self.tblPost.layer)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrAllPost.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 148.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        postHeaderview = Bundle.main.loadNibNamed("PostHeaderView", owner: self, options: nil)?[0] as! PostHeaderView
        
        postHeaderview.imgProfilePic.layer.cornerRadius = postHeaderview.imgProfilePic.frame.size.height/2
        postHeaderview.imgProfilePic.layer.masksToBounds =  true
        
        let strImageURL = UserDefaults.standard.value(forKey: keyProfilePic) as! NSString
        
        let imgURL = NSURL(string: strImageURL as String)
        
        let imageRequest = NSURLRequest(url: imgURL as! URL, cachePolicy: NSURLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 600)
        self.postHeaderview.imgProfilePic.setImageWith(imageRequest as URLRequest!, placeholderImage: UIImage(named: "unknown_user.png"), withGradient: true, success: nil, failure: nil)
     
        let tap = UITapGestureRecognizer(target: self, action : #selector(HomeViewController.handleTapForHeader))
        tap.numberOfTapsRequired = 1
        self.postHeaderview.addGestureRecognizer(tap)
        
        return postHeaderview
        
    }
    
    func handleTapForHeader(){
        print("handle")
        let addPhotoVC = self.storyboard?.instantiateViewController(withIdentifier: IdentifireAddPostView) as! AddPostViewController
        addPhotoVC.delegate = self
        self.navigationController?.pushViewController(addPhotoVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let objPost = arrAllPost.object(at: indexPath.row) as! PostModel
        getLeftTime(objPost.PostedDate)
        let index = NSString(format: "%d%d", indexPath.section, indexPath.row)
        
        //Only Text
        if(objPost.arrImageVideo.count == 0){
            var cell: PostCellText! = tableView.dequeueReusableCell(withIdentifier: "PostCellText") as? PostCellText
            if cell == nil {
                tableView.register(UINib(nibName: "PostCellText", bundle: nil), forCellReuseIdentifier: "PostCellText")
                cell = tableView.dequeueReusableCell(withIdentifier: "PostCellText") as? PostCellText
            }
            
            self.setCommonValueForCellText(cell: cell, objPost: objPost)
            
            if(self.dictLikeData.value(forKey: index as String) != nil){
                cell.btnLikeCount.setTitle(String(format: "%d", objPost.LikeCount), for: UIControlState.normal)
                cell.btnLike.setImage(UIImage(named: "like.png"), for: UIControlState.normal)
            }
            else{
                cell.btnLike.setImage(UIImage(named: "unlike.png"), for: UIControlState.normal)
            }
            
            if(self.dictIndicatorData.value(forKey: index as String) != nil){
                cell.activityIndi.startAnimating()
            }
            else{
                cell.activityIndi.stopAnimating()
            }
            
            
            cell.btnUser.addTarget(self, action: #selector(HomeViewController.onClick_btnUserProfile), for: UIControlEvents.touchUpInside)
           
            cell.btnReport.addTarget(self,action:#selector(HomeViewController.onClick_btnReport(sender:)), for: .touchUpInside)
            cell.btnComment.addTarget(self,action:#selector(HomeViewController.onClick_btnComment(sender:)), for: .touchUpInside)
            cell.btnLike.addTarget(self,action:#selector(HomeViewController.btnLikeForTextClick(sender:)), for: .touchUpInside)
            cell.btnLikeCount.addTarget(self,action:#selector(HomeViewController.btnLikeCountClick(sender:)), for: .touchUpInside)
            cell.btnShare.addTarget(self,action:#selector(HomeViewController.btnShareClicked(sender:)), for: .touchUpInside)
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }
        //One Image
        else if(objPost.arrImageVideo.count == 1){
            var cell: PostCellOneImage! = tableView.dequeueReusableCell(withIdentifier: "PostCellOneImage") as? PostCellOneImage
            if cell == nil {
                tableView.register(UINib(nibName: "PostCellOneImage", bundle: nil), forCellReuseIdentifier: "PostCellOneImage")
                cell = tableView.dequeueReusableCell(withIdentifier: "PostCellOneImage") as? PostCellOneImage
            }
            self.setCommonValueForCellOneImage(cell: cell, objPost: objPost)
            
            if(self.dictLikeData.value(forKey: index as String) != nil){
                cell.btnLikeCount.setTitle(String(format: "%d", objPost.LikeCount), for: UIControlState.normal)
                cell.btnLike.setImage(UIImage(named: "like.png"), for: UIControlState.normal)
            }
            else{
                cell.btnLike.setImage(UIImage(named: "unlike.png"), for: UIControlState.normal)
            }
            
            if(self.dictIndicatorData.value(forKey: index as String) != nil){
                cell.activityIndi.startAnimating()
            }
            else{
                cell.activityIndi.stopAnimating()
            }
            
            cell.btnUser.addTarget(self, action: #selector(HomeViewController.onClick_btnUserProfile), for: UIControlEvents.touchUpInside)
            
            cell.btnReport.addTarget(self,action:#selector(HomeViewController.onClick_btnReport(sender:)), for: .touchUpInside)
            cell.btnComment.addTarget(self,action:#selector(HomeViewController.onClick_btnComment(sender:)), for: .touchUpInside)
            cell.btnPost.addTarget(self,action:#selector(HomeViewController.onClick_btnPostImage), for: .touchUpInside)
            cell.btnLike.addTarget(self,action:#selector(HomeViewController.btnLikeForOneImage(sender:)), for: .touchUpInside)
            cell.btnLikeCount.addTarget(self,action:#selector(HomeViewController.btnLikeCountClick(sender:)), for: .touchUpInside)
            cell.btnShare.addTarget(self,action:#selector(HomeViewController.btnShareClicked(sender:)), for: .touchUpInside)
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }
        //Two Image
        else if(objPost.arrImageVideo.count == 2){
            var cell: PostCellTwoImages! = tableView.dequeueReusableCell(withIdentifier: "PostCellTwoImages") as? PostCellTwoImages
            if cell == nil {
                tableView.register(UINib(nibName: "PostCellTwoImages", bundle: nil), forCellReuseIdentifier: "PostCellTwoImages")
                cell = tableView.dequeueReusableCell(withIdentifier: "PostCellTwoImages") as? PostCellTwoImages
            }
            self.setCommonValueForCellTwoImage(cell: cell, objPost: objPost)
            
            if(self.dictLikeData.value(forKey: index as String) != nil){
                cell.btnLikeCount.setTitle(String(format: "%d", objPost.LikeCount), for: UIControlState.normal)
                cell.btnLike.setImage(UIImage(named: "like.png"), for: UIControlState.normal)
            }
            else{
                cell.btnLike.setImage(UIImage(named: "unlike.png"), for: UIControlState.normal)
            }
            
            if(self.dictIndicatorData.value(forKey: index as String) != nil){
                cell.activityIndi.startAnimating()
            }
            else{
                cell.activityIndi.stopAnimating()
            }
            
           
            cell.btnUser.addTarget(self, action: #selector(HomeViewController.onClick_btnUserProfile), for: UIControlEvents.touchUpInside)
            cell.btnReport.addTarget(self,action:#selector(HomeViewController.onClick_btnReport(sender:)), for: .touchUpInside)
            cell.btnComment.addTarget(self,action:#selector(HomeViewController.onClick_btnComment(sender:)), for: .touchUpInside)
            cell.btnPost1.addTarget(self,action:#selector(HomeViewController.onClick_btnPostImage), for: .touchUpInside)
            cell.btnPost2.addTarget(self,action:#selector(HomeViewController.onClick_btnPostImage), for: .touchUpInside)
            cell.btnLike.addTarget(self,action:#selector(HomeViewController.btnLikeForTwoImage(sender:)), for: .touchUpInside)
            cell.btnLikeCount.addTarget(self,action:#selector(HomeViewController.btnLikeCountClick(sender:)), for: .touchUpInside)
            cell.btnShare.addTarget(self,action:#selector(HomeViewController.btnShareClicked(sender:)), for: .touchUpInside)
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }
        //Three Image
        else if(objPost.arrImageVideo.count == 3){
            var cell: PostCellThreeImages! = tableView.dequeueReusableCell(withIdentifier: "PostCellThreeImages") as? PostCellThreeImages
            if cell == nil {
                tableView.register(UINib(nibName: "PostCellThreeImages", bundle: nil), forCellReuseIdentifier: "PostCellThreeImages")
                cell = tableView.dequeueReusableCell(withIdentifier: "PostCellThreeImages") as? PostCellThreeImages
            }
            self.setCommonValueForCellThreeImage(cell: cell, objPost: objPost)
            
            if(self.dictLikeData.value(forKey: index as String) != nil){
                cell.btnLikeCount.setTitle(String(format: "%d", objPost.LikeCount), for: UIControlState.normal)
                cell.btnLike.setImage(UIImage(named: "like.png"), for: UIControlState.normal)
            }
            else{
                cell.btnLike.setImage(UIImage(named: "unlike.png"), for: UIControlState.normal)
            }
           
            if(self.dictIndicatorData.value(forKey: index as String) != nil){
                cell.activityIndi.startAnimating()
            }
            else{
                cell.activityIndi.stopAnimating()
            }
            
            cell.btnReport.addTarget(self,action:#selector(HomeViewController.onClick_btnReport(sender:)), for: .touchUpInside)
            cell.btnUser.addTarget(self, action: #selector(HomeViewController.onClick_btnUserProfile), for: UIControlEvents.touchUpInside)
            cell.btnComment.addTarget(self,action:#selector(HomeViewController.onClick_btnComment(sender:)), for: .touchUpInside)
            cell.btnPost1.addTarget(self,action:#selector(HomeViewController.onClick_btnPostImage), for: .touchUpInside)
            cell.btnPost2.addTarget(self,action:#selector(HomeViewController.onClick_btnPostImage), for: .touchUpInside)
            cell.btnPost3.addTarget(self,action:#selector(HomeViewController.onClick_btnPostImage), for: .touchUpInside)
            cell.btnLike.addTarget(self,action:#selector(HomeViewController.btnLikeForThreeImage(sender:)), for: .touchUpInside)
            cell.btnLikeCount.addTarget(self,action:#selector(HomeViewController.btnLikeCountClick(sender:)), for: .touchUpInside)
            cell.btnShare.addTarget(self,action:#selector(HomeViewController.btnShareClicked(sender:)), for: .touchUpInside)
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }
        //Four Image
        else if(objPost.arrImageVideo.count == 4){
            var cell: PostCellFourImages! = tableView.dequeueReusableCell(withIdentifier: "PostCellFourImages") as? PostCellFourImages
            if cell == nil {
                tableView.register(UINib(nibName: "PostCellFourImages", bundle: nil), forCellReuseIdentifier: "PostCellFourImages")
                cell = tableView.dequeueReusableCell(withIdentifier: "PostCellFourImages") as? PostCellFourImages
            }
            self.setCommonValueForCellFourImage(cell: cell, objPost: objPost)
            
            if(self.dictLikeData.value(forKey: index as String) != nil){
                cell.btnLikeCount.setTitle(String(format: "%d", objPost.LikeCount), for: UIControlState.normal)
                cell.btnLike.setImage(UIImage(named: "like.png"), for: UIControlState.normal)
            }
            else{
                cell.btnLike.setImage(UIImage(named: "unlike.png"), for: UIControlState.normal)
            }
            
            if(self.dictIndicatorData.value(forKey: index as String) != nil){
                cell.activityIndi.startAnimating()
            }
            else{
                cell.activityIndi.stopAnimating()
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.btnReport.addTarget(self,action:#selector(HomeViewController.onClick_btnReport(sender:)), for: .touchUpInside)
             cell.btnUser.addTarget(self, action: #selector(HomeViewController.onClick_btnUserProfile), for: UIControlEvents.touchUpInside)
            cell.btnComment.addTarget(self,action:#selector(HomeViewController.onClick_btnComment(sender:)), for: .touchUpInside)
            cell.btnPost1.addTarget(self,action:#selector(HomeViewController.onClick_btnPostImage), for: .touchUpInside)
            cell.btnPost2.addTarget(self,action:#selector(HomeViewController.onClick_btnPostImage), for: .touchUpInside)
            cell.btnPost3.addTarget(self,action:#selector(HomeViewController.onClick_btnPostImage), for: .touchUpInside)
            cell.btnViewMore.addTarget(self,action:#selector(HomeViewController.onClick_btnPostImage), for: .touchUpInside)
            cell.btnLike.addTarget(self,action:#selector(HomeViewController.btnLikeForFourImage(sender:)), for: .touchUpInside)
            cell.btnLikeCount.addTarget(self,action:#selector(HomeViewController.btnLikeCountClick(sender:)), for: .touchUpInside)
            cell.btnShare.addTarget(self,action:#selector(HomeViewController.btnShareClicked(sender:)), for: .touchUpInside)
            
            cell.btnViewMore.isHidden = true
            cell.btnViewMore.backgroundColor = UIColor.clear
            
            return cell
        }
        //More than four image
        else{
            var cell: PostCellFourImages! = tableView.dequeueReusableCell(withIdentifier: "PostCellFourImages") as? PostCellFourImages
            if cell == nil {
                tableView.register(UINib(nibName: "PostCellFourImages", bundle: nil), forCellReuseIdentifier: "PostCellFourImages")
                cell = tableView.dequeueReusableCell(withIdentifier: "PostCellFourImages") as? PostCellFourImages
            }
            self.setCommonValueForCellFourImage(cell: cell, objPost: objPost)
            
            if(self.dictLikeData.value(forKey: index as String) != nil){
                cell.btnLikeCount.setTitle(String(format: "%d", objPost.LikeCount), for: UIControlState.normal)
                cell.btnLike.setImage(UIImage(named: "like.png"), for: UIControlState.normal)
            }
            else{
                cell.btnLike.setImage(UIImage(named: "unlike.png"), for: UIControlState.normal)
            }
            
            if(self.dictIndicatorData.value(forKey: index as String) != nil){
                cell.activityIndi.startAnimating()
            }
            else{
                cell.activityIndi.stopAnimating()
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.btnReport.addTarget(self,action:#selector(HomeViewController.onClick_btnReport(sender:)), for: .touchUpInside)
             cell.btnUser.addTarget(self, action: #selector(HomeViewController.onClick_btnUserProfile), for: UIControlEvents.touchUpInside)
            cell.btnComment.addTarget(self,action:#selector(HomeViewController.onClick_btnComment(sender:)), for: .touchUpInside)
            cell.btnPost1.addTarget(self,action:#selector(HomeViewController.onClick_btnPostImage), for: .touchUpInside)
            cell.btnPost2.addTarget(self,action:#selector(HomeViewController.onClick_btnPostImage), for: .touchUpInside)
            cell.btnPost3.addTarget(self,action:#selector(HomeViewController.onClick_btnPostImage), for: .touchUpInside)
            cell.btnViewMore.addTarget(self,action:#selector(HomeViewController.onClick_btnPostImage), for: .touchUpInside)
            cell.btnLike.addTarget(self,action:#selector(HomeViewController.btnLikeForFourImage(sender:)), for: .touchUpInside)
            cell.btnLikeCount.addTarget(self,action:#selector(HomeViewController.btnLikeCountClick(sender:)), for: .touchUpInside)
            cell.btnShare.addTarget(self,action:#selector(HomeViewController.btnShareClicked(sender:)), for: .touchUpInside)
            
            cell.btnViewMore.backgroundColor = UIColor.black.withAlphaComponent(0.65)
            
            let viewMoreCount : Int = objPost.arrImageVideo.count - 4
            cell.btnViewMore.setTitle(NSString(format : "+%d",viewMoreCount) as String, for: UIControlState.normal)
            
            return cell
        }
    }
    
    func onClick_btnUserProfile(sender: AnyObject)
    {
        let btn:UIButton = sender as! UIButton
        NSLog("btn tag...%d", btn.tag)

        let buttonPosition:CGPoint = btn.convert(CGPoint.zero, to:self.tblPost)
        let indexPath = self.tblPost.indexPathForRow(at: buttonPosition)
        let objPost = arrAllPost.object(at: (indexPath?.row)!) as! PostModel
        let userdetailVC = self.storyboard?.instantiateViewController(withIdentifier: IdentifireUserDetailsView) as! UserDetailsViewController
        userdetailVC.strFirstName = objPost.FirstName
        userdetailVC.strLastName = objPost.LastName
        userdetailVC.strContact = objPost.Contact
        userdetailVC.strEmail = objPost.Email
        userdetailVC.strBirthDate = objPost.BirthDate
        userdetailVC.strProfilePic = objPost.ProfilePic
        self.navigationController?.pushViewController(userdetailVC, animated: true)
    }
    
    func onClick_btnPostReport(sender: AnyObject)
    {
        
        viewMainReport.removeFromSuperview()
        
        let btn:UIButton = sender as! UIButton
        NSLog("btn tag...%d", btn.tag)
        
        viewReport =  Bundle.main.loadNibNamed("ViewLayout", owner: self, options: nil)?[1] as! ViewLayout
        viewReport.frame = CGRect(x:viewReport.frame.origin.x, y:viewReport.frame.origin.y, width:self.view.frame.size.width, height:self.view.frame.size.height)
        viewReport.viewReport.layer.cornerRadius = 4.0
        viewReport.viewReport.layer.masksToBounds = true
        viewReport.txtReportDesc.delegate = self
        viewReport.btnSubmitReport.layer.cornerRadius = 4.0
        viewReport.btnSubmitReport.layer.masksToBounds = true
        viewReport.txtReportDesc.becomeFirstResponder()
        viewReport.btnSubmitReport.addTarget(self, action: #selector(HomeViewController.onClickSubmitReport), for: UIControlEvents.touchUpInside)
        
        let buttonPosition:CGPoint = btn.convert(CGPoint.zero, to:self.tblPost)
        let indexPath = self.tblPost.indexPathForRow(at: buttonPosition)
       
        viewReport.btnSubmitReport.tag = btn.tag
        viewReport.btnClose.addTarget(self, action: #selector(HomeViewController.onClickClose), for: UIControlEvents.touchUpInside)
        
        self.addBottomLineToTextField(textField: viewReport.txtReportDesc)
        self.setTexfieldTitle(textField: viewReport.txtReportDesc, title: "Description")
        
        self.navigationController!.view.superview?.addSubview(viewReport)
    }
    
    func onClick_btnReport(sender: AnyObject)
    {
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        let btn:UIButton = sender as! UIButton
        NSLog("btn tag...%d", btn.tag)
        
        let buttonPosition:CGPoint = btn.convert(CGPoint.zero, to:self.tblPost)
        let indexPath = self.tblPost.indexPathForRow(at: buttonPosition)
        
        let objPost = arrAllPost.object(at: (indexPath?.row)!) as! PostModel
        print(objPost.PostId)
        
        viewMainReport =  Bundle.main.loadNibNamed("ViewLayout", owner: self, options: nil)?[2] as! ViewLayout
        viewMainReport.frame = CGRect(x:viewMainReport.frame.origin.x, y:viewMainReport.frame.origin.y, width:self.view.frame.size.width, height:self.view.frame.size.height)
        viewMainReport.viewMainReport.frame = CGRect(x:viewMainReport.viewMainReport.frame.origin.x, y:viewMainReport.viewMainReport.frame.origin.y, width:self.view.frame.size.width, height:self.view.frame.size.height)
        
        if(btn.tag == 0){
            let cell: PostCellText! = self.tblPost.cellForRow(at: indexPath! as IndexPath) as! PostCellText!
            viewMainReport.viewMainBottomReport.frame = CGRect(x:self.view.frame.size.width-viewMainReport.viewMainBottomReport.frame.size.width, y:cell.frame.origin.y-self.tblPost.contentOffset.y+40, width:viewMainReport.viewMainBottomReport.frame.size.width, height:viewMainReport.viewMainBottomReport.frame.size.height)
        }
        else if(btn.tag == 1){
            let cell: PostCellOneImage! = self.tblPost.cellForRow(at: indexPath! as IndexPath) as! PostCellOneImage!
            viewMainReport.viewMainBottomReport.frame = CGRect(x:self.view.frame.size.width-viewMainReport.viewMainBottomReport.frame.size.width, y:cell.frame.origin.y-self.tblPost.contentOffset.y+40, width:viewMainReport.viewMainBottomReport.frame.size.width, height:viewMainReport.viewMainBottomReport.frame.size.height)
        }
        else if(btn.tag == 2){
            let cell: PostCellTwoImages! = self.tblPost.cellForRow(at: indexPath! as IndexPath) as! PostCellTwoImages!
             viewMainReport.viewMainBottomReport.frame = CGRect(x:self.view.frame.size.width-viewMainReport.viewMainBottomReport.frame.size.width, y:cell.frame.origin.y-self.tblPost.contentOffset.y+40, width:viewMainReport.viewMainBottomReport.frame.size.width, height:viewMainReport.viewMainBottomReport.frame.size.height)
        }
        else if(btn.tag == 3){
            let cell: PostCellThreeImages! = self.tblPost.cellForRow(at: indexPath! as IndexPath) as! PostCellThreeImages!
             viewMainReport.viewMainBottomReport.frame = CGRect(x:self.view.frame.size.width-viewMainReport.viewMainBottomReport.frame.size.width, y:cell.frame.origin.y-self.tblPost.contentOffset.y+40, width:viewMainReport.viewMainBottomReport.frame.size.width, height:viewMainReport.viewMainBottomReport.frame.size.height)
           
        }
        else if(btn.tag == 4){
            let cell: PostCellFourImages! = self.tblPost.cellForRow(at: indexPath! as IndexPath) as! PostCellFourImages!
             viewMainReport.viewMainBottomReport.frame = CGRect(x:self.view.frame.size.width-viewMainReport.viewMainBottomReport.frame.size.width, y:cell.frame.origin.y-self.tblPost.contentOffset.y+40, width:viewMainReport.viewMainBottomReport.frame.size.width, height:viewMainReport.viewMainBottomReport.frame.size.height)
          
        }
        viewMainReport.viewBottomReport.layer.cornerRadius = 4.0
        viewMainReport.viewBottomReport.layer.masksToBounds = true
        viewMainReport.btnReport.addTarget(self, action: #selector(HomeViewController.onClick_btnPostReport), for: UIControlEvents.touchUpInside)
        
        
        viewMainReport.btnReport.tag = objPost.PostId as Int
        
        let tap = UITapGestureRecognizer(target: self, action : #selector(HomeViewController.btnRemoveReportClicked))
        tap.numberOfTapsRequired = 1
        self.viewMainReport.addGestureRecognizer(tap)
        
        
        self.navigationController!.view.superview?.addSubview(viewMainReport)
        
      /*  if(btn.tag == 0){
            let cell: PostCellText! = self.tblPost.cellForRow(at: indexPath! as IndexPath) as! PostCellText!
            if(cell.viewMainReport.isHidden == false ){
                cell.viewMainReport.isHidden = true
            }
            else{
                cell.viewMainReport.isHidden = false
            }
        }
        else if(btn.tag == 1){
            let cell: PostCellOneImage! = self.tblPost.cellForRow(at: indexPath! as IndexPath) as! PostCellOneImage!
            if(cell.viewMainReport.isHidden == false ){
                cell.viewMainReport.isHidden = true
            }
            else{
                cell.viewMainReport.isHidden = false
            }
        }
        else if(btn.tag == 2){
            let cell: PostCellTwoImages! = self.tblPost.cellForRow(at: indexPath! as IndexPath) as! PostCellTwoImages!
            if(cell.viewMainReport.isHidden == false ){
                cell.viewMainReport.isHidden = true
            }
            else{
                cell.viewMainReport.isHidden = false
            }
        }
        else if(btn.tag == 3){
            let cell: PostCellThreeImages! = self.tblPost.cellForRow(at: indexPath! as IndexPath) as! PostCellThreeImages!
            if(cell.viewMainReport.isHidden == false ){
                cell.viewMainReport.isHidden = true
            }
            else{
                cell.viewMainReport.isHidden = false
            }
        }
        else if(btn.tag == 4){
            let cell: PostCellFourImages! = self.tblPost.cellForRow(at: indexPath! as IndexPath) as! PostCellFourImages!
            if(cell.viewMainReport.isHidden == false ){
                cell.viewMainReport.isHidden = true
            }
            else{
                cell.viewMainReport.isHidden = false
            }
        } */
       
    }
    
    func btnRemoveReportClicked(){
        viewMainReport.removeFromSuperview()
     
    }
    
    func addBottomLineToTextField(textField : UITextField) {
        let border = CALayer()
        let borderWidth = CGFloat(1.0)
        border.borderColor =  UIColor.MKColor.DarkGrey.cgColor
        border.frame = CGRect(x : 0, y : textField.frame.size.height - borderWidth, width : textField.frame.size.width+50, height : textField.frame.size.height)
        border.borderWidth = borderWidth
        textField.layer.addSublayer(border)
        textField.layer.masksToBounds = true
    }
    
    func setTexfieldTitle(textField : MKTextField, title : NSString){
        
        textField.layer.borderColor = UIColor.clear.cgColor
        textField.floatingPlaceholderEnabled = true
        textField.bottomBorderEnabled = false
        textField.placeholder = title as String
        textField.tintColor = UIColor.MKColor.DarkGrey
        textField.rippleLocation = .right
        textField.cornerRadius = 0
    }
    
    func onClickSubmitReport(sender: UIButton)
    {
        viewReport.removeFromSuperview()
        
        self.backgroundRequestForPostReport(postId: sender.tag)
    }
    
    func onClickClose()
    {
        viewReport.removeFromSuperview()
    }

    func onClick_btnComment(sender: AnyObject)
    {
        let btn:UIButton = sender as! UIButton
        NSLog("btn tag...%d", btn.tag)
        
        let buttonPosition:CGPoint = btn.convert(CGPoint.zero, to:self.tblPost)
        let indexPath = self.tblPost.indexPathForRow(at: buttonPosition)
        
        let commentVC = self.storyboard?.instantiateViewController(withIdentifier: IdentifireCommentView) as! CommentViewController
        
        let objPost = arrAllPost.object(at: (indexPath?.row)!) as! PostModel
        commentVC.postID = objPost.PostId
        commentVC.delegate = self
        commentVC.index = indexPath?.row
        self.navigationController?.pushViewController(commentVC, animated: true)
    }
    
    func onClick_btnPostImage(sender: AnyObject)
    {
        let btn:UIButton = sender as! UIButton
        NSLog("btn tag...%d", btn.tag)
        
        let buttonPosition:CGPoint = btn.convert(CGPoint.zero, to:self.tblPost)
        let indexPath = self.tblPost.indexPathForRow(at: buttonPosition)
        
        let albumVC = self.storyboard?.instantiateViewController(withIdentifier: IdentifireAlbumPhotoSlideView) as! AlbumPhotoSlideViewController
        
        print(indexPath?.row as Any)
        
        let objPost = arrAllPost.object(at: (indexPath?.row)!) as! PostModel
        
        albumVC.arrAlbumImages = objPost.arrImageVideo
        albumVC.index = btn.tag
        self.navigationController?.pushViewController(albumVC, animated: true)
        
    }
    
    func downloadVideoLinkAndCreateAsset(_ videoLink: String) {
        
        // use guard to make sure you have a valid url
        guard let videoURL = URL(string: videoLink) else { return }
        
        let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        // check if the file already exist at the destination folder if you don't want to download it twice
        if !FileManager.default.fileExists(atPath: documentsDirectoryURL.appendingPathComponent(videoURL.lastPathComponent).path) {
            
            // set up your download task
            URLSession.shared.downloadTask(with: videoURL) { (location, response, error) -> Void in
                
                // use guard to unwrap your optional url
                guard let location = location else { return }
                
                // create a deatination url with the server response suggested file name
                let destinationURL = documentsDirectoryURL.appendingPathComponent(response?.suggestedFilename ?? videoURL.lastPathComponent)
                
                do {
                    
                    try FileManager.default.moveItem(at: location, to: destinationURL)
                    
                    PHPhotoLibrary.requestAuthorization({ (authorizationStatus: PHAuthorizationStatus) -> Void in
                        
                        // check if user authorized access photos for your app
                        if authorizationStatus == .authorized {
                            PHPhotoLibrary.shared().performChanges({
                                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: destinationURL)}) { completed, error in
                                    if completed {
                                        print("Video asset created")
                                    } else {
                                        print(error)
                                    }
                            }
                        }
                    })
                    
                } catch let error as NSError { print(error.localizedDescription)}
                
                }.resume()
            
        } else {
            print("File already exists at destination url")
        }
        
    }

    
    func btnShareClicked(sender: AnyObject){
        let btn:UIButton = sender as! UIButton
        
        let buttonPosition:CGPoint = btn.convert(CGPoint.zero, to:self.tblPost)
        let indexPath = self.tblPost.indexPathForRow(at: buttonPosition)
        
        let objPost = self.arrAllPost.object(at: (indexPath?.row)!) as! PostModel
        let shareText = objPost.PostText as String
        let items : NSMutableArray = NSMutableArray()
        
        if(btn.tag == 0){
            items.add(shareText)
            let activityVC = UIActivityViewController(activityItems: items as! [Any], applicationActivities: nil)
            activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList, UIActivityType.assignToContact, UIActivityType.copyToPasteboard]
            self.present(activityVC, animated: true, completion: nil)
        }
        else if(btn.tag == 1){
            let cell: PostCellOneImage! = self.tblPost.cellForRow(at: indexPath! as IndexPath) as! PostCellOneImage!
            
            items.add(shareText)
            
            for i in 0 ..< objPost.arrImageVideo.count
            {
                var objImageVideo : ImageModel = ImageModel()
                objImageVideo = objPost.arrImageVideo.object(at: i) as! ImageModel
                
                let isImageVideo = objImageVideo.IsImageVideo as Int
                if(isImageVideo == 1){
                    if(i == 0){
                       items.add(cell.imgPost.image as Any)
                        let activityVC = UIActivityViewController(activityItems: items as! [Any], applicationActivities: nil)
                        activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList, UIActivityType.assignToContact, UIActivityType.copyToPasteboard]
                        self.present(activityVC, animated: true, completion: nil)
                    }
                }
                else{
                    self.ShowActivityIndicator()
                    let videoLink = objImageVideo.PostContent as NSString
                    // use guard to make sure you have a valid url
                    guard let videoURL = URL(string: videoLink as String) else { return }
                    
                    let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                    
                    // check if the file already exist at the destination folder if you don't want to download it twice
                    if !FileManager.default.fileExists(atPath: documentsDirectoryURL.appendingPathComponent(videoURL.lastPathComponent).path) {
                        
                        // set up your download task
                        URLSession.shared.downloadTask(with: videoURL) { (location, response, error) -> Void in
                            
                            print(response as Any)
                            
                            // use guard to unwrap your optional url
                            guard let location = location else { return }
                            print(location)
                            // create a deatination url with the server response suggested file name
                            let destinationURL = documentsDirectoryURL.appendingPathComponent(response?.suggestedFilename ?? videoURL.lastPathComponent)
                            print("destinationURL\(destinationURL)")
                            
                            do {
                                
                                try FileManager.default.moveItem(at: location, to: destinationURL)
                                
                                PHPhotoLibrary.requestAuthorization({ (authorizationStatus: PHAuthorizationStatus) -> Void in
                                    
                                    // check if user authorized access photos for your app
                                    if authorizationStatus == .authorized {
                                        PHPhotoLibrary.shared().performChanges({
                                            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: destinationURL)}) { completed, error in
                                                if completed {
                                                    print("Video asset created")
                                                    items.add(destinationURL)
                                                    let activityVC = UIActivityViewController(activityItems: items as! [Any], applicationActivities: nil)
                                                    activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList, UIActivityType.assignToContact, UIActivityType.copyToPasteboard]
                                                    self.present(activityVC, animated: true, completion: nil)

                                                    self.RemoveActivityIndicator()
                                                } else {
                                                    print(error as Any)
                                                    self.RemoveActivityIndicator()
                                                }
                                                
                                        }
                                    }
                                })
                                
                            } catch let error as NSError { print(error.localizedDescription)}
                            
                            }.resume()
                        
                    } else {
                        print("File already exists at destination url")
                        print(documentsDirectoryURL.appendingPathComponent(videoURL.lastPathComponent))
                        let destinationURL = documentsDirectoryURL.appendingPathComponent(videoURL.lastPathComponent)
                        items.add(destinationURL)
                        let activityVC = UIActivityViewController(activityItems: items as! [Any], applicationActivities: nil)
                        activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList, UIActivityType.assignToContact, UIActivityType.copyToPasteboard]
                        self.present(activityVC, animated: true, completion: nil)

                        self.RemoveActivityIndicator()
                    }
                }
            }

        }
        else if(btn.tag == 2){
           
            let myGroup = DispatchGroup()
            
            let cell: PostCellTwoImages! = self.tblPost.cellForRow(at: indexPath! as IndexPath) as! PostCellTwoImages!
            
            items.add(shareText)
            
            for i in 0 ..< objPost.arrImageVideo.count
            {
                myGroup.enter()
                var objImageVideo : ImageModel = ImageModel()
                objImageVideo = objPost.arrImageVideo.object(at: i) as! ImageModel
                
                let isImageVideo = objImageVideo.IsImageVideo as Int
                if(isImageVideo == 1){
                    if(i == 0){
                        items.add(cell.imgPost1.image as Any)
                    }
                    else if(i == 1){
                        items.add(cell.imgPost2.image as Any)
                    }
                    myGroup.leave()
                }
                else{
                    self.ShowActivityIndicator()
                    let videoLink = objImageVideo.PostContent as NSString
                    // use guard to make sure you have a valid url
                    guard let videoURL = URL(string: videoLink as String) else { return }
                    
                    let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                    
                    // check if the file already exist at the destination folder if you don't want to download it twice
                    if !FileManager.default.fileExists(atPath: documentsDirectoryURL.appendingPathComponent(videoURL.lastPathComponent).path) {
                    
                        // set up your download task
                        URLSession.shared.downloadTask(with: videoURL) { (location, response, error) -> Void in
                            
                            print(response as Any)
                            
                            // use guard to unwrap your optional url
                            guard let location = location else { return }
                            print(location)
                            // create a deatination url with the server response suggested file name
                            let destinationURL = documentsDirectoryURL.appendingPathComponent(response?.suggestedFilename ?? videoURL.lastPathComponent)
                            print("destinationURL\(destinationURL)")
                            
                            do {
                                
                                try FileManager.default.moveItem(at: location, to: destinationURL)
                                
                                PHPhotoLibrary.requestAuthorization({ (authorizationStatus: PHAuthorizationStatus) -> Void in
                                    
                                    // check if user authorized access photos for your app
                                    if authorizationStatus == .authorized {
                                        PHPhotoLibrary.shared().performChanges({
                                            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: destinationURL)}) { completed, error in
                                                if completed {
                                                    print("Video asset created")
                                                    items.add(destinationURL)
                                                    self.RemoveActivityIndicator()
                                                } else {
                                                    print(error as Any)
                                                    self.RemoveActivityIndicator()
                                                }
                                                myGroup.leave()
                                        }
                                    }
                                })
                                
                            } catch let error as NSError { print(error.localizedDescription)}
                            
                            }.resume()
                        
                    } else {
                        print("File already exists at destination url")
                        print(documentsDirectoryURL.appendingPathComponent(videoURL.lastPathComponent))
                        let destinationURL = documentsDirectoryURL.appendingPathComponent(videoURL.lastPathComponent)
                        items.add(destinationURL)
                        myGroup.leave()
                        self.RemoveActivityIndicator()
                    }
                }
            }
            
            myGroup.notify(queue: .main) {
                print("Finished all requests.")
                let activityVC = UIActivityViewController(activityItems: items as! [Any], applicationActivities: nil)
                activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList, UIActivityType.assignToContact, UIActivityType.copyToPasteboard]
                self.present(activityVC, animated: true, completion: nil)

            }
            
            
        }
        else if(btn.tag == 3){
            let cell: PostCellThreeImages! = self.tblPost.cellForRow(at: indexPath! as IndexPath) as! PostCellThreeImages!
            
            items.add(shareText)
            let myGroup = DispatchGroup()
            
            for i in 0 ..< objPost.arrImageVideo.count
            {
                myGroup.enter()
                var objImageVideo : ImageModel = ImageModel()
                objImageVideo = objPost.arrImageVideo.object(at: i) as! ImageModel
                
                let isImageVideo = objImageVideo.IsImageVideo as Int
                if(isImageVideo == 1){
                    if(i == 0){
                        items.add(cell.imgPost1.image as Any)
                    }
                    else if(i == 1){
                        items.add(cell.imgPost2.image as Any)
                    }
                    else if(i == 2){
                        items.add(cell.imgPost3.image as Any)
                    }
                    myGroup.leave()
                }
                else{
                    self.ShowActivityIndicator()
                    let videoLink = objImageVideo.PostContent as NSString
                    // use guard to make sure you have a valid url
                    guard let videoURL = URL(string: videoLink as String) else { return }
                    
                    let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                    
                    // check if the file already exist at the destination folder if you don't want to download it twice
                    if !FileManager.default.fileExists(atPath: documentsDirectoryURL.appendingPathComponent(videoURL.lastPathComponent).path) {
                        
                        // set up your download task
                        URLSession.shared.downloadTask(with: videoURL) { (location, response, error) -> Void in
                            
                            print(response as Any)
                            
                            // use guard to unwrap your optional url
                            guard let location = location else { return }
                            print(location)
                            // create a deatination url with the server response suggested file name
                            let destinationURL = documentsDirectoryURL.appendingPathComponent(response?.suggestedFilename ?? videoURL.lastPathComponent)
                            print("destinationURL\(destinationURL)")
                            
                            do {
                                
                                try FileManager.default.moveItem(at: location, to: destinationURL)
                                
                                PHPhotoLibrary.requestAuthorization({ (authorizationStatus: PHAuthorizationStatus) -> Void in
                                    
                                    // check if user authorized access photos for your app
                                    if authorizationStatus == .authorized {
                                        PHPhotoLibrary.shared().performChanges({
                                            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: destinationURL)}) { completed, error in
                                                if completed {
                                                    print("Video asset created")
                                                    items.add(destinationURL)
                                                    self.RemoveActivityIndicator()
                                                } else {
                                                    print(error as Any)
                                                    self.RemoveActivityIndicator()
                                                }
                                                myGroup.leave()
                                        }
                                    }
                                })
                                
                            } catch let error as NSError { print(error.localizedDescription)}
                            
                            }.resume()
                        
                    } else {
                        print("File already exists at destination url")
                        print(documentsDirectoryURL.appendingPathComponent(videoURL.lastPathComponent))
                        let destinationURL = documentsDirectoryURL.appendingPathComponent(videoURL.lastPathComponent)
                        items.add(destinationURL)
                        myGroup.leave()
                        self.RemoveActivityIndicator()
                    }
                }

            }
            
            myGroup.notify(queue: .main) {
                print("Finished all requests.")
                let activityVC = UIActivityViewController(activityItems: items as! [Any], applicationActivities: nil)
                activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList, UIActivityType.assignToContact, UIActivityType.copyToPasteboard]
                self.present(activityVC, animated: true, completion: nil)
            }
            
        }
        else if(btn.tag == 4){
            let cell: PostCellFourImages! = self.tblPost.cellForRow(at: indexPath! as IndexPath) as! PostCellFourImages!
            
            items.add(shareText)
            let myGroup = DispatchGroup()
            
            for i in 0 ..< objPost.arrImageVideo.count
            {
                myGroup.enter()
                var objImageVideo : ImageModel = ImageModel()
                objImageVideo = objPost.arrImageVideo.object(at: i) as! ImageModel
                
                let isImageVideo = objImageVideo.IsImageVideo as Int
                if(isImageVideo == 1){
                    if(i == 0){
                        items.add(cell.imgPost1.image as Any)
                    }
                    else if(i == 1){
                        items.add(cell.imgPost2.image as Any)
                    }
                    else if(i == 2){
                        items.add(cell.imgPost3.image as Any)
                    }
                    else if(i == 3){
                        items.add(cell.imgPost4.image as Any)
                    }
                    myGroup.leave()
                }
                else{
                    self.ShowActivityIndicator()
                    let videoLink = objImageVideo.PostContent as NSString
                    // use guard to make sure you have a valid url
                    guard let videoURL = URL(string: videoLink as String) else { return }
                    
                    let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                    
                    // check if the file already exist at the destination folder if you don't want to download it twice
                    if !FileManager.default.fileExists(atPath: documentsDirectoryURL.appendingPathComponent(videoURL.lastPathComponent).path) {
                        
                        // set up your download task
                        URLSession.shared.downloadTask(with: videoURL) { (location, response, error) -> Void in
                            
                            print(response as Any)
                            
                            // use guard to unwrap your optional url
                            guard let location = location else { return }
                            print(location)
                            // create a deatination url with the server response suggested file name
                            let destinationURL = documentsDirectoryURL.appendingPathComponent(response?.suggestedFilename ?? videoURL.lastPathComponent)
                            print("destinationURL\(destinationURL)")
                            
                            do {
                                
                                try FileManager.default.moveItem(at: location, to: destinationURL)
                                
                                PHPhotoLibrary.requestAuthorization({ (authorizationStatus: PHAuthorizationStatus) -> Void in
                                    
                                    // check if user authorized access photos for your app
                                    if authorizationStatus == .authorized {
                                        PHPhotoLibrary.shared().performChanges({
                                            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: destinationURL)}) { completed, error in
                                                if completed {
                                                    print("Video asset created")
                                                    items.add(destinationURL)
                                                    self.RemoveActivityIndicator()
                                                } else {
                                                    print(error as Any)
                                                    self.RemoveActivityIndicator()
                                                }
                                                myGroup.leave()
                                        }
                                    }
                                })
                                
                            } catch let error as NSError { print(error.localizedDescription)}
                            
                            }.resume()
                        
                    } else {
                        print("File already exists at destination url")
                        print(documentsDirectoryURL.appendingPathComponent(videoURL.lastPathComponent))
                        let destinationURL = documentsDirectoryURL.appendingPathComponent(videoURL.lastPathComponent)
                        items.add(destinationURL)
                        myGroup.leave()
                        self.RemoveActivityIndicator()
                    }
                }

            }
            
            myGroup.notify(queue: .main) {
                print("Finished all requests.")
                let activityVC = UIActivityViewController(activityItems: items as! [Any], applicationActivities: nil)
                activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList, UIActivityType.assignToContact, UIActivityType.copyToPasteboard]
                self.present(activityVC, animated: true, completion: nil)
            }
 
        }
        
        
    }
    
    func BackgroundRequestForGiveLike(PostId : Int, index: NSIndexPath, likeCount : Int, sender : UIButton, from : Int, objPost : PostModel){
        
        if(from == 0){
            let cell: PostCellText! = self.tblPost.cellForRow(at: index as IndexPath) as! PostCellText!
            cell.activityIndi.startAnimating()
        }
        else if(from == 1){
            let cell: PostCellOneImage! = self.tblPost.cellForRow(at: index as IndexPath) as! PostCellOneImage!
            cell.activityIndi.startAnimating()
        }
        else if(from == 2){
            let cell: PostCellTwoImages! = self.tblPost.cellForRow(at: index as IndexPath) as! PostCellTwoImages!
            cell.activityIndi.startAnimating()
        }
        else if(from == 3){
            let cell: PostCellThreeImages! = self.tblPost.cellForRow(at: index as IndexPath) as! PostCellThreeImages!
            cell.activityIndi.startAnimating()
        }
        else if(from == 4){
            let cell: PostCellFourImages! = self.tblPost.cellForRow(at: index as IndexPath) as! PostCellFourImages!
            cell.activityIndi.startAnimating()
        }
        
        let struserID = UserDefaults.standard.value(forKey: keyUserId) as! Int
        let url = NSString(format : "%@%@", BASE_URL, LIKE_UNLIKE_URL)
        print("url\(url)");
        
        let manager = AFHTTPRequestOperationManager()
        manager.requestSerializer.timeoutInterval = 120
        manager.requestSerializer.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
        
        let parameters = NSMutableDictionary()
        parameters.setObject(struserID, forKey: "LikeUserId" as NSCopying)
        parameters.setObject(PostId, forKey: "PostId" as NSCopying)
        
        print(parameters)
        
        manager.post(url as String!, parameters: parameters, success: { (operation, responseObject) in
            
            print("Response Object :\(responseObject)")
            let element : NSDictionary = responseObject as! NSDictionary
            let error_code = element.value(forKey: "error_code") as! NSNumber
            let message : String = element.value(forKey: "msg") as! String
            
            if(error_code == 0)
            {
                print(likeCount)
                self.dictIndicatorData.removeObject(forKey: NSString(format: "%d%d", index.section, index.row))
                
                if(from == 0){
                    let cell: PostCellText! = self.tblPost.cellForRow(at: index as IndexPath) as! PostCellText!
                 
                        cell.btnLike.setImage(UIImage(named: "like.png"), for: UIControlState.normal)
                        
                        let likeNumber = likeCount as Int!
                        cell.btnLikeCount.setTitle(String(format: "%d", likeNumber!+1), for: UIControlState.normal)
                    
                        objPost.LikeCount = likeNumber!+1
                        self.dictLikeData.setObject(String(likeNumber!+1), forKey: NSString(format: "%d%d", index.section, index.row))
                        cell.activityIndi.stopAnimating()
                    
                    
                }
                else if(from == 1){
                    let cell: PostCellOneImage! = self.tblPost.cellForRow(at: index as IndexPath) as! PostCellOneImage!
                  
                    
                        cell.btnLike.setImage(UIImage(named: "like.png"), for: UIControlState.normal)
                        
                        let likeNumber = likeCount as Int!
                        cell.btnLikeCount.setTitle(String(format: "%d", likeNumber!+1), for: UIControlState.normal)
                        objPost.LikeCount = likeNumber!+1
                        self.dictLikeData.setObject(String(likeNumber!+1), forKey: NSString(format: "%d%d", index.section, index.row))
                        cell.activityIndi.stopAnimating()
                }
                else if(from == 2){
                    let cell: PostCellTwoImages! = self.tblPost.cellForRow(at: index as IndexPath) as! PostCellTwoImages!
                        //cell.btnLike.isSelected = true
                        cell.btnLike.setImage(UIImage(named: "like.png"), for: UIControlState.normal)
                        
                        let likeNumber = likeCount as Int!
                        cell.btnLikeCount.setTitle(String(format: "%d", likeNumber!+1), for: UIControlState.normal)
                        objPost.LikeCount = likeNumber!+1
                        self.dictLikeData.setObject(String(likeNumber!+1), forKey: NSString(format: "%d%d", index.section, index.row))
                        cell.activityIndi.stopAnimating()
                }
                else if(from == 3){
                    let cell: PostCellThreeImages! = self.tblPost.cellForRow(at: index as IndexPath) as! PostCellThreeImages!
                  
                        //cell.btnLike.isSelected = true
                        cell.btnLike.setImage(UIImage(named: "like.png"), for: UIControlState.normal)
                        
                        let likeNumber = likeCount as Int!
                        cell.btnLikeCount.setTitle(String(format: "%d", likeNumber!+1), for: UIControlState.normal)
                        objPost.LikeCount = likeNumber!+1
                        self.dictLikeData.setObject(String(likeNumber!+1), forKey: NSString(format: "%d%d", index.section, index.row))
                        cell.activityIndi.stopAnimating()
                }
                else if(from == 4){
                    let cell: PostCellFourImages! = self.tblPost.cellForRow(at: index as IndexPath) as! PostCellFourImages!
                   
                        //cell.btnLike.isSelected = true
                        cell.btnLike.setImage(UIImage(named: "like.png"), for: UIControlState.normal)
                        
                        let likeNumber = likeCount as Int!
                        cell.btnLikeCount.setTitle(String(format: "%d", likeNumber!+1), for: UIControlState.normal)
                        objPost.LikeCount = likeNumber!+1
                        self.dictLikeData.setObject(String(likeNumber!+1), forKey: NSString(format: "%d%d", index.section, index.row))
                        cell.activityIndi.stopAnimating()
                   }
            }
            else if(error_code == 1){
                
                if(from == 0){
                    let cell: PostCellText! = self.tblPost.cellForRow(at: index as IndexPath) as! PostCellText!
                  
                       // cell.btnLike.isSelected = false
                        cell.btnLike.setImage(UIImage(named: "unlike.png"), for: UIControlState.normal)
                        
                        let likeNumber = likeCount as Int!
                        
                        if(likeNumber! > 0){
                            cell.btnLikeCount.setTitle(String(format: "%d", likeNumber!-1), for: UIControlState.normal)
                            objPost.LikeCount = likeNumber!-1
                        }
                        else{
                            cell.btnLikeCount.setTitle(String(format: "0"), for: UIControlState.normal)
                            objPost.LikeCount = 0
                        }
                    
                    self.dictLikeData.removeObject(forKey: NSString(format: "%d%d", index.section, index.row))
                    cell.activityIndi.stopAnimating()
                   
                }
                else if(from == 1){
                    let cell: PostCellOneImage! = self.tblPost.cellForRow(at: index as IndexPath) as! PostCellOneImage!
                  
                        //cell.btnLike.isSelected = false
                        cell.btnLike.setImage(UIImage(named: "unlike.png"), for: UIControlState.normal)
                        
                        let likeNumber = likeCount as Int!
                        
                        if(likeNumber! > 0){
                            cell.btnLikeCount.setTitle(String(format: "%d", likeNumber!-1), for: UIControlState.normal)
                            objPost.LikeCount = likeNumber!-1
                        }
                        else{
                            cell.btnLikeCount.setTitle(String(format: "0"), for: UIControlState.normal)
                            objPost.LikeCount = 0
                        }
                  self.dictLikeData.removeObject(forKey: NSString(format: "%d%d", index.section, index.row))
                    cell.activityIndi.stopAnimating()
                }
                else if(from == 2){
                    let cell: PostCellTwoImages! = self.tblPost.cellForRow(at: index as IndexPath) as! PostCellTwoImages!
                   
                      //  cell.btnLike.isSelected = false
                        cell.btnLike.setImage(UIImage(named: "unlike.png"), for: UIControlState.normal)
                        
                        let likeNumber = likeCount as Int!
                        
                        if(likeNumber! > 0){
                            cell.btnLikeCount.setTitle(String(format: "%d", likeNumber!-1), for: UIControlState.normal)
                            objPost.LikeCount = likeNumber!-1
                        }
                        else{
                            cell.btnLikeCount.setTitle(String(format: "0"), for: UIControlState.normal)
                            objPost.LikeCount = 0
                        }
                   self.dictLikeData.removeObject(forKey: NSString(format: "%d%d", index.section, index.row))
                    cell.activityIndi.stopAnimating()
                }
                else if(from == 3){
                    let cell: PostCellThreeImages! = self.tblPost.cellForRow(at: index as IndexPath) as! PostCellThreeImages!
                  
                       // cell.btnLike.isSelected = false
                        cell.btnLike.setImage(UIImage(named: "unlike.png"), for: UIControlState.normal)
                        
                        let likeNumber = likeCount as Int!
                        
                        if(likeNumber! > 0){
                            cell.btnLikeCount.setTitle(String(format: "%d", likeNumber!-1), for: UIControlState.normal)
                            objPost.LikeCount = likeNumber!-1
                        }
                        else{
                            cell.btnLikeCount.setTitle(String(format: "0"), for: UIControlState.normal)
                            objPost.LikeCount = 0
                        }
                    self.dictLikeData.removeObject(forKey: NSString(format: "%d%d", index.section, index.row))
                    cell.activityIndi.stopAnimating()
                }
                else if(from == 4){
                    let cell: PostCellFourImages! = self.tblPost.cellForRow(at: index as IndexPath) as! PostCellFourImages!
                   
                        //cell.btnLike.isSelected = false
                        cell.btnLike.setImage(UIImage(named: "unlike.png"), for: UIControlState.normal)
                        
                        let likeNumber = likeCount as Int!
                        
                        if(likeNumber! > 0){
                            cell.btnLikeCount.setTitle(String(format: "%d", likeNumber!-1), for: UIControlState.normal)
                            objPost.LikeCount = likeNumber!-1
                        }
                        else{
                            cell.btnLikeCount.setTitle(String(format: "0"), for: UIControlState.normal)
                            objPost.LikeCount = 0
                        }
                    self.dictLikeData.removeObject(forKey: NSString(format: "%d%d", index.section, index.row))
                    cell.activityIndi.stopAnimating()
                }
            }
            else{
               
                if(from == 0){
                    let cell: PostCellText! = self.tblPost.cellForRow(at: index as IndexPath) as! PostCellText!
                    cell.activityIndi.stopAnimating()
                }
                else if(from == 1){
                    let cell: PostCellOneImage! = self.tblPost.cellForRow(at: index as IndexPath) as! PostCellOneImage!
                    cell.activityIndi.stopAnimating()
                }
                else if(from == 2){
                    let cell: PostCellTwoImages! = self.tblPost.cellForRow(at: index as IndexPath) as! PostCellTwoImages!
                    cell.activityIndi.stopAnimating()
                }
                else if(from == 3){
                    let cell: PostCellThreeImages! = self.tblPost.cellForRow(at: index as IndexPath) as! PostCellThreeImages!
                    cell.activityIndi.stopAnimating()
                }
                else if(from == 4){
                    let cell: PostCellFourImages! = self.tblPost.cellForRow(at: index as IndexPath) as! PostCellFourImages!
                    cell.activityIndi.stopAnimating()
                }
                self.appDelegate.ShowAlert(AlertTitle as NSString, alertMessage: message as NSString)
            }
            
        },
        failure: { (operation, error) in
                        let err = error as! NSError
                        print("We got an error here.. \(err.localizedDescription)")
                       // self.RemoveActivityIndicator()
                        self.appDelegate.ShowAlert(AlertTitle as NSString, alertMessage: INTERNET_CONNECTION as NSString)
            
            if(from == 0){
                let cell: PostCellText! = self.tblPost.cellForRow(at: index as IndexPath) as! PostCellText!
                cell.activityIndi.stopAnimating()
            }
            else if(from == 1){
                let cell: PostCellOneImage! = self.tblPost.cellForRow(at: index as IndexPath) as! PostCellOneImage!
                cell.activityIndi.stopAnimating()
            }
            else if(from == 2){
                let cell: PostCellTwoImages! = self.tblPost.cellForRow(at: index as IndexPath) as! PostCellTwoImages!
                cell.activityIndi.stopAnimating()
            }
            else if(from == 3){
                let cell: PostCellThreeImages! = self.tblPost.cellForRow(at: index as IndexPath) as! PostCellThreeImages!
                cell.activityIndi.stopAnimating()
            }
            else if(from == 4){
                let cell: PostCellFourImages! = self.tblPost.cellForRow(at: index as IndexPath) as! PostCellFourImages!
                cell.activityIndi.stopAnimating()
            }
                        
        })

    }
    
    @IBAction func btnLikeCountClick(sender: UIButton)
    {
        let buttonPosition :CGPoint = sender.convert(CGPoint.zero, to: self.tblPost)
        let indexPath : NSIndexPath = self.tblPost.indexPathForRow(at: buttonPosition)! as NSIndexPath
        let objPost = self.arrAllPost.object(at: (indexPath.row)) as! PostModel
      
        let likeVC = self.storyboard?.instantiateViewController(withIdentifier: IdentifireLikePeopleView) as! LikePeopleListViewController
        likeVC.postID = objPost.PostId
        likeVC.likeCount = objPost.LikeCount
        if(objPost.LikeCount > 0){
            self.navigationController?.pushViewController(likeVC, animated: true)
        }
       
    }
    
    @IBAction func btnLikeForTextClick(sender: UIButton)
    {
        
        let buttonPosition :CGPoint = sender.convert(CGPoint.zero, to: self.tblPost)
        let indexPath : NSIndexPath = self.tblPost.indexPathForRow(at: buttonPosition)! as NSIndexPath
        
        let objPost = self.arrAllPost.object(at: (indexPath.row)) as! PostModel
        self.dictIndicatorData.setObject("", forKey: NSString(format: "%d%d", indexPath.section, indexPath.row))
        self.BackgroundRequestForGiveLike(PostId: objPost.PostId, index: indexPath, likeCount: objPost.LikeCount, sender: sender,from: 0,objPost:objPost)
    }
    
    @IBAction func btnLikeForOneImage(sender: UIButton)
    {
        let buttonPosition :CGPoint = sender.convert(CGPoint.zero, to: self.tblPost)
        let indexPath : NSIndexPath = self.tblPost.indexPathForRow(at: buttonPosition)! as NSIndexPath
        let objPost = self.arrAllPost.object(at: (indexPath.row)) as! PostModel
        self.dictIndicatorData.setObject("", forKey: NSString(format: "%d%d", indexPath.section, indexPath.row))
        self.BackgroundRequestForGiveLike(PostId: objPost.PostId, index: indexPath, likeCount: objPost.LikeCount, sender: sender,from: 1,objPost:objPost)
    }
    
    @IBAction func btnLikeForTwoImage(sender: UIButton)
    {
        let buttonPosition :CGPoint = sender.convert(CGPoint.zero, to: self.tblPost)
        let indexPath : NSIndexPath = self.tblPost.indexPathForRow(at: buttonPosition)! as NSIndexPath
        let objPost = self.arrAllPost.object(at: (indexPath.row)) as! PostModel
        self.dictIndicatorData.setObject("", forKey: NSString(format: "%d%d", indexPath.section, indexPath.row))
        self.BackgroundRequestForGiveLike(PostId: objPost.PostId, index: indexPath, likeCount: objPost.LikeCount, sender: sender,from: 2,objPost:objPost)
    }
    
    @IBAction func btnLikeForThreeImage(sender: UIButton)
    {
        let buttonPosition :CGPoint = sender.convert(CGPoint.zero, to: self.tblPost)
        let indexPath : NSIndexPath = self.tblPost.indexPathForRow(at: buttonPosition)! as NSIndexPath
        let objPost = self.arrAllPost.object(at: (indexPath.row)) as! PostModel
        self.dictIndicatorData.setObject("", forKey: NSString(format: "%d%d", indexPath.section, indexPath.row))
        self.BackgroundRequestForGiveLike(PostId: objPost.PostId, index: indexPath, likeCount: objPost.LikeCount, sender: sender,from: 3,objPost:objPost)
    }
    
    @IBAction func btnLikeForFourImage(sender: UIButton)
    {
        let buttonPosition :CGPoint = sender.convert(CGPoint.zero, to: self.tblPost)
        let indexPath : NSIndexPath = self.tblPost.indexPathForRow(at: buttonPosition)! as NSIndexPath
        let objPost = self.arrAllPost.object(at: (indexPath.row)) as! PostModel
        self.dictIndicatorData.setObject("", forKey: NSString(format: "%d%d", indexPath.section, indexPath.row))
        self.BackgroundRequestForGiveLike(PostId: objPost.PostId, index: indexPath, likeCount: objPost.LikeCount, sender: sender,from: 4,objPost:objPost)
    }
    
    func setCommonValueForCellText(cell : PostCellText, objPost : PostModel){
        
        let isLike : Bool = objPost.IsLike
        if(isLike == true){
            cell.btnLike.setImage(UIImage(named: "like.png"), for: UIControlState.normal)
        }
        else{
            cell.btnLike.setImage(UIImage(named: "unlike.png"), for: UIControlState.normal)
        }
        
        var strComment : NSString!
        
        if(objPost.CommentCount > 0){
            strComment = NSString(format:"%d comments",objPost.CommentCount)
        }else{
            strComment = NSString(format:"%d comment",objPost.CommentCount)
        }
        
        cell.lblComment.setTitle(String(strComment), for: UIControlState.normal)
        cell.btnLikeCount.setTitle(String(objPost.LikeCount), for: UIControlState.normal)
        cell.lblTime.text = self.strLeftTime as String!
        cell.lblUserName.text = NSString(format : "%@ %@", objPost.FirstName, objPost.LastName) as String
        cell.lblPostContent?.attributedText = makeAttributedStringForText(title: (objPost.PostText as String?)!)
        
        if(objPost.isPublic == true){
            cell.btnUser.isHidden = false
        }
        else{
            cell.btnUser.isHidden = true
        }
        
        cell.imgUserProfile.layer.cornerRadius = cell.imgUserProfile.frame.size.height/2
        cell.imgUserProfile.layer.masksToBounds =  true
        
        let strImageURL = objPost.ProfilePic as NSString
        let imgURL = NSURL(string: strImageURL as String)

        let imageRequest = NSURLRequest(url: imgURL as! URL, cachePolicy: NSURLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 600)
        cell.imgUserProfile.setImageWith(imageRequest as URLRequest!, placeholderImage: UIImage(named: "unknown_user.png"), withGradient: true, success: nil, failure: nil)
        
    }
    
    func setCommonValueForCellOneImage(cell : PostCellOneImage, objPost : PostModel){
        
        let isLike : Bool = objPost.IsLike
        if(isLike == true){
            cell.btnLike.setImage(UIImage(named: "like.png"), for: UIControlState.normal)
        }
        else{
            cell.btnLike.setImage(UIImage(named: "unlike.png"), for: UIControlState.normal)
        }
        
        var strComment : NSString!
        
        if(objPost.CommentCount > 0){
            strComment = NSString(format:"%d comments",objPost.CommentCount)
        }else{
            strComment = NSString(format:"%d comment",objPost.CommentCount)
        }
        
        cell.lblComment.setTitle(String(strComment), for: UIControlState.normal)
        cell.btnLikeCount.setTitle(String(objPost.LikeCount), for: UIControlState.normal)
        cell.lblTime.text = self.strLeftTime as String!
        cell.lblUserName.text = NSString(format : "%@ %@", objPost.FirstName, objPost.LastName) as String
        cell.lblPostContent?.attributedText = makeAttributedString(title: (objPost.PostText as String?)!)
        
        cell.imgUserProfile.layer.cornerRadius = cell.imgUserProfile.frame.size.height/2
        cell.imgUserProfile.layer.masksToBounds =  true
        
        let strImageURL = objPost.ProfilePic as NSString
        let imgURL = NSURL(string: strImageURL as String)
        
        let imageRequest = NSURLRequest(url: imgURL as! URL, cachePolicy: NSURLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 600)
        cell.imgUserProfile.setImageWith(imageRequest as URLRequest!, placeholderImage: UIImage(named: "unknown_user.png"), withGradient: true, success: nil, failure: nil)
        
        if(objPost.isPublic == true){
            cell.btnUser.isHidden = false
        }
        else{
            cell.btnUser.isHidden = true
        }
        
        cell.imgPost.layer.cornerRadius = 3
        cell.imgPost.layer.masksToBounds = true
        
        for i in 0 ..< objPost.arrImageVideo.count
        {
            var objImageVideo : ImageModel = ImageModel()
            objImageVideo = objPost.arrImageVideo.object(at: i) as! ImageModel
            
            let strImageURL : NSString
            
            let isImageVideo = objImageVideo.IsImageVideo as Int
            if(isImageVideo == 2){
                strImageURL = objImageVideo.VideoThumbnail as NSString
                cell.btnPost.setImage(UIImage(named: "play.png"), for: UIControlState.normal)
            }
            else{
                strImageURL = objImageVideo.PostContent as NSString
                cell.btnPost.setImage(UIImage(named: ""), for: UIControlState.normal)
            }
            
            let imgURL = NSURL(string: strImageURL as String)
          
            let imageRequest = NSURLRequest(url: imgURL as! URL, cachePolicy: NSURLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 600)
           
            if(isImageVideo == 2){
                cell.imgPost.setImageWith(imageRequest as URLRequest!, placeholderImage: UIImage(named: "video_off_land.png"), withGradient: true, success: nil, failure: nil)
            }
            else{
                cell.imgPost.setImageWith(imageRequest as URLRequest!, placeholderImage: UIImage(named: "noAlbumLand.png"), withGradient: true, success: nil, failure: nil)
            }
         
        }
    }
    
    
    func setCommonValueForCellTwoImage(cell : PostCellTwoImages, objPost : PostModel){
        
        let isLike : Bool = objPost.IsLike
        if(isLike == true){
            cell.btnLike.setImage(UIImage(named: "like.png"), for: UIControlState.normal)
        }
        else{
            cell.btnLike.setImage(UIImage(named: "unlike.png"), for: UIControlState.normal)
        }
        
        var strComment : NSString!
        
        if(objPost.CommentCount > 0){
            strComment = NSString(format:"%d comments",objPost.CommentCount)
        }else{
            strComment = NSString(format:"%d comment",objPost.CommentCount)
        }
        
        cell.lblComment.setTitle(String(strComment), for: UIControlState.normal)
        cell.btnLikeCount.setTitle(String(objPost.LikeCount), for: UIControlState.normal)
        cell.lblTime.text = self.strLeftTime as String!
        cell.lblUserName.text = NSString(format : "%@ %@", objPost.FirstName, objPost.LastName) as String
        cell.lblPostContent?.attributedText = makeAttributedString(title: (objPost.PostText as String?)!)
        
        cell.imgUserProfile.layer.cornerRadius = cell.imgUserProfile.frame.size.height/2
        cell.imgUserProfile.layer.masksToBounds =  true
        
        cell.imgPost1.layer.cornerRadius = 3
        cell.imgPost1.layer.masksToBounds = true
        
        cell.imgPost2.layer.cornerRadius = 3
        cell.imgPost2.layer.masksToBounds = true

        let strImageURL = objPost.ProfilePic as NSString
        let imgURL = NSURL(string: strImageURL as String)
        
        let imageRequest = NSURLRequest(url: imgURL as! URL, cachePolicy: NSURLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 600)
        cell.imgUserProfile.setImageWith(imageRequest as URLRequest!, placeholderImage: UIImage(named: "unknown_user.png"), withGradient: true, success: nil, failure: nil)

        if(objPost.isPublic == true){
            cell.btnUser.isHidden = false
        }
        else{
            cell.btnUser.isHidden = true
        }
        
        for i in 0 ..< objPost.arrImageVideo.count
        {
            var objImageVideo : ImageModel = ImageModel()
            objImageVideo = objPost.arrImageVideo.object(at: i) as! ImageModel
            
            let isImageVideo = objImageVideo.IsImageVideo as Int
            
            print("IsImageVideo-\(isImageVideo)")
            
            let strImageURL : NSString
            if(isImageVideo == 2){
                strImageURL = objImageVideo.VideoThumbnail as NSString
            }
            else{
                strImageURL = objImageVideo.PostContent as NSString
            }
            
            let imgURL = NSURL(string: strImageURL as String)
           
            let imageRequest = NSURLRequest(url: imgURL as! URL, cachePolicy: NSURLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 600)
            
            if(i == 0){
                
                if(isImageVideo == 2){
                    cell.btnPost1.setImage(UIImage(named: "play.png"), for: UIControlState.normal)
                    cell.imgPost1.setImageWith(imageRequest as URLRequest!, placeholderImage: UIImage(named: "video_off.png"), withGradient: true, success: nil, failure: nil)
                }
                else{
                    cell.btnPost1.setImage(UIImage(named: ""), for: UIControlState.normal)
                    cell.imgPost1.setImageWith(imageRequest as URLRequest!, placeholderImage: UIImage(named: "noAlbum.png"), withGradient: true, success: nil, failure: nil)
                }
            }
            else if(i == 1){
                
                if(isImageVideo == 2){
                    cell.btnPost2.setImage(UIImage(named: "play.png"), for: UIControlState.normal)
                    cell.imgPost2.setImageWith(imageRequest as URLRequest!, placeholderImage: UIImage(named: "video_off.png"), withGradient: true, success: nil, failure: nil)
                }
                else{
                    cell.btnPost2.setImage(UIImage(named: ""), for: UIControlState.normal)
                     cell.imgPost2.setImageWith(imageRequest as URLRequest!, placeholderImage: UIImage(named: "noAlbum.png"), withGradient: true, success: nil, failure: nil)
                }
            }
           
        }
        
    }
    
    func setCommonValueForCellThreeImage(cell : PostCellThreeImages, objPost : PostModel){
        
        let isLike : Bool = objPost.IsLike
        if(isLike == true){
            cell.btnLike.setImage(UIImage(named: "like.png"), for: UIControlState.normal)
        }
        else{
            cell.btnLike.setImage(UIImage(named: "unlike.png"), for: UIControlState.normal)
        }
        
        var strComment : NSString!
        
        if(objPost.CommentCount > 0){
            strComment = NSString(format:"%d comments",objPost.CommentCount)
        }else{
            strComment = NSString(format:"%d comment",objPost.CommentCount)
        }
        
        cell.lblComment.setTitle(String(strComment), for: UIControlState.normal)
        cell.btnLikeCount.setTitle(String(objPost.LikeCount), for: UIControlState.normal)
        cell.lblTime.text = self.strLeftTime as String!
        cell.lblUserName.text = NSString(format : "%@ %@", objPost.FirstName, objPost.LastName) as String
        cell.lblPostContent?.attributedText = makeAttributedString(title: (objPost.PostText as String?)!)
        
        cell.imgUserProfile.layer.cornerRadius = cell.imgUserProfile.frame.size.height/2
        cell.imgUserProfile.layer.masksToBounds =  true
        
        let strImageURL = objPost.ProfilePic as NSString
        let imgURL = NSURL(string: strImageURL as String)
        
        if(objPost.isPublic == true){
            cell.btnUser.isHidden = false
        }
        else{
            cell.btnUser.isHidden = true
        }
        
        let imageRequest = NSURLRequest(url: imgURL as! URL, cachePolicy: NSURLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 600)
        cell.imgUserProfile.setImageWith(imageRequest as URLRequest!, placeholderImage: UIImage(named: "unknown_user.png"), withGradient: true, success: nil, failure: nil)
 
        
        for i in 0 ..< objPost.arrImageVideo.count
        {
            var objImageVideo : ImageModel = ImageModel()
            objImageVideo = objPost.arrImageVideo.object(at: i) as! ImageModel
            
            
            let strImageURL : NSString
            
            let isImageVideo = objImageVideo.IsImageVideo as Int
            if(isImageVideo == 2){
                strImageURL = objImageVideo.VideoThumbnail as NSString
            }
            else{
                strImageURL = objImageVideo.PostContent as NSString
            }
            
            let imgURL = NSURL(string: strImageURL as String)
            
            let imageRequest = NSURLRequest(url: imgURL as! URL, cachePolicy: NSURLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 600)
            
            
            if(i == 0){
               
                if(isImageVideo == 2){
                    cell.btnPost1.setImage(UIImage(named: "play.png"), for: UIControlState.normal)
                    cell.imgPost1.setImageWith(imageRequest as URLRequest!, placeholderImage: UIImage(named: "video_off_up.png"), withGradient: true, success: nil, failure: nil)
                }
                else{
                    cell.btnPost1.setImage(UIImage(named: ""), for: UIControlState.normal)
                    cell.imgPost1.setImageWith(imageRequest as URLRequest!, placeholderImage: UIImage(named: "noAlbum.png"), withGradient: true, success: nil, failure: nil)
                }
            }
            else if(i == 1){
                
                if(isImageVideo == 2){
                    cell.btnPost2.setImage(UIImage(named: "play.png"), for: UIControlState.normal)
                    cell.imgPost2.setImageWith(imageRequest as URLRequest!, placeholderImage: UIImage(named: "video_off.png"), withGradient: true, success: nil, failure: nil)
                }
                else{
                    cell.btnPost2.setImage(UIImage(named: ""), for: UIControlState.normal)
                    cell.imgPost2.setImageWith(imageRequest as URLRequest!, placeholderImage: UIImage(named: "noAlbum.png"), withGradient: true, success: nil, failure: nil)
                }
            }
            else if(i == 2){
               
                if(isImageVideo == 2){
                    cell.btnPost3.setImage(UIImage(named: "play.png"), for: UIControlState.normal)
                    cell.imgPost3.setImageWith(imageRequest as URLRequest!, placeholderImage: UIImage(named: "video_off.png"), withGradient: true, success: nil, failure: nil)
                }
                else{
                    cell.btnPost3.setImage(UIImage(named: ""), for: UIControlState.normal)
                    cell.imgPost3.setImageWith(imageRequest as URLRequest!, placeholderImage: UIImage(named: "noAlbum.png"), withGradient: true, success: nil, failure: nil)
                }
            }
        }
    }
    
    func setCommonValueForCellFourImage(cell : PostCellFourImages, objPost : PostModel){
        
        let isLike : Bool = objPost.IsLike
        if(isLike == true){
            cell.btnLike.setImage(UIImage(named: "like.png"), for: UIControlState.normal)
        }
        else{
            cell.btnLike.setImage(UIImage(named: "unlike.png"), for: UIControlState.normal)
        }
        
        var strComment : NSString!
        
        if(objPost.CommentCount > 0){
            strComment = NSString(format:"%d comments",objPost.CommentCount)
        }else{
            strComment = NSString(format:"%d comment",objPost.CommentCount)
        }
        
        cell.lblComment.setTitle(String(strComment), for: UIControlState.normal)
        cell.btnLikeCount.setTitle(String(objPost.LikeCount), for: UIControlState.normal)
        cell.lblTime.text = self.strLeftTime as String!
        cell.lblUserName.text = NSString(format : "%@ %@", objPost.FirstName, objPost.LastName) as String
        cell.lblPostContent?.attributedText = makeAttributedString(title: (objPost.PostText as String?)!)
        
        cell.imgUserProfile.layer.cornerRadius = cell.imgUserProfile.frame.size.height/2
        cell.imgUserProfile.layer.masksToBounds =  true
        
        let strImageURL = objPost.ProfilePic as NSString
        let imgURL = NSURL(string: strImageURL as String)
        
        if(objPost.isPublic == true){
            cell.btnUser.isHidden = false
        }
        else{
            cell.btnUser.isHidden = true
        }
        
        let imageRequest = NSURLRequest(url: imgURL as! URL, cachePolicy: NSURLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 600)
        cell.imgUserProfile.setImageWith(imageRequest as URLRequest!, placeholderImage: UIImage(named: "unknown_user.png"), withGradient: true, success: nil, failure: nil)
        
        for i in 0 ..< objPost.arrImageVideo.count
        {
            var objImageVideo : ImageModel = ImageModel()
            objImageVideo = objPost.arrImageVideo.object(at: i) as! ImageModel
            
            let strImageURL : NSString
            
            let isImageVideo = objImageVideo.IsImageVideo as Int
            if(isImageVideo == 2){
                strImageURL = objImageVideo.VideoThumbnail as NSString
            }
            else{
                strImageURL = objImageVideo.PostContent as NSString
            }
            
            let imgURL = NSURL(string: strImageURL as String)
           
            let imageRequest = NSURLRequest(url: imgURL as! URL, cachePolicy: NSURLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 600)
            
            if(i == 0){
                
                if(isImageVideo == 2){
                    cell.btnPost1.setImage(UIImage(named: "play.png"), for: UIControlState.normal)
                    cell.imgPost1.setImageWith(imageRequest as URLRequest!, placeholderImage: UIImage(named: "video_off_land.png"), withGradient: true, success: nil, failure: nil)
                }
                else{
                    cell.btnPost1.setImage(UIImage(named: ""), for: UIControlState.normal)
                    cell.imgPost1.setImageWith(imageRequest as URLRequest!, placeholderImage: UIImage(named: "noAlbumLand.png"), withGradient: true, success: nil, failure: nil)
                }
            }
            else if(i == 1){
                
                if(isImageVideo == 2){
                    cell.btnPost2.setImage(UIImage(named: "play.png"), for: UIControlState.normal)
                    cell.imgPost2.setImageWith(imageRequest as URLRequest!, placeholderImage: UIImage(named: "video_off.png"), withGradient: true, success: nil, failure: nil)
                }
                else{
                    cell.btnPost2.setImage(UIImage(named: ""), for: UIControlState.normal)
                    cell.imgPost2.setImageWith(imageRequest as URLRequest!, placeholderImage: UIImage(named: "noAlbum.png"), withGradient: true, success: nil, failure: nil)
                }
            }
            else if(i == 2){
                
                if(isImageVideo == 2){
                    cell.btnPost3.setImage(UIImage(named: "play.png"), for: UIControlState.normal)
                    cell.imgPost3.setImageWith(imageRequest as URLRequest!, placeholderImage: UIImage(named: "video_off.png"), withGradient: true, success: nil, failure: nil)
                }
                else{
                    cell.btnPost3.setImage(UIImage(named: ""), for: UIControlState.normal)
                    cell.imgPost3.setImageWith(imageRequest as URLRequest!, placeholderImage: UIImage(named: "noAlbum.png"), withGradient: true, success: nil, failure: nil)
                }
            }
            else if(i == 3){
                
                cell.imgPost4.setImageWith(imageRequest as URLRequest!, placeholderImage: UIImage(named: "noAlbum.png"), withGradient: true, success: nil, failure: nil)
               
            }
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
   
    func makeAttributedStringForText(title: String) -> NSAttributedString {
        
        let titleAttributes = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: .headline), NSForegroundColorAttributeName: UIColor.black]
        
        let titleString = NSMutableAttributedString(string: "\(title)", attributes: titleAttributes)
        
        return titleString
    }
    
    func makeAttributedString(title: String) -> NSAttributedString {
       
        let titleAttributes = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: .subheadline), NSForegroundColorAttributeName: UIColor.black]
        
        let titleString = NSMutableAttributedString(string: "\(title)", attributes: titleAttributes)
        
        return titleString
    }

    func getLeftTime(_ strDate : NSString){
        
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        let fullDate = dateFormatter.date(from: strDate as String)
        
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let strCurrentDate = formatter.string(from: Foundation.Date())
        
        let fmt: DateFormatter = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
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

    
    //Show activity indicator while downloading data from API
    func ShowActivityIndicator(){
        
        let size = CGSize(width: 50, height:50)
        startAnimating(size, message: nil, type: NVActivityIndicatorType(rawValue: 6)!)
    }
    
    //Remove activity indicator after downloading data from API
    func RemoveActivityIndicator(){
        stopAnimating()
    }
    
    func handleTapForRemovePopMenu(){
        print("handle")
        viewTopMenu.removeFromSuperview()
    }
    
    @IBAction func btnLogoutClicked(sender: UIButton) {
        
        viewTopMenu =  Bundle.main.loadNibNamed("ViewLayout", owner: self, options: nil)?[0] as! ViewLayout
        viewTopMenu.frame = CGRect(x:viewTopMenu.frame.origin.x, y:viewTopMenu.frame.origin.y, width:self.view.frame.size.width, height:self.view.frame.size.height)
        viewTopMenu.viewMenu.layer.cornerRadius = 4.0
        viewTopMenu.viewMenu.layer.masksToBounds = true
        viewTopMenu.btnSettings.addTarget(self, action: #selector(HomeViewController.btnSettingsClicked), for: UIControlEvents.touchUpInside)
        viewTopMenu.btnRefresh.addTarget(self, action: #selector(HomeViewController.btnRefreshClicked), for: UIControlEvents.touchUpInside)
        viewTopMenu.btnExit.addTarget(self, action: #selector(HomeViewController.btnExitClicked), for: UIControlEvents.touchUpInside)
        
        let tap = UITapGestureRecognizer(target: self, action : #selector(HomeViewController.handleTapForRemovePopMenu))
        tap.numberOfTapsRequired = 1
        self.viewTopMenu.addGestureRecognizer(tap)
        
        self.navigationController!.view.superview?.addSubview(viewTopMenu)
    }
    
    func btnRefreshClicked(){
        viewTopMenu.removeFromSuperview()
        self.getAllPost(offset: 0)
    }
    
    func btnExitClicked(){
        viewTopMenu.removeFromSuperview()
        UserDefaults.standard.removeObject(forKey:keyUserId)
        UserDefaults.standard.removeObject(forKey:keyFirstName)
        UserDefaults.standard.removeObject(forKey:keyLastName)
        UserDefaults.standard.removeObject(forKey:keyEmail)
        UserDefaults.standard.removeObject(forKey:keyContact)
        UserDefaults.standard.removeObject(forKey:keyBirthDate)
        UserDefaults.standard.removeObject(forKey:keyProfilePic)
        self.navigationController?.popViewController(animated: true)
    }
    
    func btnSettingsClicked(){
        
        viewTopMenu.removeFromSuperview()
        let settingVC = self.storyboard!.instantiateViewController(withIdentifier: IdentifireSettingsView) as! SettingsViewController
        self.navigationController?.pushViewController(settingVC, animated: false)

    }
    
    //Report API calling
    func backgroundRequestForPostReport(postId : Int){
        
        self.ShowActivityIndicator()
        
        let url = NSString(format : "%@%@", BASE_URL, POST_REPORT)
        print("url\(url)");
        let manager = AFHTTPRequestOperationManager()
        
        let struserID = UserDefaults.standard.value(forKey: keyUserId) as! Int
        
        let parameters = NSMutableDictionary()
        parameters.setObject(struserID, forKey: "UserId" as NSCopying)
        parameters.setObject(postId, forKey: "PostId" as NSCopying)
        parameters.setObject(self.viewReport.txtReportDesc.text! as String, forKey: "Description" as NSCopying)
        
        print(parameters)
        
        manager.post(url as String!, parameters: parameters, success: { (operation, responseObject) in
            
            print("Response Object :\(responseObject)")
            let element : NSDictionary = responseObject as! NSDictionary
            let error_code = element.value(forKey: "error_code") as! NSNumber
            let message : String = element.value(forKey: "msg") as! String
            
            if(error_code == 0)
            {
                self.RemoveActivityIndicator()
                self.appDelegate.ShowAlert(AlertTitle as NSString, alertMessage: message as NSString)
            }
            else{
                self.RemoveActivityIndicator()
                self.appDelegate.ShowAlert(AlertTitle as NSString, alertMessage: message as NSString)
            }
            
        },
        failure: { (operation, error) in
            let err = error as! NSError
            print("We got an error here.. \(err.localizedDescription)")
                self.RemoveActivityIndicator()
                self.appDelegate.ShowAlert(AlertTitle as NSString, alertMessage: INTERNET_CONNECTION as NSString)
                        
        })
        
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        viewReport.txtReportDesc.resignFirstResponder()
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
