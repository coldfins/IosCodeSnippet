//
//  DashBoard1ViewController.swift
//  MapMyDiet
//
//  Created by Coldfin Lab on 14/03/16.
//  Copyright © 2016 Coldfin Lab. All rights reserved.
//

import UIKit
import HealthKit

class DashBoard1ViewController: UIViewController, NVActivityIndicatorViewable, UIScrollViewDelegate,JTCalendarDelegate,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var bgview: UIView!
   //StepCount  View
    @IBOutlet weak var lblRemaingStepCount: UILabel!
    @IBOutlet weak var lblGoalSteps: UILabel!
    @IBOutlet weak var lblTotalNumberOfStepsTaken: UILabel!
    @IBOutlet weak var circularProgressStepsTaken: KNCirclePercentView!
    
  //Calorie Count View
    @IBOutlet weak var circularProgressCalorieConsumed: KNCirclePercentView!
    @IBOutlet weak var lblGoalCalorie: UILabel!
    @IBOutlet weak var lblTotalConsumedCalorie: UILabel!
    @IBOutlet weak var lblRemainingCalorieStatus: UILabel!
//     @IBOutlet weak var circularProgressCalorieConsumed: KDCircularProgress!
    
  //Progress View - Calorie consumed View
    @IBOutlet weak var lblDisplaycalorieValue: UILabel!
    @IBOutlet weak var progressBarCaloriesConsumed: YLProgressBar!
    
    
  //Progress View - Steps View
    
    @IBOutlet weak var lblStepsCount: UILabel!
    @IBOutlet weak var lblCaloriesBurnedFromSteps: UILabel!
    @IBOutlet weak var progressBarSteps: YLProgressBar!
    
    
  //Progress View - calorie burned View
    @IBOutlet weak var lblTotalBurnedCalorie: UILabel!
    @IBOutlet weak var progressBarCaloriesBurned: YLProgressBar!
    
    
    @IBOutlet weak var imgDisplay: UIImageView!
    @IBOutlet weak var lblDisplayText: UILabel!
    @IBOutlet var viewFlip: UIView!
    @IBOutlet var viewStepsDisplay: UIView!
    @IBOutlet var viewCalorieDisplay: UIView!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var viewTableview: UIView!
    @IBOutlet weak var viewRemainingCalorieStatus: UIView!
    
    @IBOutlet weak var viewSteps_CalorieBurn: UIView!
//    
//    
//    @IBOutlet weak var viewNetTab: UIView!
//   @IBOutlet weak var lblTotalNetCalorie: UILabel!
//    
//    @IBOutlet weak var lblWaterStatus: UILabel!
//    @IBOutlet weak var viewWaterIntake: UIView!
//    @IBOutlet weak var lblWaterIntakeGoal: UILabel!
//    @IBOutlet weak var lblTodaysWaterIntake: UILabel!
//    @IBOutlet weak var lblCaloriesConsumed: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    @IBOutlet weak var lblDateDisplay: UILabel!
    @IBOutlet weak var calView: UIView!
    @IBOutlet weak var calendarMenuView: JTCalendarMenuView!
    @IBOutlet weak var calendarContentView: JTHorizontalCalendarView!
    
