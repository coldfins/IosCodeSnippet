//
//  AppDelegate.swift
//  BestDoct
//
//  Created by Coldfin Lab on 04/02/16.
//  Copyright (c) 2016 ved. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UITabBarControllerDelegate,CNPPopupControllerDelegate,UNUserNotificationCenterDelegate
{

    var window: UIWindow?
    var baseUrl = "http://34.212.127.62:82/api/DocAppSysAPI/"
    var latitudeApp : String = String()
    var longitudeApp : String = String()
    var arrLatitude = NSMutableArray()
    var arrLongitude = NSMutableArray()
    var arrName = NSMutableArray()
    var arrAddress = NSMutableArray()
    var arrDegree = NSMutableArray()
    var arrImage = NSMutableArray()
    var arrExperience = NSMutableArray()
    var arrStartTime = NSMutableArray()
    var arrEndTime = NSMutableArray()
    var arrDocInfoId = NSMutableArray()
    var arrFees = NSMutableArray()
    var Speciality : String = String()
    var Reason : String = String()
    var categoryId = NSNumber()
    var subcategoryId = NSNumber()
    var arrAppointmentDate = NSMutableArray()
    var arrCurrentAppointment = NSMutableArray()
    var arrPastAppointment = NSMutableArray()
    var arrFutureAppointment = NSMutableArray()
    var fileimages = NSMutableArray()
    var strStart = String()
    var strPassword = String()
    var check = String()
   
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UIApplication.shared.statusBarStyle = .lightContent

        UIApplication.shared.applicationIconBadgeNumber = 0
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
                // Enable or disable features based on authorization.
            }
        } else {
            let settings = UIUserNotificationSettings(types: [UIUserNotificationType.alert, UIUserNotificationType.sound] , categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
            UIApplication.shared.registerForRemoteNotifications()
            // Fallback on earlier versions
        }
        UIApplication.shared.registerForRemoteNotifications()
        
        var tabcontroller:UITabBarController = self.window?.rootViewController as! UITabBarController
        var tabbar : UITabBar = tabcontroller.tabBar
        
        let item1  : UITabBarItem=(tabbar.items?[0])! as UITabBarItem
        let item2  : UITabBarItem=(tabbar.items?[1])! as UITabBarItem
        
        
        item1.image=UIImage(named: "Search1.png")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        item2.image=UIImage(named: "Settings1.png")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
       
        item1.selectedImage=UIImage(named: "SearchWhite.png")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        item2.selectedImage=UIImage(named: "SettingsWhite.png")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor(red: 133.0/255.0, green: 205.0/255.0, blue: 239.0/255.0, alpha: 1.0)], for:UIControlState())
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.white], for:.selected)
        
        return true
    }
    
    func application( _ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data )
    {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        NSLog("Device Token %@", deviceTokenString)
        let defaults = UserDefaults.standard
        defaults.set(deviceTokenString, forKey: "keydeviceTokenString")
        defaults.synchronize()
    }

    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (_ options: UNNotificationPresentationOptions) -> Void) {
        //Called when a notification is delivered to a foreground app.
        NSLog("Userinfo %@",(notification.request.content.userInfo))
        //.ShowAlert(AlertTitle as NSString, alertMessage:message)
        completionHandler(UNNotificationPresentationOptions.alert)
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        //Called to let your app know which action was selected by the user for a given notification.
        NSLog("Userinfo %@",(response.notification.request.content.userInfo))
        
        let dict : NSDictionary = response.notification.request.content.userInfo as NSDictionary
        if dict.object(forKey: "aps") as? NSDictionary != nil
        {
            let notification:NSDictionary = dict.object(forKey: "aps") as! NSDictionary
            let alert:NSString = notification.object(forKey: "alert") as! NSString
            
            let alertCtrl = UIAlertController(title: "DoctFin", message: alert as String, preferredStyle: UIAlertControllerStyle.alert)
            alertCtrl.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            // Find the presented VC...
            var presentedVC = self.window?.rootViewController
            while (presentedVC!.presentedViewController != nil)  {
                presentedVC = presentedVC!.presentedViewController
            }
            presentedVC!.present(alertCtrl, animated: true, completion: nil)
        }

    }

    func application( _ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error )
    {
        NSLog("Notification Error:%@", error.localizedDescription)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any])
    {
        NSLog("Receive Remote Notification ::::::%@", userInfo)
        let dict : NSDictionary = userInfo as NSDictionary
        let notification:NSDictionary = dict.object(forKey: "aps") as! NSDictionary
        let alert:NSString = notification.object(forKey: "alert") as! NSString
        
            let alertCtrl = UIAlertController(title: "DoctFin", message: alert as String, preferredStyle: UIAlertControllerStyle.alert)
            alertCtrl.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            // Find the presented VC...
            var presentedVC = self.window?.rootViewController
            while (presentedVC!.presentedViewController != nil)  {
                presentedVC = presentedVC!.presentedViewController
            }
            presentedVC!.present(alertCtrl, animated: true, completion: nil)
            
            let state : UIApplicationState = application.applicationState
            if (state == UIApplicationState.active)
            {
                let localNotification = UILocalNotification()
                localNotification.fireDate = Date()
                localNotification.userInfo = userInfo
                localNotification.alertBody = alert as String
                UIApplication.shared.scheduleLocalNotification(localNotification)
            }
    }
    
   func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
    
    application.applicationIconBadgeNumber = 0
    
    let dict : NSDictionary = notification.userInfo! as NSDictionary
    
    let notification : NSDictionary = dict.object(forKey: "aps") as! NSDictionary
    let alert : NSString = notification.object(forKey: "alert") as! NSString
    
    let alertCtrl = UIAlertController(title: "DoctFin", message: alert as String, preferredStyle: UIAlertControllerStyle.alert)
                alertCtrl.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                // Find the presented VC...
                var presentedVC = self.window?.rootViewController
                while (presentedVC!.presentedViewController != nil)  {
                    presentedVC = presentedVC!.presentedViewController
                }
                presentedVC!.present(alertCtrl, animated: true, completion: nil)
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

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.ved.BestDoct" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1] 
    }()

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "BestDoct")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
  /*  lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "BestDoct", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("BestDoct.sqlite")
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        if coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil) == nil {
            coordinator = nil
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges && !moc.save(&error) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog("Unresolved error \(error), \(error!.userInfo)")
                abort()
            }
        }
    } */

}

