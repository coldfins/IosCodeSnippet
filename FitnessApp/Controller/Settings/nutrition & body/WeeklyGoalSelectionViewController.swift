//
//  WeeklyGoalSelectionViewController.swift
//  MapMyDiet
//
//  Created by ved on 20/04/16.
//  Copyright © 2016 ved. All rights reserved.
//

import UIKit

protocol WeeklyGoalSelectionViewControllerDelegate {
    
    func goalSetSuccessfully(_ goalSuccess : Bool)
    
}


class WeeklyGoalSelectionViewController: UIViewController, NVActivityIndicatorViewable, UITableViewDelegate,UITableViewDataSource {
    var delegate: WeeklyGoalSelectionViewControllerDelegate!
    @IBOutlet weak var viewMessage: UIView!
    @IBOutlet weak var tblview: UITableView!
    var isChecked : Bool = false
    var selectedWeeklyGoal : Float = 0.0
    var estimatedDate : String = ""
    var goalType : String = ""
    var goal_weight : Float = 0.0
    var activity_type : String = ""
    var arrayList : NSMutableArray = NSMutableArray()
    var isGoalSelected : Bool = false
    var dictselectedGoal : NSDictionary?
    var calorie : Float = 0.0
    var goal_endDate : Date = Date()
    var currentweight : Float = 0.0
    
    @IBOutlet weak var lblMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let border2 : CALayer = CALayer()
        border2.borderColor = utils.colorBorder.cgColor
        border2.frame = CGRect(x: 0, y: viewMessage.frame.size.height - 1, width: viewMessage.frame.size.width, height: viewMessage.frame.size.height)
        border2.borderWidth = 1
        viewMessage.layer.addSublayer(border2)
        viewMessage.layer.masksToBounds = true
        
        let nib = UINib(nibName: "WeeklyGoalCell", bundle: nil)
        tblview.register(nib, forCellReuseIdentifier: "acell")
        var weeklyGoal : Float = 0.25
        var calorieDeficit : Int = 125
        currentweight = (defaults.value(forKey: USER_DEFAULTS_USER_CURRRENT_WEIGHT_KEY)! as AnyObject).floatValue
        NSLog("goal type ; \(goalType)")
        
        for _ in 0 ..< 8 {
            
            let dict : NSMutableDictionary = NSMutableDictionary()
            dict.setValue(weeklyGoal, forKey: "weeklyGoal")
            dict.setValue(calorieDeficit, forKey: "calorieDeficit")
            if goalType == "Gain" {
                let weightDiff = goal_weight - currentweight
                let timeToGain = weightDiff / weeklyGoal
                let calculatedDate = (Calendar.current as NSCalendar).date(byAdding: .weekOfYear, value: Int(timeToGain), to: Date(), options: NSCalendar.Options.init(rawValue: 0))
                    dict.setValue(calculatedDate, forKey: "estimatedDate")
            }else if goalType == "Lose" {
                let weightDiff = currentweight - goal_weight
                let timeToGain = weightDiff / weeklyGoal
                let calculatedDate = (Calendar.current as NSCalendar).date(byAdding: .weekOfYear, value: Int(timeToGain), to: Date(), options: NSCalendar.Options.init(rawValue: 0))
                dict.setValue(calculatedDate, forKey: "estimatedDate")
            }else{
            
            
            }
            
            weeklyGoal = weeklyGoal + 0.25
            calorieDeficit = calorieDeficit + 125
            
            arrayList.add(dict)

        }
        animateTable()
        
        
        
        print("array : \(arrayList)")
        
        
    }
    
    func animateTable()
    {
        tblview.reloadData()
        
        let cells = tblview.visibleCells
        let tableHeight: CGFloat = tblview.bounds.size.height
        
        for i in cells {
            let cell: UITableViewCell = i as! WeeklyGoalCell
            cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
        }
        
        var index = 0
        
        for a in cells {
            let cell: UITableViewCell = a as! WeeklyGoalCell
            UIView.animate(withDuration: 1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0);
                }, completion: nil)
            
            index += 1
        }
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : WeeklyGoalCell? = tableView.dequeueReusableCell(withIdentifier: "acell") as? WeeklyGoalCell
        let dict = arrayList.object(at: indexPath.row)
        cell?.lblGoalType.text = goalType
        let datestr = utils.convertDateToString((dict as AnyObject).value(forKey: "estimatedDate") as! Date, format: "MMM dd, yyyy")
        cell?.lblEstimatedDate.text = datestr
        cell?.lblweeklyGoal.text = String("\((dict as AnyObject).value(forKey: "weeklyGoal")!) Kgs per week")
        
        if goalType == "Gain" {
            cell?.lblCaloriePerDay.text = String("+ \((dict as AnyObject).value(forKey: "calorieDeficit")!) cal / day")
            
        }else if goalType == "Lose" {
            cell?.lblCaloriePerDay.text = String("- \((dict as AnyObject).value(forKey: "calorieDeficit")!) cal / day")
        }
        
       // cell?.btnChk.addTarget(self, action: Selector("selectGoal:"), forControlEvents: .TouchUpInside)
        cell?.selectionStyle = .gray
