//
//  DailyWeightViewController.swift
//  MapMyDiet
//
//  Created by Coldfin Lab on 23/02/16.
//  Copyright © 2016 Coldfin Lab. All rights reserved.
//

import UIKit

class DailyWeightViewController: UIViewController,NVActivityIndicatorViewable {

    @IBOutlet weak var lblWeightValue: UILabel!
    @IBOutlet weak var lblPrevDayWeight: UILabel!
    @IBOutlet weak var lblGoalWeight: UILabel!
    @IBOutlet weak var viewWeightScale: UIView!
    
    var longScrolView : DMCircularScrollView = DMCircularScrollView()
    var scales : NSArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblWeightValue.text = String("\(weightForDate)")
        lblPrevDayWeight.isHidden = true
        
        longScrolView = DMCircularScrollView()
        longScrolView = DMCircularScrollView(frame: CGRect(x: 0, y: 30, width: self.viewWeightScale.frame.width,height: viewWeightScale.frame.height - 30))
        scales = generateSampleUIViews(50)
        longScrolView.pageWidth = 50;
        longScrolView.backgroundColor = utils.colorTheme
        
        longScrolView.setPageCount(UInt(scales.count), withDataSource: { (pageIndex : UInt) -> UIView! in
            return (self.scales.object(at: Int(pageIndex)) as! UIView)
        })

        longScrolView.currentPageIndex = UInt(weightForDate)
        viewWeightScale.addSubview(longScrolView)
        
        let imageview : UIImageView = UIImageView(frame: CGRect(x: self.viewWeightScale.frame.width/2 - 15, y: 0, width: 30, height: 30))
        imageview.image = UIImage(named: "Arrowtop_G_25.png")
        viewWeightScale.addSubview(imageview)

        longScrolView.handlePageChange = { (currentPageIndex : UInt, previousPageIndex : UInt) -> Void in
            let viewbg : UIView = self.scales.object(at: Int(currentPageIndex)) as! UIView
            let btn : UIButton = viewbg.viewWithTag(11111) as! UIButton
            self.lblWeightValue.text = String("\(btn.title(for: UIControlState())!)")
        }
        
        if defaults.value(forKey: USER_DEFAULTS_USER_GOAL_WEIGHT_KEY) != nil {
            lblGoalWeight.text = String("\(defaults.value(forKey: USER_DEFAULTS_USER_GOAL_WEIGHT_KEY)!)Kgs.")
            
        }else{
            lblGoalWeight.text = String("\(defaults.value(forKey: USER_DEFAULTS_USER_CURRRENT_WEIGHT_KEY)!)Kgs.")
        }
       
    }
    
    func generateSampleUIViews(_ wd : CGFloat) -> NSMutableArray {
        let scale_view : NSMutableArray = NSMutableArray()
        
        for k in 0  ..< 280 {
            let backview = UIView(frame: CGRect(x: 0,y: 0, width: wd, height: 75))
            let lbl : UILabel = UILabel(frame: CGRect(x: 0,y: 10,width: wd,height: 25))
            lbl.text = String("\(k)")
            lbl.textColor = UIColor.white
            lbl.tag = 1
            lbl.font = UIFont(name: "Helvetica Neue", size: 12.0)
            lbl.textAlignment = .center
            
            backview.addSubview(lbl)
            
            let btn : UIButton = UIButton(type: .custom)
            btn.frame = CGRect(x: 0,y: 25,width: wd,height: 50)
            btn.setTitle(String("\(k)"), for: UIControlState())
            btn.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 0.0)
            btn.titleLabel?.textColor = utils.colorTheme
            btn.isUserInteractionEnabled = true
            btn.setBackgroundImage(UIImage(named: "Lines_75_1.png"), for: UIControlState())
            btn.tag = 11111
            backview.addSubview(btn)
            scale_view.add(backview)
        }
        return scale_view
    }

    @IBAction func btn_tapped(_ sender: AnyObject) {
        let btn : UIButton  = sender as! UIButton
        NSLog("\(btn.title(for: UIControlState())!)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onClick_setWeight(_ sender: AnyObject) {
        
       let weightfloat : Float = Float(lblWeightValue.text!)!
       let size = CGSize(width: 30, height:30)
       startAnimating(size, message: nil, type: NVActivityIndicatorType(rawValue: 22)!)
        
       if weightfloat > 20 {
            let userid : Int = defaults.value(forKey: USER_DEFAULTS_USER_ID_KEY) as! Int
            let url : String = String("\(API_BASE_URL)/\(API_ADD_WEIGHT)")
            let parameters : NSDictionary = ["date":SELECTED_DATESTR,"weight":weightfloat,"user_id":userid]
        
            let manager = AFHTTPRequestOperationManager()
            manager.post( url, parameters: parameters,
                success: { (operation, responseObject) in
                    self.stopAnimating()
                    
                    let element : NSDictionary = responseObject as! NSDictionary
                    let strStatus : String = element.value(forKey: "status") as! String
                    if strStatus == "success" {
                        weightForDate = weightfloat
                        defaults.set(weightfloat, forKey: USER_DEFAULTS_USER_CURRRENT_WEIGHT_KEY)
                        self.navigationController?.popViewController(animated: true)
                        
                    }else{
                        self.stopAnimating()
                        utils.customAlertView("Something went wrong. Try Again.", view: self.view)
                    }
                     self.stopAnimating()
                },
                failure: { (operation, error) in
                    self.stopAnimating()
                    utils.failureBlock(self.view)
                    NSLog("We got an error here.. \(error?.localizedDescription)")
            } )
        }else{
            self.stopAnimating()
            utils.customAlertView("The weight is too low for normal human being. Select valid weight.", view: self.view)
        }
    }
    
    @IBAction func onClick_BackButton(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }

}
