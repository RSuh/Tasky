//
//  Category.swift
//  Toodo
//
//  Created by Reginald Suh on 2015-07-14.
//  Copyright (c) 2015 ReginaldSuh. All rights reserved.
//

import Foundation
import RealmSwift
import UIKit

// A new Category object
class Category: Object {
    dynamic var categoryTitle = ""
    dynamic var taskCount = 0
    dynamic var badge = 0
    dynamic var tasksWithinCategory = List<Task>()
    // RGB values
    dynamic var R = 1.0
    dynamic var G = 1.0
    dynamic var B = 1.0
}
