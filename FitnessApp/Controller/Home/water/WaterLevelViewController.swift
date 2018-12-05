//
//  WaterLevelViewController.swift
//  MapMyDiet
//
//  Created by Coldfin Lab on 22/02/16.
//  Copyright © 2016 Coldfin Lab. All rights reserved.
//

import UIKit


class WaterLevelViewController: UIViewController, NVActivityIndicatorViewable, UIGestureRecognizerDelegate,CAAnimationDelegate {

    @IBOutlet weak var viewWaterLevel: UIView!
    @IBOutlet weak var viewWaterIntakeLevel: UIView!
    @IBOutlet weak var btn29ml: UIButton!
    @IBOutlet weak var btn236ml: UIButton!
    @IBOutlet weak var btn354ml: UIButton!
    @IBOutlet weak var btn709ml: UIButton!
    @IBOutlet weak var viewSelectML: UIView!
    @IBOutlet weak var imgStatus: UIImageView!
    @IBOutlet weak var lblGoalLiters: UILabel!
    @IBOutlet weak var lblTotalLitersDrank: UILabel!
    
    var dailyWaterGoal : Float = 0.0
    var waterAddingFactor : Float = 29.0
    var totalWaterIntake : Float = 0.0
    var defaultFrame : CGRect = CGRect.zero
    var dailywaterGoalLtrs : Float = 0.0
    var bubbleTimer : Timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let border1: CALayer = CALayer()
        let borderWidth1: CGFloat = 1
        border1.borderColor = utils.colorBorder.cgColor
        border1.frame = CGRect(x: 0, y: viewSelectML.frame.size.height - borderWidth1, width: viewSelectML.frame.size.width, height: viewSelectML.frame.size.height)
        border1.borderWidth = borderWidth1
        viewSelectML.layer.addSublayer(border1)
        viewSelectML.layer.masksToBounds = true
        
        btn29ml.backgroundColor = utils.colorTheme
        btn29ml.isSelected = true
        btn29ml.layer.borderColor = UIColor(red: 232.0/255.0, green: 232.0/255.0, blue: 232.0/255.0, alpha: 1.0).cgColor
        btn29ml.layer.borderWidth = 1.0
        
        btn236ml.layer.borderColor = UIColor(red: 232.0/255.0, green: 232.0/255.0, blue: 232.0/255.0, alpha: 1.0).cgColor
        btn236ml.layer.borderWidth = 1.0
        
        btn354ml.layer.borderColor = UIColor(red: 232.0/255.0, green: 232.0/255.0, blue: 232.0/255.0, alpha: 1.0).cgColor
        btn354ml.layer.borderWidth = 1.0
        
        btn709ml.layer.borderColor = UIColor(red: 232.0/255.0, green: 232.0/255.0, blue: 232.0/255.0, alpha: 1.0).cgColor
        btn709ml.layer.borderWidth = 1.0

        let glass : UIImage = UIImage(named: "EmptyGlass350.png")!
        let imageView : UIImageView = UIImageView(image: glass)
        imageView.frame = CGRect(x: 0, y: 0, width: viewWaterLevel.frame.width, height: viewWaterLevel.frame.height - 35.0);
        imageView.contentMode = .scaleAspectFit
        
        viewWaterLevel.mask = imageView;
        viewWaterLevel.layer.masksToBounds = true
        viewWaterLevel.layer.cornerRadius = 5
        viewWaterLevel.clipsToBounds = true
        
        let swipeUpGesture = UISwipeGestureRecognizer(target: self, action: #selector(WaterLevelViewController.handleSwipeUp(_:)))
        swipeUpGesture.delegate = self
        swipeUpGesture.direction = .up
        viewWaterLevel.addGestureRecognizer(swipeUpGesture)

        defaultFrame = viewWaterIntakeLevel.frame
        
        let swipeDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(WaterLevelViewController.handleSwipeDown(_:)))
        swipeDownGesture.delegate = self
        swipeDownGesture.direction = .down
        viewWaterLevel.addGestureRecognizer(swipeDownGesture)
        