//    @IBOutlet weak var calendarView: CVCalendarView!
//    @IBOutlet weak var menuView: CVCalendarMenuView!
    
    @IBOutlet weak var viewDate: UIView!
    
    @IBOutlet weak var lblCalorieBurnedValue: UILabel!
    @IBOutlet weak var lblCalorieConsumedValue: UILabel!
    @IBOutlet weak var lblweightValue: UILabel!
    @IBOutlet weak var lblwaterValue: UILabel!
    
    
    let healthManager:HealthManager = HealthManager()
    var numberOfSteps : Int = 0
    
    var calendarManager : JTCalendarManager!
    var datesSelected : NSMutableArray = []
    var helloWorldTimer:Timer = Timer()
    var dailywaterGoalLtrs : Float = 0.0
    var arrayImgsModules : [String] = ["Eaten25.png","Burn25.png","water25.png","Weight25.png"]
    var arrayModules : [String] = ["Food Consumed","Exercise Performed","Water","Weight"];
    
    var arrayValue : [String] = [];
    var prevSteps : Int = 0
    var isFlipped = false
    var isConnected : Bool!
    //var selectedDay:DayView!
    var animationFinished = true
    
    var arrayExercisesPerformed : NSMutableArray = []
    var arrayFoodsConsumed : NSMutableArray = []
    var stepsGoal : Int = 10000
    var isFoundSteps : Bool = false
    
    
    func authorizeHealthKit()
    {
        healthManager.authorizeHealthKit { (success, error) -> Void in
        
            if success {
                NSLog("HealthKit is authorized successfully")
            }else{
                NSLog("HealthKit authorization denied.")
                if error != nil {
                    NSLog("\(error)")
                }
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        redirect()
        authorizeHealthKit()
        loadDefaultValues()
        setLayouts()
        tblView.reloadData()
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(DashBoard1ViewController.reachabilityDidChange(_:)), name: NSNotification.Name.reachabilityChanged, object: nil)

        
        
        let nib = UINib(nibName: "DashboardTableViewCell", bundle: nil)
        tblView.register(nib, forCellReuseIdentifier: "acell")
        
        lblGoalCalorie.text = String("\(defaults.value(forKey: USER_DEFAULTS_USER_GOAL_CALORIE)!)")
        lblRemainingCalorieStatus.text = String("\(defaults.value(forKey: USER_DEFAULTS_USER_GOAL_CALORIE)!)")
        
        //Calendar
        datesSelected = NSMutableArray()
        datesSelected.add(Date())
        self.view.sendSubview(toBack: calView)
        //Calendar Code
        calView.isHidden = true
        calendarManager = JTCalendarManager()
        calendarManager.delegate = self;
        calendarManager.menuView = calendarMenuView
        calendarManager.contentView = calendarContentView
        calendarManager.setDate(Date())
        
        calView.layer.borderColor = utils.colorTheme.cgColor
        calView.layer.borderWidth = 1.0
        
        //setLayouts()
    }
    
    func reachabilityDidChange(_ notification : Notification) {
        if ReachabilityManager.isReachable() {
            isConnected = true
        }else{
            isConnected = false
            utils.customAlertView("Poor Internet Connection. Make sure you are connected to internet.", view: self.view)

        }
    }

    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
         scrollView.contentSize = CGSize(width: self.view.frame.size.width,height: self.viewTableview.frame.origin.y + self.viewTableview.frame.size.height)
        NSLog("content size : \(scrollView.contentSize)")
         //scrollView.frame = CGRectMake(scrollView.frame.origin.x, scrollView.frame.origin.y, self.view.frame.width, self.view.frame.height - viewDate.frame.height + 44)
        //fetchSteps()
        setFetchedValues()
        
        
    }
    
    override func viewDidLayoutSubviews() {
//        calendarView.commitCalendarViewUpdate()
//        menuView.commitMenuViewUpdate()
//        calendarView.changeDaysOutShowingState(false)
//        shouldShowDaysOut = true
    }
    
    func setLayouts() {
        
        progressBarCaloriesConsumed.progressTintColor = utils.colorTheme
        progressBarCaloriesConsumed.hideStripes = true
        progressBarCaloriesConsumed.progressTintColors = [utils.colorTheme,utils.colorTheme]
        
        
        progressBarSteps.progressTintColor = UIColor(red: 255.0/255.0, green: 121.0/255.0, blue: 186.0/255.0, alpha: 1.0)
        progressBarSteps.hideStripes = true
        progressBarSteps.progressTintColors = [UIColor(red: 255.0/255.0, green: 121.0/255.0, blue: 186.0/255.0, alpha: 1.0),UIColor(red: 255.0/255.0, green: 121.0/255.0, blue: 186.0/255.0, alpha: 1.0)]
        
        
        progressBarCaloriesBurned.progressTintColor = UIColor(red: 255.0/255.0, green: 172.0/255.0, blue: 95.0/255.0, alpha: 1.0)
        progressBarCaloriesBurned.hideStripes = true
        progressBarCaloriesBurned.progressTintColors = [UIColor(red: 255.0/255.0, green: 172.0/255.0, blue: 95.0/255.0, alpha: 1.0),UIColor(red: 255.0/255.0, green: 172.0/255.0, blue: 95.0/255.0, alpha: 1.0)]
        
        let border0: CALayer = CALayer()
        border0.borderColor = utils.colorBorder.cgColor
        border0.frame = CGRect(x: 0, y: viewDate.frame.size.height - 1, width: viewDate.frame.size.width, height: viewDate.frame.size.height)
        border0.borderWidth = 1
        viewDate.layer.addSublayer(border0)
        viewDate.layer.masksToBounds = true
        
        
        
        let border1: CALayer = CALayer()
        let borderWidth1: CGFloat = 1
        border1.borderColor = utils.colorBorder.cgColor
        border1.frame = CGRect(x: 0, y: viewFlip.frame.size.height - borderWidth1, width: viewFlip.frame.size.width, height: viewFlip.frame.size.height)
        border1.borderWidth = borderWidth1
        viewFlip.layer.addSublayer(border1)
        viewFlip.layer.masksToBounds = true
        
        
        let border2: CALayer = CALayer()
      //  let borderWidth1: CGFloat = 1
        border2.borderColor = utils.colorBorder.cgColor
        border2.frame = CGRect(x: 0, y: viewSteps_CalorieBurn.frame.size.height - borderWidth1, width: viewSteps_CalorieBurn.frame.size.width, height: viewSteps_CalorieBurn.frame.size.height)
        border2.borderWidth = borderWidth1
        viewSteps_CalorieBurn.layer.addSublayer(border2)
        viewSteps_CalorieBurn.layer.masksToBounds = true
        
        
        //CIRCULAR PROGRESS BAR 
        circularProgressCalorieConsumed.backgroundColor = UIColor.clear

        circularProgressCalorieConsumed.drawCircle(withPercent: 0, duration: 2, lineWidth: 10, clockwise: true, lineCap: kCALineCapRound, fill: UIColor.clear, stroke: utils.colorTheme, animatedColors: nil)
        
        circularProgressStepsTaken.backgroundColor = UIColor.clear
        
        circularProgressStepsTaken.drawCircle(withPercent: 0, duration: 2, lineWidth: 10, clockwise: true, lineCap: kCALineCapRound, fill: UIColor.clear, stroke: utils.colorSteps, animatedColors: nil)
        
//        let border3: CALayer = CALayer()
//        border3.borderColor = utils.colorBorder.CGColor
//        border3.frame = CGRectMake(0, viewTableview.frame.size.height - borderWidth1, viewTableview.frame.size.width, viewTableview.frame.size.height)
//        border3.borderWidth = borderWidth1
//        viewTableview.layer.addSublayer(border3)
//        viewTableview.layer.masksToBounds = true
        
        calView.layer.cornerRadius = 2
        let shadowPath: UIBezierPath = UIBezierPath(rect: calView.bounds)
        calView.layer.masksToBounds = false
        calView.layer.shadowColor = UIColor.gray.cgColor
        calView.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        calView.layer.shadowOpacity = 1
        calView.layer.shadowPath = shadowPath.cgPath
        
//        viewDate.layer.cornerRadius = 2
//        let shadowPath0: UIBezierPath = UIBezierPath(rect: viewDate.bounds)
//        viewDate.layer.masksToBounds = false
//        viewDate.layer.shadowColor = UIColor(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 1.0).CGColor
//        viewDate.layer.shadowOffset = CGSizeMake(0.0,2.0)
//        viewDate.layer.shadowOpacity = 0.5
//        viewDate.layer.shadowPath = shadowPath0.CGPath
//
        viewFlip.layer.cornerRadius = 2
        let shadowPath1: UIBezierPath = UIBezierPath(rect: viewFlip.bounds)
        viewFlip.layer.masksToBounds = false
        viewFlip.layer.shadowColor = UIColor(red: 244.0/255.0, green: 244.0/255.0, blue: 244.0/255.0, alpha: 1.0).cgColor
        viewFlip.layer.shadowOffset = CGSize(width: 0.0,height: 4.0)
        viewFlip.layer.shadowOpacity = 0.75
        viewFlip.layer.shadowPath = shadowPath1.cgPath
//
//        viewSteps_CalorieBurn.layer.cornerRadius = 2
//        let shadowPath1: UIBezierPath = UIBezierPath(rect: viewSteps_CalorieBurn.bounds)
//        viewSteps_CalorieBurn.layer.masksToBounds = false
//        viewSteps_CalorieBurn.layer.shadowColor = UIColor(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 1.0).CGColor
//        viewSteps_CalorieBurn.layer.shadowOffset = CGSizeMake(0.0, 3.0)
//        viewSteps_CalorieBurn.layer.shadowOpacity = 0.5
//        viewSteps_CalorieBurn.layer.shadowPath = shadowPath1.CGPath
//
//        viewTableview.layer.cornerRadius = 2
//        let shadowPath2: UIBezierPath = UIBezierPath(rect: viewTableview.bounds)
//        viewTableview.layer.masksToBounds = false
//        viewTableview.layer.shadowColor = UIColor(red: 244.0/255.0, green: 244.0/255.0, blue: 244.0/255.0, alpha: 1.0).CGColor
//        viewTableview.layer.shadowOffset = CGSizeMake(0.0, 3.0)
//        viewTableview.layer.shadowOpacity = 0.5
//        viewTableview.layer.shadowPath = shadowPath2.CGPath

        
    }
    
    func loadDefaultValues() {
        
        lblDateDisplay.text = utils.convertDateToString(Date(), format: "MMM dd, yyyy")
        
        arrayExercisesPerformed = NSMutableArray()
        arrayFoodsConsumed = NSMutableArray()
        
        if defaults.value(forKey: USER_DEFAULTS_USER_CURRRENT_WEIGHT_KEY) != nil {
            let currWeight = defaults.value(forKey: USER_DEFAULTS_USER_CURRRENT_WEIGHT_KEY) as! Float
            let goalWeight = defaults.value(forKey: USER_DEFAULTS_USER_GOAL_WEIGHT_KEY) as! Float
            let goalType = defaults.value(forKey: USER_DEFAULTS_USER_GOAL_TYPE_KEY) as! String
           
            if goalType == "Gain" {
                if currWeight >= goalWeight {
                    if defaults.value(forKey: USER_DEFAULTS_TENTATIVE_GOAL_ACHIEVEMENT_DATE) != nil {
                        let goal_end_date : Date = defaults.value(forKey: USER_DEFAULTS_TENTATIVE_GOAL_ACHIEVEMENT_DATE) as! Date
                        let currentDate = Date()
                        
                        if currentDate.compare(goal_end_date) == ComparisonResult.orderedSame {
                            let customAlertViewController = self.storyboard?.instantiateViewController(withIdentifier: "CustomAlertViewController") as! CustomAlertViewController
                            customAlertViewController.strMessage = "Congratulations!! You have achieved your goal weight. Do you want to set new goal? if no, we will help you maintain your weight until you set a new goal."
                            customAlertViewController.definesPresentationContext = true;
                            customAlertViewController.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
                            self.navigationController?.present(customAlertViewController, animated: true, completion: nil)
                            
                            print("you have reached ur goal ..!! you can set new goal and if not we will help you maintain your goal.")
                            
                        }else if currentDate.compare(goal_end_date) == ComparisonResult.orderedAscending {
//                            let days = goal_end_date.daysFrom(currentDate)
//                            print("\(days) left to complete your goal")
//                            let customAlertViewController = self.storyboard?.instantiateViewControllerWithIdentifier("CustomAlertViewController") as! CustomAlertViewController
//                            customAlertViewController.delegate = self
//                            customAlertViewController.strMessage = "Congratulations!! You have achieved your goal weight early.There are \(days) days left from your tentative Goal End Date. Do you want to set new goal? if no, we will help you maintain your weight until you set a new goal."
//                            customAlertViewController.definesPresentationContext = true;
//                            customAlertViewController.modalPresentationStyle = UIModalPresentationStyle.OverFullScreen
//                            self.navigationController?.presentViewController(customAlertViewController, animated: true, completion: nil)
                            print("current date is lesser than goal end date.. i.e your goal is completed")
                            
                        }else{
                            print("goal date : \(goal_end_date)")
                        }
                    }else{
                        
                    }
                }else if currWeight < goalWeight {
                    if defaults.value(forKey: USER_DEFAULTS_TENTATIVE_GOAL_ACHIEVEMENT_DATE) != nil {
                        let goal_end_date : Date = defaults.value(forKey: USER_DEFAULTS_TENTATIVE_GOAL_ACHIEVEMENT_DATE) as! Date
                        let currentDate = Date()
                        
                        if currentDate.compare(goal_end_date) == ComparisonResult.orderedSame {
                            print("you have not yet reached your goal..  do you want to edit your goal? or let it be..!!")
                            let customAlertViewController = self.storyboard?.instantiateViewController(withIdentifier: "CustomAlertViewController") as! CustomAlertViewController
                            customAlertViewController.strMessage = "Oops!! Your goal was suppose to complete today. You have not yet reached the goal. Do you want to edit your goal?"
                            customAlertViewController.definesPresentationContext = true;
                            customAlertViewController.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
                            self.navigationController?.present(customAlertViewController, animated: true, completion: nil)
                            
                            print("you have reached ur goal ..!! you can set new goal and if not we will help you maintian your goal.")
                            
                        }else if currentDate.compare(goal_end_date) == ComparisonResult.orderedAscending {
//                            let days = goal_end_date.daysFrom(currentDate)
//                            print("\(days) left to complete your goal")
//                            let customAlertViewController = self.storyboard?.instantiateViewControllerWithIdentifier("CustomAlertViewController") as! CustomAlertViewController
//                            customAlertViewController.delegate = self
//                            customAlertViewController.type = "daysLeft"
//                            customAlertViewController.strMessage = "You are \(days) days away from your tentative Goal End Date. What are you up to? \n\n Log your correct data daily to reach your goal easily."
//                            customAlertViewController.definesPresentationContext = true;
//                            customAlertViewController.modalPresentationStyle = UIModalPresentationStyle.OverFullScreen
//                            self.navigationController?.presentViewController(customAlertViewController, animated: true, completion: nil)
                            print("current date is lesser than goal end date.. i.e your goal is left")
                            
                        }else{
                            print("goal date : \(goal_end_date)")
                        }
                    }else{
                        
                    }
                }
                
            }else if goalType == "Lose" {
            
                if currWeight <= goalWeight {
                    if defaults.value(forKey: USER_DEFAULTS_TENTATIVE_GOAL_ACHIEVEMENT_DATE) != nil {
                        let goal_end_date : Date = defaults.value(forKey: USER_DEFAULTS_TENTATIVE_GOAL_ACHIEVEMENT_DATE) as! Date
                        let currentDate = Date()
                        
                        if currentDate.compare(goal_end_date) == ComparisonResult.orderedSame {
                            let customAlertViewController = self.storyboard?.instantiateViewController(withIdentifier: "CustomAlertViewController") as! CustomAlertViewController
                            customAlertViewController.strMessage = "Congratulations!! You have achieved your goal weight. Do you want to set new goal? if no, we will help you maintain your weight until you set a new goal."
                          
                            customAlertViewController.definesPresentationContext = true;
                            customAlertViewController.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
                            self.navigationController?.present(customAlertViewController, animated: true, completion: nil)
                            
                            print("you have reached ur goal ..!! you can set new goal and if not we will help you maintian your goal.")
                            
                        }else if currentDate.compare(goal_end_date) == ComparisonResult.orderedAscending {
//                            let days = goal_end_date.daysFrom(currentDate)
//                            print("\(days) left to complete your goal")
//                            let customAlertViewController = self.storyboard?.instantiateViewControllerWithIdentifier("CustomAlertViewController") as! CustomAlertViewController
//                            customAlertViewController.delegate = self
//                            customAlertViewController.strMessage = "Congratulations!! You have achieved your goal weight early.There are \(days) days left from your tentative Goal End Date. Do you want to set new goal? if no, we will help you maintain your weight until you set a new goal."
//                            customAlertViewController.definesPresentationContext = true;
//                            customAlertViewController.modalPresentationStyle = UIModalPresentationStyle.OverFullScreen
//                            self.navigationController?.presentViewController(customAlertViewController, animated: true, completion: nil)
                            print("current date is lesser than goal end date.. i.e your goal is completed")
                            
                        }else{
                            print("goal date : \(goal_end_date)")
                        }
                    }else{
                        
                    }
                }else if currWeight > goalWeight {
                    if defaults.value(forKey: USER_DEFAULTS_TENTATIVE_GOAL_ACHIEVEMENT_DATE) != nil {
                        let goal_end_date : Date = defaults.value(forKey: USER_DEFAULTS_TENTATIVE_GOAL_ACHIEVEMENT_DATE) as! Date
                        let currentDate = Date()
                        
                        if currentDate.compare(goal_end_date) == ComparisonResult.orderedSame {
                            print("you have not yet reached your goal..  do you want to edit your goal? or let it be..!!")
                            let customAlertViewController = self.storyboard?.instantiateViewController(withIdentifier: "CustomAlertViewController") as! CustomAlertViewController
                            customAlertViewController.strMessage = "Oops!! Your goal was suppose to complete today. You have not yet reached the goal. Do you want to edit your goal?"
                            customAlertViewController.definesPresentationContext = true;
                            customAlertViewController.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
                            self.navigationController?.present(customAlertViewController, animated: true, completion: nil)
                            
                            print("you have reached ur goal ..!! you can set new goal and if not we will help you maintian your goal.")
                            
                        }else if currentDate.compare(goal_end_date) == ComparisonResult.orderedAscending {
//                            let days = goal_end_date.daysFrom(currentDate)
//                            print("\(days) left to complete your goal")
//                            let customAlertViewController = self.storyboard?.instantiateViewControllerWithIdentifier("CustomAlertViewController") as! CustomAlertViewController
//                            customAlertViewController.delegate = self
//                            customAlertViewController.type = "daysLeft"
//                            customAlertViewController.strMessage = "You are \(days) days away from your tentative Goal End Date. What are you up to? \n\n Log your correct data daily to reach your goal easily."
//                            customAlertViewController.definesPresentationContext = true;
//                            customAlertViewController.modalPresentationStyle = UIModalPresentationStyle.OverFullScreen
//                            self.navigationController?.presentViewController(customAlertViewController, animated: true, completion: nil)
                            print("current date is lesser than goal end date.. i.e your goal is left")
                            
                        }else{
                            print("goal date : \(goal_end_date)")
                        }
                    }else{
                        
                    }
                }
            }
            else if goalType == "Maintain" {
                
                if currWeight == goalWeight {
                    let customAlertViewController = self.storyboard?.instantiateViewController(withIdentifier: "CustomAlertViewController") as! CustomAlertViewController
                    customAlertViewController.strMessage = "You are on 'Weight Maintaining' Mode. Do you want to set goal for your weight loosing or gaining?"
                    customAlertViewController.definesPresentationContext = true;
                    customAlertViewController.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
                    self.navigationController?.present(customAlertViewController, animated: true, completion: nil)
                    print("maintain")
                }else if currWeight < goalWeight {
//                    let customAlertViewController = self.storyboard?.instantiateViewControllerWithIdentifier("CustomAlertViewController") as! CustomAlertViewController
//                    customAlertViewController.delegate = self
//                    customAlertViewController.strMessage = "Your weight is being decreasing from the past few days. Do you want to set goal to 'Gain/Lose' weight?"
//                    customAlertViewController.definesPresentationContext = true;
//                    customAlertViewController.modalPresentationStyle = UIModalPresentationStyle.OverFullScreen
//                    self.navigationController?.presentViewController(customAlertViewController, animated: true, completion: nil)
//                    print("maintain-> currWeight < goalWeight")
                }else if currWeight > goalWeight {
//                    let customAlertViewController = self.storyboard?.instantiateViewControllerWithIdentifier("CustomAlertViewController") as! CustomAlertViewController
//                    customAlertViewController.delegate = self
//                    customAlertViewController.strMessage = "Your weight is being increasing from the past few days. Do you want to set goal to 'Lose/Gain' weight?"
//                    customAlertViewController.definesPresentationContext = true;
//                    customAlertViewController.modalPresentationStyle = UIModalPresentationStyle.OverFullScreen
//                    self.navigationController?.presentViewController(customAlertViewController, animated: true, completion: nil)
//                    print("maintain->currWeight > goalWeight")
                }
                
                
                
            }
            
            fetchTodaysStepFromHealthkit()
            
        }
       
    }
        
