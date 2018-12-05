//
//  FirstScreenViewController.swift
//  MapMyDiet
//
//  Created by Coldfin Lab on 05/03/16.
//  Copyright © 2016 Coldfin Lab. All rights reserved.
//

import UIKit

class FirstScreenViewController: UIViewController,NVActivityIndicatorViewable {
   
    var isConnected : Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(FirstScreenViewController.reachabilityDidChange(_:)), name: NSNotification.Name.reachabilityChanged, object: nil)
    }

    func reachabilityDidChange(_ notification : Notification) {
        if ReachabilityManager.isReachable() {
            isConnected = true
        }else{
            isConnected = false
            utils.customAlertView("Poor Internet Connection. Make sure you are connected to internet.", view: self.view)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClick_redirect_to_LoginPage(_ sender: AnyObject) {
        
        let size = CGSize(width: 30, height:30)
        startAnimating(size, message: nil, type: NVActivityIndicatorType(rawValue: 22)!)
        
        let url : String = String("\(API_BASE_URL)/\(API_LOGIN_URL)")
        let parameters : NSDictionary = ["email":"bnp@gmail.com","password":"123456789"]
        
        let manager = AFHTTPRequestOperationManager()
        manager.post( url, parameters: parameters,
                          success: { (operation, responseObject) in
                         
                            self.stopAnimating()
                            
                            let element : NSDictionary = responseObject as! NSDictionary
                            let strStatus : String = element.value(forKey: "code") as! String
                            if strStatus == "0" {
                                defaults.setValue("true", forKey: USER_DEFAULTS_IS_LOGGED_IN)
                                
                                let dicUserDetail : NSDictionary = element.value(forKey: "user") as! NSDictionary
                                
                                if let udefault = dicUserDetail.value(forKey: "height") as? String
                                {
                                    defaults.set(udefault, forKey: USER_DEFAULTS_USER_HEIGHT_KEY)
                                }else{
                                    defaults.set(5.4, forKey: USER_DEFAULTS_USER_HEIGHT_KEY)
                                }
                                
                                if let udefault = dicUserDetail.value(forKey: "id") as? Int
                                {
                                    defaults.set(udefault, forKey: USER_DEFAULTS_USER_ID_KEY)
                                }else{
                                    defaults.set(1, forKey: USER_DEFAULTS_USER_ID_KEY)
                                }
                                
                                
                                if let udefault = dicUserDetail.value(forKey: "step_goal") as? Int
                                {
                                    defaults.set(udefault, forKey: USER_DEFAULTS_USER_GOAL_STEPS)
                                }else{
                                    defaults.set(10000, forKey: USER_DEFAULTS_USER_GOAL_STEPS)
                                }
                                
                                if let calorieGoalDict = dicUserDetail.value(forKey: "calories_goal") as? NSDictionary {
                                    if let udefault = calorieGoalDict.value(forKey: "activity_type") as? String
                                    {
                                        defaults.set(udefault, forKey: USER_DEFAULTS_USER_ACTIVITY_TYPE_KEY)
                                    }else{
                                        defaults.set("Sedentary", forKey: USER_DEFAULTS_USER_ACTIVITY_TYPE_KEY)
                                    }
                                    
                                    if let udefault = calorieGoalDict.value(forKey: "current_weight") as? Float
                                    {
                                        defaults.set(udefault, forKey: USER_DEFAULTS_USER_CURRRENT_WEIGHT_KEY)
                                    }else{
                                        defaults.set(40.0, forKey: USER_DEFAULTS_USER_CURRRENT_WEIGHT_KEY)
                                    }
                                    
                                    if let udefault = calorieGoalDict.value(forKey: "goal_calories") as? Float
                                    {
                                        defaults.set(udefault, forKey: USER_DEFAULTS_USER_GOAL_CALORIE)
                                    }else{
                                        defaults.set(1200.0, forKey: USER_DEFAULTS_USER_GOAL_CALORIE)
                                    }
                                    
                                    if let udefault = calorieGoalDict.value(forKey: "goal_end_date") as? String
                                    {
                                        let arr = udefault.components(separatedBy: "T")
                                        let endDate : Date = utils.convertStringToDate(arr[0], dateFormat: "yyyy-MM-dd")
                                        defaults.set(endDate, forKey: USER_DEFAULTS_TENTATIVE_GOAL_ACHIEVEMENT_DATE)
                                    }else{
                                        defaults.set(Date(), forKey: USER_DEFAULTS_TENTATIVE_GOAL_ACHIEVEMENT_DATE)
                                    }
                                    
                                    if let udefault = calorieGoalDict.value(forKey: "goal_type") as? String
                                    {
                                        defaults.set(udefault, forKey: USER_DEFAULTS_USER_GOAL_TYPE_KEY)
                                    }else{
                                        defaults.set("Maintain", forKey: USER_DEFAULTS_USER_GOAL_TYPE_KEY)
                                    }
                                    
                                    if let udefault = calorieGoalDict.value(forKey: "goal_weight") as? Float
                                    {
                                        defaults.set(udefault, forKey: USER_DEFAULTS_USER_GOAL_WEIGHT_KEY)
                                    }else{
                                        defaults.set(50.0, forKey: USER_DEFAULTS_USER_GOAL_WEIGHT_KEY)
                                    }
                                    
                                    if let udefault = calorieGoalDict.value(forKey: "weekly_goal") as? Float
                                    {
                                        defaults.set(udefault, forKey: USER_DEFAULTS_USER_WEEKLY_GOAL_WEIGHT_KEY)
                                    }else{
                                        defaults.set(0.0, forKey: USER_DEFAULTS_USER_WEEKLY_GOAL_WEIGHT_KEY)
                                    }
                                }else{
                                    defaults.set("Sedentary", forKey: USER_DEFAULTS_USER_ACTIVITY_TYPE_KEY)
                                    defaults.set(40.0, forKey: USER_DEFAULTS_USER_CURRRENT_WEIGHT_KEY)
                                    defaults.set(1200.0, forKey: USER_DEFAULTS_USER_GOAL_CALORIE)
                                    
                                    defaults.set(Date(), forKey: USER_DEFAULTS_TENTATIVE_GOAL_ACHIEVEMENT_DATE)
                                    defaults.set("Maintain", forKey: USER_DEFAULTS_USER_GOAL_TYPE_KEY)
                                    defaults.set(50.0, forKey: USER_DEFAULTS_USER_GOAL_WEIGHT_KEY)
                                    defaults.set(0.0, forKey: USER_DEFAULTS_USER_WEEKLY_GOAL_WEIGHT_KEY)
                                }
                                
                                
                                let joiningdatestr : [String] = (dicUserDetail.value(forKey: "created_at") as! String).components(separatedBy: "T")
                                
                                let joiningdate : Date = utils.convertStringToDate(joiningdatestr[0], dateFormat: "yyyy-MM-dd")
                                NSLog("joining date ; \(joiningdate)")
                                self.getJoiningTime(joiningdate)
                                
                                
                                 let homeTabBarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "myTabbarControllerID")
                                
                                self.navigationController?.pushViewController(homeTabBarController, animated: true)
                                
                                
                            }else if strStatus == "1" {
                                utils.customAlertView("You have entered invalid password. Please try correct password.", view: self.view)
                                
                            }else if strStatus == "2" {
                                utils.customAlertView("You may have entered invalid username / password. Please try again.", view: self.view)
                            }
            },
                          failure: { (operation, error) in
                            self.stopAnimating()
                            utils.failureBlock(self.view)
                            NSLog("We got an error here.. \(error?.localizedDescription)")
            } )
  
    }

    func getJoiningTime(_ joiningDate : Date) {
        let currentDAte = Date()
        let years = currentDAte.yearsFrom(joiningDate)
        let months = currentDAte.monthsFrom(joiningDate)
        let days = currentDAte.daysFrom(joiningDate)
        
        if years != 0 {
            defaults.setValue(String("Joined \(years) year(s) ago."), forKey: USER_DEFAULTS_USER_JOINING_PERIOD)
        }else if months != 0 {
            defaults.setValue(String("Joined \(months) month(s) ago."), forKey: USER_DEFAULTS_USER_JOINING_PERIOD)
        }else if days != 0 {
            defaults.setValue(String("Joined \(days) day(s) ago."), forKey: USER_DEFAULTS_USER_JOINING_PERIOD)
        }else{
            defaults.setValue(String("Joined today."), forKey: USER_DEFAULTS_USER_JOINING_PERIOD)
        }
    }
}
