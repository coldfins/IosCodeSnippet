//
//  PastViewController.swift
//  
//
//  Created by Coldfin Lab on 27/02/16.
//
//

import UIKit

class PastViewController: UIViewController,UITableViewDelegate,UITableViewDataSource
{

    @IBOutlet weak var tblPastAppointments: UITableView!
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
        for i in 0 ..< self.appObj.arrPastAppointment.count
        {
            objFutureModel = self.appObj.arrPastAppointment.object(at: i) as! FutureAppointmentModel
            arrAppointmentDate.add(objFutureModel.pastAppointmentDate)
            arrAppointmentAddress.add(objFutureModel.pastAddress)
            arrAppointmentFname.add(objFutureModel.pastfirstName)
            arrAppointmentStartTime.add(objFutureModel.pastStartTime)
            arrAppointmentimage.add(objFutureModel.pastImage)
            arrAppointmentAttend.add(objFutureModel.pastAttend)
            arrId.add(objFutureModel.pastAppointmentId)
        }
        let nib = UINib(nibName: "CustomPastCell", bundle: nil)
        self.tblPastAppointments.register(nib, forCellReuseIdentifier: "cellPast")
        self.tblPastAppointments.reloadData()
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
        return appObj.arrPastAppointment.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell:CustomPastCell! = tableView.dequeueReusableCell(withIdentifier: "cellPast") as! CustomPastCell
        
        if cell == nil
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "cellPast") as! CustomPastCell
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
        if attend == 0
        {
            cell.imgAttend.image = UIImage(named: "Panding.png")
        }
        if attend == 2
        {
            cell.imgAttend.image = UIImage(named: "Rejected.png")
        }
       
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell
    }
      
}