//        if defaults.valueForKey(USER_DEFAULTS_TENTATIVE_GOAL_ACHIEVEMENT_DATE) != nil {
//            let goal_end_date : NSDate = defaults.valueForKey(USER_DEFAULTS_TENTATIVE_GOAL_ACHIEVEMENT_DATE) as! NSDate
//            let currentDate = NSDate()
//            
//            if currentDate.compare(goal_end_date) == NSComparisonResult.OrderedSame {
//                if defaults.valueForKey(USER_DEFAULTS_USER_CURRRENT_WEIGHT_KEY) != nil {
//                    let currWeight = defaults.valueForKey(USER_DEFAULTS_USER_CURRRENT_WEIGHT_KEY) as! Float
//                    let goalWeight = defaults.valueForKey(USER_DEFAULTS_USER_GOAL_WEIGHT_KEY) as! Float
//                    if currWeight == goalWeight {
//                        let customAlertViewController = self.storyboard?.instantiateViewControllerWithIdentifier("CustomAlertViewController") as! CustomAlertViewController
//                        customAlertViewController.strMessage = "Congratulations!! You have achieved your goal weight. Do you want to set new goal? if no, we will help you maintain your weight until you set a new goal."
//                        customAlertViewController.delegate = self
//                        customAlertViewController.definesPresentationContext = true;
//                        customAlertViewController.modalPresentationStyle = UIModalPresentationStyle.OverFullScreen
//                        self.navigationController?.presentViewController(customAlertViewController, animated: true, completion: nil)
//
//                        print("you have reached ur goal ..!! you can set new goal and if not we will help you maintian your goal.")
//                    }else{
//                        print("you have not yet reached your goal..  do you want to edit your goal? or let it be..!!")
//                        let customAlertViewController = self.storyboard?.instantiateViewControllerWithIdentifier("CustomAlertViewController") as! CustomAlertViewController
//                        customAlertViewController.strMessage = "Oops!! Your goal was suppose to complete today. You have not yet reached the goal. Do you want to edit your goal?"
//                        customAlertViewController.delegate = self
//                        customAlertViewController.definesPresentationContext = true;
//                        customAlertViewController.modalPresentationStyle = UIModalPresentationStyle.OverFullScreen
//                        self.navigationController?.presentViewController(customAlertViewController, animated: true, completion: nil)
//                    }
//                }
//                
//            }else if currentDate.compare(goal_end_date) == NSComparisonResult.OrderedAscending {
//                
//                let days = goal_end_date.daysFrom(currentDate)
//                
//                print("\(days) left to complete your goal")
//                
//                
//                let customAlertViewController = self.storyboard?.instantiateViewControllerWithIdentifier("CustomAlertViewController") as! CustomAlertViewController
//                customAlertViewController.delegate = self
//                customAlertViewController.type = "daysLeft"
//                customAlertViewController.strMessage = "You are \(days) days away from your tentative Goal End Date. What are you up to? \n\n Log your correct data daily to reach your goal easily."
//                customAlertViewController.definesPresentationContext = true;
//                customAlertViewController.modalPresentationStyle = UIModalPresentationStyle.OverFullScreen
//                self.navigationController?.presentViewController(customAlertViewController, animated: true, completion: nil)
//                print("current date is lesser than goal end date.. i.e your goal is left")
//            }else{
//                print("goal date : \(goal_end_date)")
//            }
//                
//            
//        }else{
//        
//        
//        }
        
        
    
    func callDashboardAPI(_ url : String) {
        
       let size = CGSize(width: 30, height:30)
       // startAnimating(size, message: nil, type: NVActivityIndicatorType(rawValue: 22)!)
        arrayExercisesPerformed = NSMutableArray()
        arrayFoodsConsumed = NSMutableArray()
//        let datestr = utils.convertDateToString(SELECTED_DATESTR, format: "yyyy-MM-dd")
        

        
        NSLog("dashboard API url ; \(url)")
        let encodedURL: String = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        NSLog("url : \(url)")
        
        let manager = AFHTTPRequestOperationManager()
        manager.get( encodedURL, parameters: nil,
            success: { (operation, responseObject) in
                self.stopAnimating()
                NSLog("Yes thies was a success \((responseObject as AnyObject).description)")
                let element : NSDictionary = responseObject as! NSDictionary
                let strStatus : String = element.value(forKey: "status") as! String
                if strStatus == "success" {
                    
                    let array : NSArray = element.value(forKey: "fetch_data") as! NSArray
                    let dict : NSDictionary = array.object(at: 0) as! NSDictionary

                    let goalDict = dict.value(forKey: "user_step_goal") as! NSDictionary
                    if let udefault = goalDict.value(forKey: "main_goal") as? Int
                    {
                        self.stepsGoal = udefault
                        defaults.set(udefault, forKey: USER_DEFAULTS_USER_GOAL_STEPS)
                    }else{
                        self.stepsGoal = 10000
                        defaults.set(10000, forKey: USER_DEFAULTS_USER_GOAL_STEPS)
                    }
                    
                    if let udefault = dict.value(forKey: "daily_step_count") as? Int
                    {
                        SelectednumberOfSteps = udefault
                        //defaults.setObject(udefault, forKey: USER_DEFAULTS_USER_GOAL_STEPS)
                    }else{
                        SelectednumberOfSteps = 10000
                        //defaults.setObject(10000, forKey: USER_DEFAULTS_USER_GOAL_STEPS)
                    }
                    
                    
                    
                    
                    if let udefault = dict.value(forKey: "weight") as? Float
                    {
                        weightForDate = udefault
                        if SELECTED_DATESTR == utils.convertDateToString(Date(), format: "yyyy-MM-dd") {
                            defaults.set(udefault, forKey: USER_DEFAULTS_USER_CURRRENT_WEIGHT_KEY)
                        }else{
                            defaults.set(udefault, forKey: USER_DEFAULTS_FETCHED_WEIGHT_FOR_DATE)
                        }
                        
                        
                    }else{
                        weightForDate = 0.0
                        if SELECTED_DATESTR == utils.convertDateToString(Date(), format: "yyyy-MM-dd") {
                            defaults.set(50.0, forKey: USER_DEFAULTS_USER_CURRRENT_WEIGHT_KEY)
                        }else{
                            defaults.set(50.0, forKey: USER_DEFAULTS_FETCHED_WEIGHT_FOR_DATE)
                        }
                    }
                    
                    if let udefault = dict.value(forKey: "water_level") as? Float
                    {
                        waterLevelForDate = udefault
                        defaults.set(udefault, forKey: USER_DEFAULTS_USER_DAILY_WATER_INTAKE_LEVEL)
                    }else{
                        waterLevelForDate = 0.0
                        defaults.set(0.0, forKey: USER_DEFAULTS_USER_DAILY_WATER_INTAKE_LEVEL)
                    }
                    
                    if let udefault = dict.value(forKey: "daily_calories_goal") as? Float
                    {
                        if udefault != 0.0 {
                            calorieGoalforDate = udefault
                            defaults.set(udefault, forKey: USER_DEFAULTS_USER_GOAL_CALORIE) 
                            
                        }else if udefault == 0.0 {
                            var bmr : Float = 0.0
                            let weight : Float = defaults.value(forKey: USER_DEFAULTS_USER_CURRRENT_WEIGHT_KEY) as! Float
                            NSLog("height : \(defaults.value(forKey: USER_DEFAULTS_USER_HEIGHT_KEY)!)")
                            
                            let strheightIN : String = String("\(defaults.value(forKey: USER_DEFAULTS_USER_HEIGHT_KEY)!)")
                            let heightIN : Float = Float(strheightIN)!
                            let heightCMS : Float = heightIN / 0.032808
                            var calorie : Float = 0.0
                            
                            let selectedActivityType : String = defaults.value(forKey: USER_DEFAULTS_USER_ACTIVITY_TYPE_KEY) as! String
                            
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
                            calorieGoalforDate = calorie
                            defaults.set(calorie, forKey: USER_DEFAULTS_USER_GOAL_CALORIE)
                            
                        }else{
                            calorieGoalforDate = 0.0
                            defaults.set("0", forKey: USER_DEFAULTS_USER_GOAL_CALORIE)
                        }
                    }else{
                        calorieGoalforDate = 0.0
                        defaults.set("1200", forKey: USER_DEFAULTS_USER_GOAL_CALORIE)
                    }
                            
                        
                        
                        
                    
                    
                    if let udefault = dict.value(forKey: "total_calories_burned") as? Float
                    {
                        totalCaloriesBurned = udefault
                        defaults.set(udefault, forKey: USER_DEFAULTS_FETCHED_TOTAL_CALORIES_BURNED_FOR_DATE)
                    }else{
                        totalCaloriesBurned = 0.0
                        defaults.set("0", forKey: USER_DEFAULTS_FETCHED_TOTAL_CALORIES_BURNED_FOR_DATE)
                    }
                    
                    if let udefault = dict.value(forKey: "total_calories_consumed") as? Float
                    {
                        totalCaloriesConsumed = udefault
                        defaults.set(udefault, forKey: USER_DEFAULTS_FETCHED_TOTAL_CALORIES_CONSUMED_FOR_DATE)
                    }else{
                        totalCaloriesConsumed = 0.0
                        defaults.set("0", forKey: USER_DEFAULTS_FETCHED_TOTAL_CALORIES_CONSUMED_FOR_DATE)
                    }
                    
                    
                    if let udefault = dict.value(forKey: "daily_exercise_perform") as? NSArray
                    {
                        if udefault.count > 0 {
                            
                            self.arrayExercisesPerformed = udefault.mutableCopy() as! NSMutableArray
                        }else{
                            exercisesList = NSMutableArray()
                            NSLog("there are no exercises performed by this user .. ")
                        }
                    }else{
                        NSLog("exercises performed array is nil")
                    }
                    
                    if let udefault = dict.value(forKey: "daily_consumed_food") as? NSArray
                    {
                        if udefault.count > 0 {
                            
                            self.arrayFoodsConsumed = udefault.mutableCopy() as! NSMutableArray
                        }else{
                            NSLog("thre are no foods consumed by this user .. ")
                        }
                    }else{
                        NSLog("foods consumed array is nil")
                    }
                    
                    self.setFetchedValues()
                   
                }else{
                    
                    utils.customAlertView("Something went wrong. Try Again.", view: self.view)
                }
            },
            failure: { (operation, error) in
                self.stopAnimating()
                utils.failureBlock(self.view)
                print("We got an error here.. \(String(describing: error?.localizedDescription))")
        } )
    }
    
    
    func setFetchedValues(){
        
        print("\(totalCaloriesConsumed) consumed calories")
        print("\(totalCaloriesBurned) burned calories")
        print("\(waterLevelForDate) water level")
        print("\(weightForDate) weight")
        
        arrayValue.removeAll()
        arrayValue.append(String("\(totalCaloriesConsumed) cal"))
        arrayValue.append(String("\(totalCaloriesBurned) cal"))
        print("here : \(totalCaloriesBurned) cal")
        
        let waterlevelLtrs = waterLevelForDate / 1000.0
        
        String(format: "%.5f", 1.0321)
        
        arrayValue.append(String("\(waterlevelLtrs) ltrs"))
        arrayValue.append(String("\(weightForDate) kgs"))
        
        
        lblCalorieConsumedValue.text = String("\(Float(totalCaloriesConsumed)) cal")
        lblCalorieBurnedValue.text = String("\(Float(totalCaloriesBurned)) cal")
        lblwaterValue.text = String("\(Float(waterlevelLtrs)) ltrs")
        lblweightValue.text = String("\(weightForDate) kgs")
        
        
        
        lblTotalBurnedCalorie.text = "0 cal."
       
        
        
       
        
        
        
        
        var totalcaloriesBurnedArray  : [String] = (lblCaloriesBurnedFromSteps.text?.components(separatedBy: " "))!
        var totalCalorieBurnedLblValue = Float(totalcaloriesBurnedArray[0])
        totalCalorieBurnedLblValue = totalCalorieBurnedLblValue! + totalCaloriesBurned
        
        lblTotalBurnedCalorie.text = String("\(totalCalorieBurnedLblValue!) cal")
        
        
        lblGoalCalorie.text = String("\(calorieGoalforDate)")
        lblTotalConsumedCalorie.text = String("\(totalCaloriesConsumed - totalCalorieBurnedLblValue!)")
        lblRemainingCalorieStatus.text = String("\(calorieGoalforDate - (totalCaloriesConsumed - totalCalorieBurnedLblValue!))")
        lblDisplaycalorieValue.text = String("\(totalCaloriesConsumed) cal")
        
        
        
        lblGoalSteps.text = String("\(stepsGoal)")
        lblTotalNumberOfStepsTaken.text = String("\(SelectednumberOfSteps)")
        lblRemaingStepCount.text = String("\(stepsGoal - SelectednumberOfSteps)")
        
        
        
        if isFlipped == true {
            setCircularProgressBar_Steps()
        }else{
            setCircularProgressBar_CaloriesConsumed()
        }
        
        //progressBarCaloriesConsumed.setProgress(CGFloat(percentCalorie), animated: true)
        progressBarCaloriesBurned.setProgress(CGFloat(totalCaloriesBurned/100.0), animated: true)
        tblView.reloadData()
    }
    
