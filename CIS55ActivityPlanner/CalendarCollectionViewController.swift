//
//  CalendarViewControllerCollectionViewController.swift
//  ActivityPlanner
//
//  Created by Peter Tran on 3/4/15.
//  Copyright (c) 2015 DeAnza. All rights reserved.
//

import UIKit
import CoreData
import QuartzCore

let reuseIdentifier = "calendarCell"

class CalendarViewControllerCollectionViewController: UICollectionViewController, NSCoding {

    let days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    let colors = ["blue", "green", "yellow", "orange", "purple", "cyan", "magenta"]

    var events: [Event] = []
    var cellMap = Dictionary<Int, String>()
    var dayOffsetMap = Dictionary<String, Int>()
    var eventMap = Dictionary<String, Event>()
    var colorMap = Dictionary<String, UIColor>()
    var selectedEvents: [Event] = []
    var selectedIndex: Int!
    var selectColor: UIColor!

    let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /*let fetchRequest = NSFetchRequest(entityName: "Event")
        var e: NSError?

        self.events = managedObjectContext!.executeFetchRequest(fetchRequest, error: &e) as [Event]

        if e != nil {
            println("Failed to retrieve record: \(e!.localizedDescription)")
        }

        dayOffsetMap.removeAll(keepCapacity: false)
        cellMap.removeAll(keepCapacity: false)

        for i in 0...6 {
            dayOffsetMap[days[i]] = i
        }

        let startingIndex = 9


        for event in events {
            let dayOffset = dayOffsetMap[event.day]

            for time in Int(event.time_start)...(Int(event.time_end) - 1) {
                //println(time)
                var index = (startingIndex + dayOffset!) + (time * 8)

                if let eventNames = cellMap[index] {
                    cellMap[index] = eventNames + "\n" + event.name
                    //self.collectionViewLayout.
                } else {
                    cellMap[index] = event.name
                }
            }
            eventMap[event.name] = event
        }*/

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.registerClass(CalanderCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        let flowLayout = self.collectionView?.collectionViewLayout as UICollectionViewFlowLayout
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        flowLayout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 23)
        //1F63FF
        self.collectionView?.backgroundColor = UIColor(red: 0x1F/255,
            green: 0x63/255, blue: 0xFF/255, alpha: 1.0)

        for c in colors {
            switch c {
            case "blue":
                colorMap[c] = UIColor.blueColor()
            case "green":
                colorMap[c] = UIColor.greenColor()
            case "orange":
                colorMap[c] = UIColor.orangeColor()
            case "yellow":
                colorMap[c] = UIColor.yellowColor()
            case "purple":
                colorMap[c] = UIColor.purpleColor()
            case "magenta":
                colorMap[c] = UIColor.magentaColor()
            case "cyan":
                colorMap[c] = UIColor.cyanColor()
            default:
                println("All colors exhausted")
            }
        }

    }

    override func viewDidAppear(animated: Bool) {
        let fetchRequest = NSFetchRequest(entityName: "Event")
        var e: NSError?

        self.events = managedObjectContext!.executeFetchRequest(fetchRequest, error: &e) as [Event]

        if e != nil {
            println("Failed to retrieve record: \(e!.localizedDescription)")
        }

        cellMap.removeAll(keepCapacity: false)
        dayOffsetMap.removeAll(keepCapacity: false)

        for i in 0...6 {
            dayOffsetMap[days[i]] = i
        }

        let startingIndex = 9


        for event in events {
            let dayOffset = dayOffsetMap[event.day]
            for time in Int(event.time_start)...(Int(event.time_end) - 1) {
                var index = (startingIndex + dayOffset!) + (time * 8)

                if let eventNames = cellMap[index] {
                    cellMap[index] = eventNames + "\n" + event.name
                    //self.collectionViewLayout.
                } else {
                    cellMap[index] = event.name
                }
            }
            eventMap[event.name] = event
        }

        self.collectionView?.reloadData()


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return 8 * 25
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as CalanderCollectionViewCell

        // Configure the cell

        //cell.cellText.font = UIFont(name: "System", size: 6.0)

        let index = indexPath.row

        cell.cellText.textColor = UIColor.whiteColor()
        cell.layer.backgroundColor = UIColor(red: 0x1F/255, green: 0x63/255, blue: 0xFF/255, alpha: 1.0).CGColor

        if index == 0 {
            cell.layer.borderWidth = 0
            cell.cellText.text = ""
        }

        else if index >= 1 && index <= 7{
            //cell.layer.borderColor = UIColor.whiteColor().CGColor
            cell.layer.borderWidth = 0
            cell.cellText.text = days[index - 1]
        }

        else if index % 8 == 0  && index != 0{
            //cell.layer.borderColor = UIColor.whiteColor().CGColor
            cell.layer.borderWidth = 0

            if index == 8 {
                cell.cellText.text = "12:00 AM"
            } else if index == 104 {
                cell.cellText.text = "12:00 PM"
            } else if index < 100 {
                cell.cellText.text = String((index / 8) - 1) + ":00 AM"
            } else {
                cell.cellText.text = String(((index / 8) - 1) % 12) + ":00 PM"
            }
        }

        else {
            //cell.backgroundColor = UIColor.blueColor()
            cell.layer.borderColor = UIColor.lightGrayColor().CGColor
            cell.layer.borderWidth = 1.0
            cell.layer.backgroundColor = UIColor.whiteColor().CGColor
            cell.cellText.numberOfLines = 0
            cell.cellText.textColor = UIColor.blackColor()

            if let eventNames = cellMap[index] {
                let eventSplit = split(eventNames) {$0 == "\n"}
                if eventSplit.count > 1 {
                    cell.layer.backgroundColor = UIColor.redColor().CGColor
                } else {
                    let c = eventMap[eventNames]?.color!
                    let cellColor: UIColor = colorMap[c!]!
                    cell.layer.backgroundColor =  cellColor.CGColor
                }
                cell.cellText.text = eventNames
            } else {
                cell.cellText.text = ""
            }
        }

        return cell
    }

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as CalanderCollectionViewCell

        let index = indexPath.row

        if (index >= 0 && index <= 7) || index % 8 == 0 {
            //do nothing
        } else {
            selectedEvents.removeAll(keepCapacity: false)
            selectColor = UIColor(CGColor:cell.layer.backgroundColor)
            cell.layer.backgroundColor = UIColor.lightTextColor().CGColor
            let cellT = String(cell.cellText.text!)
            let eventsplit = split(cellT) {$0 == "\n"}
            for event in eventsplit {
                let e: Event = eventMap[event]!
                selectedEvents.append(e)
            }
            selectedIndex = index
        }

    }

    override func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        let index = indexPath.row

        if !((index >= 0 && index <= 7) || index % 8 == 0) {
            cell?.layer.backgroundColor = selectColor.CGColor//UIColor.whiteColor().CGColor
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "goToEventForm" {
            let viewCont = segue.destinationViewController as EventFormViewController

            if selectedEvents.count > 0 {
                viewCont.eventsPassed = selectedEvents
            } else {
                if selectedIndex != nil {
                    viewCont.indexPassed = selectedIndex
                }
            }
        }
    }

    /*func collectionView(collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
    return 0
    }

    func collectionView(collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    insetForSectionAtIndex section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 0)
    }

    func collectionView(collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
    return 0
    }*/

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
    return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
    return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
    return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
    return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */
    
}
