//
//  ViewLayout.swift
//  ZantaApp
//
//  Created by ved on 21/03/15.
//  Copyright (c) 2015 ved. All rights reserved.
//

import UIKit

class ViewLayout: UIView {
    
    //Report
    @IBOutlet weak var viewBottomReport: UIView!
    @IBOutlet weak var viewMainBottomReport: UIView!
    @IBOutlet weak var viewMainReport: UIView!
    @IBOutlet weak var btnReport: UIButton!
    
    //Post Report
    @IBOutlet weak var viewReport: UIView!
    @IBOutlet weak var txtReportDesc: MKTextField!
    @IBOutlet weak var btnSubmitReport: UIButton!
    @IBOutlet weak var btnClose: UIButton!
    
    //SettingMenu
    @IBOutlet weak var viewMenu: UIView!
    @IBOutlet weak var btnRefresh: UIButton!
    @IBOutlet weak var btnSettings: UIButton!
    @IBOutlet weak var btnExit: UIButton!
    
}

