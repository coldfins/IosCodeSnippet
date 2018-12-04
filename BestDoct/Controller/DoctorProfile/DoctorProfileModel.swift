//
//  DoctorProfileModel.swift
//  
//
//  Created by Coldfin Lab on 26/02/16.
//
//

import UIKit

class DoctorProfileModel: NSObject
{
    var DoctorProfileName =  String()
    var DoctorProfileDegree = String()
    var DoctorProfileAddress = String()
    var DoctorProfileImage = String()
    var DoctorProfileTime = String()
    var DoctorProfileExperience = String()
    var DoctorProfileFees = NSNumber()
    var DoctorProfileAppointmentDate = String()
    var DoctorProfileAppointmentDateP = String()
    var DoctorStartTime = String()
    var DoctorEndTime = String()
    var DoctorInfoId = NSNumber()
    var DoctorLatitude = NSNumber()
    var DoctorLongitude = NSNumber()
    var collectionViewArray = NSArray()
    var collectionViewArrayEndTime = NSArray()
    var returnstart = String()
    var returnend = String()
    var returnfinal = String()
    
    /// if date is not changed
    var tblStartTime = NSArray()
    var tblEndTime = NSArray()
    var strstart = String()
    var strend = String()
}
