//
//  HealthManager.swift
//  HKTutorial
//
//  Created by ernesto on 18/10/14.
//  Copyright (c) 2014 raywenderlich. All rights reserved.
//

import Foundation
import HealthKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class HealthManager {
  let healthkitstore : HKHealthStore = HKHealthStore()
  
  let stepsCount = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)
  let stepsUnit = HKUnit.count()
  
  func checkAuthorization() -> Bool
    {
        // Default to assuming that we're authorized
        var isEnabled = true
        
        // Do we have access to HealthKit on this device?
        if HKHealthStore.isHealthDataAvailable()
        {
            // We have to request each data type explicitly
            let steps = NSSet(object: HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!)
            
            // Now we can request authorization for step count data
            HKHealthStore().requestAuthorization(toShare: nil, read: steps as? Set<HKObjectType>) { (success, error) -> Void in
                isEnabled = success
            }
        }
        else
        {
            isEnabled = false
        }
        
        return isEnabled
    }
    
    func recentSteps(_ endDate : Date,completion: @escaping (Double, Error?) -> () )
    {
        // The type of data we are requesting (this is redundant and could probably be an enumeration
        let type = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)
        
        // Our search predicate which will fetch data from now until a day ago
        // (Note, 1.day comes from an extension
        // You'll want to change that to your own NSDate
        
        
        let calendar = Calendar.current
        let dateComponents = (calendar as NSCalendar).components([.day, .month, .year, .weekOfYear, .hour, .minute, .second, .nanosecond], from: endDate)
        let day = dateComponents.day
        let month = dateComponents.month
        let year  = dateComponents.year
        
        var comps: DateComponents = DateComponents()
        comps.day = day
        comps.month = month
        comps.year = year
        comps.hour = 0
        comps.minute = 0
        comps.second = 0
        let startDate = Calendar.current.date(from: comps)
       
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end:endDate, options: HKQueryOptions())
        
        // The actual HealthKit Query which will fetch all of the steps and sub them up for us.
        let query = HKSampleQuery(sampleType: type!, predicate: predicate, limit: 0, sortDescriptors: nil) { query, results, error in
            var steps: Double = 0
            
            if results?.count > 0
            {
                for result in results as! [HKQuantitySample]
                {
                    steps += result.quantity.doubleValue(for: HKUnit.count())
                }
            }
            
            completion(steps, error)
        }
        
        HKHealthStore().execute(query)
    }
    
  func authorizeHealthKit(_ completion: ((_ success:Bool, _ error:Error?) -> Void)!) {
    
    let healthkitTypesToRead : [AnyObject] = [
        HKObjectType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.dateOfBirth)!,
        HKObjectType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.biologicalSex)!,
        HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)!,
        HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.height)!,
        HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!,
        HKObjectType.workoutType()
    ]
    
    let healthkitTypesToWrite : [AnyObject] = [HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMassIndex)!,
        HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)!,
        HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)!,
        HKObjectType.workoutType()
    ]
    
    if !HKHealthStore.isHealthDataAvailable() {
      let error  = NSError(domain: "com.HKTutorial.app", code: 2, userInfo: [NSLocalizedDescriptionKey : "Healthkit is not available in this device"])
      if completion != nil {
        completion(false, error)
      }
      return;
    }
    
    healthkitstore.requestAuthorization(toShare: NSSet(array: healthkitTypesToWrite) as? Set<HKSampleType>, read: NSSet(array: healthkitTypesToRead) as? Set<HKObjectType> ) { (success, error) -> Void in
      if completion != nil {
        completion(success,error)
      }
    }
  }

  func saveRunningWorkout(_ startDate : Date , endDate : Date , distance : Double,  distanceUnit : HKUnit , kiloCalories : Double , completion : ((Bool, Error?) -> Void)!) {
    let distanceQuantity = HKQuantity(unit: distanceUnit, doubleValue: distance)
    let caloriesQuantity = HKQuantity(unit: HKUnit.kilocalorie(), doubleValue: kiloCalories)
    
    let workout = HKWorkout(activityType: HKWorkoutActivityType.running, start: startDate, end: endDate, duration: abs(endDate.timeIntervalSince(startDate)), totalEnergyBurned: caloriesQuantity, totalDistance: distanceQuantity, metadata: nil)
    
    healthkitstore.save(workout, withCompletion: { (success, error) -> Void in
      if error != nil {
        NSLog("error storing value to HealthKit")
        completion(success,error)
      }else{
        let distancesample = HKQuantitySample(type: HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)!, quantity: distanceQuantity, start: startDate, end: endDate)
        
        let energyBurnedSample = HKQuantitySample(type: HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)!, quantity: caloriesQuantity, start: startDate, end: endDate)
        
        self.healthkitstore.add([distancesample,energyBurnedSample], to: workout, completion: { (success, error) -> Void in
          completion(success,error)
        })
      }
    })
  }
  
  
  func readRunningWorkOuts(_ completion: (([AnyObject]?, Error?) -> Void)!) {
    let predicate = HKQuery.predicateForWorkouts(with: HKWorkoutActivityType.running)
    let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
    let sampleQuery = HKSampleQuery(sampleType: HKWorkoutType.workoutType(), predicate: predicate, limit: 0, sortDescriptors: [sortDescriptor]) { (sampleQuery, results, error) -> Void in
      if let queryError = error {
       NSLog("there was an error while reading data from healtkit framework\(queryError)")
      }
      completion(results,error)
    }
    
    
    healthkitstore.execute(sampleQuery)
  }
}