        totalWaterIntake = waterLevelForDate
        if totalWaterIntake == 0.0 {
            let waterINtakeLevelHeight : Float = 0
            var viewframe : CGRect = self.viewWaterIntakeLevel.frame
            viewframe.origin.x = 0
            viewframe.origin.y = viewframe.origin.y - CGFloat(waterINtakeLevelHeight)
            viewframe.size.height = 0
            self.viewWaterIntakeLevel.frame = viewframe
        }else{
            if defaults.value(forKey: "waterLevelHeight") != nil {
                let waterINtakeLevelHeight : Float = ((defaults.value(forKey: "waterLevelHeight") as AnyObject).floatValue)!
                if waterINtakeLevelHeight != 0.0 {
                    var viewframe : CGRect = self.viewWaterIntakeLevel.frame
                    viewframe.origin.x = 0
                    viewframe.origin.y = viewframe.origin.y - CGFloat(waterINtakeLevelHeight)
                    viewframe.size.height = viewframe.size.height + CGFloat(waterINtakeLevelHeight)
                    self.viewWaterIntakeLevel.frame = viewframe
                }else{
                    let waterINtakeLevelHeight : Float = totalWaterIntake/2
                    var viewframe : CGRect = self.viewWaterIntakeLevel.frame
                    viewframe.origin.x = 0
                    viewframe.origin.y = viewframe.origin.y - CGFloat(waterINtakeLevelHeight)
                    viewframe.size.height = viewframe.size.height + CGFloat(waterINtakeLevelHeight)
                    self.viewWaterIntakeLevel.frame = viewframe
                }
                
            }else{
                let waterINtakeLevelHeight : Float = totalWaterIntake/2
                var viewframe : CGRect = self.viewWaterIntakeLevel.frame
                viewframe.origin.x = 0
                viewframe.origin.y = viewframe.origin.y - CGFloat(waterINtakeLevelHeight)
                viewframe.size.height = viewframe.size.height + CGFloat(waterINtakeLevelHeight)
                self.viewWaterIntakeLevel.frame = viewframe
            }
        }
        
        convertMilliLitersToLiters(totalWaterIntake)
        
        bubbleTimer = Timer.scheduledTimer(timeInterval: 0.12, target: self, selector: #selector(WaterLevelViewController.addBubble), userInfo: nil, repeats: true)
        
        loadDefaults()
    }
    
