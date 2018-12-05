//
//  MapViewController.swift
//  CutIt
//
//  Created by Coldfin lab

//  Copyright © 2017 Coldfin lab. All rights reserved.

import UIKit

class MapViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {

    @IBOutlet weak var viewMap: GMSMapView!
    let locationManager = CLLocationManager()
    let arrLatLong = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewMap.mapType = kGMSTypeNormal
        self.viewMap.delegate = self
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
        
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
            self.viewMap.isMyLocationEnabled = true
            self.viewMap.settings.myLocationButton = true
        }
    }
   
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
            for i in 0..<arrLatLong.count
            {
                let category = arrLatLong[i] as! SalonModel
                let marker = GMSMarker()
                if category.salonLatitude != ""
                {
                    let camera : GMSCameraPosition = GMSCameraPosition.camera(withLatitude: Double(category.salonLatitude)!,longitude: Double(category.salonLongitude)!, zoom: 10.0)
                    self.viewMap.camera = camera
                    marker.position = CLLocationCoordinate2DMake(Double(category.salonLatitude)!, Double(category.salonLongitude)!)
                    marker.title = category.salonName as String
                    marker.snippet = category.salonAddress as String
                    marker.userData = category.salonImage as String
                    marker.appearAnimation = kGMSMarkerAnimationPop
                }
                marker.map = self.viewMap
                marker.infoWindowAnchor = CGPoint(x: 0.5, y: 0.2)
                marker.accessibilityLabel = "\(i)"
                locationManager.stopUpdatingLocation()
            }
    }
    func mapView(_ mapView: GMSMapView!, markerInfoWindow marker: GMSMarker!) -> UIView! {
   
        let customInfoWindow =  Bundle.main.loadNibNamed("ViewLayout", owner: self, options: nil)?[1] as! ViewLayout
        for i in 0..<arrLatLong.count
        {
            let category = arrLatLong[i] as! SalonModel
            if category.salonLatitude != ""
            {
                customInfoWindow.lblShopName.text = marker.title
                customInfoWindow.lblShopAddress.text = marker.snippet
                customInfoWindow.imgShop.sd_setImage(with: URL(string: marker.userData as! String), placeholderImage: UIImage(named: "default_cutitEvent.png"))
            }
        }
        return customInfoWindow
    }
    @IBAction func btnBack_Click(_ sender: UIButton)
    {
        _ = navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
