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
    dynamic var modificationDate = NSDate()
    dynamic var taskNote: String = ""
}