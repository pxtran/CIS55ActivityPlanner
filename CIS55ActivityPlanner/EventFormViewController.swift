//
//  EventFormViewController.swift
//  CIS55-ActivityPlanner
//
//  Created by Peter Tran on 3/15/15.
//  Copyright (c) 2015 DeAnza. All rights reserved.
//

import UIKit
import CoreData

class EventFormViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {

    let days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    var times: [String] = []

    var eventItem: Event!

    @IBOutlet var datePicker: UIPickerView!
    @IBOutlet var startTimePicker: UIPickerView!
    @IBOutlet var endTimePicker: UIPickerView!
    @IBOutlet var eventName: UITextField!
    @IBOutlet var dateText: UITextField!
    @IBOutlet var startTimeText: UITextField!
    @IBOutlet var endTimeText: UITextField!
    @IBOutlet var descriptionText: UITextView!

    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var saveButton: UIButton!
    var currentPicker: UIPickerView!

    override func viewDidLoad() {
        super.viewDidLoad()

        times.append("12 AM")

        for num in 1...11 {
            times.append("\(num) AM")
        }

        times.append("12 PM")

        for num in 1...11 {
            times.append("\(num) PM")
        }

        attachPickerToTextField(dateText, picker: datePicker)
        attachPickerToTextField(startTimeText, picker: startTimePicker)
        attachPickerToTextField(endTimeText, picker: endTimePicker)

        // Do any additional setup after loading the view.
    }

    /*required init(coder aDecoder: NSCoder) {
        super.init()
        //fatalError("init(coder:) has not been implemented")
    }*/

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func attachPickerToTextField(textField: UITextField, picker: UIPickerView) {
        picker.dataSource = self
        picker.delegate = self

        textField.delegate = self
        textField.inputView = picker

        picker.hidden = true
    }

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == self.datePicker {
            return days.count
        } else {
            return times.count
        }
    }

    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        if pickerView == self.datePicker {
            return self.days[row]
        } else {
            return self.times[row]
        }
    }

    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == self.datePicker {
            self.dateText.text = self.days[row]
        } else if pickerView == self.startTimePicker {
            self.startTimeText.text = times[row]
        } else if pickerView == self.endTimePicker {
            self.endTimeText.text = times[row]
        }

        self.currentPicker = pickerView

        //pickerView.hidden = true
    }

    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if textField.inputView == self.datePicker {
            self.datePicker.hidden = false
            self.startTimePicker.hidden = true
            self.endTimePicker.hidden = true
        } else if textField.inputView == self.startTimePicker {
            self.startTimePicker.hidden = false
            self.datePicker.hidden = true
            self.endTimePicker.hidden = true
        } else if textField.inputView == self.endTimePicker {
            self.endTimePicker.hidden = false
            self.datePicker.hidden = true
            self.startTimePicker.hidden = true
        }

        self.descriptionText.alpha = 0
        self.cancelButton.alpha = 0
        self.saveButton.alpha = 0

        return false
    }

    @IBAction func pressedCancel(sender: AnyObject) {
        if let navController = self.navigationController {
            navController.popViewControllerAnimated(true)
        }
    }


    @IBAction func pressedSave(sender: AnyObject) {

        let myMOC = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext

        eventItem = NSEntityDescription.insertNewObjectForEntityForName("Event", inManagedObjectContext: myMOC!) as Event

        var startTimeFloat: Double!
        var endTimeFloat: Double!

        startTimeFloat = getFloatFromTime(self.startTimeText.text)
        endTimeFloat = getFloatFromTime(self.endTimeText.text)

        eventItem.name = self.eventName.text
        eventItem.time_start = startTimeFloat
        eventItem.time_end = endTimeFloat
        eventItem.day = self.dateText.text
        eventItem.details = self.descriptionText.text

        var saveErr: NSError?
        if myMOC!.save(&saveErr) != true {
            println("Insert to DB Error \(saveErr?.localizedDescription)")
            return
        }

        if let navController = self.navigationController {
            navController.popViewControllerAnimated(true)
        }

    }

    func getFloatFromTime(time: String) -> Double {

        let timeSplit = split(time) {$0 == " "}

        if timeSplit[1] == "AM" {
            if timeSplit[0] == "12" {
                return 0.0
            } else {
                return (timeSplit[0] as NSString).doubleValue
            }
        } else if timeSplit[1] == "PM" {
            if timeSplit[0] == "12" {
                return 12.0
            } else {
                return (timeSplit[0] as NSString).doubleValue + 12
            }
        }

        return 0.0
    }

    @IBAction func tapView(sender: AnyObject) {
        self.datePicker.hidden = true
        self.startTimePicker.hidden = true
        self.endTimePicker.hidden = true
        self.eventName.resignFirstResponder()
        self.descriptionText.resignFirstResponder()
        self.cancelButton.alpha = 1
        self.saveButton.alpha = 1
        self.descriptionText.alpha = 1
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