//    func fetchSteps(){
//        fetchTodaysStepFromHealthkit()
//        //helloWorldTimer = NSTimer.scheduledTimerWithTimeInterval(8.0, target: self, selector: Selector("fetchTodaysStepFromHealthkit"), userInfo: nil, repeats: true)
//       
//    }
    
    func fetchTodaysStepFromHealthkit() {
        var stepsArray : [String] = (lblStepsCount.text?.components(separatedBy: " "))!
        //NSLog("steps \(stepsArray)")
        prevSteps = Int(stepsArray[0])!
        let calendar = Calendar.current
        let dateComponents = (calendar as NSCalendar).components([NSCalendar.Unit.day, NSCalendar.Unit.month, NSCalendar.Unit.year, NSCalendar.Unit.weekOfYear, NSCalendar.Unit.hour, NSCalendar.Unit.minute, NSCalendar.Unit.second, NSCalendar.Unit.nanosecond], from: SELECTED_DATEE as Date)
        let day = dateComponents.day
        let month = dateComponents.month
        let year  = dateComponents.year
//        let weekofMonth = dateComponents.weekOfMonth
//        let weekofYear = dateComponents.weekOfYear
//        let weekday = dateComponents.weekday
        
                var comps: DateComponents = DateComponents()
        comps.day = day
        comps.month = month
        comps.year = year
        comps.hour = 23
        comps.minute = 59
        comps.second = 59
        let endDate = Calendar.current.date(from: comps)
        
        
        print("calculated end datee:\(endDate)")
        
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "yyyy-MM-dd"
        dateFormatter1.timeZone = TimeZone(identifier: "UTC")
      
        print("===================================selected      endDate : \(endDate)")
        healthManager.recentSteps(endDate!) { (steps, error) -> () in
            print("steps : \(steps)")
            print("current datee")
            
            DispatchQueue.main.async(execute: {() -> Void in
                SelectednumberOfSteps = Int(steps)
                let newPercent  = (SelectednumberOfSteps/self.stepsGoal) * 100
                self.circularProgressStepsTaken.drawCircle(withPercent: CGFloat(newPercent), duration: 2, lineWidth: 10, clockwise: true, lineCap: kCALineCapRound, fill: UIColor.clear, stroke: UIColor(red: 255.0/255.0, green: 121.0/255.0, blue: 186.0/255.0, alpha: 1.0), animatedColors: nil)
                self.circularProgressStepsTaken.startAnimation()
                
                self.lblStepsCount.text = String("\(SelectednumberOfSteps) steps")
                self.lblTotalNumberOfStepsTaken.text = String("\(SelectednumberOfSteps)")
                self.progressBarSteps.setProgress(CGFloat((SelectednumberOfSteps/self.stepsGoal)*100)/100.0, animated: true)
                self.calculateCaloriesBurnedFromSteps()
                
                
                let userid : Int = defaults.value(forKey: USER_DEFAULTS_USER_ID_KEY) as! Int
                let url : String = String("\(API_BASE_URL)/\(API_DASHBOARD)/\(SELECTED_DATESTR)/\(userid)/\(steps)")
                self.callDashboardAPI(url)
            })

            
            
        }

    }
    
    

    
    func calculateCaloriesBurnedFromSteps() {
        let newSteps : Int = SelectednumberOfSteps// - prevSteps
        
        var weightLbs : Float = 0.0
        var heightCms : Float = 0.0
        if defaults.object(forKey: USER_DEFAULTS_USER_CURRRENT_WEIGHT_KEY) != nil {
            let weightKgs = defaults.object(forKey: USER_DEFAULTS_USER_CURRRENT_WEIGHT_KEY)! as! Float
            weightLbs = weightKgs * 2.2046
            NSLog("weight Lbl: \(weightLbs)   weight Kgs : \(weightKgs)")
        }
        
        if defaults.object(forKey: USER_DEFAULTS_USER_HEIGHT_KEY) != nil {
            let heightFt = defaults.object(forKey: USER_DEFAULTS_USER_HEIGHT_KEY)! as! Float
            heightCms = heightFt / 0.032808
            NSLog("height feet : \(heightFt) height cms : \(heightCms)")
        }
        
        
        let strideLength : Float = 0.0
        
        NSLog("stride length : \(strideLength)")
        
        let defaultNumberOfStepsInMile = 160934 / strideLength
        
        NSLog("default number of steps in a mile : \(defaultNumberOfStepsInMile)")
        
        
        //FOR CASUAL WALKING
        
        let caloriesBurnedPerMile = weightLbs * 0.57
        NSLog("calories Burned Per Mile : \(caloriesBurnedPerMile) ")
        
        let caloriesBurnedPerStep = caloriesBurnedPerMile / defaultNumberOfStepsInMile
        NSLog("calories Burned Per Step : \(caloriesBurnedPerStep)")
        NSLog("number of steps in float : \(self.lblStepsCount.text!) new steps : \(newSteps)")
        
        let totalCaloriesBurned = caloriesBurnedPerStep * Float(newSteps)
        
        NSLog("total Calories Burned : \(totalCaloriesBurned)")
        
        lblCaloriesBurnedFromSteps.text = String("\(totalCaloriesBurned) cal.")
        
        
        //For adding to exsiting calories
//        var caloriesBurnedArray  : [String] = (lblCaloriesBurnedFromSteps.text?.componentsSeparatedByString(" "))!
//        var CalorieBurnedLblValue = Float(caloriesBurnedArray[0])
//        CalorieBurnedLblValue = CalorieBurnedLblValue! + totalCaloriesBurned
//        lblCaloriesBurnedFromSteps.text = String("\(CalorieBurnedLblValue!) cal.")
        
        var totalcaloriesBurnedArray  : [String] = (lblTotalBurnedCalorie.text?.components(separatedBy: " "))!
        var totalCalorieBurnedLblValue = Float(totalcaloriesBurnedArray[0])
        totalCalorieBurnedLblValue = totalCalorieBurnedLblValue! + totalCaloriesBurned
        var totalRemainingCalories : Float = Float(lblRemainingCalorieStatus.text!)!
        totalRemainingCalories = totalRemainingCalories + totalCaloriesBurned
//        lblRemainingCalorieStatus.text = String("\(totalRemainingCalories)")
//        lblTotalBurnedCalorie.text = String("\(Float(totalCalorieBurnedLblValue!)) cal.")
        
//        if lblTotalBurnedCalorie.text == lblCaloriesBurnedFromSteps.text {
//            lblTotalBurnedCalorie.text = lblCaloriesBurnedFromSteps.text
//            
//        }else {
//            totalCalorieBurnedLblValue = totalCalorieBurnedLblValue! + totalCaloriesBurned
//            var totalRemainingCalories : Float = Float(lblRemainingCalorieStatus.text!)!
//            totalRemainingCalories = totalRemainingCalories + totalCaloriesBurned
//            lblRemainingCalorieStatus.text = String("\(totalRemainingCalories)")
//            
//        }
        
        
    }
    
    
    func setCircularProgressBar_CaloriesConsumed() {
        if totalCaloriesConsumed != calorieGoalforDate && totalCaloriesConsumed >= 0{
            var newpercent : CGFloat = 0.0
            newpercent = CGFloat(((totalCaloriesConsumed - totalCaloriesBurned) / calorieGoalforDate) * 100)
            circularProgressCalorieConsumed.backgroundColor = UIColor.clear
            circularProgressCalorieConsumed.drawCircle(withPercent: newpercent, duration: 2, lineWidth: 10, clockwise: true, lineCap: kCALineCapRound, fill: UIColor.clear, stroke: utils.colorTheme, animatedColors: nil)
            circularProgressCalorieConsumed.startAnimation()
            
            let newPercentSteps : CGFloat = (CGFloat(SelectednumberOfSteps)/CGFloat(self.stepsGoal)) * 100.0
            print("newpercemtSteps :\(newPercentSteps/100.0)")
            progressBarSteps.setProgress(newPercentSteps/100.0, animated: true)
        }
    }
    
    func setCircularProgressBar_Steps() {
        let newPercent : CGFloat = (CGFloat(SelectednumberOfSteps)/CGFloat(self.stepsGoal)) * 100.0
        self.circularProgressStepsTaken.drawCircle(withPercent: newPercent, duration: 2, lineWidth: 10, clockwise: true, lineCap: kCALineCapRound, fill: UIColor.clear, stroke: UIColor(red: 255.0/255.0, green: 121.0/255.0, blue: 186.0/255.0, alpha: 1.0), animatedColors: nil)
        self.circularProgressStepsTaken.startAnimation()
        
        if totalCaloriesConsumed != calorieGoalforDate && totalCaloriesConsumed >= 0 {
            let newpercentcalorie : CGFloat = CGFloat(((totalCaloriesConsumed - totalCaloriesBurned) / calorieGoalforDate) * 100)
            print("newpercemtSteps :\(newpercentcalorie/100.0)")
            progressBarSteps.setProgress(newpercentcalorie/100.0, animated: true)
        }else{
            progressBarSteps.setProgress(0.0, animated: true)
        }
        
        
    }
    
    
