//
//  AppDelegate.swift
//  CutIt
//
//  Created by Coldfin lab

//  Copyright © 2017 Coldfin lab. All rights reserved.

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder,UIApplicationDelegate,UIAlertViewDelegate,UNUserNotificationCenterDelegate {

    var window: UIWindow?
    var userType:String = ""
    var planName:String = ""
    var isAccepted : Bool = false
    var customerId = NSNumber()
    var vendorId = NSNumber()
    var txtTitle : UITextField = UITextField()
    var txtPromotionDescription = UITextField()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        GMSServices.provideAPIKey(keyGoogleMap)
        return true
    }
    
    //Show activity indicator while downloading data from API
    func ShowActivityIndicator(){
        
        //  CGRectMake(0, 0, 150 / [[UIScreen mainScreen] scale], 50 / [[UIScreen mainScreen] scale])
        
        let animationView : UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        
        let image1 = UIImage(named: "01.png")
        let image2 = UIImage(named: "02.png")
        let image3 = UIImage(named: "03.png")
        let image4 = UIImage(named: "04.png")
        let image5 = UIImage(named: "05.png")
        let image6 = UIImage(named: "06.png")
        let image7 = UIImage(named: "07.png")
        let image8 = UIImage(named: "08.png")
        let image9 = UIImage(named: "09.png")
        let image10 = UIImage(named: "10.png")
        let image11 = UIImage(named: "11.png")
        let image12 = UIImage(named: "12.png")
        let image13 = UIImage(named: "13.png")
        let image14 = UIImage(named: "14.png")
        let image15 = UIImage(named: "15.png")
        let image16 = UIImage(named: "16.png")
        let image17 = UIImage(named: "17.png")
        let image18 = UIImage(named: "18.png")
        let image19 = UIImage(named: "19.png")
        let image20 = UIImage(named: "20.png")
        
        let arrayImage = NSArray(array: [image1!,image2!,image3!,image4!,image5!,image6!,image7!,image8!,image9!,image10!,image11!,image12!,image13!,image14!,image15!,image16!,image17!,image18!,image19!,image20!])
        
        animationView.animationImages = arrayImage as? [UIImage]
        animationView.animationDuration = 2.5
        animationView.animationRepeatCount = 0
        animationView.startAnimating()
        
        JTProgressHUD.show(with: animationView, style: JTProgressHUDStyle.default, transition: JTProgressHUDTransition.fade, backgroundAlpha: 0.5)
    }
    
    //Remove activity indicator after downloading data from API
    func RemoveActivityIndicator(){
        JTProgressHUD.hide()
    }
    
    func ShowAlert(_ alertTitle : NSString , alertMessage : NSString)
    {
        let alert = UIAlertView()
        alert.title = alertTitle as String
        alert.message = alertMessage as String
        alert.addButton(withTitle: "OK")
        alert.show()
    }
   
   
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}
