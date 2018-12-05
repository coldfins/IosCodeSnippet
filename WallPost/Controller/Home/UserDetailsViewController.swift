//
//  UserDetailsViewController.swift
//  WallPost
//
//  Created by Ved on 17/03/17.
//  Copyright © 2017 Ved. All rights reserved.
//

import UIKit

class UserDetailsViewController: UIViewController {

    @IBOutlet weak var imgUserProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblBirthday: UILabel!
    @IBOutlet weak var lblMobile: UILabel!
    
    var strFirstName : NSString!
    var strLastName : NSString!
    var strEmail : NSString!
    var strContact : NSString!
    var strBirthDate : NSString!
    var strProfilePic : NSString!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lblName.text = NSString(format : "%@ %@", strFirstName, strLastName) as String
        self.lblEmail.text = NSString(format : "%@", strEmail) as String
        self.lblMobile.text = NSString(format : "%@", strContact) as String
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        let date = dateFormatter.date(from: strBirthDate as String)
        print(date as Any)
        
        let df = DateFormatter()
        df.dateStyle = DateFormatter.Style.medium
        df.timeStyle = DateFormatter.Style.none
        df.dateFormat =  "MMM dd, yyyy"
       
        self.lblBirthday.text = df.string(from: date!)
        
        self.imgUserProfile.layer.cornerRadius = self.imgUserProfile.frame.size.height/2
        self.imgUserProfile.layer.masksToBounds =  true
        
        let strImageURL = strProfilePic as NSString
        let imgURL = NSURL(string: strImageURL as String)
        
        let imageRequest = NSURLRequest(url: imgURL as! URL, cachePolicy: NSURLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 600)
        self.imgUserProfile.setImageWith(imageRequest as URLRequest!, placeholderImage: UIImage(named: "unknown_user.png"), withGradient: true, success: nil, failure: nil)

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnBackClicked(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.barTintColor = UIColor.colorForApp()
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
}
