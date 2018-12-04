//
//  MapViewController.swift
//  
//
//  Created by Coldfin Lab on 18/02/16.
//
//

import UIKit
import MapKit

class MapViewController: UIViewController,MKMapViewDelegate
{
    var appObj : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    let regionRadius: CLLocationDistance = 5000
    var latitudedoubleValue : Double = Double()
    var longitudedoubleValue : Double = Double()
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let sendButton = UIBarButtonItem(title: "List", style: UIBarButtonItemStyle.plain, target: self, action: #selector(MapViewController.sendList))
        self.navigationItem.rightBarButtonItem = sendButton
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Helvetica Neue", size: 14)!], for: UIControlState())
        self.navigationItem.title = "Search Results"
        mapView.delegate = self
        self.navigationItem.hidesBackButton = true
        modalTransitionStyle = .flipHorizontal
        
        for i in 0 ..< self.appObj.arrLatitude.count
        {
           self.latitudedoubleValue = (self.appObj.arrLatitude.object(at: i) as AnyObject).doubleValue
        }
        for i in 0 ..< self.appObj.arrLongitude.count
        {
           self.longitudedoubleValue = (self.appObj.arrLongitude.object(at: i) as AnyObject).doubleValue
           
            // set initial location in Map
            let initialLocation = CLLocation(latitude: self.latitudedoubleValue, longitude: self.longitudedoubleValue)
            centerMapOnLocation(initialLocation)
            let annotation = Annotation(title: self.appObj.arrName.object(at: i) as! String, subTitle: self.appObj.arrAddress.object(at: i) as! String,image: UIImage(named: "Marker.png")!, coordinate: CLLocationCoordinate2D(latitude: latitudedoubleValue, longitude: longitudedoubleValue))
            mapView.addAnnotation(annotation)
        }
    }
    func sendList()
    {
        let DoctorListController = storyboard?.instantiateViewController(withIdentifier: "DoctorViewController") as! DoctorListViewController
        UIView.animate(withDuration: 0.75, animations:
        { () -> Void in
            UIView.setAnimationCurve(UIViewAnimationCurve.easeInOut)
            self.navigationController!.popViewController(animated: true)
            UIView.setAnimationTransition(UIViewAnimationTransition.flipFromLeft, for: self.navigationController!.view!, cache: false)
        })
    }
    func centerMapOnLocation(_ location: CLLocation)
    {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,regionRadius * 2.0, regionRadius * 2.0)
         mapView.setRegion(coordinateRegion, animated: true)
    }
    func mapView(_ mapView: MKMapView!, viewFor annotation: MKAnnotation!) -> MKAnnotationView!
    {
        if let annotation = annotation as? Annotation
        {
            let identifier = "pin"
            var dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            if dequeuedView == nil
            {
                dequeuedView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                dequeuedView!.canShowCallout = true
            }
            else
            {
                dequeuedView!.annotation = annotation
            }
            dequeuedView!.image = UIImage(named:"Marker.png")
            
            return dequeuedView
        }
        return nil
    }
}
