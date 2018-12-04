//
//  ReasonTableViewController.swift
//  
//
//  Created by Coldfin Lab on 10/02/16.
//
//

import UIKit

class ReasonTableViewController: UITableViewController
{
    var appObj : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var objDoctorList : DoctorListModel = DoctorListModel()
    @IBOutlet var tblReason: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor.white,
                NSFontAttributeName: UIFont(name: "Helvetica Neue", size: 16)!]
        let button: UIButton = UIButton(type:UIButtonType.custom)
        //set image for button
        button.setImage(UIImage(named: "Back_arrow.png"), for: UIControlState())
        //add function for button
        button.addTarget(self, action: #selector(ReasonTableViewController.Cancelbtn), for: UIControlEvents.touchUpInside)
        //set frame
        button.frame = CGRect(x: 8,y: 36,width: 8,height: 14)
        let barButton = UIBarButtonItem(customView: button)
        //assign button to navigationbar
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
        manager.get(self.appObj.baseUrl+"subCategoryList?Id=\(self.objDoctorList.subcategoryId)",
            parameters: nil,
            success: { (operation,
                responseObject) in
                
                let element : NSDictionary = responseObject as! NSDictionary
                
                var status : NSString = element.object(forKey:"status") as! NSString
                if status == "Success"
                {
                    //print(responseObject.description)
                    let arrCategory : NSArray = element.object(forKey:"subCategoryList") as! NSArray
                    for dict in arrCategory
                    {
                        self.objDoctorList.strName = (dict as AnyObject).value(forKey: "SubCategoryName") as! String
                        self.objDoctorList.catid = (dict as AnyObject).value(forKey: "SubCategoryId") as! NSNumber
                        self.objDoctorList.arrId.add(self.objDoctorList.catid)
                        self.objDoctorList.arrReason.add(self.objDoctorList.strName)
                        self.tblReason.reloadData()
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
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.objDoctorList.arrReason.count
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 55
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) 

        cell.textLabel?.text = self.objDoctorList.arrReason[indexPath.row] as? String
        cell.textLabel?.font = UIFont.systemFont(ofSize: 12.0)
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let index = tableView.indexPathForSelectedRow
        let currentCell = tableView.cellForRow(at: index!) as UITableViewCell!
        currentCell?.contentView.backgroundColor = UIColor.colorApplication()
        self.objDoctorList.strLabel = (currentCell?.textLabel!.text!)!
        self.objDoctorList.data = self.objDoctorList.arrId[indexPath.row] as! NSNumber
        let app = UIApplication.shared.delegate as! AppDelegate
        app.Reason = self.objDoctorList.strLabel
        app.categoryId = self.objDoctorList.subcategoryId
        app.subcategoryId = self.objDoctorList.data
        let viewcntroller = storyboard?.instantiateViewController(withIdentifier: "SecondViewController") as! FindDoctorViewController
        self.navigationController?.pushViewController(viewcntroller, animated: false)
    }
}
