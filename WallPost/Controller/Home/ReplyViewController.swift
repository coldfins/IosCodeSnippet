//
//  ReplyViewController.swift
//  WallPost
//
//  Created by Ved on 09/03/17.
//  Copyright © 2017 Ved. All rights reserved.
//

import UIKit

@objc protocol sendReplyCommentProtocol
{
    func sendExistingCommentObjectToPreviousVC(objComment:CommentModel, index : Int)
}

class ReplyViewController: UIViewController, NVActivityIndicatorViewable,UITableViewDelegate, UITableViewDataSource,HPGrowingTextViewDelegate, UITextFieldDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet var viewTypeReply: UIView!
    @IBOutlet weak var tblReply: UITableView!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var btnPhoto: UIButton!
    
    var delegate:sendReplyCommentProtocol?
    
    var objComment : CommentModel!
    var appDelegate = AppDelegate()
    var offset : Int = 0
    var arrAllReply : NSMutableArray = NSMutableArray()
    var postID : Int!
    var postCommentID : Int!
    var strLeftTime : NSString!
    var textViewExpand = HPGrowingTextView()
    var dictLikeData = NSMutableDictionary()
    var imagePicker = UIImagePickerController()
    var replyHeaderview = ReplyHeaderView()
    var replyImageHeaderview = ReplyHeaderViewWithImage()
    var imageProfilePath : NSURL!
    var imageView : UIImageView!
    var index : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.arrAllReply = objComment.arrReply
        
       appDelegate = UIApplication.shared.delegate as! AppDelegate
        
       self.tblReply.sectionHeaderHeight = UITableViewAutomaticDimension
       self.tblReply.estimatedSectionHeaderHeight = 98
        
       self.growingCommentTextview()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnSendCommentClick(sender: UIButton)
    {
        textViewExpand.resignFirstResponder()
        self.BackgroundRequestForSendComment()
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
 
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if(objComment.CommentImage != nil){
            replyImageHeaderview = Bundle.main.loadNibNamed("ReplyHeaderViewWithImage", owner: self, options: nil)?[0] as! ReplyHeaderViewWithImage
            
            getLeftTime(objComment.PostedDate)
            
            replyImageHeaderview.btnLike.setTitle(String(objComment.LikeCount), for: UIControlState.normal)
            replyImageHeaderview.btnReply.setTitle(String(objComment.ReplyCount), for: UIControlState.normal)
            replyImageHeaderview.lblTime.text = self.strLeftTime as String!
            replyImageHeaderview.lblUserName.text = NSString(format : "%@ %@", objComment.FirstName, objComment.LastName) as String
            replyImageHeaderview.lblCommentText?.attributedText = makeAttributedString(title: (objComment.Comment as String?)!)
            
            replyImageHeaderview.imgUserProfile.layer.cornerRadius = replyImageHeaderview.imgUserProfile.frame.size.height/2
            replyImageHeaderview.imgUserProfile.layer.masksToBounds =  true
            
            let strImageURL = objComment.ProfilePic as NSString
            let imgURL = NSURL(string: strImageURL as String)
            
            let imageRequest = NSURLRequest(url: imgURL as! URL, cachePolicy: NSURLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 600)
            replyImageHeaderview.imgUserProfile.setImageWith(imageRequest as URLRequest!, placeholderImage: UIImage(named: "unknown_user.png"), withGradient: true, success: nil, failure: nil)
            
            let strCommentImageURL = objComment.CommentImage as NSString
            let imgCommentURL = NSURL(string: strCommentImageURL as String)
            
            let imageCommentRequest = NSURLRequest(url: imgCommentURL as! URL, cachePolicy: NSURLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 600)
            replyImageHeaderview.imgComment.setImageWith(imageCommentRequest as URLRequest!, placeholderImage: UIImage(named: "noAlbum.png"), withGradient: true, success: nil, failure: nil)
            
            
            let isLike : Bool = objComment.IsLike
            if(isLike == true){
                replyImageHeaderview.btnLike.setImage(UIImage(named: "likecount.png"), for: UIControlState.normal)
            }
            else{
                replyImageHeaderview.btnLike.setImage(UIImage(named: "unlikecount.png"), for: UIControlState.normal)
            }
            
           replyImageHeaderview.btnLike.addTarget(self,action:#selector(ReplyViewController.btnLikeForHeaderClick), for: .touchUpInside)
            return replyImageHeaderview
        }
        else{
            replyHeaderview = Bundle.main.loadNibNamed("ReplyHeaderView", owner: self, options: nil)?[0] as! ReplyHeaderView
        
            getLeftTime(objComment.PostedDate)
            
            replyHeaderview.btnLike.setTitle(String(objComment.LikeCount), for: UIControlState.normal)
            replyHeaderview.btnReply.setTitle(String(objComment.ReplyCount), for: UIControlState.normal)
            replyHeaderview.lblTime.text = self.strLeftTime as String!
            replyHeaderview.lblUserName.text = NSString(format : "%@ %@", objComment.FirstName, objComment.LastName) as String
            replyHeaderview.lblCommentText?.attributedText = makeAttributedString(title: (objComment.Comment as String?)!)
        
            replyHeaderview.imgUserProfile.layer.cornerRadius = replyHeaderview.imgUserProfile.frame.size.height/2
            replyHeaderview.imgUserProfile.layer.masksToBounds =  true
        
            let strImageURL = objComment.ProfilePic as NSString
            let imgURL = NSURL(string: strImageURL as String)
        
            let imageRequest = NSURLRequest(url: imgURL as! URL, cachePolicy: NSURLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 600)
            replyHeaderview.imgUserProfile.setImageWith(imageRequest as URLRequest!, placeholderImage: UIImage(named: "unknown_user.png"), withGradient: true, success: nil, failure: nil)
        
        
            let isLike : Bool = objComment.IsLike
            if(isLike == true){
                replyHeaderview.btnLike.setImage(UIImage(named: "likecount.png"), for: UIControlState.normal)
            }
            else{
                replyHeaderview.btnLike.setImage(UIImage(named: "unlikecount.png"), for: UIControlState.normal)
            }
       
            replyHeaderview.btnLike.addTarget(self,action:#selector(ReplyViewController.btnLikeForHeaderClick), for: .touchUpInside)
            return replyHeaderview
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.objComment.arrReply.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let objComment = self.objComment.arrReply.object(at: indexPath.row) as! CommentModel
        
        if(objComment.ReplyImage == ""){
            var cell: ReplyCommentCell! = tableView.dequeueReusableCell(withIdentifier: "ReplyCommentCell") as?ReplyCommentCell
        
            if cell == nil {
                tableView.register(UINib(nibName: "ReplyCommentCell", bundle: nil), forCellReuseIdentifier: "ReplyCommentCell")
                cell = tableView.dequeueReusableCell(withIdentifier: "ReplyCommentCell") as? ReplyCommentCell
            }
       
            getLeftTime(objComment.ReplyPostedDate)
        
            cell.btnLike.setTitle(String(objComment.ReplyLikeCount), for: UIControlState.normal)
            cell.lblTime.text = self.strLeftTime as String!
            cell.lblUserName.text = NSString(format : "%@ %@", objComment.ReplyFirstName, objComment.ReplyLastName) as String
            cell.lblCommentText?.attributedText = makeAttributedString(title: (objComment.Reply as String?)!)
        
            cell.imgUserProfile.layer.cornerRadius = cell.imgUserProfile.frame.size.height/2
            cell.imgUserProfile.layer.masksToBounds =  true
        
            let strImageURL = objComment.ReplyProfilePic as NSString
            let imgURL = NSURL(string: strImageURL as String)
        
            let imageRequest = NSURLRequest(url: imgURL as! URL, cachePolicy: NSURLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 600)
            cell.imgUserProfile.setImageWith(imageRequest as URLRequest!, placeholderImage: UIImage(named: "unknown_user.png"), withGradient: true, success: nil, failure: nil)
        
            let index = NSString(format: "%d%d", indexPath.section, indexPath.row)
        
            if(self.dictLikeData.value(forKey: index as String) != nil){
                cell.btnLike.setTitle(String(format: "%d", objComment.ReplyLikeCount), for: UIControlState.normal)
                cell.btnLike.setImage(UIImage(named: "likecount.png"), for: UIControlState.normal)
            }
            else{
                let isLike : Bool = objComment.ReplyIsLike
                if(isLike == true){
                    cell.btnLike.setImage(UIImage(named: "likecount.png"), for: UIControlState.normal)
                }
                else{
                    cell.btnLike.setImage(UIImage(named: "unlikecount.png"), for: UIControlState.normal)
                }
            }
        
            if(objComment.ReplyisPublic == true){
                cell.btnUser.isHidden = false
            }
            else{
                cell.btnUser.isHidden = true
            }
            
            cell.btnUser.addTarget(self, action: #selector(ReplyViewController.onClick_btnUserProfile), for: UIControlEvents.touchUpInside)
            cell.btnLike.addTarget(self,action:#selector(ReplyViewController.btnLikeForTextClick(sender:)), for: .touchUpInside)
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }
        else{
            var cell: ReplyCommentWithImageCell! = tableView.dequeueReusableCell(withIdentifier: "ReplyCommentWithImageCell") as?ReplyCommentWithImageCell
            
            if cell == nil {
                tableView.register(UINib(nibName: "ReplyCommentWithImageCell", bundle: nil), forCellReuseIdentifier: "ReplyCommentWithImageCell")
                cell = tableView.dequeueReusableCell(withIdentifier: "ReplyCommentWithImageCell") as? ReplyCommentWithImageCell
            }
            
            getLeftTime(objComment.ReplyPostedDate)
            
            cell.btnLike.setTitle(String(objComment.ReplyLikeCount), for: UIControlState.normal)
            cell.lblTime.text = self.strLeftTime as String!
            cell.lblUserName.text = NSString(format : "%@ %@", objComment.ReplyFirstName, objComment.ReplyLastName) as String
            cell.lblCommentText?.attributedText = makeAttributedString(title: (objComment.Reply as String?)!)
            
            cell.imgUserProfile.layer.cornerRadius = cell.imgUserProfile.frame.size.height/2
            cell.imgUserProfile.layer.masksToBounds =  true
            
            let strImageURL = objComment.ReplyProfilePic as NSString
            let imgURL = NSURL(string: strImageURL as String)
            
            let imageRequest = NSURLRequest(url: imgURL as! URL, cachePolicy: NSURLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 600)
            cell.imgUserProfile.setImageWith(imageRequest as URLRequest!, placeholderImage: UIImage(named: "unknown_user.png"), withGradient: true, success: nil, failure: nil)
            
            let strCommentImageURL = objComment.ReplyImage as NSString
            let imgCommentURL = NSURL(string: strCommentImageURL as String)
            
            let imgForCommentRequest = NSURLRequest(url: imgCommentURL as! URL, cachePolicy: NSURLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 600)
            cell.imgComment.setImageWith(imgForCommentRequest as URLRequest!, placeholderImage: UIImage(named: "unknown_user.png"), withGradient: false, success: nil, failure: nil)
            
            let index = NSString(format: "%d%d", indexPath.section, indexPath.row)
            
            if(self.dictLikeData.value(forKey: index as String) != nil){
                cell.btnLike.setTitle(String(format: "%d", objComment.ReplyLikeCount), for: UIControlState.normal)
                cell.btnLike.setImage(UIImage(named: "likecount.png"), for: UIControlState.normal)
            }
            else{
                let isLike : Bool = objComment.ReplyIsLike
                if(isLike == true){
                    cell.btnLike.setImage(UIImage(named: "likecount.png"), for: UIControlState.normal)
                }
                else{
                    cell.btnLike.setImage(UIImage(named: "unlikecount.png"), for: UIControlState.normal)
                }
            }
            
            if(objComment.ReplyisPublic == true){
                cell.btnUser.isHidden = false
            }
            else{
                cell.btnUser.isHidden = true
            }

            
            cell.btnUser.addTarget(self, action: #selector(ReplyViewController.onClick_btnUserProfile), for: UIControlEvents.touchUpInside)
            cell.btnLike.addTarget(self,action:#selector(ReplyViewController.btnLikeForTextClick(sender:)), for: .touchUpInside)
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }
    }
    
    func onClick_btnUserProfile(sender: AnyObject)
    {
        let btn:UIButton = sender as! UIButton
        NSLog("btn tag...%d", btn.tag)
        
        let buttonPosition:CGPoint = btn.convert(CGPoint.zero, to:self.tblReply)
        let indexPath = self.tblReply.indexPathForRow(at: buttonPosition)
        let objComment = self.objComment.arrReply.object(at: (indexPath?.row)!) as! CommentModel
        let userdetailVC = self.storyboard?.instantiateViewController(withIdentifier: IdentifireUserDetailsView) as! UserDetailsViewController
        userdetailVC.strFirstName = objComment.ReplyFirstName
        userdetailVC.strLastName = objComment.ReplyLastName
        userdetailVC.strContact = objComment.ReplyContact
        userdetailVC.strEmail = objComment.ReplyEmail
        userdetailVC.strBirthDate = objComment.ReplyBirthDate
        userdetailVC.strProfilePic = objComment.ReplyProfilePic
        self.navigationController?.pushViewController(userdetailVC, animated: true)
    }
    
    @IBAction func btnLikeForHeaderClick()
    {
        self.BackgroundRequestForGiveHeaderLike()
    }
    
    func BackgroundRequestForGiveHeaderLike(){
        
        let struserID = UserDefaults.standard.value(forKey: keyUserId) as! Int
        let url = NSString(format : "%@%@", BASE_URL, GIVE_LIKE_ON_COMMENT)
        print("url\(url)")
        
        let manager = AFHTTPRequestOperationManager()
        manager.requestSerializer.timeoutInterval = 120
        manager.requestSerializer.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
        
        let parameters = NSMutableDictionary()
        parameters.setObject(struserID, forKey: "UserId" as NSCopying)
        parameters.setObject(objComment.PostCommentId, forKey: "PostCommentId" as NSCopying)
        
        manager.post(url as String!, parameters: parameters, success: { (operation, responseObject) in
            
            print("Response Object :\(responseObject)")
            let element : NSDictionary = responseObject as! NSDictionary
            let error_code = element.value(forKey: "error_code") as! NSNumber
            let message : String = element.value(forKey: "msg") as! String
            
            if(error_code == 0)
            {
                self.replyHeaderview.btnLike.setImage(UIImage(named: "likecount.png"), for: UIControlState.normal)
                
                let likeNumber = self.objComment.LikeCount as Int!
                self.replyHeaderview.btnLike.setTitle(String(format: "%d", likeNumber!+1), for: UIControlState.normal)
                
                self.objComment.LikeCount = likeNumber!+1
                self.objComment.IsLike = true
            }
            else if(error_code == 1){
                
                self.replyHeaderview.btnLike.setImage(UIImage(named: "unlikecount.png"), for: UIControlState.normal)
            
                let likeNumber = self.objComment.LikeCount as Int!
                
                if(likeNumber! > 0){
                    self.replyHeaderview.btnLike.setTitle(String(format: "%d", likeNumber!-1), for: UIControlState.normal)
                    self.objComment.LikeCount = likeNumber!-1
                    self.objComment.IsLike = false
                }
                else{
                    self.replyHeaderview.btnLike.setTitle(String(format: "0"), for: UIControlState.normal)
                    self.objComment.LikeCount = 0
                    self.objComment.IsLike = false
                }
            }
            else{
                self.appDelegate.ShowAlert(AlertTitle as NSString, alertMessage: message as NSString)
            }
        },
                     failure: { (operation, error) in
                        let err = error as! NSError
                        print("We got an error here.. \(err.localizedDescription)")
                        self.appDelegate.ShowAlert(AlertTitle as NSString, alertMessage: INTERNET_CONNECTION as NSString)
        })
    }
    
    @IBAction func btnLikeForTextClick(sender: UIButton)
    {
        let buttonPosition :CGPoint = sender.convert(CGPoint.zero, to: self.tblReply)
        let indexPath : NSIndexPath = self.tblReply.indexPathForRow(at: buttonPosition)! as NSIndexPath
        let objComment = self.arrAllReply.object(at: (indexPath.row)) as! CommentModel
        
        if(sender.tag == 0){
            self.BackgroundRequestForGiveLike(index: indexPath, likeCount: objComment.ReplyLikeCount, sender: sender,objComment:objComment, from:0)
        }
        else{
            self.BackgroundRequestForGiveLike(index: indexPath, likeCount: objComment.ReplyLikeCount, sender: sender,objComment:objComment, from:1)
        }
    }
    
    func BackgroundRequestForGiveLike(index: NSIndexPath, likeCount : Int, sender : UIButton, objComment : CommentModel, from:Int){
        
        self.ShowActivityIndicator()
        
        let struserID = UserDefaults.standard.value(forKey: keyUserId) as! Int
        let url = NSString(format : "%@%@", BASE_URL, GIVE_LIKE_TO_REPLY)
        print("url\(url)");
        
        let manager = AFHTTPRequestOperationManager()
        manager.requestSerializer.timeoutInterval = 120
        manager.requestSerializer.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
        
        let parameters = NSMutableDictionary()
        parameters.setObject(struserID, forKey: "UserId" as NSCopying)
        parameters.setObject(objComment.ReplyPostCommentId, forKey: "PostCommentReplyId" as NSCopying)
        
        manager.post(url as String!, parameters: parameters, success: { (operation, responseObject) in
            
            print("Response Object :\(responseObject)")
            let element : NSDictionary = responseObject as! NSDictionary
            let error_code = element.value(forKey: "error_code") as! NSNumber
            let message : String = element.value(forKey: "msg") as! String
            
            if(error_code == 0)
            {
                if(from == 0){
                    let cell: ReplyCommentCell! = self.tblReply.cellForRow(at: index as IndexPath) as! ReplyCommentCell!
                    cell.btnLike.setImage(UIImage(named: "likecount.png"), for: UIControlState.normal)
                    
                    let likeNumber = likeCount as Int!
                    cell.btnLike.setTitle(String(format: "%d", likeNumber!+1), for: UIControlState.normal)
                    
                    objComment.ReplyLikeCount = likeNumber!+1
                    objComment.ReplyIsLike = true
                    self.dictLikeData.setObject(String(likeNumber!+1), forKey: NSString(format: "%d%d", index.section, index.row))
                }
                else{
                    let cell: ReplyCommentWithImageCell! = self.tblReply.cellForRow(at: index as IndexPath) as! ReplyCommentWithImageCell!
                    cell.btnLike.setImage(UIImage(named: "likecount.png"), for: UIControlState.normal)
                    
                    let likeNumber = likeCount as Int!
                    cell.btnLike.setTitle(String(format: "%d", likeNumber!+1), for: UIControlState.normal)
                    
                    objComment.ReplyLikeCount = likeNumber!+1
                    objComment.ReplyIsLike = true
                    self.dictLikeData.setObject(String(likeNumber!+1), forKey: NSString(format: "%d%d", index.section, index.row))
                }
               
            }
            else if(error_code == 1){
                 if(from == 0){
                    let cell: ReplyCommentCell! = self.tblReply.cellForRow(at: index as IndexPath) as! ReplyCommentCell
                    cell.btnLike.setImage(UIImage(named: "unlikecount.png"), for: UIControlState.normal)
                    let likeNumber = likeCount as Int!
                
                    if(likeNumber! > 0){
                        cell.btnLike.setTitle(String(format: "%d", likeNumber!-1), for: UIControlState.normal)
                        objComment.ReplyLikeCount = likeNumber!-1
                        objComment.ReplyIsLike = false
                    }
                    else{
                        cell.btnLike.setTitle(String(format: "0"), for: UIControlState.normal)
                        objComment.ReplyLikeCount = 0
                        objComment.ReplyIsLike = false
                    }
                    self.dictLikeData.removeObject(forKey: NSString(format: "%d%d", index.section, index.row))
                }
                 else{
                    let cell: ReplyCommentWithImageCell! = self.tblReply.cellForRow(at: index as IndexPath) as! ReplyCommentWithImageCell
                    cell.btnLike.setImage(UIImage(named: "unlikecount.png"), for: UIControlState.normal)
                    let likeNumber = likeCount as Int!
                    
                    if(likeNumber! > 0){
                        cell.btnLike.setTitle(String(format: "%d", likeNumber!-1), for: UIControlState.normal)
                        objComment.ReplyLikeCount = likeNumber!-1
                        objComment.ReplyIsLike = false
                    }
                    else{
                        cell.btnLike.setTitle(String(format: "0"), for: UIControlState.normal)
                        objComment.ReplyLikeCount = 0
                        objComment.ReplyIsLike = false
                    }
                    self.dictLikeData.removeObject(forKey: NSString(format: "%d%d", index.section, index.row))
                }
            }
            else{
                self.appDelegate.ShowAlert(AlertTitle as NSString, alertMessage: message as NSString)
            }
            self.RemoveActivityIndicator()
        },
                     failure: { (operation, error) in
                        let err = error as! NSError
                        print("We got an error here.. \(err.localizedDescription)")
                        self.RemoveActivityIndicator()
                        self.appDelegate.ShowAlert(AlertTitle as NSString, alertMessage: INTERNET_CONNECTION as NSString)
        })
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    // SendComment API calling
    func BackgroundRequestForSendComment(){
        
        self.ShowActivityIndicator()
        
        let struserID = UserDefaults.standard.value(forKey: keyUserId) as! Int
        let url = NSString(format : "%@%@", BASE_URL, POST_REPLY_TO_COMMENT)
        print("url\(url)");
        let manager = AFHTTPRequestOperationManager()
        
        let parameters = NSMutableDictionary()
        parameters.setObject(objComment.PostCommentId, forKey: "PostCommentId" as NSCopying)
        parameters.setObject(struserID, forKey: "UserId" as NSCopying)
        parameters.setObject(textViewExpand.text, forKey: "Reply" as NSCopying)
        
        print(parameters)
        
        manager.post(url as String!, parameters: parameters,
                     constructingBodyWith: { (data) in
                        if self.imageProfilePath != nil{
                            let replyPhoto = try! data?.appendPart(withFileURL: self.imageProfilePath as URL!, name: "ReplyImage")
                        }
        },
                     success: { (operation, responseObject) in
                        
                        print("Response Object :\(responseObject)")
                        let dict : NSDictionary = responseObject as! NSDictionary
                        let error_code = dict.value(forKey: "error_code") as! NSNumber
                        let message : String = dict.value(forKey: "msg") as! String
                        
                        if(error_code == 0)
                        {
                            //replycomment
                            let dictReply = (dict as AnyObject).value(forKey: "postCommentReply") as! NSDictionary
                            
                            let objReply = CommentModel()
                            
                            if let PostCommentId = (dictReply as AnyObject).value(forKey: "PostCommentId") as? Int {
                                objReply.PostCommentReplyId = PostCommentId
                            }
                            else{
                                objReply.PostCommentReplyId = 0
                            }
                            
                            if let ReplyPostCommentId = (dictReply as AnyObject).value(forKey: "PostCommentReplyId") as? Int {
                                objReply.ReplyPostCommentId = ReplyPostCommentId
                            }
                            else{
                                objReply.ReplyPostCommentId = 0
                            }
                            
                            if let Reply = (dictReply as AnyObject).value(forKey: "Reply") as? NSString {
                                objReply.Reply = Reply
                            }
                            else{
                                objReply.Reply = ""
                            }
                            
                            if let ReplyImage = (dictReply as AnyObject).value(forKey: "ReplyImage") as? NSString {
                                objReply.ReplyImage = ReplyImage
                            }
                            else{
                                objReply.ReplyImage = ""
                            }
                            
                            if let PostedDate = (dictReply as AnyObject).value(forKey: "PostedDate") as? NSString {
                                objReply.ReplyPostedDate = PostedDate
                            }
                            else{
                                objReply.ReplyPostedDate = ""
                            }
                            
                            if let LikeCount = (dictReply as AnyObject).value(forKey: "LikeCount") as? Int {
                                objReply.ReplyLikeCount = LikeCount
                            }
                            else{
                                objReply.ReplyLikeCount = 0
                            }
                            
                            if let FirstName = (dictReply as AnyObject).value(forKey: "FirstName") as? NSString {
                                objReply.ReplyFirstName = FirstName
                            }
                            else{
                                objReply.ReplyFirstName = ""
                            }
                            
                            if let LastName = (dictReply as AnyObject).value(forKey: "LastName") as? NSString {
                                objReply.ReplyLastName = LastName
                            }
                            else{
                                objReply.ReplyLastName = ""
                            }
                            
                            if let ProfilePic = (dictReply as AnyObject).value(forKey: "ProfilePic") as? NSString {
                                objReply.ReplyProfilePic = ProfilePic
                            }
                            else{
                                objReply.ReplyProfilePic = ""
                            }
                            
                            if let IsLike = (dictReply as AnyObject).value(forKey: "IsLike") as? Bool {
                                objReply.ReplyIsLike = IsLike
                            }
                            else{
                                objReply.ReplyIsLike = false
                            }
                            
                            if let IsPublic = (dictReply as AnyObject).value(forKey: "IsPublic") as? Bool {
                                objReply.ReplyisPublic = IsPublic
                            }
                            else{
                                objReply.ReplyisPublic = false
                            }
                            
                            if let Email = (dictReply as AnyObject).value(forKey: "Email") as? NSString {
                                objReply.ReplyEmail = Email
                            }
                            else{
                                objReply.ReplyEmail = ""
                            }
                            
                            if let BirthDate = (dictReply as AnyObject).value(forKey: "BirthDate") as? NSString {
                                objReply.ReplyBirthDate = BirthDate
                            }
                            else{
                                objReply.ReplyBirthDate = ""
                            }
                            
                            if let Contact = (dictReply as AnyObject).value(forKey: "Contact") as? NSString {
                                objReply.ReplyContact = Contact
                            }
                            else{
                                objReply.ReplyContact = ""
                            }
                            
                            self.objComment.arrReply.add(objReply)
                            self.objComment.ReplyCount = self.objComment.ReplyCount + 1
                            
                           // self.arrAllReply.add(objReply)
                            if(self.imageView?.image != nil){
                                self.imageView?.removeFromSuperview()
                            }
                            self.textViewExpand.text = ""
                            
                            if(IS_IPHONE_5){
                                self.textViewExpand.frame = CGRect(x:self.btnPhoto.frame.size.width+self.btnPhoto.frame.origin.x, y:9, width:self.viewTypeReply.frame.size.width-self.btnSend.frame.size.width-self.btnPhoto.frame.origin.x-50,height:30)
                                self.tblReply.frame = CGRect(x: self.tblReply.frame.origin.x, y:0 , width: self.view.frame.size.width, height: self.view.frame.size.height-45)
                                self.viewTypeReply.frame = CGRect(x: self.tblReply.frame.origin.x, y:self.tblReply.frame.size.height, width: self.view.frame.size.width, height: 45)
                                self.btnSend.frame.origin.x = self.textViewExpand.frame.origin.x+self.textViewExpand.frame.size.width+5
                            }
                            else{
                                self.viewTypeReply.frame.origin.y = 622
                                self.viewTypeReply.frame.size.height = 45
                                self.textViewExpand.frame = CGRect(x:self.btnPhoto.frame.size.width+self.btnPhoto.frame.origin.x, y:9, width:self.viewTypeReply.frame.size.width-self.btnSend.frame.size.width-self.btnPhoto.frame.origin.x-50,height:30)
                                self.tblReply.frame.size.height =  self.view.frame.size.height-self.viewTypeReply.frame.size.height
                            }
                            
                            
                            self.tblReply.reloadData()
                            self.RemoveActivityIndicator()
                        }
                        else{
                            self.RemoveActivityIndicator()
                            self.appDelegate.ShowAlert(AlertTitle as NSString, alertMessage: message as NSString)
                        }
        },
                     failure: { (operation, error) in
                        self.RemoveActivityIndicator()
                        print(error?.localizedDescription as Any)
                        print(error?._userInfo as Any)
                        self.appDelegate.ShowAlert(AlertTitle as NSString, alertMessage: INTERNET_CONNECTION as NSString)
        })
    }
    
    func growingTextView()
    {
        textViewExpand.frame = CGRect(x:self.btnPhoto.frame.size.width+self.btnPhoto.frame.origin.x, y:9, width:self.viewTypeReply.frame.size.width-self.btnSend.frame.size.width-self.btnPhoto.frame.origin.x-50,height:80)
        textViewExpand.contentInset = UIEdgeInsetsMake(0, 5, 0, 5)
        textViewExpand.isScrollable = false
        textViewExpand.minNumberOfLines = 1
        textViewExpand.maxNumberOfLines = 6
        textViewExpand.delegate = self
        textViewExpand.internalTextView.backgroundColor = UIColor(red: 243/255, green: 245/255, blue: 246/255, alpha: 1.0)
        textViewExpand.internalTextView.layer.masksToBounds = true
        textViewExpand.internalTextView.layer.cornerRadius = 4
        
        textViewExpand.internalTextView.layer.borderWidth = 1;
        textViewExpand.internalTextView.layer.borderColor = UIColor.lightGray.cgColor
        
        textViewExpand.placeholder = "Write a comment...."
        textViewExpand.internalTextView.textColor = UIColor.black
        textViewExpand.font = UIFont(name: "HelveticaNueu", size: 14.0)
        self.viewTypeReply.addSubview(textViewExpand)
    }
    
    func growingCommentTextview(){
        
        textViewExpand.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(note:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(note:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        self.tblReply.frame = CGRect(x:self.tblReply.frame.origin.x, y:0, width:self.tblReply.frame.size.width, height:self.tblReply.frame.size.height+70)
        
        growingTextView()
        
        if(IS_IPHONE_5){
            self.tblReply.frame = CGRect(x: self.tblReply.frame.origin.x, y:0 , width: self.view.frame.size.width, height: self.view.frame.size.height-self.viewTypeReply.frame.size.height)
            self.textViewExpand.frame = CGRect(x: self.textViewExpand.frame.origin.x, y:textViewExpand.frame.origin.y, width: self.viewTypeReply.frame.size.width-self.btnSend.frame.size.width-self.btnPhoto.frame.size.width-80, height: self.textViewExpand.frame.size.height)
            self.btnSend.frame.origin.x = self.textViewExpand.frame.origin.x+self.textViewExpand.frame.size.width+5
            self.viewTypeReply.frame = CGRect(x: self.tblReply.frame.origin.x, y:self.tblReply.frame.size.height, width: self.view.frame.size.width, height: self.viewTypeReply.frame.size.height)
            
        }else{
            self.tblReply.frame = CGRect(x:self.tblReply.frame.origin.x, y:0, width:self.tblReply.frame.size.width, height:self.tblReply.frame.size.height+70)
        }
        
        self.view.keyboardTriggerOffset = viewTypeReply.bounds.size.height
        
        self.view.addKeyboardPanning(frameBasedActionHandler: {
            (keyboardFrameInView: CGRect, opening:Bool, closing: Bool)in
            
            var containerFrame: CGRect = self.viewTypeReply.frame
            containerFrame.origin.y =  keyboardFrameInView.origin.y - containerFrame.size.height
            self.viewTypeReply.frame = containerFrame
            
            var scrollViewFrame: CGRect = self.tblReply.frame
            scrollViewFrame.size.height =  containerFrame.origin.y
            self.tblReply.frame = scrollViewFrame
            NSLog("Table Y....%f", self.tblReply.frame.origin.y)
            
        }, constraintBasedActionHandler: nil)
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
    
    func makeAttributedString(title: String) -> NSAttributedString {
        
        let titleAttributes = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: .subheadline), NSForegroundColorAttributeName: UIColor.darkGray]
        
        let titleString = NSMutableAttributedString(string: "\(title)", attributes: titleAttributes)
        
        return titleString
    }
    
    func keyboardWillShow(note: NSNotification)
    {
        
        var keyboardBounds = CGRect()
        let notificationInfo: NSDictionary = note.userInfo! as NSDictionary
        (notificationInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as AnyObject).getValue(&keyboardBounds)
        
        let duration: NSNumber = notificationInfo.object(forKey: UIKeyboardAnimationDurationUserInfoKey) as! NSNumber
        let curve: NSNumber = notificationInfo.object(forKey: UIKeyboardAnimationCurveUserInfoKey) as! NSNumber
        
        keyboardBounds = self.view.convert(keyboardBounds, to: nil)
        
        // get a rect for the textView frame
        var containerFrame: CGRect = self.viewTypeReply.frame
        containerFrame.origin.y = self.view.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height)-125
        
        // animations settings
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(duration.doubleValue)
        UIView.setAnimationCurve(UIViewAnimationCurve(rawValue: Int(curve))!)
        
        self.viewTypeReply.frame = containerFrame
        self.tblReply.frame = CGRect(x:self.tblReply.frame.origin.x, y:self.tblReply.frame.origin.y, width:self.tblReply.frame.size.width, height:self.viewTypeReply.frame.origin.y-50)
        UIView.commitAnimations()
    }
    
    func keyboardWillHide(note: NSNotification)
    {
        
        let notificationInfo: NSDictionary = note.userInfo! as NSDictionary
        let duration: NSNumber = notificationInfo.object(forKey: UIKeyboardAnimationDurationUserInfoKey) as! NSNumber
        let curve: NSNumber = notificationInfo.object(forKey: UIKeyboardAnimationCurveUserInfoKey) as! NSNumber
        
        // get a rect for the textView frame
        var containerFrame: CGRect = viewTypeReply.frame
        containerFrame.origin.y = self.view.bounds.size.height - containerFrame.size.height
        
        // animations settings
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(duration.doubleValue)
        UIView.setAnimationCurve(UIViewAnimationCurve(rawValue: Int(curve))!)
        
        // set views with new info
        viewTypeReply.frame = containerFrame
        NSLog("Y,..KH..%f",  viewTypeReply.frame.origin.y)
        
        self.tblReply.frame = CGRect(x:self.tblReply.frame.origin.x,y:self.tblReply.frame.origin.y, width:self.tblReply.frame.size.width,height:454)
        UIView.commitAnimations()
        
    }
    
    func growingTextView(_ growingTextView: HPGrowingTextView!, willChangeHeight height: Float) {
        
        let diff: Float = Float(growingTextView.frame.size.height) - height
        
        var r: CGRect = viewTypeReply.frame
        r.size.height -= CGFloat(diff)
        r.origin.y += CGFloat(diff)
        NSLog("Y.....%f >>> %f", r.size.height, r.origin.y)
        viewTypeReply.frame = r
        self.tblReply.frame = CGRect(x:self.tblReply.frame.origin.x, y:self.tblReply.frame.origin.y, width:self.tblReply.frame.size.width,height:self.viewTypeReply.frame.origin.y)
    }
    
    func growingTextViewDidChange(_ growingTextView: HPGrowingTextView!) {
        
        btnSend.isEnabled = true
        if(textViewExpand.text == "")
        {
            btnSend.isEnabled = false
            btnSend.setImage(UIImage(named: "send_disable.png"), for: UIControlState.normal)
        }
        else{
            btnSend.isEnabled = true
            btnSend.setImage(UIImage(named: "send.png"), for: UIControlState.normal)
        }
    }
    
    @IBAction func btnAddPhotos(sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum){
            
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum;
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if (info[UIImagePickerControllerOriginalImage] as? UIImage) != nil {
            imageView = UIImageView(image: info[UIImagePickerControllerOriginalImage] as? UIImage)
            if(IS_IPHONE_5){
                imageView?.frame = CGRect(x: self.textViewExpand.frame.origin.x+5, y: 8, width: 50, height: 50)
                self.btnPhoto.frame.origin.x = 5
                self.btnSend.frame.origin.x = self.textViewExpand.frame.origin.x+self.textViewExpand.frame.size.width+5
                self.textViewExpand.frame = CGRect(x: self.btnPhoto.frame.origin.x+self.btnPhoto.frame.size.width-10, y: (imageView?.frame.origin.y)!+(imageView?.frame.size.height)!+10, width: self.viewTypeReply.frame.size.width-self.btnSend.frame.size.width-self.btnPhoto.frame.size.width, height: self.textViewExpand.frame.size.height)
                self.viewTypeReply.frame = CGRect(x: self.viewTypeReply.frame.origin.x, y: self.viewTypeReply.frame.origin.y-60, width: self.view.frame.size.width, height: self.textViewExpand.frame.size.height+(imageView?.frame.size.height)!+30)
            }
            else{
                imageView?.frame = CGRect(x: self.textViewExpand.frame.origin.x+5, y: 5, width: 50, height: 50)
                self.textViewExpand.frame = CGRect(x: self.textViewExpand.frame.origin.x, y: (imageView?.frame.origin.y)!+(imageView?.frame.size.height)!+10, width: self.viewTypeReply.frame.size.width-self.btnSend.frame.size.width-self.btnPhoto.frame.size.width, height: self.textViewExpand.frame.size.height)
                self.viewTypeReply.frame = CGRect(x: self.viewTypeReply.frame.origin.x, y: self.viewTypeReply.frame.origin.y-100, width: self.view.frame.size.width, height: self.textViewExpand.frame.size.height+(imageView?.frame.size.height)!+30)
            }
            
            
            self.tblReply.frame = CGRect(x:self.tblReply.frame.origin.x, y:self.tblReply.frame.origin.y, width:self.tblReply.frame.size.width,height:self.viewTypeReply.frame.origin.y)
            
            self.viewTypeReply.addSubview(imageView!)
            
            let data:NSData = UIImageJPEGRepresentation((info[UIImagePickerControllerOriginalImage] as? UIImage)!,1.0)! as NSData
            
            //path for save image
            let imageName = NSString(format: "%.0f.png", NSDate().timeIntervalSince1970) as NSString
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent(imageName as String)
            let path = fileURL.path
            
            if(data.write(toFile: path as String, atomically: true))
            {
                NSLog("Save local sucessfully")
            }
            else{
                NSLog("Problem to save file in directory")
            }
            
            imageProfilePath = fileURL as NSURL!
            
        }
        
        self.dismiss(animated: true, completion: { () -> Void in
            
        })
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
    
    @IBAction func btnBackClicked(sender: UIButton) {
        
        if let myDelegate = self.delegate {
            self.delegate?.sendExistingCommentObjectToPreviousVC(objComment: self.objComment, index : index)
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black]

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

extension UITableView {
    //set the tableHeaderView so that the required height can be determined, update the header's frame and set it again
    func setAndLayoutTableHeaderView(header: UIView) {
        self.tableHeaderView = header
        header.setNeedsLayout()
        header.layoutIfNeeded()
        let height = header.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
        var frame = header.frame
        frame.size.height = height
        header.frame = frame
        self.tableHeaderView = header
    }
}
