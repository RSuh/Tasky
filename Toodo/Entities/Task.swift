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
    dynamic var taskTitle: NSMutableString = ""
    dynamic var modificationDate = ""
    dynamic var taskNote: String = ""
    dynamic var badge = 0
    dynamic var category: Category?
}


