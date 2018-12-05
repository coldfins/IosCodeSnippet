//
//  LikePeopleListViewController.swift
//  WallPost
//
//  Created by Ved on 04/03/17.
//  Copyright © 2017 Ved. All rights reserved.
//

import UIKit

class LikePeopleListViewController: UIViewController,UITableViewDelegate, UITableViewDataSource,NVActivityIndicatorViewable {

    @IBOutlet weak var tblLike: UITableView!
    
    var arrAllLike : NSMutableArray = NSMutableArray()
    var appDelegate = AppDelegate()
    var offset : Int = 0
    var postID : Int!
    var likeCount : Int!
    var likeHeaderview : LikeHeaderView! = LikeHeaderView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        self.tblLike.addInfiniteScrolling {
            self.getAllLikeUsers()
        }
        self.getAllLikeUsers()
        
        // Do any additional setup after loading the view.
    }
    
    func getAllLikeUsers(){
        
        let url = NSString(format : "%@%@%d&offset=%d&limit=10", BASE_URL, LIKE_USERS_OF_POST,postID, offset)
        print("url\(url)")
        
        let manager = AFHTTPRequestOperationManager()
       // manager.requestSerializer.timeoutInterval = 600
       // manager.requestSerializer.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
        
        manager.get(url as String!, parameters: nil, success: { (operation, responseObject) in
            
            print("Response Object :\(responseObject)")
            let element : NSDictionary = responseObject as! NSDictionary
            let error_code = element.value(forKey: "error_code") as! NSNumber
            let message : String = element.value(forKey: "msg") as! String
            
            if(error_code == 0)
            {
                print(element)
                
                let likeElement = element["likeusers"] as! NSArray
                
                if likeElement.count > 0{
                    
                    self.offset = self.offset + likeElement.count
                    
                    for dict in likeElement{
                        let objPostModel = PostModel()
                        
                        objPostModel.BirthDate = (dict as AnyObject).value(forKey: "BirthDate") as! NSString
                        objPostModel.Contact = (dict as AnyObject).value(forKey: "Contact") as! NSString
                        objPostModel.Email = (dict as AnyObject).value(forKey: "Email") as! NSString
                        objPostModel.FirstName = (dict as AnyObject).value(forKey: "FirstName") as! NSString
                        objPostModel.LastName = (dict as AnyObject).value(forKey: "LastName") as! NSString
                        objPostModel.ProfilePic = (dict as AnyObject).value(forKey: "ProfilePic") as! NSString
                        
                        self.arrAllLike.add(objPostModel)
                        
                    }
                    
                    self.tblLike.infiniteScrollingView.stopAnimating()
                    self.tblLike.reloadData()
                }
                else{
                    
                    self.tblLike.infiniteScrollingView.stopAnimating()
                    if self.arrAllLike.count == 0{
                    }
                    else{
                        //  self.collectionView.infiniteScrollingView.stopAnimating()
                    }
                }
                
                
            }
            else{
                
                self.appDelegate.ShowAlert(AlertTitle as NSString, alertMessage: message as NSString)
            }
            self.tblLike.infiniteScrollingView.stopAnimating()
            
        },
                    failure: { (operation, error) in
                        let err = error as! NSError
                        print("We got an error here.. \(err.localizedDescription)")
                        print("Error Info.. \(err.userInfo)")
                        print("Error desc.. \(err.description)")
                        self.appDelegate.ShowAlert(AlertTitle as NSString, alertMessage: INTERNET_CONNECTION as NSString)
                        
                        self.tblLike.infiniteScrollingView.stopAnimating()
                        
        })
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrAllLike.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        likeHeaderview = Bundle.main.loadNibNamed("LikeHeaderView", owner: self, options: nil)?[0] as! LikeHeaderView
        
        likeHeaderview.lblCount.text = NSString(format:"All %d", likeCount) as String
        
        return likeHeaderview
        
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       var cell: LikeUsersCell! = tableView.dequeueReusableCell(withIdentifier: "LikeUsersCell") as?LikeUsersCell
        if cell == nil {
            tableView.register(UINib(nibName: "LikeUsersCell", bundle: nil), forCellReuseIdentifier: "LikeUsersCell")
            cell = tableView.dequeueReusableCell(withIdentifier: "LikeUsersCell") as? LikeUsersCell
        }
        
        let objLike = arrAllLike.object(at: indexPath.row) as! PostModel
        
        cell.lblUserName.text = NSString(format : "%@ %@", objLike.FirstName, objLike.LastName) as String
        cell.imgProfilePic.layer.cornerRadius = cell.imgProfilePic.frame.size.height/2
        cell.imgProfilePic.layer.masksToBounds =  true
        
        let strImageURL = objLike.ProfilePic as NSString
        let imgURL = NSURL(string: strImageURL as String)
        
        let imageRequest = NSURLRequest(url: imgURL as! URL, cachePolicy: NSURLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 600)
        cell.imgProfilePic.setImageWith(imageRequest as URLRequest!, placeholderImage: UIImage(named: "unknown_user.png"), withGradient: true, success: nil, failure: nil)
        
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    @IBAction func btnBackClicked(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