    func loadDefaults() {
        var totalWaterIntake_defaults : Float = 0.0
        totalWaterIntake_defaults = waterLevelForDate
        calculateWaterLevelStatus(totalWaterIntake_defaults)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func handleSwipeUp(_ recognizer :UISwipeGestureRecognizer) {
        
        let animation : CATransition = CATransition()
        animation.delegate = self
        animation.duration = 1.75
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.type = "rippleEffect"
        animation.fillMode = kCAFillModeRemoved
        animation.endProgress = 0.99
        animation.isRemovedOnCompletion = false
        viewWaterIntakeLevel.layer.add(animation, forKey: nil)
        
        var viewframe : CGRect = self.viewWaterIntakeLevel.frame
        viewframe.origin.x = 0
        
        if waterAddingFactor == 29.0 {
            
            UIView.animate(withDuration: 2.0, animations: { () -> Void in
                viewframe.origin.y = viewframe.origin.y - 14.5
                viewframe.size.height = viewframe.size.height + 14.5
                self.viewWaterIntakeLevel.frame = viewframe
                }, completion: { (finished : Bool) -> Void in
                   NSLog("animatipon done")
            }) 
        }else if waterAddingFactor == 236.0 {
            UIView.animate(withDuration: 2.0, animations: { () -> Void in
                viewframe.origin.y = viewframe.origin.y - 50.0
                viewframe.size.height = viewframe.size.height + 50.0
                self.viewWaterIntakeLevel.frame = viewframe
                }, completion: { (finished : Bool) -> Void in
                    NSLog("animatipon done")
            }) 
        }else if waterAddingFactor == 354.0 {
            UIView.animate(withDuration: 2.0, animations: { () -> Void in
                viewframe.origin.y = viewframe.origin.y - 75.0
                viewframe.size.height = viewframe.size.height + 75.0
                self.viewWaterIntakeLevel.frame = viewframe
                }, completion: { (finished : Bool) -> Void in
                    NSLog("animatipon done")
            }) 
        }else if waterAddingFactor == 709.0 {
            UIView.animate(withDuration: 2.0, animations: { () -> Void in
                viewframe.origin.y = viewframe.origin.y - 100.0
                viewframe.size.height = viewframe.size.height + 100.0
                self.viewWaterIntakeLevel.frame = viewframe
                }, completion: { (finished : Bool) -> Void in
                    NSLog("animatipon done")
            })
        }
        totalWaterIntake = totalWaterIntake + waterAddingFactor
        convertMilliLitersToLiters(totalWaterIntake)
        calculateWaterLevelStatus(totalWaterIntake)
    }
    
    func handleSwipeDown(_ recognizer :UISwipeGestureRecognizer) {
       
        var viewframe : CGRect = self.viewWaterIntakeLevel.frame
        viewframe.origin.x = 0
        
        if waterAddingFactor == 29.0 {
            if totalWaterIntake > 29.0 {
                let count : Float = totalWaterIntake / 29.0
                let reducingHeight : CGFloat = viewWaterIntakeLevel.frame.size.height / CGFloat(count)
                
                UIView.animate(withDuration: 2.0, animations: { () -> Void in
                    viewframe.origin.y = viewframe.origin.y + reducingHeight
                    viewframe.size.height = viewframe.size.height - reducingHeight
                    self.viewWaterIntakeLevel.frame = viewframe
                    }, completion: { (finished : Bool) -> Void in
                        NSLog("animatipon done")
                }) 
                
                totalWaterIntake = totalWaterIntake - waterAddingFactor
             }else{
                
                UIView.animate(withDuration: 2.0, animations: { () -> Void in
                    viewframe.origin.y = self.viewWaterLevel.frame.size.height
                    viewframe.size.height = 0
                    self.viewWaterIntakeLevel.frame = viewframe
                    }, completion: { (finished : Bool) -> Void in
                        NSLog("animatipon done")
                }) 
              totalWaterIntake = 0
            }
        }else if waterAddingFactor == 236 {
            
            if totalWaterIntake > 236 {
                let count : Float = totalWaterIntake / 236.0
                let reducingHeight : CGFloat = viewWaterIntakeLevel.frame.size.height / CGFloat(count)
                UIView.animate(withDuration: 2.0, animations: { () -> Void in
                    viewframe.origin.y = viewframe.origin.y + reducingHeight
                    viewframe.size.height = viewframe.size.height - reducingHeight
                    self.viewWaterIntakeLevel.frame = viewframe
                    }, completion: { (finished : Bool) -> Void in
                        NSLog("animation done")
                }) 
                
                totalWaterIntake = totalWaterIntake - waterAddingFactor
              
            }else{
                
                UIView.animate(withDuration: 2.0, animations: { () -> Void in
                    viewframe.origin.y = self.viewWaterLevel.frame.size.height
                    viewframe.size.height = 0
                    self.viewWaterIntakeLevel.frame = viewframe
                    }, completion: { (finished : Bool) -> Void in
                        NSLog("animatipon done")
                }) 
                totalWaterIntake = 0
            }
        }else if waterAddingFactor == 354 {
            if totalWaterIntake > 354 {
                let count : Float = totalWaterIntake / 354.0
                let reducingHeight : CGFloat = viewWaterIntakeLevel.frame.size.height / CGFloat(count)
                
                UIView.animate(withDuration: 2.0, animations: { () -> Void in
                    viewframe.origin.y = viewframe.origin.y + reducingHeight
                    viewframe.size.height = viewframe.size.height - reducingHeight
                    self.viewWaterIntakeLevel.frame = viewframe
                    }, completion: { (finished : Bool) -> Void in
                        NSLog("animatipon done")
                }) 
                
                totalWaterIntake = totalWaterIntake - waterAddingFactor
            }else{
                
                UIView.animate(withDuration: 2.0, animations: { () -> Void in
                    viewframe.origin.y = self.viewWaterLevel.frame.size.height
                    viewframe.size.height = 0
                    self.viewWaterIntakeLevel.frame = viewframe

                    }, completion: { (finished : Bool) -> Void in
                        NSLog("animatipon done")
                }) 
                
                totalWaterIntake = 0
            }
        }else if waterAddingFactor == 709 {
            if totalWaterIntake > 709 {
                let count : Float = totalWaterIntake / 709.0
                let reducingHeight : CGFloat = viewWaterIntakeLevel.frame.size.height / CGFloat(count)
                
                UIView.animate(withDuration: 2.0, animations: { () -> Void in
                    viewframe.origin.y = viewframe.origin.y + reducingHeight
                    viewframe.size.height = viewframe.size.height - reducingHeight
                    self.viewWaterIntakeLevel.frame = viewframe
                    
                    }, completion: { (finished : Bool) -> Void in
                        NSLog("animatipon done")
                }) 
                
                totalWaterIntake = totalWaterIntake - waterAddingFactor
            }else{
                
                UIView.animate(withDuration: 2.0, animations: { () -> Void in
                    viewframe.origin.y = self.viewWaterLevel.frame.size.height
                    viewframe.size.height = 0
                    self.viewWaterIntakeLevel.frame = viewframe
                    
                    }, completion: { (finished : Bool) -> Void in
                        NSLog("animatipon done")
                }) 
                totalWaterIntake = 0
            }
        }
        
        convertMilliLitersToLiters(totalWaterIntake)
        
        let animation : CATransition = CATransition()
        animation.delegate = self as! CAAnimationDelegate
        animation.duration = 1.75
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn) //kCAMediaTimingFunctionEaseInEaseOut
        animation.type = "rippleEffect"
        animation.fillMode = kCAFillModeRemoved
        animation.endProgress = 0.99
        animation.isRemovedOnCompletion = false
        viewWaterIntakeLevel.layer.add(animation, forKey: nil)
        calculateWaterLevelStatus(totalWaterIntake)
    }
    
