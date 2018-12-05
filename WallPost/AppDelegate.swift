//
//  AppDelegate.swift
//  WallPost
//
//  Created by Ved on 22/02/17.
//  Copyright © 2017 Ved. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let reachability = Reachability()!
    var networkStatus : Reachability!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged),name: ReachabilityChangedNotification,object: reachability)
        
        try! reachability.startNotifier()
        
        
        // Override point for customization after application launch.
        return true
    }
    
    
    func ShowAlert(_ alertTitle : NSString , alertMessage
        : NSString)
    {
        let alert = UIAlertView()
        alert.title = alertTitle as String
        alert.message = alertMessage as String
        alert.addButton(withTitle: "OK")
        alert.show()
    }


    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func reachabilityChanged(note: NSNotification) {
        
        networkStatus = note.object as! Reachability
        
        if networkStatus.isReachable {
            if networkStatus.isReachableViaWiFi {
                print("App - Reachable via WiFi")
            } else {
                print("App - Reachable via Cellular")
            }
        } else {
            print("App - Network not reachable")
            
        }
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged),name: ReachabilityChangedNotification,object: reachability)
        
        do{
            try! reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

