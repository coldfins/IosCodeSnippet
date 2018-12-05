
//
//  AppDelegate.swift
//  FitnessApp
//
//  Created by Coldfin Lab on 04/02/16.
//  Copyright (c) 2016 ved. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UIAlertViewDelegate {

	var window: UIWindow?
    var timeDiff : Int = 0
    var stoppedTime : Date!
    
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

       calledFrom = ""
        
       UIApplication.shared.statusBarStyle = .lightContent
       ReachabilityManager.shared()
        if defaults.value(forKey: USER_DEFAULTS_IS_LOGGED_IN) != nil {
            if defaults.value(forKey: USER_DEFAULTS_IS_LOGGED_IN) as! String == "true" {
                let initialViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "myTabbarControllerID")
                window?.rootViewController = initialViewController
                window?.makeKeyAndVisible()
            }
        }
        return true
    }
    
	func applicationWillResignActive(_ application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	}
    
	func applicationDidEnterBackground(_ application: UIApplication) {
        stoppedTime = Date()
	}

	func applicationWillEnterForeground(_ application: UIApplication) {
        
        let timeinterval : TimeInterval = Date().timeIntervalSince(stoppedTime)
        let swappedSeconds : Double = timeinterval.truncatingRemainder(dividingBy: 60)
        Seconds = Seconds + Int(swappedSeconds)
	}

	func applicationDidBecomeActive(_ application: UIApplication) {
        NSLog("Application did become active")
    }
    

	func applicationWillTerminate(_ application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}
}

