//
//  ViewController.swift
//  WallPost
//
//  Created by Ved on 22/02/17.
//  Copyright © 2017 Ved. All rights reserved.
//

import UIKit

let kMaxRadius: CGFloat = 200
let kMaxDuration: TimeInterval = 10

class JoinViewController: UIViewController {

    @IBOutlet weak var btnConnect: UIButton!
    
    let pulsator = Pulsator()
    let reachability = Reachability()!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnConnect.layer.superlayer?.insertSublayer(pulsator, below: btnConnect.layer)
        
        pulsator.numPulse = 4
        pulsator.radius = 150.0
        pulsator.backgroundColor = UIColor.black.cgColor
        pulsator.start()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged),name: ReachabilityChangedNotification,object: reachability)
        
        try! reachability.startNotifier()
        
    }
    
    func reachabilityChanged(note: NSNotification) {
        
        let networkStatus = note.object as! Reachability
        
        if networkStatus.isReachable {
            if networkStatus.isReachableViaWiFi {
                print("Reachable via WiFi")
                self.btnConnect.setTitle("Join", for: UIControlState.normal)
            } else {
                print("Reachable via Cellular")
                self.btnConnect.setTitle("Connect", for: UIControlState.normal)
                self.setAlertViewforWifi()
            }
        } else {
            print("Network not reachable")
            self.btnConnect.setTitle("Connect", for: UIControlState.normal)
            self.setAlertViewforWifi()
        }
    }
    
    func setAlertViewforWifi(){
        
        let alertController = UIAlertController (title: "Wi-Fi", message: "Wi-Fi connections are disabled", preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string:"App-Prefs:root=WIFI") else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        print("Settings opened: \(success)") // Prints true
                    })
                } else {
                    // Fallback on earlier versions
                    UIApplication.shared.openURL(settingsUrl)
                }
            }
        }
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func btnFindClicked(sender: UIButton) {
        let storyboard=UIStoryboard(name: "Main", bundle: nil)
        let RegistrationVC = storyboard.instantiateViewController(withIdentifier: IdentifireLoginView) as! LoginViewController
        self.navigationController?.pushViewController(RegistrationVC, animated: false)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.layer.layoutIfNeeded()
        pulsator.position = btnConnect.layer.position
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

