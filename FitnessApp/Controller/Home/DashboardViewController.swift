//
//  DashboardViewController.swift
//  MapMyDiet
//
//  Created by ved on 15/02/16.
//  Copyright © 2016 ved. All rights reserved.
//

import UIKit
import HealthKit

class DashboardViewController: UIViewController,LeftSideViewControllerDelegate,UIScrollViewDelegate,JTCalendarDelegate {
//
    
    @IBOutlet weak var progressBarSteps: UIProgressView!
    @IBOutlet weak var progressBarCaloriesBurned: UIProgressView!
    @IBOutlet weak var lblCaloriesBurned: UILabel!
    @IBOutlet weak var tblView: UITableView!
   
    
    
    
    
    
    
//
    let healthManager:HealthManager = HealthManager()
    var numberOfSteps : Int = 0
    //var defaults : NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    @IBOutlet weak var calorieConsumedprogressView: KDCircularProgress!
    @IBOutlet weak var lblGoalCalorie: UILabel!
    @IBOutlet weak var lblStepsCount: UILabel!
    
        
    @IBOutlet weak var lblRemainingCalorieStatus: UILabel!
    @IBOutlet weak var viewRemainingCalorieStatus: UIView!
    
    @IBOutlet weak var viewConsumedTab: UIView!
    @IBOutlet weak var lblTotalConsumedCalorie: UILabel!
    
    
    @IBOutlet weak var viewBurnedTab: UIView!
    @IBOutlet weak var lblTotalBurnedCalorie: UILabel!
    
    
    @IBOutlet weak var viewNetTab: UIView!
    @IBOutlet weak var lblTotalNetCalorie: UILabel!
    
    @IBOutlet weak var lblWaterStatus: UILabel!
    @IBOutlet weak var viewWaterIntake: UIView!
    @IBOutlet weak var lblWaterIntakeGoal: UILabel!
    @IBOutlet weak var lblTodaysWaterIntake: UILabel!
    @IBOutlet weak var lblCaloriesConsumed: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var lblWeight: UILabel!
    @IBOutlet weak var viewWeight: UIView!
    
    
    @IBOutlet weak var lblDateDisplay: UILabel!
    @IBOutlet weak var calendarView: UIView!
    @IBOutlet weak var calendarMenuView: JTCalendarMenuView!
    @IBOutlet weak var calendarContentView: JTHorizontalCalendarView!
    var calendarManager : JTCalendarManager!
    var datesSelected : NSMutableArray = []

    @IBOutlet weak var viewDailyCalorieCalculation: UIView!
    
    var helloWorldTimer:NSTimer = NSTimer()
    var dailywaterGoalLtrs : Float = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.backgroundColor = UIColor(red: 0.0/255.0, green: 150.0/255.0, blue: 136.0/255.0, alpha: 1.0)
        scrollView.contentSize = CGSize(width: self.view.frame.size.width,height: self.tblView.frame.origin.y + self.tblView.frame.size.height)
      //  let leftSideViewController : LeftSideViewController = self.sidePanelController?.leftPanel as! LeftSideViewController
       // leftSideViewController.delegate = self
        NSLog("\(defaults.valueForKey(USER_DEFAULTS_USER_GOAL_CALORIE)!)")
        lblGoalCalorie.text = String("\(defaults.valueForKey(USER_DEFAULTS_USER_GOAL_CALORIE)!)")
        lblRemainingCalorieStatus.text = String("\(defaults.valueForKey(USER_DEFAULTS_USER_GOAL_CALORIE)!)")
        
        //Calendar Code : 
        
        datesSelected = NSMutableArray()
        self.view.sendSubviewToBack(calendarView)
        self.view.bringSubviewToFront(scrollView)
        //Calendar Code
        calendarView.hidden = true
        calendarManager = JTCalendarManager()
        calendarManager.delegate = self;
        calendarManager.menuView = calendarMenuView
        calendarManager.contentView = calendarContentView
        calendarManager.setDate(NSDate())
        
