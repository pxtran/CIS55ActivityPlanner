//
//  Event.swift
//  CIS55-ActivityPlanner
//
//  Created by Tomo Haga on 3/14/15.
//  Copyright (c) 2015 DeAnza. All rights reserved.
//

import Foundation
import CoreData

class Event:NSManagedObject{
    
    @NSManaged var name:String!
    @NSManaged var day:String!
    @NSManaged var time_start:NSNumber!
    @NSManaged var time_end:NSNumber!
    @NSManaged var details:String!
    
}
