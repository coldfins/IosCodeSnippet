//
//  BookAppointmentViewController.swift
//  
//
//  Created by Coldfin Lab on 15/02/16.
//
//

import UIKit

class BookAppointmentViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate,ELCImagePickerControllerDelegate
{
    var images : NSMutableArray = NSMutableArray()
    var elcPicker = ELCImagePickerController()
    var image1: UIImage = UIImage()
    var strTime = ""
    var objBook : BookModel = BookModel()
    var objDoctorList : DoctorListModel = DoctorListModel()
    var arrReason = NSMutableArray()
    var arrReasonId = NSMutableArray()
    var reasonid = NSNumber()
    let image = UIImage(named: "RadioCheck.png") as UIImage?
    var appObj : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var btnNewPatient: UIButton!
    @IBOutlet weak var btnVisitedBefore: UIButton!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var viewDocData: UIView!
    @IBOutlet weak var txtPicker: UITextField!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var imgDoctor: UIImageView!
    @IBOutlet weak var lblDegree: UILabel!
    @IBOutlet weak var viewPatient: UIView!
    @IBOutlet weak var viewBookAppointment: UIView!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        design()
        setDoctorData()
        setpickerView()
        callApi()
        self.btnNewPatient.setImage(image, for: UIControlState())
        self.tabBarController?.tabBar.isHidden = true
        self.scrollview.contentSize = CGSize(width: 320, height: 700)
        let nib = UINib(nibName: "CollectionCellImage", bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: "cellImage")
    }
    override func viewWillAppear(_ animated: Bool)
    {
        elcPicker = ELCImagePickerController(imagePicker: ())
    }
    func setpickerView()
    {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        txtPicker.inputView = pickerView
    }
    func setDoctorData()
    {
        self.lblDegree.text = self.objBook.bookDegree
        self.lblAddress.text = self.objBook.bookAddress
        self.lblName.text = self.objBook.bookName 
        self.lblTime.text = self.objBook.bookTime
        self.imgDoctor.layer.cornerRadius = self.imgDoctor.frame.size.height/2
        self.imgDoctor.clipsToBounds = true
        self.imgDoctor.layer.borderWidth = 0.5
        self.imgDoctor.layer.borderColor = UIColor.lightGray.cgColor
        self.imgDoctor.setImageWith(URL(string: self.objBook.bookImage), placeholderImage:UIImage(named: "user_blank.png"))
        
    }
    func design()
    {
        
        self.navigationItem.title = "Booking"
           
        let button: UIButton = UIButton(type: UIButtonType.custom)
        //set image for button
        button.setImage(UIImage(named: "Back_arrow.png"), for: UIControlState())
        //add function for button
        button.addTarget(self, action: #selector(BookAppointmentViewController.Cancel), for: UIControlEvents.touchUpInside)
        //set frame
        button.frame = CGRect(x: 8,y: 36,width: 8,height: 14)
        let barButton = UIBarButtonItem(customView: button)
        //assign button to navigationbar
        self.navigationItem.leftBarButtonItem = barButton
    }
    func callApi()
    {
        let manager = AFHTTPRequestOperationManager()
        manager.get(self.appObj.baseUrl+"subCategoryList?Id=\(1)",
            parameters: nil,
            success: { (operation,
                responseObject) in
               // print(responseObject.description)
                let element : NSDictionary = responseObject as! NSDictionary
                
                let status : NSString = element.object(forKey:"status") as! NSString
                // print(status)
                if status == "Success"
                {
                    //print(responseObject.description)
                    let arrCategory : NSArray = element.object(forKey:"subCategoryList") as! NSArray
                    for dict in arrCategory
                    {
                        var str = (dict as AnyObject).value(forKey: "SubCategoryName") as! String
                        self.arrReason.add(str)
                        var id = (dict as AnyObject).value(forKey: "SubCategoryId") as! NSNumber
                        self.arrReasonId.add(id)
                    }
                }
            },
            failure: { (operation,
                error) in
               // println("Error: " + error.localizedDescription)
            }
        )
    }
   
    @IBAction func btnNewPatient(_ sender: UIButton!)
    {
        
        self.btnNewPatient.setImage(image, for: UIControlState())
        let image1 = UIImage(named: "RadioUncheck.png") as UIImage?
        self.btnVisitedBefore.setImage(image1, for: UIControlState())

    }
    @IBAction func btnVisitedBefore(_ sender: UIButton!)
    {
        self.btnVisitedBefore.setImage(image, for: UIControlState())
        let image1 = UIImage(named: "RadioUncheck.png") as UIImage?
        self.btnNewPatient.setImage(image1, for: UIControlState())

    }
    func Cancel()
    {
        self.navigationController?.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnContinue(_ sender: UIButton)
    {
        let strId:String = "12187"

              let params = [
                
                "UserId":strId,
                "DocInfoId":self.objBook.bookDocInfoId,
                "AppointmentDate":self.objBook.bookAppointmentDateP,
                "StartTime":self.objBook.bookStartTimeP,
                "EndTime":self.objBook.bookEndTime,
                "SubCategoryId":reasonid,
                "DoctorSeen":"true",
                "DiseasesImage":self.images
                            ] as [String : Any]
   
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return self.arrReason.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return self.arrReason[row] as? String
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        reasonid = self.arrReasonId.object(at: row) as! NSNumber
        self.txtPicker.text = self.arrReason[row] as? String
        self.view.endEditing(true)
    }
    
    @IBAction func btnChooseImage(_ sender: AnyObject)
    {
        if self.images.count == 0
        {
            elcPicker.maximumImagesCount = 5
        }
        else if self.images.count == 1
        {
            elcPicker.maximumImagesCount = 4
        }
        else if self.images.count == 2
        {
            elcPicker.maximumImagesCount = 3
        }
        else if self.images.count == 3
        {
            elcPicker.maximumImagesCount = 2
        }
        else if self.images.count == 4
        {
            elcPicker.maximumImagesCount = 1
        }
        else if self.images.count == 0
        {
            elcPicker.maximumImagesCount = 5
        }
        
        elcPicker.returnsOriginalImage = true
        //Only return the fullScreenImage, not the fullResolutionImage
        elcPicker.returnsImage = true
        //Return UIimage if YES. If NO, only return asset location information
        elcPicker.onOrder = true
        elcPicker.imagePickerDelegate = self
        self.present(elcPicker, animated: true, completion: nil)
    }
    
    
    public func elcImagePickerController(_ picker: ELCImagePickerController!, didFinishPickingMediaWithInfo info: [Any]!) {
        self.dismiss(animated: true, completion: nil)
        
        for dict in info{
            
             let dictionary = dict as? [String: AnyObject]
             let image1 = (dictionary?[UIImagePickerControllerOriginalImage] as! UIImage)
             self.images.add(self.image1)
           
        }
        self.collectionView.reloadData()
    }
  
    func elcImagePickerControllerDidCancel(_ picker: ELCImagePickerController!)
    {
        self.dismiss(animated: true, completion: nil)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.images.count
    }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    func collectionView(_ collectionView: UICollectionView, cellForItemAtIndexPath indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellImage", for: indexPath) as! CollectionCellImage
        if self.images.count == 0
        {
        }
        else
        {
            cell.imgDisease.image = self.images.object(at: indexPath.row) as? UIImage
            cell.btnClose.addTarget(self, action: #selector(BookAppointmentViewController.Delete(_:)), for: UIControlEvents.touchUpInside)
            cell.btnClose.layer.setValue(indexPath.row, forKey: "index")
        }
        
        return cell
    }
    func Delete(_ sender:UIButton!)
    {
        let i = sender.layer.value(forKey: "index") as! Int
        self.images.removeObject(at: i)
        self.collectionView.reloadData()
    }
    
}