//        let bgColorView = UIView()
//        bgColorView.backgroundColor = UIColor.redColor()
//        cell!.selectedBackgroundView = bgColorView

        return cell!
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let cell = tblview.dequeueReusableCellWithIdentifier("acell", forIndexPath: indexPath) as! WeeklyGoalCell
//        cell.backgroundColor = UIColor(red: 0.0/255.0, green: 150.0/255.0, blue: 136.0/255.0, alpha: 0.5)
//        cell.setSelected(true, animated: true)
//        let bgColorView = UIView()
//        bgColorView.backgroundColor = UIColor.redColor()
//        cell.selectedBackgroundView = bgColorView
//        cell.btnChk.selected = true
//        if cell.btnChk.selected == false {
//            cell.btnChk.selected = true
//        }
        dictselectedGoal = arrayList.object(at: indexPath.row) as? NSDictionary
    }
    
    @IBAction func onclick_backbtn(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClick_setGoal(_ sender: AnyObject) {
        if dictselectedGoal != nil {
            calorie = calculateDailyCalorie()
           let size = CGSize(width: 30, height:30)
        startAnimating(size, message: nil, type: NVActivityIndicatorType(rawValue: 22)!)
            
            let userid : Int = defaults.value(forKey: USER_DEFAULTS_USER_ID_KEY) as! Int
            let url : String = String("\(API_BASE_URL)/\(API_UPDATE_DAILY_CALORIE_GOAL)")
            NSLog("userid : \(userid)")
            NSLog("current_weight : \(currentweight)")
            NSLog("NSDate() : \(Date())")
            NSLog("goal_weight : \(goal_weight)")
            NSLog("weeklyGoal : \(selectedWeeklyGoal)")
            NSLog("txtfieldActivityType.text! : \(activity_type)")
            NSLog("selectedGoalType : \(goalType)")
            NSLog("USER_DEFAULTS_TENTATIVE_GOAL_ACHIEVEMENT_DATE : \(goal_endDate)")
            NSLog("calorie : \(calorie)")
            
                       
            let parameters : NSDictionary = ["user_id":userid,"current_weight":currentweight,"start_date":Date(),"goal_weight":goal_weight,"weekly_goal_weight":selectedWeeklyGoal,"activity_type":activity_type,"goal_type":goalType,"end_date":goal_endDate,"user_calories_goal":calorie]
            NSLog("parameters : \(parameters)")
            let manager = AFHTTPRequestOperationManager()
            manager.post( url, parameters: parameters,
                success: { (operation, responseObject) in
                    self.stopAnimating()
                    NSLog("Yes thies was a success \((responseObject as AnyObject).description)")
                    let element : NSDictionary = responseObject as! NSDictionary
                    let strStatus : String = element.value(forKey: "status") as! String
                    let strcode : String = element.value(forKey: "code") as! String
                    if strStatus == "success" {
                        if let delegate = self.delegate {
                            delegate.goalSetSuccessfully(true)
                        }
                        
                        defaults.set(self.goal_weight, forKey: USER_DEFAULTS_USER_GOAL_WEIGHT_KEY)
                        defaults.set(self.selectedWeeklyGoal, forKey: USER_DEFAULTS_USER_WEEKLY_GOAL_WEIGHT_KEY)
                        defaults.set(self.activity_type, forKey: USER_DEFAULTS_USER_ACTIVITY_TYPE_KEY)
                        defaults.set(self.goalType, forKey: USER_DEFAULTS_USER_GOAL_TYPE_KEY)
                        defaults.set(self.goal_endDate, forKey: USER_DEFAULTS_TENTATIVE_GOAL_ACHIEVEMENT_DATE)
                        defaults.set(self.calorie, forKey: USER_DEFAULTS_USER_GOAL_CALORIE)
                    
                        self.navigationController?.popViewController(animated: true)
                        
                    }else if strcode == "-1" {
                        //If invalid data entered
                        utils.customAlertView("Something went wrong. Try Again.", view: self.view)
                        
                        //Custom Alert view for invalid user name and password
                    }
                },
                failure: { (operation, error) in
                    self.stopAnimating()
                    //custom Alert View for network error
                    utils.failureBlock(self.view)
                    NSLog("We got an error here.. \(error?.localizedDescription)")
            } )
        
        }else{
            lblMessage.text = String("Please select your weekly goal to \(goalType) weight to start your weight plan.")
            lblMessage.textColor = UIColor.red
        }
    }
    
    
    func calculateDailyCalorie() -> Float {
        var bmr : Float = 0.0

        NSLog("height : \(defaults.value(forKey: USER_DEFAULTS_USER_HEIGHT_KEY)!)")
        
        let strheightIN : String = String("\(defaults.value(forKey: USER_DEFAULTS_USER_HEIGHT_KEY)!)")
        let heightIN : Float = Float(strheightIN)!
        let heightCMS : Float = heightIN / 0.032808
        
        
        
        NSLog("dob ; \(defaults.value(forKey: USER_DEFAULTS_USER_DOB_KEY) as! String)")
        let age = calculateAgeFromBirthdate(defaults.value(forKey: USER_DEFAULTS_USER_DOB_KEY) as! String)
        NSLog("age : \(age)")
        if defaults.value(forKey: USER_DEFAULTS_USER_GENDER_KEY) != nil {
            if defaults.value(forKey: USER_DEFAULTS_USER_GENDER_KEY) as! String == "Male" {
                bmr = 66.47 + (13.75 * currentweight) + (5.0 * heightCMS) - (6.75 * Float(age))
            }else if defaults.value(forKey: USER_DEFAULTS_USER_GENDER_KEY) as! String == "Female" {
                bmr = 665.09 + (9.56 * currentweight) + (1.84 * heightCMS) - (4.67 * Float(age))
            }
        }
        
        
        let selectedActivityType : String = activity_type
        
        if selectedActivityType == "Sedentary" {
            calorie = bmr * 1.2
        }else if selectedActivityType == "Light Active" {
            calorie = bmr * 1.375
        }else if selectedActivityType == "Moderate Active" {
            calorie = bmr * 1.55
        }else if selectedActivityType == "Very Active" {
            calorie = bmr * 1.725
        }else if selectedActivityType == "Extra Active" {
            calorie = bmr * 1.9
        }
        
        
        if goalType == "Gain" {
            
            selectedWeeklyGoal = dictselectedGoal?.value(forKey: "weeklyGoal") as! Float
            let calorieDeficit : Float = Float(dictselectedGoal?.value(forKey: "calorieDeficit") as! Int)
            
            calorie = calorie + calorieDeficit
            goal_endDate = dictselectedGoal?.value(forKey: "estimatedDate") as! Date
            
            
            NSLog("calculated date ; \(goal_endDate)")
            
            
        }else if goalType == "Lose" {
            selectedWeeklyGoal = dictselectedGoal?.value(forKey: "weeklyGoal") as! Float
            let calorieDeficit : Float = Float(dictselectedGoal?.value(forKey: "calorieDeficit") as! Int)
            
            calorie = calorie - calorieDeficit
            goal_endDate = dictselectedGoal?.value(forKey: "estimatedDate") as! Date
            
            
            NSLog("calculated date ; \(goal_endDate)")
            
        }else if goalType == "Maintain" {
            selectedWeeklyGoal = 0.0
            defaults.set(0.0, forKey: USER_DEFAULTS_USER_WEEKLY_GOAL_WEIGHT_KEY)
            defaults.set(Date.distantFuture, forKey: USER_DEFAULTS_TENTATIVE_GOAL_ACHIEVEMENT_DATE)
            
        }
        return calorie
        
    }
    
    
    func calculateAgeFromBirthdate(_ dob : String) -> Int {
        
        
        
        var start = dob as String
        NSLog("start : \(start)");
        let end = Date()
        start = "2006/3/20"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let startDate : Date = utils.convertStringToDate(start, dateFormat: "yyyy-MM-dd")
        NSLog("startdate : \(startDate)")
        let endDate:Date = end
        
        let cal = Calendar.current
        
        
        let unit : NSCalendar.Unit = NSCalendar.Unit.year
        
        let components = (cal as NSCalendar).components(unit, from: startDate, to: endDate, options: NSCalendar.Options.matchFirst)
        return components.year!
        
        
        
    }


}