    func calculateWaterLevelStatus(_ totalWaterIntake : Float){
        
        let weightKgs : Float = defaults.value(forKey: USER_DEFAULTS_USER_CURRRENT_WEIGHT_KEY) as! Float
        let weightLbs : Float = weightKgs * 2.2048
        let dailywaterGoaloz = weightLbs * 0.5
       
        dailywaterGoalLtrs = dailywaterGoaloz / 33.814
        lblGoalLiters.text = NSString(format: "%.01f Liters", dailywaterGoalLtrs) as String
        defaults.setValue(dailywaterGoalLtrs, forKey: USER_DEFAULTS_USER_DAILY_WATER_GOAL)
        
        let totalWaterIntakeLtr = totalWaterIntake / 1000.0
        if dailywaterGoalLtrs > totalWaterIntakeLtr {
            imgStatus.image = UIImage(named: "Arrow_R_down_25.png")
        }else{
            imgStatus.image = UIImage(named: "Arrow_G_up_25.png")
        }
    }
    
    func convertMilliLitersToLiters(_ waterLevelMLs : Float) {
        let waterlevelLtrs = waterLevelMLs / 1000.0
        lblTotalLitersDrank.text = String("\(waterlevelLtrs) Ltrs")
    }
    
    func addBubble() {
       
        let radius: CGFloat = 1
        let x1 = arc4random_uniform(UInt32(viewWaterIntakeLevel.frame.size.width))
        
        let circle = UIView(frame: CGRect(x: CGFloat(x1), y: viewWaterIntakeLevel.frame.size.height - 20, width: 2*radius, height: 2*radius))
        circle.layer.cornerRadius = radius
        circle.layer.borderWidth = 1
        circle.layer.masksToBounds = true
        circle.layer.borderColor = UIColor.white.cgColor
        viewWaterIntakeLevel.addSubview(circle)
        UIView.animate(withDuration: 2.0, animations: {
            let radius:CGFloat = 4
            circle.layer.frame = CGRect(x: CGFloat(x1), y: -10, width: 2*radius, height: 2*radius)
            circle.layer.cornerRadius = radius
            }, completion: { _ in
                circle.removeFromSuperview()
        }) 
    }
    