        calendarContentView.layer.borderColor = UIColor.orangeColor().CGColor
        calendarContentView.layer.borderWidth = 1.0
        
//        viewDailyCalorieCalculation.layer.borderColor = UIColor.darkGrayColor().CGColor
//        viewDailyCalorieCalculation.layer.borderWidth = 2.0
        
        
        
        
       // loadDefaultView()
       
    }
    
    func loadDefaultView() {
        
        
//        let weightKgs : Float = defaults.valueForKey(USER_DEFAULTS_USER_CURRRENT_WEIGHT_KEY) as! Float
//        
//        let weightLbs : Float = weightKgs * 2.2048
//        
//        let dailywaterGoaloz = weightLbs * 0.5
//        dailywaterGoalLtrs = dailywaterGoaloz / 33.814
//        lblWaterIntakeGoal.text = NSString(format: "%.01f Liters", dailywaterGoalLtrs) as String
//        var totalWaterIntake : Float = 0.0
//        if defaults.valueForKey("waterLevel") != nil {
//            totalWaterIntake = defaults.valueForKey("waterLevel")!.floatValue
//            lblTodaysWaterIntake.text = String("\(defaults.valueForKey("waterLevel")!) mLs")
//        }
//        
//        let totalWaterIntakeLtr = totalWaterIntake / 1000.0
//        if dailywaterGoalLtrs > totalWaterIntakeLtr {
//            lblWaterStatus.text = "Try Drinking More Water..!!"
//            lblWaterStatus.textColor = UIColor.redColor()
//        }else{
//            lblWaterStatus.text = "Keep It Up..!!"
//            lblWaterStatus.textColor = UIColor(red: 51.0/255.0, green: 204.0/255.0, blue: 0.0/255.0, alpha: 1.0)
//        }
        
        let goalCalorie = defaults.valueForKey(USER_DEFAULTS_USER_GOAL_CALORIE)!.floatValue
        let calorieConsumed = Float(lblTotalConsumedCalorie.text!)
        if calorieConsumed != goalCalorie {
            
            let newAngleValue = Int(360 * (calorieConsumed! / goalCalorie))
            
            calorieConsumedprogressView.animateFromAngle(0, toAngle: newAngleValue, duration: 5) { completed in
                if completed {
                    NSLog("animation stopped, completed")
                } else {
                    NSLog("animation stopped, was interrupted")
                }
            }
        }
        
        
        fetchTodaysStepFromHealthkit()
        helloWorldTimer = NSTimer.scheduledTimerWithTimeInterval(8.0, target: self, selector: Selector("fetchTodaysStepFromHealthkit"), userInfo: nil, repeats: true)

    }
    
    override func viewWillAppear(animated: Bool) {
        loadDefaultView()
    }
    
    @IBAction func onTapDate(sender: UITapGestureRecognizer) {
        self.view.bringSubviewToFront(calendarView)
        
        if calendarView.hidden == true {
            calendarView.hidden = false
        }else{
            calendarView.hidden = true;
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func showLeftPanel(sender: AnyObject) {
        //self.sidePanelController?.toggleLeftPanel(sender)
    }
    
    func menuClick(rowid: Int) {
        self.sidePanelController?.toggleLeftPanel(nil)
        if rowid == 0 {
            
            let dashboardViewController : DashBoard1ViewController = self.storyboard?.instantiateViewControllerWithIdentifier("DashBoard1ViewController") as! DashBoard1ViewController
            self.navigationController?.pushViewController(dashboardViewController, animated: true)
        }else if rowid == 1 {
            
            let progressViewcontroller : ProgressViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ProgressViewController") as! ProgressViewController
            self.navigationController?.pushViewController(progressViewcontroller, animated: true)
            
        }else if rowid == 2 {

            
        }
        
    }

    @IBAction func onClick_AddWorkoutsBtn(sender: AnyObject) {
        let addworkoutViewController : AddWorkoutViewController = self.storyboard?.instantiateViewControllerWithIdentifier("AddWorkoutViewController") as! AddWorkoutViewController
//        addworkoutViewController.lblRecentSteps.text = lblStepsCount.text
//        addworkoutViewController.lblCaloriesBurned.text = lblCaloriesBurned.text
        self.navigationController?.pushViewController(addworkoutViewController, animated: true)
        
        
        
    }
    
    
    func fetchTodaysStepFromHealthkit() {
        
        let type = HKSampleType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount)
        let startDate = NSDate.distantPast()
        let interval = NSDateComponents()
        interval.day = 1
        
        let predicate = HKQuery.predicateForSamplesWithStartDate(startDate, endDate: NSDate(), options: .StrictStartDate)
        let query = HKStatisticsCollectionQuery(quantityType: type!, quantitySamplePredicate: predicate, options: [.CumulativeSum], anchorDate: NSDate.distantPast(), intervalComponents:interval)
        
        query.initialResultsHandler = { query, results, error in
            
            
            let endDate = NSDate()
            let startDate = NSDate.distantPast()
            if let myResults = results{
                myResults.enumerateStatisticsFromDate(startDate, toDate: endDate) {
                    statistics, stop in
                    
                    if let quantity = statistics.sumQuantity() {
                        
                        let date = statistics.startDate
                        let steps = quantity.doubleValueForUnit(HKUnit.countUnit())
                        NSLog("\(date): steps = \(steps)")
                        self.numberOfSteps = Int(steps)
                        NSLog(" steps = \(self.numberOfSteps)")
                        
                        let dateFormatter = NSDateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
                        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
                        
                        let dateStr = dateFormatter.stringFromDate(date)
                        
                        let dateDte : NSDate = dateFormatter.dateFromString(dateStr)! as NSDate
                        
                        let currentDate = NSDate()
                        let currentDateStr = dateFormatter.stringFromDate(currentDate)
                        let currentDte : NSDate = dateFormatter.dateFromString(currentDateStr)! as NSDate
                        
                        
                        
                        
                        if currentDte.compare(dateDte) == NSComparisonResult.OrderedSame {
                            NSLog("current date ; \(currentDte) and date from : \(dateDte)")
                            
                            dispatch_async(dispatch_get_main_queue()) {
                                self.lblStepsCount.text = String("\(self.numberOfSteps) steps")
                                self.calculateCaloriesBurned()
                            }
                        }else{
                            NSLog("date dint match");
                        }
                    }
                }
                
            }
            
        }
        
        healthManager.healthkitstore.executeQuery(query)
        
        
    }
    
    
    func calculateCaloriesBurned() {
        var weightLbs : Float = 0.0
        var heightCms : Float = 0.0
        if defaults.objectForKey(USER_DEFAULTS_USER_CURRRENT_WEIGHT_KEY) != nil {
            let weightKgs = defaults.objectForKey(USER_DEFAULTS_USER_CURRRENT_WEIGHT_KEY)! as! Float
            weightLbs = weightKgs * 2.2046
            NSLog("weight Lbl: \(weightLbs)   weight Kgs : \(weightKgs)")
        }
        
        if defaults.objectForKey(USER_DEFAULTS_USER_HEIGHT_KEY) != nil {
            let heightFt = defaults.objectForKey(USER_DEFAULTS_USER_HEIGHT_KEY)! as! Float
            heightCms = heightFt / 0.032808
            NSLog("weight feet : \(heightFt) weight cms : \(heightCms)")
        }
        
        
        var strideLength : Float = 0.0
        
        
        if defaults.objectForKey(USER_DEFAULTS_USER_GENDER_KEY) != nil {
            NSLog("\(defaults.objectForKey(USER_DEFAULTS_USER_GENDER_KEY))")
            if defaults.objectForKey(USER_DEFAULTS_USER_GENDER_KEY)! as! String == "Male" {
                strideLength = heightCms * 0.415
            }else if defaults.objectForKey(USER_DEFAULTS_USER_GENDER_KEY)! as! String == "Female" {
                strideLength = heightCms * 0.413
            }
        }
        
        NSLog("stride length : \(strideLength)")
        
        let defaultNumberOfStepsInMile = 160934 / strideLength
        
        NSLog("defaultnumber of steps in a mile : \(defaultNumberOfStepsInMile)")
        
        
        //FOR CASUAL WALKING
        
        let caloriesBurnedPerMile = weightLbs * 0.57
        NSLog("calories Burned Per Mile : \(caloriesBurnedPerMile) ")
        
        let caloriesBurnedPerStep = caloriesBurnedPerMile / defaultNumberOfStepsInMile
        NSLog("calories Burned Per Step : \(caloriesBurnedPerStep)")
        NSLog("number of steps in float : \(self.lblStepsCount.text!)")
        
        let totalCaloriesBurned = caloriesBurnedPerStep * Float(numberOfSteps)
        
        NSLog("total Calories Burned : \(totalCaloriesBurned)")
        
        lblCaloriesBurned.text = String("\(totalCaloriesBurned)")
        var totalCalorieBurnedLblValue = Float(lblTotalBurnedCalorie.text!)
        
        if lblTotalBurnedCalorie.text == lblCaloriesBurned.text {
            lblTotalBurnedCalorie.text = lblCaloriesBurned.text
            
        }else {
            totalCalorieBurnedLblValue = totalCalorieBurnedLblValue! + totalCaloriesBurned
            var totalRemainingCalories : Float = Float(lblRemainingCalorieStatus.text!)!
            totalRemainingCalories = totalRemainingCalories + totalCaloriesBurned
            lblRemainingCalorieStatus.text = String("\(totalRemainingCalories)")
            
        }
        lblTotalBurnedCalorie.text = String("\(totalCalorieBurnedLblValue!)")
        
    }
    
    @IBAction func onClick_addWater(sender: AnyObject) {
        let waterLevelViewController = self.storyboard?.instantiateViewControllerWithIdentifier("WaterLevelViewController") as! WaterLevelViewController
        waterLevelViewController.dailyWaterGoal = dailywaterGoalLtrs
       
       // waterLevelViewController.modalTransitionStyle = .FlipHorizontal
        //self.navigationController?.presentViewController(waterLevelViewController, animated: true, completion: nil)
        self.navigationController?.pushViewController(waterLevelViewController, animated: true)
    }
    
//MARK: Next & Previous Button Click Events
    
    @IBAction func onClick_PreviousBtn(sender: AnyObject) {
        
        if lblDateDisplay.text == "Today"  {
          
            let calculatedDate = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Day, value: -1, toDate: NSDate(), options: NSCalendarOptions.init(rawValue: 0))
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            
            let displayedDate : String = dateFormatter.stringFromDate(calculatedDate!)
            lblDateDisplay.text = displayedDate
            calendarManager.setDate(calculatedDate)
            calendarManager.reload()
            
        }else {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            NSLog(" \(lblDateDisplay.text)")
            let displayedDate : NSDate = dateFormatter.dateFromString(lblDateDisplay.text!)!
            
            
            
            let calculatedDate = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Day, value: -1, toDate: displayedDate, options: NSCalendarOptions.init(rawValue: 0))
            
            
            if calculatedDate == NSDate() {
                
                lblDateDisplay.text = "Today"
            }
            else{
                let displayedStr : String = dateFormatter.stringFromDate(calculatedDate!)
                lblDateDisplay.text = displayedStr
            }
            
            calendarManager.setDate(calculatedDate)
            calendarManager.reload()
        }
        
        
        
        
        
        
       // calendarContentView.loadPreviousPageWithAnimation()
    }
    
    @IBAction func onClick_NextBtn(sender: AnyObject) {
        if lblDateDisplay.text == "Today"  {
            
            let calculatedDate = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Day, value: +1, toDate: NSDate(), options: NSCalendarOptions.init(rawValue: 0))
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            
            let displayedDate : String = dateFormatter.stringFromDate(calculatedDate!)
            lblDateDisplay.text = displayedDate
            calendarManager.setDate(calculatedDate)
            calendarManager.reload()
            SELECTED_DATE = calculatedDate!
        }else {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            NSLog(" \(lblDateDisplay.text)")
            let displayedDate : NSDate = dateFormatter.dateFromString(lblDateDisplay.text!)!
            
            
            
            let calculatedDate = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Day, value: +1, toDate: displayedDate, options: NSCalendarOptions.init(rawValue: 0))
            
            if calculatedDate == NSDate() {
            
                lblDateDisplay.text = "Today"
            }
            else{
                let displayedStr : String = dateFormatter.stringFromDate(calculatedDate!)
                lblDateDisplay.text = displayedStr
            }
            
            calendarManager.setDate(calculatedDate)
            calendarManager.reload()
            SELECTED_DATE = calculatedDate!
        }
        
    }
    
