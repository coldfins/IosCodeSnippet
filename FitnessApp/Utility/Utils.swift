//
//  Utils.swift
//  MapMyDiet
//
//  Created by Coldfin Lab on 06/04/16.
//  Copyright © 2016 Coldfin Lab. All rights reserved.
//

import UIKit

class Utils: NSObject {
    
    func customAlertView(_ message : String, view : UIView) {
        let alert = NZAlertView(style: NZAlertStyle.error, message: message)
        alert?.show()
    }
    
    func failureBlock(_ view : UIView){
        let alert = NZAlertView(style: NZAlertStyle.info, message: "Problem fetching data from server. The server must be down. Try Again.")
        alert?.show()
    }
    
    func getWeightArray() -> NSArray {
        let weightArray = NSMutableArray()
        for i in sequence(first: 40.0,
                          next: { $0 + 0.1 <= 130.0 ? $0 + 0.1 : nil }) //for var i = 40.0; i < 130.0 ; i = i + 0.1 
        {
            let str : String = String(format: "%0.1f", i)
            NSLog("\(str)")
            weightArray.add(str)
        }
        
        return weightArray
    }
    
    func getWeightUnitArray() -> NSArray {
        let weightUnitArray = NSMutableArray()
        weightUnitArray.add("Kgs")
        return weightUnitArray
    }
    
    func getFeetArray() -> NSArray {
        let feetArray = NSMutableArray()
        //for var i = 1; i <= 12 ; i += 1
        for i in sequence(first: 1,
                          next: { $0 + 1 <= 12 ? $0 + 1 : nil })
        {
            let str : String = String(format: "%d", i)
            NSLog("\(str)")
            feetArray.add(str)
        }
        return feetArray
    }
    
    func getInchArray() -> NSArray {
        let inchArray = NSMutableArray()
        for i in 0 ..< 12 {
            let str : String = String(format: "%d", i)
            NSLog("\(str)")
            inchArray.add(str)
        }
        return inchArray
    }
    
//MARK: Date Utility
    
    func convertDateToString(_ dateToConvert : Date, format : String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        let stringDate = dateFormatter.string(from: dateToConvert)
        return stringDate
    }
    
    func convertStringToDate(_ strToConvert : String, dateFormat : String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        let convertedDate = dateFormatter.date(from: strToConvert)
        return convertedDate!
    }
    
//MARK: Color Utility
   
    let colorTheme : UIColor = UIColor(red: 0/255.0, green: 173/255.0, blue: 221/255.0, alpha: 1.0)
    let colorSteps : UIColor = UIColor(red: 255.0/255.0, green: 121.0/255.0, blue: 186.0/255.0, alpha: 1.0)
    let colorWeight : UIColor = UIColor(red: 238.0/255.0, green: 57.0/255.0, blue: 104.0/255.0, alpha: 1.0)
    let colorWater : UIColor = UIColor(red: 145.0/255.0, green: 142.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    let colorCalorieBurned : UIColor = UIColor(red: 255.0/255.0, green: 172.0/255.0, blue: 95.0/255.0, alpha: 1.0)
    let colorBorder : UIColor = UIColor(red: 225.0/255.0, green: 225.0/255.0, blue: 225.0/255.0, alpha: 1.0)
}

