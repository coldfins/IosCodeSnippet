//
//  DatePickerViewController.swift
//  MapMyDiet
//
//  Created by Coldfin Lab on 11/04/16.
//  Copyright © 2016 Coldfin Lab. All rights reserved.
//

import UIKit

protocol DatePickerViewControllerDelegate {
    func sendSelectValue(_ selectedDate : Date, calledFor : String)
}

class DatePickerViewController: UIViewController {
    var delegate: DatePickerViewControllerDelegate!
    @IBOutlet weak var btnSelect: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var datepickerview: UIDatePicker!
    var selectedDate : Date?
    var tag : Int = 0
    var calledFor : String = ""
   
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTitle.text = calledFor
        datepickerview.date = selectedDate!
        datepickerview.datePickerMode = .date
        datepickerview.maximumDate = (Calendar.current as NSCalendar).date(byAdding: .year, value: -10, to: Date(), options: NSCalendar.Options.init(rawValue: 0))
        datepickerview.minimumDate = (Calendar.current as NSCalendar).date(byAdding: .year, value: -90, to: Date(), options: NSCalendar.Options.init(rawValue: 0))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onClick_btnCancel(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onClick_btnSelect(_ sender: AnyObject) {
        delegate.sendSelectValue(datepickerview.date, calledFor: calledFor)
        self.dismiss(animated: true, completion: nil)
    }
    

}
