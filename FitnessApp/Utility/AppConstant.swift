//
//  AppConstant.swift
//  FitnessApp
//
//  Created by Coldfin Lab on 08/02/16.
//  Copyright © 2016 Coldfin Lab. All rights reserved.
//

import Foundation

let defaults : UserDefaults = UserDefaults.standard
var images : [UIImage] = []
let utils : Utils = Utils()

//MARK: start: Start workout timer
var Seconds = 0
var timeractivity : Timer!

//MARK: Global selected date
var SELECTED_DATESTR : String = utils.convertDateToString(Date(), format: "yyyy-MM-dd")
var SELECTED_DATEE : Date = Date()
var SelectednumberOfSteps : Int = 0

var calledFrom : String = ""

//MARK: User defaults values
let USER_DEFAULTS_IS_LOGGED_IN = "is_logged_in"
let USER_DEFAULTS_USER_EMAILID_KEY = "user_emailid"
let USER_DEFAULTS_USER_CURRRENT_WEIGHT_KEY = "user_currentWeight"
let USER_DEFAULTS_USER_GOAL_TYPE_KEY = "user_goal_type"
let USER_DEFAULTS_USER_GOAL_WEIGHT_KEY = "user_goalWeight"
let USER_DEFAULTS_USER_HEIGHT_KEY = "user_height"
let USER_DEFAULTS_USER_ACTIVITY_TYPE_KEY = "user_activityType"
let USER_DEFAULTS_USER_WEEKLY_GOAL_WEIGHT_KEY = "user_weeklyGoal"
let USER_DEFAULTS_USER_ID_KEY = "user_id"
let USER_DEFAULTS_USER_GOAL_CALORIE = "user_calorie_goal"
let USER_DEFAULTS_USER_GOAL_STEPS = "user_steps_goal"
let USER_DEFAULTS_TENTATIVE_GOAL_ACHIEVEMENT_DATE = "tentativeDateOfGoalAchievement"
let USER_DEFAULTS_USER_DAILY_WATER_GOAL = "user_daily_water_goal"
let USER_DEFAULTS_USER_DAILY_WATER_INTAKE_LEVEL = "user_daily_water_intake_level"
let USER_DEFAULTS_USER_JOINING_PERIOD = "user_joining_period"
let USER_DEFAULTS_FETCHED_WEIGHT_FOR_DATE = "weight_for_date"
let USER_DEFAULTS_FETCHED_WATER_FOR_DATE = "water_for_date"
let USER_DEFAULTS_FETCHED_GOAL_FOR_DATE = "goal_for_date"
let USER_DEFAULTS_FETCHED_TOTAL_CALORIES_BURNED_FOR_DATE = "total_calories_burned_for_date"
let USER_DEFAULTS_FETCHED_TOTAL_CALORIES_CONSUMED_FOR_DATE = "total_calories_consumed_for_date"

//MARK: API details
let API_BASE_URL = "http://13.58.33.217:84/mapmydiet_api"
let API_LOGIN_URL = "login"
//let API_FETCH_DETAILS_OF_USER = "fetch_detail_of_user"
let API_ADD_DAILY_WATER_LEVEL = "add_daily_water_level"
let API_DASHBOARD = "fetching_all_details_of_user_for_particular_date"
let API_ADD_WEIGHT = "add_weight"

//MARK: Device screens
let IS_IPHONE  = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone)
let IS_IPAD =  (UI_USER_INTERFACE_IDIOM() == .pad)
let IS_IPHONE_4_OR_LESS =  (IS_IPHONE && UIScreen.main.bounds.size.height < 568.0)

let IS_IPHONE_5 = (IS_IPHONE && UIScreen.main.bounds.size.height == 568.0)
let IS_IPHONE_6 = (IS_IPHONE && UIScreen.main.bounds.size.height == 667.0)
let IS_IPHONE_6P =  (IS_IPHONE && UIScreen.main.bounds.size.height == 736)

//get device height and width according to orientation
let SCREEN_WIDTH = (((UIApplication.shared.statusBarOrientation == .portrait) || (UIApplication.shared.statusBarOrientation == .portraitUpsideDown)) ? UIScreen.main.bounds.size.width : UIScreen.main.bounds.size.height)


let SCREEN_HEIGHT = (((UIApplication.shared.statusBarOrientation == .portrait) || (UIApplication.shared.statusBarOrientation == .portraitUpsideDown)) ? UIScreen.main.bounds.size.height : UIScreen.main.bounds.size.width)

//MARK: Dashboard Variables
///Variables for storing fetched data from dashboard API

var waterLevelForDate : Float = 0.0
var weightForDate : Float = 0.0
var totalCaloriesConsumed : Float = 0.0
var totalCaloriesBurned : Float = 0.0
var calorieGoalforDate : Float = 0.0

//MARK: Exercise Performed View Controller
var exercisesList : NSMutableArray = NSMutableArray()
