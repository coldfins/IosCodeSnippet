//
//  SettingsViewController.swift
//  WallPost
//
//  Created by Ved on 15/03/17.
//  Copyright © 2017 Ved. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btn_ProfileClick(_ sender: AnyObject){
        
        let profileVC = self.storyboard!.instantiateViewController(withIdentifier: IdentifireEditProfileView) as! EditProfileViewController
        self.navigationController?.pushViewController(profileVC, animated: false) 
    }
    
    @IBAction func btn_ChangePwdClick(_ sender: AnyObject){
        
        let changePwdVC = self.storyboard!.instantiateViewController(withIdentifier: IdentifireChangePwdView) as! ChangePasswordViewController
        self.navigationController?.pushViewController(changePwdVC, animated: false)
    }
    
    @IBAction func btnLogoutClicked(sender: UIButton) {
        
        UserDefaults.standard.removeObject(forKey:keyUserId)
        UserDefaults.standard.removeObject(forKey:keyFirstName)
        UserDefaults.standard.removeObject(forKey:keyLastName)
        UserDefaults.standard.removeObject(forKey:keyEmail)
        UserDefaults.standard.removeObject(forKey:keyContact)
        UserDefaults.standard.removeObject(forKey:keyBirthDate)
        UserDefaults.standard.removeObject(forKey:keyProfilePic)
        self.navigationController?.popViewController(animated: true)
        
    }

    @IBAction func btnBackClicked(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
}
