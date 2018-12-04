//
//  TimeViewController.swift
//  
//
//  Created by Coldfin Lab on 28/03/16.
//
//

import UIKit
protocol RateDelegate: class {
    
    func SubmitCall()
}

class TimeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    var appObj : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var viewDismiss: UIView!
    @IBOutlet weak var viewTableview: UIView!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var viewBackground: UIView!
    weak var delegate: RateDelegate?
    @IBOutlet weak var tblTimeSlots: UITableView!
    var objDoctorModel : DoctorProfileModel = DoctorProfileModel()
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.tblTimeSlots.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        if IS_IPHONE_4_OR_LESS
        {
            self.viewDismiss.frame = CGRect(x: 0, y: 430, width: 320, height: 50)
            self.viewTableview.frame = CGRect(x: 0, y: 0, width: 334, height: 430)
            self.tblTimeSlots.frame = CGRect(x: 0, y: 0, width: 334, height: 430)
        }
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    @IBAction func btnClose(_ sender: UIButton)
    {
        self.dismiss(animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.objDoctorModel.tblStartTime.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:UITableViewCell = self.tblTimeSlots.dequeueReusableCell(withIdentifier: "cell")!
        
        
        self.objDoctorModel.strstart = self.objDoctorModel.tblStartTime.object(at: indexPath.row) as! String
        self.objDoctorModel.strend = self.objDoctorModel.tblEndTime.object(at: indexPath.row) as! String
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let dateObj = dateFormatter.date(from: self.objDoctorModel.strstart)
        let dateObjEnd = dateFormatter.date(from: self.objDoctorModel.strend)
        dateFormatter.dateFormat = "HH:mm a"
        let convertedDate = dateFormatter.string(from: dateObj!)
        let convertedDateEnd = dateFormatter.string(from: dateObjEnd!)
        let strCompleteDate = convertedDate + " - " + convertedDateEnd
        cell.textLabel?.text = strCompleteDate
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.font = UIFont.systemFont(ofSize: 12.0)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        delegate?.SubmitCall()
        self.objDoctorModel.strstart = self.objDoctorModel.tblStartTime.object(at: indexPath.row) as! String
        self.objDoctorModel.strend = self.objDoctorModel.tblEndTime.object(at: indexPath.row) as! String
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let dateObj = dateFormatter.date(from: self.objDoctorModel.strstart)
        let dateObjEnd = dateFormatter.date(from: self.objDoctorModel.strend)
        let current = Date()
        if current.compare(dateObj!) == ComparisonResult.orderedSame
        {
            dateFormatter.dateFormat = "HH:mm a"
            let convertedDate = dateFormatter.string(from: dateObj!)
            let convertedDateEnd = dateFormatter.string(from: dateObjEnd!)
            let strCompleteDate = convertedDate + " - " + convertedDateEnd
            self.objDoctorModel.returnfinal = strCompleteDate
            
            let prefs = UserDefaults.standard
            prefs.setValue(strCompleteDate, forKey: "Finaldate")
            prefs.setValue(self.objDoctorModel.strstart, forKey: "StartTime")
            prefs.setValue(self.objDoctorModel.strend, forKey: "EndTime")
            self.dismiss(animated: true, completion: nil)
        }
        else if current.compare(dateObj!) == ComparisonResult.orderedAscending
        {
            dateFormatter.dateFormat = "HH:mm a"
            let convertedDate = dateFormatter.string(from: dateObj!)
            let convertedDateEnd = dateFormatter.string(from: dateObjEnd!)
            let strCompleteDate = convertedDate + " - " + convertedDateEnd
            self.objDoctorModel.returnfinal = strCompleteDate
            
            let prefs = UserDefaults.standard
            prefs.setValue(strCompleteDate, forKey: "Finaldate")
            prefs.setValue(self.objDoctorModel.strstart, forKey: "StartTime")
            prefs.setValue(self.objDoctorModel.strend, forKey: "EndTime")
            self.dismiss(animated: true, completion: nil)
        }
        else if current.compare(dateObj!) == ComparisonResult.orderedDescending
        {
            self.appObj.strStart = "oopss"
            let alert : SCLAlertView = SCLAlertView()
            alert.labelTitle.textColor = UIColor.red
            alert.labelTitle.alpha = 0.8
            alert.backgroundType = .Blur
            alert.showAnimationType = .SlideInFromTop
            alert.hideAnimationType = .SlideOutToBottom
            alert.tintTopCircle = true
            alert.showWaiting(self, title: "Oops!!", subTitle: "Valid time is not selected!" , closeButtonTitle: "OK", duration: 3.0)
        }
    }
}
