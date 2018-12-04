//
//  SpecialityTableViewController.swift
//  
//
//  Created by Coldfin Lab on 10/02/16.
//
//

import UIKit
class SpecialityTableViewController: UITableViewController
{
  
   var objDoctorList : DoctorListModel = DoctorListModel()
   var appObj : AppDelegate = UIApplication.shared.delegate as! AppDelegate
   @IBOutlet var tblSpeciality: UITableView!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white,NSFontAttributeName: UIFont(name: "Helvetica Neue", size: 16)!]
        
        let button: UIButton = UIButton(type:UIButtonType.custom)
        button.setImage(UIImage(named: "Back_arrow.png"), for: UIControlState())
        button.addTarget(self, action: #selector(SpecialityTableViewController.Cancelbtn), for: UIControlEvents.touchUpInside)
        button.frame = CGRect(x: 8,y: 36,width: 8,height: 14)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = barButton
        callApi()
    }
    func Cancelbtn()
    {
        self.navigationController?.popViewController(animated: true)
        
    }
    func callApi()
    {
         let manager = AFHTTPRequestOperationManager()
        manager.get(self.appObj.baseUrl+"categoryList",
            parameters: nil,
            success: { (operation,
                responseObject) in
                
                let element : NSDictionary = responseObject as! NSDictionary
                
                var status : NSString = element.object(forKey:"status") as! NSString
                
                if status == "Success"
                {
                   
                    let arrCategory : NSArray = element.object(forKey:"categoryList") as! NSArray
                   
                    for dict in arrCategory
                    {
                        self.objDoctorList.strSpeciality = (dict as AnyObject).value(forKey: "CategoryName") as! String
                        self.objDoctorList.SpecialityId = (dict as AnyObject).value(forKey: "CategoryId") as! NSNumber
                        self.objDoctorList.arrSpecialty.add( self.objDoctorList.strSpeciality)
                        self.objDoctorList.arrIdSpeciality.add(self.objDoctorList.SpecialityId)
                        self.tblSpeciality.reloadData()
                    }
                   
                                  }
                else
                {
                    print("Sorry!!!!")
                }
                //
            },
            failure: { (operation,
                error) in
               // println("Error: " + error.localizedDescription)
            }
            )
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return self.objDoctorList.arrSpecialty.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 55
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
          let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) 
         cell.textLabel?.text = self.objDoctorList.arrSpecialty.object(at: indexPath.row) as? String
        cell.textLabel?.font = UIFont.systemFont(ofSize: 12.0)

        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let indexPath = tableView.indexPathForSelectedRow
       let currentCell = tableView.cellForRow(at: indexPath!) as UITableViewCell!
        currentCell?.contentView.backgroundColor = UIColor.colorApplication()
        self.objDoctorList.strSpeciality = (currentCell?.textLabel!.text!)!
        let app = UIApplication.shared.delegate as! AppDelegate
        app.Speciality = self.objDoctorList.strSpeciality
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "ReasonTableViewController") as! ReasonTableViewController
        secondViewController.objDoctorList.subcategoryId = self.objDoctorList.arrIdSpeciality[indexPath!.row] as! NSNumber
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
}