//MARK : JTCalendar Delegate & DataSource
    
    func isInDatesSelected(date : NSDate) -> Bool {
        for datesel in datesSelected {
            if calendarManager.dateHelper.date(datesel as! NSDate, isTheSameDayThan: date) {
                return true
            }
        }
        return false
        
    }
    
    
    
    func calendar(calendar: JTCalendarManager!, prepareDayView dayView: UIView!) {
        
        let dayView : JTCalendarDayView = dayView as! JTCalendarDayView
        let outputTimeZone : NSTimeZone = NSTimeZone.localTimeZone()
        let outputDateFormatter = NSDateFormatter()
        outputDateFormatter.timeZone = outputTimeZone
        outputDateFormatter.dateFormat = "MMM dd, yyyy"
        
        let selectedDate : String = outputDateFormatter.stringFromDate(dayView.date)
        //NSLog("selected DAte : \(selectedDate)")
        
        // Today
        if calendarManager.dateHelper.date(NSDate(), isTheSameDayThan: dayView.date) {
            dayView.circleView.hidden = false
            dayView.circleView.backgroundColor = UIColor.blueColor()
            dayView.dotView.backgroundColor = UIColor.whiteColor()
            dayView.textLabel.textColor = UIColor.whiteColor()
        }
            // Selected date
        else if isInDatesSelected(dayView.date) {
            dayView.circleView.hidden = false;
            dayView.circleView.backgroundColor = UIColor.redColor()
            dayView.dotView.backgroundColor = UIColor.whiteColor()
            dayView.textLabel.textColor = UIColor.whiteColor()
        }
            // Other month
        else if calendarManager.dateHelper.date(calendarContentView.date, isTheSameMonthThan: dayView.date) {
            dayView.circleView.hidden = true;
            dayView.dotView.backgroundColor = UIColor.redColor()
            dayView.textLabel.textColor =  UIColor.lightGrayColor()
        }
            
            // Another day of the current month
        else{
            dayView.circleView.hidden = true;
            dayView.dotView.backgroundColor = UIColor.redColor()
            dayView.textLabel.textColor = UIColor.blackColor()
            //calendarView.hidden = true;
            
        }
        //calendarManager.reload()
    }
    
    func calendar(calendar: JTCalendarManager!, didTouchDayView dayView: UIView!) {
        
        
        let dayView : JTCalendarDayView = dayView as! JTCalendarDayView
        
        let outputTimeZone : NSTimeZone = NSTimeZone.localTimeZone()
        let outputDateFormatter = NSDateFormatter()
        outputDateFormatter.timeZone = outputTimeZone
        outputDateFormatter.dateFormat = "MMM dd, yyyy"
        
        let selectedDate : String = outputDateFormatter.stringFromDate(dayView.date)
        //NSLog("selected DAte : \(selectedDate)")
        self.lblDateDisplay.text = selectedDate
        
        if isInDatesSelected(dayView.date) {
            datesSelected .removeObject(dayView.date)
            UIView.transitionWithView(dayView, duration: 0.3, options: UIViewAnimationOptions.TransitionNone, animations: { () -> Void in
                self.calendarManager.reload()
                dayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1)
                }, completion: nil)
            
        }else{
            datesSelected.addObject(dayView.date)
            dayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
            UIView.transitionWithView(dayView, duration: 0.3, options: UIViewAnimationOptions.TransitionNone, animations: { () -> Void in
                self.calendarManager.reload()
                dayView.circleView.transform = CGAffineTransformIdentity
                }, completion: nil)
            
        }
        // Load the previous or next page if touch a day from another month
        if !calendarManager.dateHelper.date(calendarContentView.date, isTheSameMonthThan: dayView.date) {
            if calendarContentView.date.compare(dayView.date) == NSComparisonResult.OrderedAscending {
                calendarContentView.loadNextPageWithAnimation()
            }else{
                calendarContentView.loadPreviousPageWithAnimation()
            }
        }
        calendarView.hidden = true
    }   

   

}
