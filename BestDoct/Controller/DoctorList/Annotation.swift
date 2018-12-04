//
//  Annotation.swift
//  
//
//  Created by Coldfin Lab on 18/02/16.
//
//

import UIKit
import MapKit

class Annotation: NSObject , MKAnnotation
{
    var title: String?
    let subTitle: String
    let image : UIImage
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, subTitle: String, image: UIImage, coordinate: CLLocationCoordinate2D)
    {
        self.title = title
        self.subTitle = subTitle
        self.image = image
        self.coordinate = coordinate
        super.init()
    }
}
