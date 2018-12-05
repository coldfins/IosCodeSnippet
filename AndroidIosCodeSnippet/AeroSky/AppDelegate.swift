//
//  AppDelegate.swift
//  AeroSky
//
//  Created by Coldfin Lab on 20-7-2017.
//  Copyright © 2017 Coldfin Lab. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate {

    open var arrAllCity = NSMutableArray()
    var window: UIWindow?
    var index : Int!
    var isShortcut : Bool = false
    
    let googleMapsApiKey = "AIzaSyDYMFCMej88rBCzVmxbiRujlLITv2lCtZk"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        GMSServices.provideAPIKey(googleMapsApiKey)
        
        if let font = UIFont(name: "Roboto-Regular.ttf", size: 12) {
            UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: font]
        }
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        UITabBar.appearance().barTintColor = UIColor.white
        //To change the image/text color on selection
        UITabBar.appearance().tintColor = UIColor.colorLikeNavigationBackground()
        
        let tabBarCon = self.window?.rootViewController as! UITabBarController
        
        return true
    }
    
    func ShowActivityIndicator(){
        
        let animationView : UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 67,height: 85))
        
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
        
        let arrayImage = NSArray(array: [image1!,image2!,image3!, image4!,image5!,image6!,image7!,image8!,image9!,image10!,image11!,image12!,image13!,image14!,image15!,image16!,image17!,image18!,image19!,image20!])
        
        animationView.animationImages = arrayImage as? [UIImage]
        animationView.animationDuration = 0.5
        animationView.animationRepeatCount = 0
        animationView.startAnimating()
        
        JTProgressHUD.show(with: animationView, style: JTProgressHUDStyle.default, transition: JTProgressHUDTransition.default, backgroundAlpha: 0.5)
    }
    
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

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "AeroSky")
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

}

