//
//  AppointmentDetailViewController.swift
//  
//
//  Created by Coldfin Lab on 11/04/16.
//
//

import UIKit

class AppointmentDetailViewController: UIViewController
{
    @IBOutlet weak var imgDoctor: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblClinic: UILabel!
    @IBOutlet weak var lblNoAttachment: UILabel!
    @IBOutlet weak var lblResidency: UILabel!
    @IBOutlet weak var lbldate: UILabel!
    @IBOutlet weak var lblOfficeAddress: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblReason: UILabel!
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var imgBack: UIButton!
    @IBOutlet weak var imgInfo: UIImageView!
    @IBOutlet weak var lblFiles: UILabel!
    @IBOutlet weak var viewDetails: UIView!
    
    let imageView = UIImageView()
    var apptdetailobj = FutureAppointmentModel()
    var imagearr = NSMutableArray()
    var appObj : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        design()
        setData()
        
        UIView.animate(withDuration: 0.7, animations:
        { () -> Void in
            
            let angle = CGFloat(90 * M_PI / 90)
            self.imgBack.transform = CGAffineTransform(rotationAngle: angle)
        })
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationController?.isNavigationBarHidden = true
        if IS_IPHONE_4_OR_LESS
        {
             self.viewDetails.frame = CGRect(x: 31, y: 28, width: 258, height: 425)
            var imgArray = NSArray()
            let str: String = self.imagearr.object(at: 0) as! String
            if str != ""
            {
                imgArray = str.components(separatedBy: ", ") as NSArray
            }
            if imgArray.count == 0
            {
                self.lblNoAttachment.isHidden = false
                self.lblNoAttachment.frame = CGRect(x: 59, y: 388, width: 130, height: 21)
            }
            else
            {
                self.lblNoAttachment.isHidden = true
                let path = "http://34.212.127.62:82/img/DiseasesImage/"
                imageView.frame = CGRect(x: 41, y: 360, width: 40, height: 40)
                view.addSubview(imageView)
                if imgArray.count == 1
                {
                    let finalImage = path + (imgArray.object(at: 0) as! String)
                    let imageView1 = UIImageView()
                    imageView1.frame = CGRect(x: imageView.frame.origin.x + 50, y: 360, width: 40, height: 40)
                    imageView.frame = imageView1.frame
                    view.addSubview(imageView1)
                    imageView1.setImageWith(URL(string:finalImage), placeholderImage:UIImage(named: "user_blank.png"))
                }
                else if imgArray.count == 2
                {
                    let finalImage = path + (imgArray.object(at: 0) as! String)
                    let imageView1 = UIImageView()
                    imageView1.frame = CGRect(x: imageView.frame.origin.x + 50, y: 360, width: 40, height: 40)
                    imageView.frame = imageView1.frame
                    view.addSubview(imageView1)
                    imageView1.setImageWith(URL(string:finalImage), placeholderImage:UIImage(named: "user_blank.png"))
                    
                    let finalImage2 = path + (imgArray.object(at: 1) as! String)
                    let imageView2 = UIImageView()
                    imageView2.frame = CGRect(x: imageView.frame.origin.x + 50, y: 360, width: 40, height: 40)
                    imageView.frame = imageView2.frame
                    view.addSubview(imageView2)
                    imageView2.setImageWith(URL(string:finalImage2), placeholderImage:UIImage(named: "user_blank.png"))
                }
                else if imgArray.count == 3
                {
                    let finalImage = path + (imgArray.object(at: 0) as! String)
                    let imageView1 = UIImageView()
                    imageView1.frame = CGRect(x: imageView.frame.origin.x + 50, y: 360, width: 40, height: 40)
                    imageView.frame = imageView1.frame
                    view.addSubview(imageView1)
                    imageView1.setImageWith(URL(string:finalImage), placeholderImage:UIImage(named: "user_blank.png"))
                    
                    let finalImage2 = path + (imgArray.object(at: 1) as! String)
                    let imageView2 = UIImageView()
                    imageView2.frame = CGRect(x: imageView.frame.origin.x + 50, y: 360, width: 40, height: 40)
                    imageView.frame = imageView2.frame
                    view.addSubview(imageView2)
                    imageView2.setImageWith(URL(string:finalImage2), placeholderImage:UIImage(named: "user_blank.png"))
                    
                    let finalImage3 = path + (imgArray.object(at: 2) as! String)
                    let imageView3 = UIImageView()
                    imageView3.frame = CGRect(x: imageView.frame.origin.x + 50, y: 360, width: 40, height: 40)
                    imageView.frame = imageView3.frame
                    view.addSubview(imageView3)
                    imageView3.setImageWith(URL(string:finalImage3), placeholderImage:UIImage(named: "user_blank.png"))
                }
                else if imgArray.count == 4
                {
                    let finalImage = path + (imgArray.object(at: 0) as! String)
                    let imageView1 = UIImageView()
                    imageView1.frame = CGRect(x: imageView.frame.origin.x + 50, y: 360, width: 40, height: 40)
                    imageView.frame = imageView1.frame
                    view.addSubview(imageView1)
                    imageView1.setImageWith(URL(string:finalImage), placeholderImage:UIImage(named: "user_blank.png"))
                    
                    let finalImage2 = path + (imgArray.object(at: 1) as! String)
                    let imageView2 = UIImageView()
                    imageView2.frame = CGRect(x: imageView.frame.origin.x + 50, y: 360, width: 40, height: 40)
                    imageView.frame = imageView2.frame
                    view.addSubview(imageView2)
                    imageView2.setImageWith(URL(string:finalImage2), placeholderImage:UIImage(named: "user_blank.png"))
                    
                    let finalImage3 = path + (imgArray.object(at: 2) as! String)
                    let imageView3 = UIImageView()
                    imageView3.frame = CGRect(x: imageView.frame.origin.x + 50, y: 360, width: 40, height: 40)
                    imageView.frame = imageView3.frame
                    view.addSubview(imageView3)
                    imageView3.setImageWith(URL(string:finalImage3), placeholderImage:UIImage(named: "user_blank.png"))
                    
                    let finalImage4 = path + (imgArray.object(at: 3) as! String)
                    let imageView4 = UIImageView()
                    imageView4.frame = CGRect(x: imageView.frame.origin.x + 50, y: 360, width: 40, height: 40)
                    imageView.frame = imageView4.frame
                    view.addSubview(imageView4)
                    imageView4.setImageWith(URL(string:finalImage4), placeholderImage:UIImage(named: "user_blank.png"))
                    
                }
                else if imgArray.count == 5
                {
                    let finalImage = path + (imgArray.object(at: 0) as! String)
                    let imageView1 = UIImageView()
                    imageView1.frame = CGRect(x: imageView.frame.origin.x + 50, y: 360, width: 40, height: 40)
                    imageView.frame = imageView1.frame
                    view.addSubview(imageView1)
                    imageView1.setImageWith(URL(string:finalImage), placeholderImage:UIImage(named: "user_blank.png"))
                    
                    let finalImage2 = path + (imgArray.object(at: 1) as! String)
                    let imageView2 = UIImageView()
                    imageView2.frame = CGRect(x: imageView.frame.origin.x + 50, y: 360, width: 40, height: 40)
                    imageView.frame = imageView2.frame
                    view.addSubview(imageView2)
                    imageView2.setImageWith(URL(string:finalImage2), placeholderImage:UIImage(named: "user_blank.png"))
                    
                    let finalImage3 = path + (imgArray.object(at: 2) as! String)
                    let imageView3 = UIImageView()
                    imageView3.frame = CGRect(x: imageView.frame.origin.x + 50, y: 360, width: 40, height: 40)
                    imageView.frame = imageView3.frame
                    view.addSubview(imageView3)
                    imageView3.setImageWith(URL(string:finalImage3), placeholderImage:UIImage(named: "user_blank.png"))
                    
                    let finalImage4 = path + (imgArray.object(at: 3) as! String)
                    let imageView4 = UIImageView()
                    imageView4.frame = CGRect(x: imageView.frame.origin.x + 50, y: 360, width: 40, height: 40)
                    imageView.frame = imageView4.frame
                    view.addSubview(imageView4)
                    imageView4.setImageWith(URL(string:finalImage4), placeholderImage:UIImage(named: "user_blank.png"))
                    
                    let finalImage5 = path + (imgArray.object(at: 4) as! String)
                    let imageView5 = UIImageView()
                    imageView5.frame = CGRect(x: imageView.frame.origin.x - 150, y: imageView.frame.origin.y + 45, width: 40, height: 40)
                    imageView.frame = imageView5.frame
                    view.addSubview(imageView5)
                    imageView5.setImageWith(URL(string:finalImage5), placeholderImage:UIImage(named: "user_blank.png"))
                }
            }
        }
        else
        {
            var imgArray = NSArray()
            let str: String = self.imagearr.object(at: 0) as! String
            if str != ""
            {
                imgArray = str.components(separatedBy: ", ") as NSArray
            }
            if imgArray.count == 0
            {
                self.lblNoAttachment.isHidden = false
                self.lblNoAttachment.frame = CGRect(x: 59, y: 388, width: 130, height: 21)
            }
            else
            {
                self.lblNoAttachment.isHidden = true
                let path = "http://34.212.127.62:82/img/DiseasesImage/"
                imageView.frame = CGRect(x: 41, y: 400, width: 40, height: 40)
                view.addSubview(imageView)
                if imgArray.count == 1
                {
                    let finalImage = path + (imgArray.object(at: 0) as! String)
                    let imageView1 = UIImageView()
                    imageView1.frame = CGRect(x: imageView.frame.origin.x + 50, y: 400, width: 40, height: 40)
                    imageView.frame = imageView1.frame
                    view.addSubview(imageView1)
                    imageView1.setImageWith(URL(string:finalImage), placeholderImage:UIImage(named: "user_blank.png"))
                }
                else if imgArray.count == 2
                {
                    var finalImage = path + (imgArray.object(at: 0) as! String)
                    var imageView1 = UIImageView()
                    imageView1.frame = CGRect(x: imageView.frame.origin.x + 50, y: 400, width: 40, height: 40)
                    imageView.frame = imageView1.frame
                    view.addSubview(imageView1)
                    imageView1.setImageWith(URL(string:finalImage), placeholderImage:UIImage(named: "user_blank.png"))
                    
                    var finalImage2 = path + (imgArray.object(at: 1) as! String)
                    var imageView2 = UIImageView()
                    imageView2.frame = CGRect(x: imageView.frame.origin.x + 50, y: 400, width: 40, height: 40)
                    imageView.frame = imageView2.frame
                    view.addSubview(imageView2)
                    imageView2.setImageWith(URL(string:finalImage2), placeholderImage:UIImage(named: "user_blank.png"))
                }
                else if imgArray.count == 3
                {
                    var finalImage = path + (imgArray.object(at: 0) as! String)
                    var imageView1 = UIImageView()
                    imageView1.frame = CGRect(x: imageView.frame.origin.x + 50, y: 400, width: 40, height: 40)
                    imageView.frame = imageView1.frame
                    view.addSubview(imageView1)
                    imageView1.setImageWith(URL(string:finalImage), placeholderImage:UIImage(named: "user_blank.png"))
                    
                    var finalImage2 = path + (imgArray.object(at: 1) as! String)
                    var imageView2 = UIImageView()
                    imageView2.frame = CGRect(x: imageView.frame.origin.x + 50, y: 400, width: 40, height: 40)
                    imageView.frame = imageView2.frame
                    view.addSubview(imageView2)
                    imageView2.setImageWith(URL(string:finalImage2), placeholderImage:UIImage(named: "user_blank.png"))
                    
                    var finalImage3 = path + (imgArray.object(at: 2) as! String)
                    var imageView3 = UIImageView()
                    imageView3.frame = CGRect(x: imageView.frame.origin.x + 50, y: 400, width: 40, height: 40)
                    imageView.frame = imageView3.frame
                    view.addSubview(imageView3)
                    imageView3.setImageWith(URL(string:finalImage3), placeholderImage:UIImage(named: "user_blank.png"))
                }
                else if imgArray.count == 4
                {
                    var finalImage = path + (imgArray.object(at: 0) as! String)
                    var imageView1 = UIImageView()
                    imageView1.frame = CGRect(x: imageView.frame.origin.x + 50, y: 400, width: 40, height: 40)
                    imageView.frame = imageView1.frame
                    view.addSubview(imageView1)
                    imageView1.setImageWith(URL(string:finalImage), placeholderImage:UIImage(named: "user_blank.png"))
                    
                    var finalImage2 = path + (imgArray.object(at: 1) as! String)
                    var imageView2 = UIImageView()
                    imageView2.frame = CGRect(x: imageView.frame.origin.x + 50, y: 400, width: 40, height: 40)
                    imageView.frame = imageView2.frame
                    view.addSubview(imageView2)
                    imageView2.setImageWith(URL(string:finalImage2), placeholderImage:UIImage(named: "user_blank.png"))
                    
                    var finalImage3 = path + (imgArray.object(at: 2) as! String)
                    var imageView3 = UIImageView()
                    imageView3.frame = CGRect(x: imageView.frame.origin.x + 50, y: 400, width: 40, height: 40)
                    imageView.frame = imageView3.frame
                    view.addSubview(imageView3)
                    imageView3.setImageWith(URL(string:finalImage3), placeholderImage:UIImage(named: "user_blank.png"))
                    
                    var finalImage4 = path + (imgArray.object(at: 3) as! String)
                    var imageView4 = UIImageView()
                    imageView4.frame = CGRect(x: imageView.frame.origin.x + 50, y: 400, width: 40, height: 40)
                    imageView.frame = imageView4.frame
                    view.addSubview(imageView4)
                    imageView4.setImageWith(URL(string:finalImage4), placeholderImage:UIImage(named: "user_blank.png"))
                    
                }
                else if imgArray.count == 5
                {
                    var finalImage = path + (imgArray.object(at: 0) as! String)
                    var imageView1 = UIImageView()
                    imageView1.frame = CGRect(x: imageView.frame.origin.x + 50, y: 400, width: 40, height: 40)
                    imageView.frame = imageView1.frame
                    view.addSubview(imageView1)
                    imageView1.setImageWith(URL(string:finalImage), placeholderImage:UIImage(named: "user_blank.png"))
                    
                    var finalImage2 = path + (imgArray.object(at: 1) as! String)
                    var imageView2 = UIImageView()
                    imageView2.frame = CGRect(x: imageView.frame.origin.x + 50, y: 400, width: 40, height: 40)
                    imageView.frame = imageView2.frame
                    view.addSubview(imageView2)
                    imageView2.setImageWith(URL(string:finalImage2), placeholderImage:UIImage(named: "user_blank.png"))
                    
                    var finalImage3 = path + (imgArray.object(at: 2) as! String)
                    var imageView3 = UIImageView()
                    imageView3.frame = CGRect(x: imageView.frame.origin.x + 50, y: 400, width: 40, height: 40)
                    imageView.frame = imageView3.frame
                    view.addSubview(imageView3)
                    imageView3.setImageWith(URL(string:finalImage3), placeholderImage:UIImage(named: "user_blank.png"))
                    
                    var finalImage4 = path + (imgArray.object(at: 3) as! String)
                    var imageView4 = UIImageView()
                    imageView4.frame = CGRect(x: imageView.frame.origin.x + 50, y: 400, width: 40, height: 40)
                    imageView.frame = imageView4.frame
                    view.addSubview(imageView4)
                    imageView4.setImageWith(URL(string:finalImage4), placeholderImage:UIImage(named: "user_blank.png"))
                    
                    var finalImage5 = path + (imgArray.object(at: 4) as! String)
                    var imageView5 = UIImageView()
                    imageView5.frame = CGRect(x: imageView.frame.origin.x - 150, y: imageView.frame.origin.y + 45, width: 40, height: 40)
                    imageView.frame = imageView5.frame
                    view.addSubview(imageView5)
                    imageView5.setImageWith(URL(string:finalImage5), placeholderImage:UIImage(named: "user_blank.png"))
                }
            }

        }
    }
    func setData()
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let date = dateFormatter.date(from: apptdetailobj.date)!
        
        dateFormatter.dateFormat = "EEE, dd MMM yyyy"
        let convertedDate = dateFormatter.string(from: date)
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let dateObj = dateFormatter.date(from: apptdetailobj.starttime)
        let dateObj1 = dateFormatter.date(from: apptdetailobj.endtime)
       
        dateFormatter.dateFormat = "HH:mm a"
        let converteddate = dateFormatter.string(from: dateObj!)
        let converteddate1 = dateFormatter.string(from: dateObj1!)

        self.lblName.text = apptdetailobj.name
        self.lblOfficeAddress.text = apptdetailobj.address
        self.lblClinic.text = apptdetailobj.clinic
        self.lbldate.text = convertedDate
        self.lblTime.text = converteddate + " - " + converteddate1
        self.lblReason.text = apptdetailobj.reason
        self.imgDoctor.setImageWith(URL(string: apptdetailobj.image), placeholderImage:UIImage(named: "user_blank.png"))
            }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    func design()
    {
        self.imgDoctor.layer.cornerRadius = self.imgDoctor.frame.size.height/2
        self.imgDoctor.clipsToBounds = true
        self.imgDoctor.layer.borderWidth = 0.5
        self.imgDoctor.layer.borderColor = UIColor.lightGray.cgColor
    }
    @IBAction func btnBack(_ sender: UIButton)
    {
        let delayTime = DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime)
        {
            self.dismiss(animated: true, completion: nil)
        }
        UIView.animate(withDuration: 0.7, animations:
        { () -> Void in
            
            let angle = CGFloat(180 * M_PI / 90)
            self.imgBack.transform = CGAffineTransform(rotationAngle: angle)
        })
        
    }
}
