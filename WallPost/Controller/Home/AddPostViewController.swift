//
//  AddPostViewController.swift
//  WallPost
//
//  Created by Ved on 27/02/17.
//  Copyright © 2017 Ved. All rights reserved.
//

import UIKit
import Photos
import AVKit

protocol createMyPostProtocol
{
    func sendNewPostObjectToPreviousVC(myPost:PostModel)
}

class AddPostViewController: UIViewController,UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate, UITextViewDelegate,NVActivityIndicatorViewable {

    var delegate:createMyPostProtocol?
    
    @IBOutlet weak var tblAllPhotos: UICollectionView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var txtStory: UITextView!
    @IBOutlet weak var viewTop: UIView?
    @IBOutlet weak var btnSend: UIButton?
    @IBOutlet weak var textHeightConstraint: NSLayoutConstraint!
    
    var arrFiles : NSMutableArray = NSMutableArray()
    var appDelegate = AppDelegate()
    var strPostText : NSString!
    var pickerController: DKImagePickerController = DKImagePickerController()
    var assets: [DKAsset]?
    var headerView : AddPostHeaderView!
    var strPhotoVideo : NSString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.btnSend?.isHidden = true
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let keyboardNextButtonView : UIToolbar = UIToolbar()
        keyboardNextButtonView.sizeToFit()
        let nextButton1 : UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(AddPostViewController.btnTextviewDoneClicked))
        keyboardNextButtonView.setItems([nextButton1], animated: true)
        self.txtStory.inputAccessoryView = keyboardNextButtonView
        self.txtStory.delegate = self
        let strImageURL = UserDefaults.standard.value(forKey: keyProfilePic) as! NSString
        
        self.lblName.text = NSString(format : "%@ %@", UserDefaults.standard.value(forKey: keyFirstName) as! CVarArg,UserDefaults.standard.value(forKey: keyLastName) as! CVarArg) as String
        
        self.imgProfile.layer.cornerRadius = self.imgProfile.frame.size.height/2
        self.imgProfile.layer.masksToBounds =  true
        
        let imgURL = NSURL(string: strImageURL as String)
        
        let imageRequest = NSURLRequest(url: imgURL as! URL, cachePolicy: NSURLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 600)
        self.imgProfile.setImageWith(imageRequest as URLRequest!, placeholderImage: UIImage(named: "unknown_user.png"), withGradient: true, success: nil, failure: nil)
        
        // Do any additional setup after loading the view.
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(self.txtStory.contentSize.height < self.textHeightConstraint.constant) {
            self.txtStory.isScrollEnabled = false
        } else {
            self.txtStory.isScrollEnabled = true
        }
        
        if(self.txtStory.text.isEmpty == true){
            if(self.assets != nil){
                self.btnSend?.isHidden = false
            }
            else{
                self.btnSend?.isHidden = false
            }
        }
        
        return true
    }

    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        if(self.txtStory.text == "What's on your mind?" || self.txtStory.text == "Say something about these photos.."){
            self.txtStory.text = nil
        }

        return true
    }
    
    @IBAction func btnTextviewDoneClicked(){
        self.txtStory.resignFirstResponder()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.assets?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if(IS_IPHONE_5 || IS_IPHONE_4_OR_LESS){
            return CGSize(width:143, height:143)
        }
        else{
            return CGSize(width:172, height:172)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      
        //let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddPhotoCell", for: indexPath) as! AddPhotoCell
        
        let asset = self.assets![indexPath.row]
        var cell: UICollectionViewCell?
        var imageView: UIImageView?
        
        if asset.isVideo {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellVideo", for: indexPath)
            imageView = cell?.contentView.viewWithTag(1) as? UIImageView
        } else {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellImage", for: indexPath)
            imageView = cell?.contentView.viewWithTag(1) as? UIImageView
        }
        
        if let cell = cell, let imageView = imageView {
            let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
            let tag = indexPath.row + 1
            cell.tag = tag
            asset.fetchImageWithSize(layout.itemSize.toPixel(), completeBlock: { image, info in
                if cell.tag == tag {
                    imageView.image = image
                }
            })
            
           
        }
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let asset = self.assets![indexPath.row]
        asset.fetchAVAssetWithCompleteBlock { (avAsset, info) in
            DispatchQueue.main.async(execute: { () in
                self.playVideo(avAsset!)
            })
        }
    }
    
    func playVideo(_ asset: AVAsset) {
        let avPlayerItem = AVPlayerItem(asset: asset)
        
        let avPlayer = AVPlayer(playerItem: avPlayerItem)
        let player = AVPlayerViewController()
        player.player = avPlayer
        
        avPlayer.play()
        
        self.present(player, animated: true, completion: nil)
    }
    
    @IBAction func btnSendClicked(sender: UIButton) {
        
        if(self.strPhotoVideo != ""){
            
            if(self.txtStory.text == "What's on your mind?" || self.txtStory.text == "Say something about these photos.."){
                strPostText = ""
            }
            else{
                strPostText = self.txtStory.text as NSString
            }
            
            let shortFoo = self.strPhotoVideo.substring(to: self.strPhotoVideo.length-1)
            
            let strPostString = NSString(format:"{%@}",shortFoo)
            NSLog("strPostString---%@", strPostString)
        
            self.backgroundAPIForAddPost(str: strPostString as NSString)
        }
        else{
            strPostText = self.txtStory.text as NSString
            self.backgroundAPIForAddPost(str: "")
        }
    }
    
    // Sign Up API calling
    func backgroundAPIForAddPost(str : NSString){
        
        self.ShowActivityIndicator()
        
        let struserID = UserDefaults.standard.value(forKey: keyUserId) as! Int
        let url = NSString(format : "%@%@", BASE_URL, ADD_POST_URL)
        print("url\(url)");
        let manager = AFHTTPRequestOperationManager()
        
        let parameters = NSMutableDictionary()
        parameters.setObject(struserID, forKey: "UserId" as NSCopying)
        if(strPostText != ""){
            parameters.setObject(strPostText, forKey: "PostText" as NSCopying)
        }
        
        parameters.setObject(str, forKey: "ImagesVideos" as NSCopying)
        
        print(parameters)
        
        manager.post(url as String!, parameters: parameters,
                     constructingBodyWith: { (data) in
                        if self.arrFiles.count > 0 {
                            
                            for var i in (0..<self.arrFiles.count)
                            {
                                let strPath = self.arrFiles[i] as! URL
                                
                                let profilePhoto = try! data?.appendPart(withFileURL: strPath as URL!, name: "ImageContent")
                            }
                        }
        },
                     success: { (operation, responseObject) in
                        
                        print("Response Object :\(responseObject)")
                        let dict : NSDictionary = responseObject as! NSDictionary
                        let error_code = dict.value(forKey: "error_code") as! NSNumber
                        let message : String = dict.value(forKey: "msg") as! String
                        
                        if(error_code == 0)
                        {
                          
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
                            
                                    if let LikeCount = (post as AnyObject).value(forKey: "LikeCount") as? Int {
                                        objPostModel.LikeCount = LikeCount
                                    }
                                    else{
                                        objPostModel.LikeCount = 0
                                    }
                            
                                    if let commentCount = (post as AnyObject).value(forKey: "CommentCount") as? Int {
                                        objPostModel.CommentCount = commentCount
                                    }
                                    else{
                                        objPostModel.CommentCount = 0
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
                                        
                                        if let strIsPublic = (user as AnyObject).value(forKey: "IsPublic") as? Bool {
                                             objPostModel.isPublic = strIsPublic
                                        }
                                        else{
                                             objPostModel.isPublic = true
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
                            
                            if let myDelegate = self.delegate {
                                self.delegate?.sendNewPostObjectToPreviousVC(myPost: objPostModel)
                            }
                            
                            self.navigationController?.popViewController(animated: true)
                            self.RemoveActivityIndicator()
                            
                        }
                        else{
                            self.RemoveActivityIndicator()
                            self.appDelegate.ShowAlert(AlertTitle as NSString, alertMessage: message as NSString)
                        }
                       
        },
                     failure: { (operation, error) in
                        
                        self.RemoveActivityIndicator()
                        print(error?.localizedDescription)
                        print(error?._userInfo)
                        self.appDelegate.ShowAlert(AlertTitle as NSString, alertMessage: INTERNET_CONNECTION as NSString)
        })
    }

    
    @IBAction func btnAddPhotosVideo(sender: UIButton) {
        
        pickerController.defaultSelectedAssets = self.assets
        
        pickerController.didSelectAssets = { [unowned self] (assets: [DKAsset]) in
            print("didSelectAssets")
            
            self.assets = assets
            
            if(self.assets != nil){
                if(self.txtStory.text == "What's on your mind?"){
                    self.txtStory.text = "Say something about these photos.."
                }
                self.btnSend?.isHidden = false
            }
            
            self.ShowActivityIndicator()
            let myGroup = DispatchGroup()
            
            for var i in (0..<self.assets!.count)
            {
                myGroup.enter()
                let asset = self.assets![i]
                
                //path for save image
                let imageName = NSString(format: "%.0f%d.png", NSDate().timeIntervalSince1970, i) as NSString
                let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                let fileURL = documentsURL.appendingPathComponent(imageName as String)
                let path = fileURL.path
                
                if asset.isVideo {
                   
                    let videoName = NSString(format: "%.0f%d.mp4", NSDate().timeIntervalSince1970, i) as NSString
                    let tempFileUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(videoName as String, isDirectory: false)
                    
                    asset.writeAVToFile(tempFileUrl.path, presetName: AVAssetExportPresetHighestQuality, completeBlock: { (success, url) in
                        print("video url...\(url)")
                        
                        self.arrFiles.add(url)
                        
                        let videoKey = "\"2\""
                        print(videoKey)
                        
                        let videoName = "\"\(videoName)\""
                        print(videoName)
                        
                        self.strPhotoVideo = self.strPhotoVideo.appending("\(videoName):\(videoKey),") as NSString
                        print("strPhotoVideo...\(self.strPhotoVideo)")
                        myGroup.leave()
                    })

                }
                else{
                    
                    asset.writeImageToFile(path, completeBlock: { (success, url) in
                        print("URL...\(url)")
                        
                        self.arrFiles.add(url)
                        
                        let imageKey = "\"1\""
                        print(imageKey)
                        
                        let imageName = "\"\(imageName)\""
                        print(imageName)
                        
                        self.strPhotoVideo = self.strPhotoVideo.appending("\(imageName):\(imageKey),") as NSString
                        print("strPhotoVideo...\(self.strPhotoVideo)")
                          myGroup.leave()
                    })
                }
            }
            
            myGroup.notify(queue: .main) {
                print("Finished all requests.")
                self.RemoveActivityIndicator()
                self.tblAllPhotos.reloadData()
            }
        }
        
        if UI_USER_INTERFACE_IDIOM() == .pad {
            pickerController.modalPresentationStyle = .formSheet
        }
        
        self.present(pickerController, animated: true) {}
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
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