//MARK: uitableview delegate methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayValue.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "acell") as! DashboardTableViewCell
        cell.lblName.text = arrayModules[indexPath.row] as String
        cell.imgview.image = UIImage(named: arrayImgsModules[indexPath.row] as String)
        
       
        cell.lblValue.text = arrayValue[indexPath.row] as String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2 {
            let waterLevelViewController = self.storyboard?.instantiateViewController(withIdentifier: "WaterLevelViewController") as! WaterLevelViewController
            waterLevelViewController.dailyWaterGoal = dailywaterGoalLtrs
            
            self.navigationController?.pushViewController(waterLevelViewController, animated: true)
        }else if indexPath.row == 3 {
            let dailyweightViewController = self.storyboard?.instantiateViewController(withIdentifier: "DailyWeightViewController") as! DailyWeightViewController
            self.navigationController?.pushViewController(dailyweightViewController, animated: true)
        }
    }
    
        
    @IBAction func onClick_water(_ sender: AnyObject) {
        let waterLevelViewController = self.storyboard?.instantiateViewController(withIdentifier: "WaterLevelViewController") as! WaterLevelViewController
        waterLevelViewController.dailyWaterGoal = dailywaterGoalLtrs
        
        self.navigationController?.pushViewController(waterLevelViewController, animated: true)
    }
    
    @IBAction func onClick_weight(_ sender: AnyObject) {
        let dailyweightViewController = self.storyboard?.instantiateViewController(withIdentifier: "DailyWeightViewController") as! DailyWeightViewController
        self.navigationController?.pushViewController(dailyweightViewController, animated: true)
    }
    
    
    
    
    @IBAction func onTapDate(_ sender: UITapGestureRecognizer) {
        self.view.bringSubview(toFront: calView)
        
        if calView.isHidden == true {
            calView.isHidden = false
            bgview.isHidden = false
        }else{
            calView.isHidden = true;
            bgview.isHidden = true
        }
        
    }
    
