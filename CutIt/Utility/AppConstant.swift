//
//  AppConstant.swift
//  
//
//  Created by Coldfin lab

//  Copyright © 2017 Coldfin lab. All rights reserved.

import UIKit
import Foundation

struct ScreenSize
{
    static let SCREEN_WIDTH = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

let IS_IPHONE_4_OR_LESS =  UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0

let BASE_URL = "http://13.58.33.217:81/api/"
let ALL_CATEGORY = "category"
let SALON_GALLERY = "get-shop-gallery"
let GET_Service_ByVendor = "getservice/"
let GET_Salon_OfCategory = "getshop/"

//Key for User Basic Info
let keyDeviceToken = "DeviceToken"
let keyEmail = "Email"
let keyAddress = "Address"
let keyFirstName = "FirstName"
let keyLastName = "LastName"
let keyPhotoUrl = "PhotoUrl"
let keyUserId = "UserId"
let keyPlanId = "PlanId"
let keyPlanAmount = "PlanAmount"
let keyIsFB = "IsFb"
let keyCity = "City"
let keyGender = "Gender"
let keyHashtag = "Hashtag"
let keyPhone = "Phone"
let keyFBUrl = "FbUrl"
let keyInstagramUrl = "InstagramUrl"
let keyTwitterUrl = "TwitterUrl"
let keyWebsiteUrl = "WebsiteUrl"
let keyYelpUrl = "YelpUrl"
let keyplanName = "PlanType"
let keyshopId = "ShopId"
let keyshopName = "ShopName"
let keyshopPhone = "ShopPhone"
let keyshopState = "ShopState"
let keyshopCity = "ShopCity"
let keyshopAddress = "ShopAddress"
let keyshopImage = "ShopImage"
let keyshopDescription = "ShopDescription"
let keyIsShopAdded = "Shop"
let keyIsAvailabilityAdded = "Availability"
let keyIsServiceAdded = "Service"
let keyIsProfileComplete = "Profile"
let keyIsTrialExpired = "Expired"
let keyTrialCount = "TrialCount"
let keyIsTrialPlan = "IsTrial"
let keyIsSubscriptionComplete = "Subscription"
let keyAvailabilityStatus = "Status"
let keyAccountFirstName = "AccountFirstName"
let keyAccountLastName = "AccountLastName"
let keyAccountCompanyName = "AccountCompanyName"

//Key for Salon Info
let keySalonName = "SalonName"
let keySalonAddress = "SalonName"
let keySalonPhone = "SalonName"
let keySalonCity = "SalonName"
let keySalonState = "SalonName"

let keyCategoryId = "CategoryId"

//keyWord
let AlertTitle = "HairEct"

//Google Map
let keyGoogleMap = "AIzaSyAgCi5cfskPKP86oq7-zwLJbItdShcD8t4"

//Identifire Customer

let IdentifireHomeDetailsView = "HomeDetailViewController"
let IdentifireMapView = "MapViewController"
let IdentifireSearchDetailView = "SearchDetailViewController"

//MESSAGE
let INTERNET_CONNECTION = "Please check your internet connection and try again."