    @IBAction func onClick_selectML(_ sender: AnyObject) {
       
        let btn : UIButton = sender as! UIButton
        
        if btn.tag == 1 {
            btn29ml.backgroundColor = utils.colorTheme
            btn236ml.backgroundColor = UIColor.white
            btn354ml.backgroundColor = UIColor.white
            btn709ml.backgroundColor = UIColor.white
            btn29ml.isSelected = true
            btn236ml.isSelected = false
            btn354ml.isSelected = false
            btn709ml.isSelected = false

            waterAddingFactor = 29
        }
        else if btn.tag == 2 {
            btn236ml.backgroundColor = utils.colorTheme
            btn29ml.backgroundColor = UIColor.white
            btn354ml.backgroundColor = UIColor.white
            btn709ml.backgroundColor = UIColor.white
            
            btn236ml.isSelected = true
            btn29ml.isSelected = false
            btn354ml.isSelected = false
            btn709ml.isSelected = false
            waterAddingFactor = 236
        }
        else if btn.tag == 3 {
            btn354ml.backgroundColor = utils.colorTheme
            btn29ml.backgroundColor = UIColor.white
            btn236ml.backgroundColor = UIColor.white
            btn709ml.backgroundColor = UIColor.white
            
            btn354ml.isSelected = true
            btn29ml.isSelected = false
            btn236ml.isSelected = false
            btn709ml.isSelected = false
            waterAddingFactor = 354
        }
        else if btn.tag == 4 {
            btn709ml.backgroundColor = utils.colorTheme
            btn29ml.backgroundColor = UIColor.white
            btn236ml.backgroundColor = UIColor.white
            btn354ml.backgroundColor = UIColor.white
            
            btn709ml.isSelected = true
            btn29ml.isSelected = false
            btn236ml.isSelected = false
            btn354ml.isSelected = false
            waterAddingFactor = 709
        }
        else {
            waterAddingFactor = 0
        }
    }
    
    @IBAction func onClick_SaveBtn(_ sender: AnyObject) {
       
        let size = CGSize(width: 30, height:30)
        startAnimating(size, message: nil, type: NVActivityIndicatorType(rawValue: 22)!)
       
        defaults.set(String("\(viewWaterIntakeLevel.frame.size.height)"), forKey: "waterLevelHeight")
        defaults.set(String("\(totalWaterIntake)"), forKey: USER_DEFAULTS_USER_DAILY_WATER_INTAKE_LEVEL)
        
        let userid : Int = defaults.value(forKey: USER_DEFAULTS_USER_ID_KEY) as! Int
        let url : String = String("\(API_BASE_URL)/\(API_ADD_DAILY_WATER_LEVEL)")
        let parameters : NSDictionary = ["daily_water_level[date]":SELECTED_DATESTR,"daily_water_level[water_level]":totalWaterIntake,"daily_water_level[user_id]":userid,"daily_water_level[water_height]":viewWaterIntakeLevel.frame.height]
        
        let manager = AFHTTPRequestOperationManager()
        manager.post( url, parameters: parameters,
            success: { (operation, responseObject) in
                self.stopAnimating()
                NSLog("Yes thies was a success \((responseObject as AnyObject).description)")
                let element : NSDictionary = responseObject as! NSDictionary
                let strStatus : String = element.value(forKey: "status") as! String
                if strStatus == "success" {
                    waterLevelForDate = self.totalWaterIntake
                    self.navigationController?.popViewController(animated: true)
                }else{
                    utils.customAlertView("Something went wrong. Try Again.", view: self.view)
                }
            },
            failure: { (operation, error) in
                self.stopAnimating()
                utils.failureBlock(self.view)
                NSLog("We got an error here.. \(error?.localizedDescription)")
        } )
    }
    
    @IBAction func onClick_CancelBtn(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
