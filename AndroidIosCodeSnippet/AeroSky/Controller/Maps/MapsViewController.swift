//
//  MapsViewController.swift
//  AeroSky
//
//  Created by Coldfin Lab on 20-7-2017.
//  Copyright © 2017 Coldfin Lab. All rights reserved.
//

import UIKit
import CoreData

class MapsViewController: UIViewController,CLLocationManagerDelegate,GMSMapViewDelegate {

    @IBOutlet weak var mapView: GMSMapView!
    let locationManager = CLLocationManager()
    var arrAllProject = NSMutableArray()
    var projects = [NSManagedObject]()
    var isLocal : Bool!
    @IBOutlet weak var btnList: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        mapView.delegate = self
        
        if(IS_IPHONE_4_OR_LESS){
            self.btnList.frame = CGRect(x: self.btnList.frame.origin.x, y: self.btnList.frame.origin.y-100, width: self.btnList.frame.size.width, height: self.btnList.frame.size.height)
        }
        
        self.putAllMarker()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController!.isNavigationBarHidden = true
    }
    
    
    func loadMarkerFromServerData(){
        
        for i in 0 ..< self.arrAllProject.count
        {
            let objProject = self.arrAllProject.object(at: i) as! ProjectsModel
            
            let current_latitude : Double = objProject.latitude
            let current_longitude : Double = objProject.longitude
            
            var pos : CLLocationCoordinate2D
            pos = CLLocationCoordinate2DMake(current_latitude, current_longitude)
            let marker : GMSMarker = GMSMarker(position: pos)
            let camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: current_latitude, longitude: current_longitude, zoom:10, bearing: 0, viewingAngle: 0)
            
            marker.title = String(format: "%@ %@ - %@", objProject.bhktype, objProject.propertytypes, objProject.area)
            marker.snippet = String(format: "\u{20B9} %d" ,objProject.rate)
            
            let strImageURL = objProject.propertyphoto_url as NSString
            let imgURL = URL(string: strImageURL as String)
            
          //  NSLog("Image Url.....%@", imgURL!)
            
            // The image isn't cached, download the img data
            // We should perform this in a background thread
            let request: URLRequest = URLRequest(url: imgURL!)
            let mainQueue = OperationQueue.main
            NSURLConnection.sendAsynchronousRequest(request, queue: mainQueue, completionHandler: { (response, data, error) -> Void in
                if error == nil {
                    // Convert the downloaded data in to a UIImage object
                    let image = UIImage(data: data!)
                    
                    DispatchQueue.main.async(execute: {
                        marker.userData = image
                    })
                }
                else{
                    NSLog("Error...")
                }
                
            })
            
            self.mapView.delegate = self
            marker.icon = UIImage(named: "marker.png")
            mapView.isMyLocationEnabled = true
            self.mapView.camera = camera
            marker.userData = objProject
            marker.map = mapView
        }
        
    }

    
    func loadMarkerFromLocalDataBase(){
        
        for i in 0 ..< self.projects.count
        {
            
            let objProject = projects[i]
            
            let latitude =  objProject.value(forKey: "latitude") as? Double
            let longitude =  objProject.value(forKey: "longitude") as? Double
            let bhkType =  objProject.value(forKey: "bhktype") as? String
            let propertytypes =  objProject.value(forKey: "propertytypes") as? String
            let area =  objProject.value(forKey: "area") as? String
            let strImageURL = objProject.value(forKey: "propertyphoto_url") as? String
            let rate = objProject.value(forKey: "rate") as? NSInteger
            
            let current_latitude : Double = latitude!
            let current_longitude : Double = longitude!
            
            var pos : CLLocationCoordinate2D
            pos = CLLocationCoordinate2DMake(current_latitude, current_longitude)
            let marker : GMSMarker = GMSMarker(position: pos)
            let camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: current_latitude, longitude: current_longitude, zoom:10, bearing: 0, viewingAngle: 0)
            
            marker.title = String(format: "%@ %@ - %@", bhkType!, propertytypes!, area!)
            marker.snippet = String(format: "\u{20B9} %d" ,rate!)
            
            let imgURL = URL(string: strImageURL! as String)
            
           // NSLog("Image Url.....%@", imgURL!)
            
            // The image isn't cached, download the img data
            // We should perform this in a background thread
            let request: URLRequest = URLRequest(url: imgURL!)
            let mainQueue = OperationQueue.main
            NSURLConnection.sendAsynchronousRequest(request, queue: mainQueue, completionHandler: { (response, data, error) -> Void in
                if error == nil {
                    // Convert the downloaded data in to a UIImage object
                    let image = UIImage(data: data!)
                    
                    NSLog("image...")
                    
                    DispatchQueue.main.async(execute: {
                        marker.userData = image
                    })
                }
                else{
                    NSLog("Error...")
                }
                
            })
            
            
            self.mapView.delegate = self
            marker.icon = UIImage(named: "marker.png")
            mapView.isMyLocationEnabled = true
            self.mapView.camera = camera
            marker.userData = objProject
            marker.map = mapView
        }

    }
    
    func putAllMarker(){
 
        if(self.isLocal == true){
            self.loadMarkerFromLocalDataBase()
        }
        else{
            self.loadMarkerFromServerData()
        }
    }
    
    func mapView(_ mapView: GMSMapView!, markerInfoWindow marker: GMSMarker!) -> UIView!
    {
        
        //for display window
    
        let infoWindow  : ViewLayout = Bundle.main.loadNibNamed("ViewLayout", owner: self, options: nil)![0] as! ViewLayout
        
        var anchor = CLLocationCoordinate2D()
        anchor = self.mapView.selectedMarker.position
        
        var position =  marker.position
        
        infoWindow.lblAddress.text = marker.title
        infoWindow.lblRate.text = marker.snippet
        
        infoWindow.viewInfoWindow.layer.cornerRadius = 2
        let shadowPath = UIBezierPath(roundedRect: infoWindow.viewInfoWindow.bounds, cornerRadius: 5)
        
        if((marker.userData) != nil){
            
            infoWindow.imgProperty.image = marker.userData as? UIImage
        }
        else{
            infoWindow.imgProperty.image =  UIImage(named: "no_results.png")
        }
        
        infoWindow.viewInfoWindow.layer.masksToBounds = false
        infoWindow.viewInfoWindow.layer.shadowColor = UIColor.black.cgColor
        infoWindow.viewInfoWindow.layer.shadowOffset = CGSize(width: 2, height: 1);
        infoWindow.viewInfoWindow.layer.shadowOpacity = 0.5
        infoWindow.viewInfoWindow.layer.shadowPath = shadowPath.cgPath
        return infoWindow
    }

    
    override func viewWillDisappear(_ animated: Bool) {
         self.navigationController!.isNavigationBarHidden = false
    }

    @IBAction func btnSwitchMapList(_ sender: AnyObject){
       
        UIView.animate(withDuration: 0.75, animations: { () -> Void in
            self.navigationController?.popViewController(animated: true)
            UIView.setAnimationTransition(UIViewAnimationTransition.flipFromRight, for: self.navigationController!.view!, cache: false)
        })
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
