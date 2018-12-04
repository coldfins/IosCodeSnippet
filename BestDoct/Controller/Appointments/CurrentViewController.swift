//
//  CurrentViewController.swift
//  
//
//  Created by Coldfin Lab on 27/02/16.
//


import UIKit

class CurrentViewController: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    @IBOutlet weak var viewNodata: UIView!
    @IBOutlet weak var tblCurrentAppointment: UITableView!
    var appObj : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var objFutureModel = FutureAppointmentModel()
    var arrAppointmentDate = NSMutableArray()
    var arrAppointmentAddress = NSMutableArray()
    var arrAppointmentFname = NSMutableArray()
    var arrAppointmentStartTime = NSMutableArray()
    var arrAppointmentimage = NSMutableArray()
    var arrAppointmentAttend = NSMutableArray()
    var arrId = NSMutableArray()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        for i in 0 ..< self.appObj.arrCurrentAppointment.count
        {
            objFutureModel = self.appObj.arrCurrentAppointment.object(at: i) as! FutureAppointmentModel
            arrAppointmentDate.add(objFutureModel.currentAppointmentDate)
            arrAppointmentAddress.add(objFutureModel.currentAddress)
            arrAppointmentFname.add(objFutureModel.currentfirstName)
            arrAppointmentStartTime.add(objFutureModel.currentStartTime)
            arrAppointmentimage.add(objFutureModel.currentImage)
            arrAppointmentAttend.add(objFutureModel.currentAttend)
            arrId.add(objFutureModel.currentAppointmentId)
        }
        let nib = UINib(nibName: "CustomCurrentCell", bundle: nil)
        self.tblCurrentAppointment.register(nib, forCellReuseIdentifier: "cellCurrent")
        self.tblCurrentAppointment.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 77
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return appObj.arrCurrentAppointment.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell:CustomCurrentCell! = tableView.dequeueReusableCell(withIdentifier: "cellCurrent") as! CustomCurrentCell
        
        if cell == nil
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "cellCurrent") as! CustomCurrentCell
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let dateObj = dateFormatter.date(from: self.arrAppointmentStartTime.object(at: indexPath.row) as! String)
        let dateObj2 = dateFormatter.date(from: self.arrAppointmentDate.object(at: indexPath.row) as! String)
        dateFormatter.dateFormat = "EEE, MMM dd, yyyy"
         let convertedAppointmentTime = dateFormatter.string(from: dateObj2!)
        dateFormatter.dateFormat = "HH:mm a"
        let converteddate = dateFormatter.string(from: dateObj!)
        cell.lblFirstName.text = "Appointment with Dr." + " " + (self.arrAppointmentFname.object(at: indexPath.row) as! String) as String
        cell.lblAppointmentTime.text = convertedAppointmentTime + " " + converteddate
        cell.lblAddress.text = self.arrAppointmentAddress.object(at: indexPath.row) as? String
        cell.imgDoctor.layer.cornerRadius = cell.imgDoctor.frame.size.height/2
        cell.imgDoctor.clipsToBounds = true
        cell.imgDoctor.layer.borderWidth = 0.5
        cell.imgDoctor.layer.borderColor = UIColor.lightGray.cgColor
        cell.imgDoctor.setImageWith(URL(string: self.arrAppointmentimage.object(at: indexPath.row) as! String), placeholderImage:UIImage(named: "user_blank.png"))
        let attend: NSNumber = self.arrAppointmentAttend.object(at: indexPath.row) as! NSNumber
        if attend == 1
        {
            cell.imgAttend.image = UIImage(named: "Accepted.png")
        }
        else if attend == 0
        {
            cell.imgAttend.image = UIImage(named: "Panding.png")
        }
        else if attend == 2
        {
            cell.imgAttend.image = UIImage(named: "Rejected.png")
        }
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
}
