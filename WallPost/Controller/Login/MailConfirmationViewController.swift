//
//  MailConfirmationViewController.swift
//  WallPost
//
//  Created by Ved on 17/03/17.
//  Copyright © 2017 Ved. All rights reserved.
//

import UIKit

class MailConfirmationViewController: UIViewController {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var btnSave: UIButton!
    
    let gradientLayer = CAGradientLayer()
    var appDelegate = AppDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.serGradientView()
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.btnSave.layer.cornerRadius = 28
        self.btnSave.layer.masksToBounds = true
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnLoginClicked(sender: UIButton) {
        let storyboard=UIStoryboard(name: "Main", bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: IdentifireLoginView) as! LoginViewController
        self.navigationController?.pushViewController(loginVC, animated: false)
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func btnBackClicked(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func serGradientView(){
        
        gradientLayer.frame = self.viewMain.bounds
        
        let color1 = UIColor.white.cgColor as CGColor
        let color2 = UIColor(red: 231/255, green: 252/255, blue: 253/255, alpha: 1.0).cgColor as CGColor
        let color3 = UIColor(red: 113/255, green: 221/255, blue: 234/255, alpha: 1.0).cgColor as CGColor
        let color4 = UIColor(red: 63/255, green: 199/255, blue: 216/255, alpha: 1.0).cgColor as CGColor
        
        gradientLayer.colors = [color1,color2,color3,color4]
        gradientLayer.locations = [0.0, 0.25, 0.75, 1.0]
        self.viewMain.layer.superlayer?.insertSublayer(gradientLayer, below: self.viewMain.layer)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
