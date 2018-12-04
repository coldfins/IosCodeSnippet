//
//  FutureViewController.swift
//  
//
//  Created by Coldfin Lab on 27/02/16.
//
//

import UIKit

class FutureViewController: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    @IBOutlet weak var tblFutureAppointment: UITableView!
    var appObj : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var convertedAppointmentTime = ""
    var attend: NSNumber = NSNumber()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let nib = UINib(nibName: "CustomFutureCell", bundle: nil)
        self.tblFutureAppointment.register(nib, forCellReuseIdentifier: "cellFuture")
        self.tblFutureAppointment.reloadData()
        // Do any additional setup after loading the view.
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.appObj.arrFutureAppointment.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 78
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell:CustomFutureCell! = tableView.dequeueReusableCell(withIdentifier: "cellFuture") as! CustomFutureCell
        
        if cell == nil
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "cellFuture") as! CustomFutureCell
        }
        let objfuture = self.appObj.arrFutureAppointment.object(at: indexPath.row) as! FutureAppointmentModel
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let dateObj = dateFormatter.date(from: objfuture.futureStartTime as String)
        let dateObj2 = dateFormatter.date(from: objfuture.futureAppointmentDate as String)
        dateFormatter.dateFormat = "EEE, MMM dd, yyyy"
        convertedAppointmentTime = dateFormatter.string(from: dateObj2!)
        dateFormatter.dateFormat = "HH:mm a"
        let converteddate = dateFormatter.string(from: dateObj!)
        cell.lblFirstName.text = "Appointment with Dr." + " " + (objfuture.futurefirstName) as String
        cell.lblAppointmentTime.text = convertedAppointmentTime + " " + converteddate
        cell.lblAddress.text = objfuture.futureAddress as String
        cell.imgDoctor.layer.cornerRadius = cell.imgDoctor.frame.size.height/2
        cell.imgDoctor.clipsToBounds = true
        cell.imgDoctor.layer.borderWidth = 0.5
        cell.imgDoctor.layer.borderColor = UIColor.lightGray.cgColor
        cell.imgDoctor.setImageWith(URL(string: objfuture.futureImage as String), placeholderImage:UIImage(named: "user_blank.png"))
        self.attend = objfuture.futureAttend as NSNumber
        if self.attend == 1
        {
            cell.imgAttend.image = UIImage(named: "Accepted.png")
        }
        else if self.attend == 0
        {
            cell.imgAttend.image = UIImage(named: "Panding.png")
        }
        else if self.attend == 2
        {
            cell.imgAttend.image = UIImage(named: "Rejected.png")
        }
       
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        // the cells you would like the actions to appear needs to be editable
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        // you need to implement this method too or you can't swipe to display the actions
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let more = UITableViewRowAction(style: .normal, title: "")
            { action, index in
        }
        more.backgroundColor = UIColor.lightGray
         let model = self.appObj.arrFutureAppointment.object(at: indexPath.row) as! FutureAppointmentModel
        self.attend = model.futureAttend as NSNumber
        if self.attend == 0
        {
            
                let more = UITableViewRowAction(style: .normal, title: "Cancel")
                { action, index in
                   
                    let params =
                    [
                        "AppointmentId" : model.futureAppointmentId,
                        "Attend" : 3
                    ]

                    let manager = AFHTTPRequestOperationManager()
                    manager.post(self.appObj.baseUrl+"DeleteAppointment",
                        parameters: params,
                        success: { (operation,
                            responseObject) in
                           // print(responseObject.description)
                            self.appObj.arrFutureAppointment.removeObject(at: indexPath.row)
                            self.tblFutureAppointment.reloadData()
                        },
                        failure: {
                            (operation,
                            error) in
                           // println("Error: " + error.localizedDescription)
                        }
                    )
                    
            }
            more.backgroundColor = UIColor.red
            return [more]
        }
       else if self.attend == 1
       {
          let more = UITableViewRowAction(style: .normal, title: "Cancel")
            { action, index in
                let model = self.appObj.arrFutureAppointment.object(at: indexPath.row) as! FutureAppointmentModel
                let params =
                [
                    "AppointmentId" : model.futureAppointmentId,
                    "RejectedReason" : ""
                ] as [String : Any]
                let manager = AFHTTPRequestOperationManager()
                manager.post(self.appObj.baseUrl+"DeleteAppointment",
                    parameters: params,
                    success: 
                    { (operation,
                        responseObject) in
                    },
                    failure: 
                    { (operation,
                        error) in
                    }
                )
                self.appObj.arrFutureAppointment.removeObject(at: indexPath.row)
                self.tblFutureAppointment.reloadData()
        }
        
        more.backgroundColor = UIColor.red
        
        let favorite = UITableViewRowAction(style: .normal, title: "Add Reminder")
            { action, index in
                let controller = self.storyboard?.instantiateViewController(withIdentifier: "AddReminderViewController") as! AddReminderViewController
                controller.apptTime = model.futureAppointmentDate as String
                controller.appointmentTime = model.futureStartTime as String
                controller.firstname = model.futurefirstName
                controller.attend = model.futureAttend
                controller.clinicname = model.futureClinicName
                controller.reason = model.futureSubCategory
                self.navigationController?.pushViewController(controller, animated: true)
        }
        favorite.backgroundColor = UIColor.orange
         return [favorite,more]
       }
        return [more]
    }
}
