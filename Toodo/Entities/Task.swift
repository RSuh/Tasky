//
//  Task.swift
//  Toodo
//
//  Created by Reginald Suh on 2015-07-10.
//  Copyright (c) 2015 ReginaldSuh. All rights reserved.
//

import Foundation
import RealmSwift
import UIKit

// Initialize a Task Object.
class Task: Object {
    dynamic var taskTitle: String = ""
    dynamic var modificationDate = ""
    // Ordering date will also serve as a notification date
    dynamic var orderingDate: NSDate = NSDate()
    //dynamic var notificationDate: NSDate = NSDate()
    dynamic var taskNote: String = ""
    dynamic var badge = 0
    dynamic var completeBadge = 0
    dynamic var category: Category?
    dynamic var complete: Bool = false
    dynamic var creationDate: NSDate = NSDate()
    //dynamic var email = ""
}


