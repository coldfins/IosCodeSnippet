//
//  AppConstant.swift
//  AeroSky
//
//  Created by Coldfin Lab on 20-7-2017.
//  Copyright (c) 2015 Ved. All rights reserved.
//

import UIKit
import Foundation

//Screen Resolution
let SCREEN_WIDTH = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height

struct ScreenSize
{
    static let SCREEN_WIDTH = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

let IS_IPHONE_4_OR_LESS =  UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
let IS_IPHONE = UIDevice.current.userInterfaceIdiom == .phone


// Identifier
let IdentifireMapView = "MapsViewController"
let IdentifireProjectDetails = "ProjectDetailsViewController"
let IdentifireSearchView = "SearchViewController"
let IdentifireMyDetailView = "MyDetailsViewController"

//API URL
let BASE_URL = "http://13.58.33.217:82/api/"
let GET_ALL_PROJECTS_URL = "get_all_properties_list"
let GET_PROPERTY_DETAILS = "get_user_property"
let GET_ALL_CITY = "get_cities"
let GET_ALL_PROPERTY_TYPE = "get_property_types"
let POST_SEARCH_DATA = "searched_property_list"

//MESSAGE
let INTERNET_CONNECTION = "Please check your internet connection and try again."
let API_ERROR = "Something went wrong! please try again later."

//Keyword
let TitleAeroSky = "HouseCheap"
let keyUserId = "UserId"
let keyDeviceToken = "DeviceToken"
let keyAppTypePro = "Production"
let keyAppTypeDev = "Development"