//MARK: Next & Previous Button Click Events
    
    @IBAction func onClick_PreviousBtn(_ sender: AnyObject) {
        datesSelected.removeAllObjects()
//        if lblDateDisplay.text == "Today"  {
//            
//            let calculatedDate = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Day, value: -1, toDate: NSDate(), options: NSCalendarOptions.init(rawValue: 0))
//            SELECTED_DATESTR = utils.convertDateToString(calculatedDate!, format: "yyyy-MM-dd")
//            
//            
//            let displayedDate : String = utils.convertDateToString(calculatedDate!, format: "MMM dd, yyyy")
//            lblDateDisplay.text = displayedDate
//            calendarManager.setDate(calculatedDate)
//            calendarManager.reload()
//             print("1on prev btn : \(SELECTED_DATESTR) &&& cal: \(calendarContentView.date)")
//        }else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            NSLog(" \(lblDateDisplay.text!)")
            let displayedDate : Date = utils.convertStringToDate(lblDateDisplay.text!, dateFormat: "MMM dd, yyyy")
            let calculatedDate = (Calendar.current as NSCalendar).date(byAdding: NSCalendar.Unit.day, value: -1, to: displayedDate, options: NSCalendar.Options.init(rawValue: 0))
            SELECTED_DATEE = calculatedDate!
            SELECTED_DATESTR = utils.convertDateToString(calculatedDate!, format: "yyyy-MM-dd")
            
//            if calculatedDate == NSDate() {
//                
//                lblDateDisplay.text = "Today"
//            }
//            else{
                let displayedStr : String =  utils.convertDateToString(calculatedDate!, format: "MMM dd, yyyy")
                lblDateDisplay.text = displayedStr
//            }
            datesSelected.add(calculatedDate!)
            calendarManager.setDate(calculatedDate)
            calendarManager.reload()
           
             print("2on prev btn : \(SELECTED_DATESTR) &&& cal: \(calendarContentView.date)")
//        }
        
        fetchTodaysStepFromHealthkit()
        
        // calendarContentView.loadPreviousPageWithAnimation()
    }
    
    @IBAction func onClick_NextBtn(_ sender: AnyObject) {
        
            
//            let calculatedDate = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Day, value: +1, toDate: NSDate(), options: NSCalendarOptions.init(rawValue: 0))
//            
//            
//            let displayedDate : String = utils.convertDateToString(calculatedDate!, format: "MMM dd, yyyy")
//            lblDateDisplay.text = displayedDate
//            calendarManager.setDate(calculatedDate)
//            calendarManager.reload()
//            SELECTED_DATESTR = utils.convertDateToString(calculatedDate!, format: "yyyy-MM-dd")
//             print("1on next btn : \(SELECTED_DATESTR) &&& cal: \(calendarContentView.date)")
      
            
        datesSelected.removeAllObjects()
        let displayedDate : Date = utils.convertStringToDate(lblDateDisplay.text!, dateFormat: "MMM dd, yyyy")
        let calculatedDate = (Calendar.current as NSCalendar).date(byAdding: NSCalendar.Unit.day, value: +1, to: displayedDate, options: NSCalendar.Options.init(rawValue: 0))
        
            if  calendarManager.dateHelper.date(calculatedDate!, isEqualOrAfter: Date()) {
                
                if calendarManager.dateHelper.date(calculatedDate!, isTheSameDayThan: Date()) {
                    
                    datesSelected.add(calculatedDate!)
                    calendarManager.setDate(calculatedDate)
                    calendarManager.reload()
                    SELECTED_DATEE = calculatedDate!
                    SELECTED_DATESTR = utils.convertDateToString(calculatedDate!, format: "yyyy-MM-dd")
                    print("2on next btn : \(SELECTED_DATESTR) &&& cal: \(calendarContentView.date)")
                    
                    let displayedStr : String = utils.convertDateToString(calculatedDate!, format: "MMM dd, yyyy")
                    lblDateDisplay.text = displayedStr
                   
                    fetchTodaysStepFromHealthkit()
                }else{
                    let alert = UIAlertController(title: "Oops..!!", message: "You cannot select future dates.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: .destructive, handler: { action in
                        switch action.style{
                        case .default:
                            NSLog("default")
                        case .cancel:
                            NSLog("cancel")
                        case .destructive:
                            NSLog("destructive")
                        }
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
                
            }else{
                datesSelected.add(calculatedDate!)
                
                calendarManager.setDate(calculatedDate)
                calendarManager.reload()
                SELECTED_DATEE = calculatedDate!
                SELECTED_DATESTR = utils.convertDateToString(calculatedDate!, format: "yyyy-MM-dd")
                let displayedStr : String = utils.convertDateToString(calculatedDate!, format: "MMM dd, yyyy")
                lblDateDisplay.text = displayedStr
                print("2on next btn : \(SELECTED_DATESTR) &&& cal: \(calendarContentView.date)")
                
                fetchTodaysStepFromHealthkit()
            }

            
            
            
            
            
        
       
    }
    
//MARK : JTCalendar Delegate & DataSource
    
    func isInDatesSelected(_ date : Date) -> Bool {
        for datesel in datesSelected {
            if calendarManager.dateHelper.date(datesel as! Date, isTheSameDayThan: date) {
                return true
            }
        }
        return false
        
    }
    
    
    
    func calendar(_ calendar: JTCalendarManager!, prepareDayView dayView: UIView!) {
        
        let dayView : JTCalendarDayView = dayView as! JTCalendarDayView
        let outputTimeZone : TimeZone = TimeZone.autoupdatingCurrent
        let outputDateFormatter = DateFormatter()
        outputDateFormatter.timeZone = outputTimeZone
        outputDateFormatter.dateFormat = "MMM dd, yyyy"
        
        if calendarManager.dateHelper.date(dayView.date, isTheSameDayThan: Date()) {
            dayView.circleView.isHidden = true
            dayView.textLabel.textColor = utils.colorTheme
        }
        
        
        // Selected date
        if isInDatesSelected(dayView.date) {
            dayView.circleView.isHidden = false;
            dayView.circleView.backgroundColor = utils.colorTheme
            dayView.dotView.backgroundColor = UIColor.white
            dayView.textLabel.textColor = UIColor.white
            
        }
//            // Today
//        else if calendarManager.dateHelper.date(NSDate(), isTheSameDayThan: dayView.date) {
//            dayView.circleView.hidden = true
////            dayView.circleView.backgroundColor = utils.colorTheme
//            dayView.dotView.backgroundColor = UIColor.whiteColor()
//            dayView.textLabel.textColor = utils.colorTheme
////            let fontD: UIFontDescriptor = dayView.textLabel.font.fontDescriptor().fontDescriptorWithSymbolicTraits(.TraitItalic)
////            dayView.textLabel.font = UIFont(descriptor: fontD, size: 11)
//        }
            
        
            // current month
        else if calendarManager.dateHelper.date(calendarContentView.date, isTheSameMonthThan: dayView.date) {
            dayView.circleView.isHidden = true;
            dayView.dotView.backgroundColor = UIColor.red
            dayView.textLabel.textColor =  UIColor.darkGray
        }
            
            // Another day of the other month
        else {
            //dayView.hidden = true
            dayView.circleView.isHidden = true;
            dayView.dotView.backgroundColor = UIColor.red
            dayView.textLabel.textColor = utils.colorBorder
            //calendarView.hidden = true;
            
        }
        
        if calendarManager.dateHelper.date(dayView.date, isEqualOrAfter: Date()) {
            if calendarManager.dateHelper.date(dayView.date, isTheSameDayThan: Date()) {
                if isInDatesSelected(dayView.date) {
                    dayView.circleView.isHidden = false;
                    dayView.circleView.backgroundColor = utils.colorTheme
                    dayView.dotView.backgroundColor = UIColor.white
                    dayView.textLabel.textColor = UIColor.white
                    
                }else{
                    dayView.circleView.isHidden = true
                    dayView.dotView.backgroundColor = UIColor.white
                    dayView.textLabel.textColor = utils.colorTheme
                }
        
            }else{
        
                dayView.circleView.isHidden = true;
                dayView.textLabel.textColor = utils.colorBorder
            }
        }
        
        
        //calendarManager.reload()
    }
    
    
    func calendar(_ calendar: JTCalendarManager!, didTouchDayView dayView: UIView!) {
        
        
        let dayView : JTCalendarDayView = dayView as! JTCalendarDayView
        
        let outputTimeZone : TimeZone = TimeZone.autoupdatingCurrent
        let outputDateFormatter = DateFormatter()
        outputDateFormatter.timeZone = outputTimeZone
        outputDateFormatter.dateFormat = "MMM dd, yyyy"
        
        let strselectedDate : String = outputDateFormatter.string(from: dayView.date)
        //NSLog("selected DAte : \(selectedDate)")
       
       
        print("\n\n\n\n\n\n did touch date view : \(SELECTED_DATESTR)")
        
        datesSelected.removeAllObjects()
        if isInDatesSelected(dayView.date) {
            datesSelected .remove(dayView.date)
            UIView.transition(with: dayView, duration: 0.3, options: UIViewAnimationOptions(), animations: { () -> Void in
                self.calendarManager.reload()
                //dayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1)
                }, completion: nil)
            
        }else{
            if calendarManager.dateHelper.date(dayView.date, isEqualOrAfter: Date()) {
                if calendarManager.dateHelper.date(dayView.date, isTheSameDayThan: Date()) {
                    datesSelected.add(dayView.date)
                    // dayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
                    UIView.transition(with: dayView, duration: 0.3, options: UIViewAnimationOptions(), animations: { () -> Void in
                        self.calendarManager.reload()
                        // dayView.circleView.transform = CGAffineTransformIdentity
                        }, completion: nil)
                    
                    if !calendarManager.dateHelper.date(dayView.date, isTheSameMonthThan: dayView.date) {
                        
                        if calendarContentView.date.compare(dayView.date) == ComparisonResult.orderedAscending {
                            calendarContentView.loadNextPageWithAnimation()
                        }else{
                            calendarContentView.loadPreviousPageWithAnimation()
                        }
                    }
                     calendarContentView.date = dayView.date
                    self.lblDateDisplay.text = strselectedDate
                    SELECTED_DATEE = (dayView.date as! NSDate) as Date
                    
                    SELECTED_DATESTR = utils.convertDateToString(dayView.date, format: "yyyy-MM-dd")
                    
                    calView.isHidden = true
                    bgview.isHidden = true
                    
                    fetchTodaysStepFromHealthkit()
                }else{
                    let alert = UIAlertController(title:"Oops..!!" , message: "You cannot select future dates.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: .destructive, handler: { action in
                        switch action.style{
                        case .default:
                            NSLog("default")
                        case .cancel:
                            NSLog("cancel")
                        case .destructive:
                            NSLog("destructive")
                            //self.navigationController?.popToRootViewControllerAnimated(true)
                        }
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
                
            }else{
                datesSelected.add(dayView.date)
                // dayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
                UIView.transition(with: dayView, duration: 0.3, options: UIViewAnimationOptions(), animations: { () -> Void in
                    self.calendarManager.reload()
                    // dayView.circleView.transform = CGAffineTransformIdentity
                    }, completion: nil)
                
                if !calendarManager.dateHelper.date(dayView.date, isTheSameMonthThan: dayView.date) {
                    
                    if calendarContentView.date.compare(dayView.date) == ComparisonResult.orderedAscending {
                        calendarContentView.loadNextPageWithAnimation()
                    }else{
                        calendarContentView.loadPreviousPageWithAnimation()
                    }
                }
                 calendarContentView.date = dayView.date
                self.lblDateDisplay.text = strselectedDate
                SELECTED_DATEE = (dayView.date as! NSDate) as Date
                
                SELECTED_DATESTR = utils.convertDateToString(dayView.date, format: "yyyy-MM-dd")
                
                calView.isHidden = true
                bgview.isHidden = true
                fetchTodaysStepFromHealthkit()
            }
            
            
            
            
            
        }
        // Load the previous or next page if touch a day from another month
        
    }
    

    @IBAction func onClick_flipView(_ sender: AnyObject) {
        
        if (isFlipped == false) {
            UIView.transition(from: viewCalorieDisplay, to: viewStepsDisplay, duration: 1.0, options: UIViewAnimationOptions.transitionFlipFromLeft, completion: nil)
            viewCalorieDisplay.isHidden = true
            viewStepsDisplay.isHidden = false
            isFlipped = true
            
            lblDisplayText.text = "EATEN"
            imgDisplay.image = UIImage(named: "Eaten25.png")
            lblStepsCount.isHidden = true
            lblCaloriesBurnedFromSteps.isHidden = true
            lblDisplaycalorieValue.isHidden = false

            setCircularProgressBar_Steps()
//            let percentCalorie = (totalCaloriesConsumed / calorieGoalforDate)
            
            progressBarSteps.progressTintColor = utils.colorTheme
            progressBarSteps.progressTintColors = [utils.colorTheme,utils.colorTheme]
//            progressBarSteps.setProgress(CGFloat(percentCalorie), animated: true)
            progressBarSteps.setNeedsDisplay()


            
        }
        else {
            UIView.transition(from: viewStepsDisplay, to: viewCalorieDisplay, duration: 1.0, options: UIViewAnimationOptions.transitionFlipFromRight, completion: nil)
            viewCalorieDisplay.isHidden = false
            viewStepsDisplay.isHidden = true
            isFlipped = false
            
            lblDisplayText.text = "STEPS"
            imgDisplay.image = UIImage(named: "Steps25.png")
            lblStepsCount.isHidden = false
            lblCaloriesBurnedFromSteps.isHidden = false
            lblDisplaycalorieValue.isHidden = true

            setCircularProgressBar_CaloriesConsumed()
            progressBarSteps.progressTintColors = [UIColor(red: 255.0/255.0, green: 121.0/255.0, blue: 186.0/255.0, alpha: 1.0),UIColor(red: 255.0/255.0, green: 121.0/255.0, blue: 186.0/255.0, alpha: 1.0)]
            //progressBarSteps.setProgress(CGFloat(numberOfSteps/100), animated: true)
             progressBarSteps.setNeedsDisplay()
        }
    }

    func getDateComponents(_ date : Date) -> (day : Int,month: Int,year: Int,weekofMonth: Int,weekofYear: Int,weekday: Int) {
        let currentDate = date
        let calendar = Calendar.current
        let dateComponents = (calendar as NSCalendar).components([NSCalendar.Unit.day, NSCalendar.Unit.month, NSCalendar.Unit.year, NSCalendar.Unit.weekOfYear, NSCalendar.Unit.hour, NSCalendar.Unit.minute, NSCalendar.Unit.second, NSCalendar.Unit.nanosecond], from: currentDate)
        let day = dateComponents.day
        let month = dateComponents.month
        let year  = dateComponents.year
        let weekofMonth = dateComponents.weekOfMonth
        let weekofYear = dateComponents.weekOfYear
        let weekday = dateComponents.weekday
        
        
        
        // print("day = \(dateComponents.day)", "month = \(dateComponents.month)", "year = \(dateComponents.year)", "week of year = \(dateComponents.weekOfYear)", "hour = \(dateComponents.hour)", "minute = \(dateComponents.minute)", "second = \(dateComponents.second)", "nanosecond = \(dateComponents.nanosecond)" , separator: ", ", terminator: "")
        
        return (day!,month!,year!,weekofMonth!,weekofYear!,weekday!)
        
    }
    
    func redirect() {
        NSLog("called from : \(calledFrom)")
        if calledFrom == "water"{
            
            NSLog("called from water")
            
//            self.tabBarController!.selectedIndex = 0
//            let tabbaritem : RAMAnimatedTabBarItem = self.tabBarController!.tabBar.items?.first as! RAMAnimatedTabBarItem
//            tabbaritem.selectedState()
            //                            self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
            //                            window!.rootViewController = self.tabBarController!;
            //                            window!.makeKeyAndVisible()
            
            
            let water = self.storyboard!.instantiateViewController(withIdentifier: "WaterLevelViewController") as! WaterLevelViewController
            
            print("selected vew ontroler : \(self.tabBarController!.selectedViewController)")
            
            let navController : UINavigationController = self.tabBarController!.selectedViewController as! UINavigationController
            navController.pushViewController(water, animated: true)
            
            
        }else if calledFrom == "weight"{
            NSLog("called from weight")
//            self.tabBarController!.selectedIndex = 0
//            let tabbaritem : RAMAnimatedTabBarItem = self.tabBarController!.tabBar.items?.first as! RAMAnimatedTabBarItem
//            tabbaritem.selectedState()
            
            
            let weight = self.storyboard!.instantiateViewController(withIdentifier: "DailyWeightViewController") as! DailyWeightViewController
            
            print("selected vew ontroler : \(self.tabBarController!.selectedViewController)")
            
            let navController : UINavigationController = self.tabBarController!.selectedViewController as! UINavigationController
            navController.pushViewController(weight, animated: true)
            
            
        }else{
           
        }
        
    }
}

//extension DashBoard1ViewController {
//    func toggleMonthViewWithMonthOffset(offset: Int) {
//        let calendar = NSCalendar.currentCalendar()
//        //        let calendarManager = calendarView.manager
//        let components = Manager.componentsForDate(NSDate()) // from today
//
//        components.month += offset
//
//        let resultDate = calendar.dateFromComponents(components)!
//
//        self.calendarView.toggleViewWithDate(resultDate)
//    }
//
//    func didShowNextMonthView(date: NSDate)
//    {
//        //        let calendar = NSCalendar.currentCalendar()
//        //        let calendarManager = calendarView.manager
//        let components = Manager.componentsForDate(date) // from today
//
//        print("Showing Month: \(components.month)")
//    }
//
//
//    func didShowPreviousMonthView(date: NSDate)
//    {
//        //        let calendar = NSCalendar.currentCalendar()
//        //        let calendarManager = calendarView.manager
//        let components = Manager.componentsForDate(date) // from today
//
//        print("Showing Month: \(components.month)")
//    }
//
//}
//
//extension DashBoard1ViewController: CVCalendarViewDelegate, CVCalendarMenuViewDelegate {
//    
//    /// Required method to implement!
//    func presentationMode() -> CalendarMode {
//        return .MonthView
//    }
//    
//    /// Required method to implement!
//    func firstWeekday() -> Weekday {
//        return .Sunday
//    }
//    
//// MARK: Optional methods
//    
//    
//    func shouldAnimateResizing() -> Bool {
//        return true // Default value is true
//    }
//    
//    func didSelectDayView(dayView: CVCalendarDayView, animationDidFinish: Bool) {
//        print("\(dayView.date.commonDescription) is selected!")
//        selectedDay = dayView
//        SELECTED_DATESTR = selectedDay.date.globalDescription
//        //lblDateDisplay.text = SELECTED_DATESTR
//        ///lblDateDisplay.sizeToFit()
//        calView.hidden = true
//        bgview.hidden = true
//        callDashboardAPI()
//        
//        var dte : NSDate = utils.convertStringToDate(dayView.date.commonDescription, dateFormat: "MMM dd, yyyy")
//        
//        print(dte)
//    }
//    
//    func presentedDateUpdated(date: CVDate) {
//        if lblDateDisplay.text != date.globalDescription && self.animationFinished {
//            let updatedMonthLabel = UILabel()
//            updatedMonthLabel.textColor = lblDateDisplay.textColor
//            updatedMonthLabel.font = lblDateDisplay.font
//            updatedMonthLabel.textAlignment = .Center
//            updatedMonthLabel.text = date.commonDescription
//            updatedMonthLabel.sizeToFit()
//            updatedMonthLabel.alpha = 0
//            updatedMonthLabel.center = self.lblDateDisplay.center
//            
//            let offset = CGFloat(48)
//            updatedMonthLabel.transform = CGAffineTransformMakeTranslation(0, offset)
//            updatedMonthLabel.transform = CGAffineTransformMakeScale(1, 0.1)
//            
//            UIView.animateWithDuration(0.35, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
//                self.animationFinished = false
//                self.lblDateDisplay.transform = CGAffineTransformMakeTranslation(0, -offset)
//                self.lblDateDisplay.transform = CGAffineTransformMakeScale(1, 0.1)
//                self.lblDateDisplay.alpha = 0
//                
//                updatedMonthLabel.alpha = 1
//                updatedMonthLabel.transform = CGAffineTransformIdentity
//                
//                }) { _ in
//                    
//                    self.animationFinished = true
//                    self.lblDateDisplay.frame = updatedMonthLabel.frame
//                    self.lblDateDisplay.text = updatedMonthLabel.text
//                    self.lblDateDisplay.transform = CGAffineTransformIdentity
//                    self.lblDateDisplay.alpha = 1
//                    updatedMonthLabel.removeFromSuperview()
//            }
//            
//            self.view.insertSubview(updatedMonthLabel, aboveSubview: self.lblDateDisplay)
//        }
//    }
//    
//    func topMarker(shouldDisplayOnDayView dayView: CVCalendarDayView) -> Bool {
//        return true
//    }
//    
////    func dotMarker(shouldShowOnDayView dayView: CVCalendarDayView) -> Bool {
////        let day = dayView.date.day
////        let randomDay = Int(arc4random_uniform(31))
////        if day == randomDay {
////            return true
////        }
////        
////        return false
////    }
//    
////    func dotMarker(colorOnDayView dayView: CVCalendarDayView) -> [UIColor] {
////        
////        let red = CGFloat(arc4random_uniform(600) / 255)
////        let green = CGFloat(arc4random_uniform(600) / 255)
////        let blue = CGFloat(arc4random_uniform(600) / 255)
////        
////        let color = UIColor(red: red, green: green, blue: blue, alpha: 1)
////        
////        let numberOfDots = Int(arc4random_uniform(3) + 1)
////        switch(numberOfDots) {
////        case 2:
////            return [color, color]
////        case 3:
////            return [color, color, color]
////        default:
////            return [color] // return 1 dot
////        }
////    }
////    
////    func dotMarker(shouldMoveOnHighlightingOnDayView dayView: CVCalendarDayView) -> Bool {
////        return true
////    }
////    
////    func dotMarker(sizeOnDayView dayView: DayView) -> CGFloat {
////        return 13
////    }
//    
//    
//    func weekdaySymbolType() -> WeekdaySymbolType {
//        return .Short
//    }
//    
//    func selectionViewPath() -> ((CGRect) -> (UIBezierPath)) {
//        return { UIBezierPath(rect: CGRectMake(0, 0, $0.width, $0.height)) }
//    }
//    
//    func shouldShowCustomSingleSelection() -> Bool {
//        return false
//    }
//    
//    func preliminaryView(viewOnDayView dayView: DayView) -> UIView {
//        let circleView = CVAuxiliaryView(dayView: dayView, rect: dayView.bounds, shape: CVShape.Circle)
//        circleView.fillColor = .colorFromCode(0xCCCCCC)
//        return circleView
//    }
//    
//    func preliminaryView(shouldDisplayOnDayView dayView: DayView) -> Bool {
//        if (dayView.isCurrentDay) {
//            return true
//        }
//        return false
//    }
//   
//}
//









//MARK: Steps 
/*

// let endDate = dateFormatter1.dateFromString(SELECTED_DATESTR)
//       let endDate : NSDate = utils.convertStringToDate(SELECTED_DATESTR, dateFormat: "yyyy-MM-dd hh:mm:ss")
// let endDate : NSDate = SELECTED_DATEE
//    func fetchTodaysStepFromHealthkit() {
//        var stepsArray : [String] = (lblStepsCount.text?.componentsSeparatedByString(" "))!
//        //NSLog("steps \(stepsArray)")
//        prevSteps = Int(stepsArray[0])!
//
//
//        // let prevStepsStr : String = lblStepsCount.text!
//        let type = HKSampleType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount)
//        let startDate = NSDate.distantPast()
//        //let endDate = utils.convertStringToDate(SELECTED_DATESTR, dateFormat: "yyyy-MM-dd")
//        let dateFormatter2 = NSDateFormatter()
//        dateFormatter2.dateFormat = "yyyy-MM-dd"
//        dateFormatter2.timeZone = NSTimeZone(name: "UTC")
//
//        let endDate : NSDate = dateFormatter2.dateFromString(SELECTED_DATESTR)!
//        print(endDate)
//        let interval = NSDateComponents()
//        interval.day = 1
//
//        let predicate = HKQuery.predicateForSamplesWithStartDate(startDate, endDate: endDate, options: .StrictStartDate)
//        let query = HKStatisticsCollectionQuery(quantityType: type!, quantitySamplePredicate: predicate, options: [.CumulativeSum], anchorDate: NSDate.distantPast(), intervalComponents:interval)
//
//        query.initialResultsHandler = { query, results, error in
//
//
//            let endDate = utils.convertStringToDate(SELECTED_DATESTR, dateFormat: "yyyy-MM-dd")
//            let startDate = NSDate.distantPast()
//            if let myResults = results{
//                myResults.enumerateStatisticsFromDate(startDate, toDate: endDate) {
//                    statistics, stop in
//
//                    if let quantity = statistics.sumQuantity() {
//
//                        let date = statistics.startDate
//                        let steps = quantity.doubleValueForUnit(HKUnit.countUnit())
//                        //  NSLog("\(date): steps = \(steps)")
//                        self.numberOfSteps = Int(steps)
//                        // NSLog(" steps = \(self.numberOfSteps)")
//
//
//                        let dateStr = utils.convertDateToString(date, format: "yyyy-MM-dd")
////                        let dateDte : NSDate = utils.convertStringToDate(dateStr, dateFormat: "yyyy-MM-dd")
//                        let dateFormatter = NSDateFormatter()
//                        dateFormatter.dateFormat = "yyyy-MM-dd"
//                        dateFormatter.timeZone = NSTimeZone(name: "UTC")
//                        let dateDte : NSDate = dateFormatter.dateFromString(dateStr)!
//
//
//
//                        // let currentDate = NSDate()
//                        let currentDateStr = SELECTED_DATESTR //utils.convertDateToString(currentDate, format: "yyyy-MM-dd")
//                        //let currentDte : NSDate = utils.convertStringToDate(currentDateStr, dateFormat: "yyyy-MM-dd")
//
//
//                        let currentDte = dateFormatter.dateFromString(currentDateStr)
//
//                        let currentDay = self.getDateComponents(currentDte!)
//                        let statDay = self.getDateComponents(date)
//
//
//
//                                               // if currentDte!.compare(date) == NSComparisonResult.OrderedSame {
//                        //if currentDay.day == statDay.day {
//                        if currentDte!.compare(dateDte) == NSComparisonResult.OrderedSame {
//                            dispatch_async(dispatch_get_main_queue()) {
//
//                                // let str =  String("\(self.numberOfSteps) steps")
//                                self.SelectednumberOfSteps = self.numberOfSteps
//                                if self.prevSteps != self.SelectednumberOfSteps {
//                                    self.SelectednumberOfSteps = self.numberOfSteps
//                                    let newPercent  = (self.SelectednumberOfSteps/self.stepsGoal) * 100
//                                    self.circularProgressStepsTaken.drawCircleWithPercent(CGFloat(newPercent), duration: 2, lineWidth: 10, clockwise: true, lineCap: kCALineCapRound, fillColor: UIColor.clearColor(), strokeColor: UIColor(red: 255.0/255.0, green: 121.0/255.0, blue: 186.0/255.0, alpha: 1.0), animatedColors: nil)
//                                    self.circularProgressStepsTaken.startAnimation()
//
//                                    self.lblStepsCount.text = String("\(self.SelectednumberOfSteps) steps")
//                                    self.lblTotalNumberOfStepsTaken.text = String("\(self.SelectednumberOfSteps)")
//                                    self.progressBarSteps.setProgress(CGFloat((self.SelectednumberOfSteps/self.stepsGoal)*100), animated: true)
//                                    self.calculateCaloriesBurnedFromSteps()
//                                }else{
//                                    NSLog("no new recorded steps found")
//                                    self.SelectednumberOfSteps = self.numberOfSteps
//                                    let newPercent  = (self.SelectednumberOfSteps/self.stepsGoal) * 100
//                                    self.circularProgressStepsTaken.drawCircleWithPercent(CGFloat(newPercent), duration: 2, lineWidth: 10, clockwise: true, lineCap: kCALineCapRound, fillColor: UIColor.clearColor(), strokeColor: UIColor(red: 255.0/255.0, green: 121.0/255.0, blue: 186.0/255.0, alpha: 1.0), animatedColors: nil)
//                                    self.circularProgressStepsTaken.startAnimation()
//
//                                    self.lblStepsCount.text = String("\(self.SelectednumberOfSteps) steps")
//                                    self.lblTotalNumberOfStepsTaken.text = String("\(self.SelectednumberOfSteps)")
//                                    self.progressBarSteps.setProgress(CGFloat((self.SelectednumberOfSteps/self.stepsGoal)*100), animated: true)
//                                    self.calculateCaloriesBurnedFromSteps()
//                                }
//                            }
//
//
//
//                        }else{
////                            self.SelectednumberOfSteps = 0
////                            let newPercent  = (self.SelectednumberOfSteps/self.stepsGoal) * 100
////                            self.circularProgressStepsTaken.drawCircleWithPercent(CGFloat(newPercent), duration: 2, lineWidth: 10, clockwise: true, lineCap: kCALineCapRound, fillColor: UIColor.clearColor(), strokeColor: UIColor(red: 255.0/255.0, green: 121.0/255.0, blue: 186.0/255.0, alpha: 1.0), animatedColors: nil)
////                            self.circularProgressStepsTaken.startAnimation()
////
////                            self.lblStepsCount.text = String("\(self.SelectednumberOfSteps) steps")
////                            self.lblTotalNumberOfStepsTaken.text = String("\(self.SelectednumberOfSteps)")
////                            self.progressBarSteps.setProgress(CGFloat((self.SelectednumberOfSteps/self.stepsGoal)*100), animated: true)
//                             NSLog("date dint match");
////                                                        //self.numberOfSteps = 0
////                                                        self.lblStepsCount.text = "0 steps"
////                                                        self.progressBarSteps.setProgress(CGFloat((self.numberOfSteps/self.stepsGoal)*100), animated: true)
////                                                        self.lblCaloriesBurnedFromSteps.text = "0.0 cal"
//                        }
//                    }
//                }
//
//            }
//
//
//        }
//        self.healthManager.healthkitstore.executeQuery(query)
//    }


//        var stepsArray : [String] = (lblStepsCount.text?.componentsSeparatedByString(" "))!
//        //NSLog("steps \(stepsArray)")
//        prevSteps = Int(stepsArray[0])!
//
//
//       // let prevStepsStr : String = lblStepsCount.text!
//        let type = HKSampleType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount)
//        let startDate = NSDate.distantPast()
//
//        let dateFormatter2 = NSDateFormatter()
//        dateFormatter2.dateFormat = "yyyy-MM-dd"
//        dateFormatter2.timeZone = NSTimeZone(name: "UTC")
//
//        let endDate : NSDate = dateFormatter2.dateFromString(SELECTED_DATESTR)!
//
//
//        //let endDate = utils.convertStringToDate(SELECTED_DATESTR, dateFormat: "yyyy-MM-dd")
//        print("end date ; \(endDate)")
//        let interval = NSDateComponents()
//        interval.day = 1
//
//        let predicate = HKQuery.predicateForSamplesWithStartDate(startDate, endDate: endDate, options: .StrictStartDate)
//        let query = HKStatisticsCollectionQuery(quantityType: type!, quantitySamplePredicate: predicate, options: [.CumulativeSum], anchorDate: NSDate.distantPast(), intervalComponents:interval)
//
//        query.initialResultsHandler = { query, results, error in
//
//
//            let endDate = utils.convertStringToDate(SELECTED_DATESTR, dateFormat: "yyyy-MM-dd")
//            let startDate = NSDate.distantPast()
//            if let myResults = results{
//                myResults.enumerateStatisticsFromDate(startDate, toDate: endDate) {
//                    statistics, stop in
//
//                    if let quantity = statistics.sumQuantity() {
//                        print(statistics)
//                        let date = statistics.endDate
//                        print(date)
//                        let steps = quantity.doubleValueForUnit(HKUnit.countUnit())
//                      //  NSLog("\(date): steps = \(steps)")
//                        self.numberOfSteps = Int(steps)
//                       // NSLog(" steps = \(self.numberOfSteps)")
//
//                        let dateFormatter1 = NSDateFormatter()
//                        dateFormatter1.dateFormat = "yyyy-MM-dd"
//                        dateFormatter1.timeZone = NSTimeZone(name: "UTC")
//                        let dateStr = dateFormatter1.stringFromDate(date)
//
//                        let dateFormatter2 = NSDateFormatter()
//                        dateFormatter2.dateFormat = "yyyy-MM-dd"
//                        dateFormatter2.timeZone = NSTimeZone(name: "UTC")
//
//                        let dateDte : NSDate = dateFormatter2.dateFromString(dateStr)!
//
//                       // let currentDate = NSDate()
//                        let currentDateStr = SELECTED_DATESTR //utils.convertDateToString(currentDate, format: "yyyy-MM-dd")
//
//                        let dateFormatter = NSDateFormatter()
//                        dateFormatter.dateFormat = "yyyy-MM-dd"
//                        dateFormatter.timeZone = NSTimeZone(name: "UTC")
//
//                        let currentDte = dateFormatter.dateFromString(currentDateStr)
////                        let currentDte : NSDate = utils.convertStringToDate(currentDateStr, dateFormat: "yyyy-MM-dd")
//
//                        print("selected Date ; \(currentDte)   selected str : \(currentDateStr)")
//                        print("healthkit  Date ; \(date)   selected str : \(dateStr)")
//
//
//                        let currentDay = self.getDateComponents(currentDte!)
//                        let statDay = self.getDateComponents(date)
//
//
//
//                       // if currentDte!.compare(date) == NSComparisonResult.OrderedSame {
//                        if currentDay.day == statDay.day {
//
//                            //dispatch_async(dispatch_get_main_queue()) {
//
//                               // let str =  String("\(self.numberOfSteps) steps")
//
//                                if self.prevSteps != self.numberOfSteps {
//
//
//                                    self.lblStepsCount.text = String("\(self.numberOfSteps) steps")
//                                    self.lblTotalNumberOfStepsTaken.text = String("\(self.numberOfSteps) steps")
//                                    //self.progressBarSteps.setProgress(CGFloat(self.numberOfSteps/self.stepsGoal), animated: true)
//                                    self.calculateCaloriesBurnedFromSteps()
//                                }else{
//                                    NSLog("no new recorded steps found")
//                                }
//                          //  }
//                        }else{
//                            NSLog("date dint match");
////                            self.numberOfSteps = 0
////                            self.lblSt epsCount.text = "0 steps"
////                            self.progressBarSteps.setProgress(CGFloat(self.numberOfSteps/100), animated: true)
////                            self.lblCaloriesBurnedFromSteps.text = "0.0 cal"
//                        }
//                    }
//                }
//
//            }
//
//        }
//
//        healthManager.healthkitstore.executeQuery(query)
*/
