//
//  DoctorListModel.swift
//  
//
//  Created by Coldfin Lab on 17/02/16.
//
//

import UIKit

class DoctorListModel: NSObject
{
    //DoctorList
    var arrMessages = NSMutableArray()
    var arrTimeslot = NSMutableArray()
    var arrTimeslot1 = NSMutableArray()
    let str = "cellIdentifier"
    var latitude = ""
    var longitude = ""
    var appointmentDate = ""
    var catId = NSNumber()
    var subCatId = NSNumber()
    var dic = NSNumber()
    var DocImage : ImageModel!
    
    //Reason Table
    var arrReason = NSMutableArray()
    var arrId : NSMutableArray = NSMutableArray()
    var strLabel = ""
    var strName = ""
    var catid = NSNumber()
    var data = NSNumber()
    var subcategoryId = NSNumber()
    
    //Speciality Table
    var arrSpecialty : NSMutableArray = NSMutableArray()
    var arrIdSpeciality : NSMutableArray = NSMutableArray()
    var strSpeciality = ""
    var SpecialityId = NSNumber()
}
