//
//  List.swift
//  Toodo
//
//  Created by Reginald Suh on 2015-07-14.
//  Copyright (c) 2015 ReginaldSuh. All rights reserved.
//

import Foundation
import RealmSwift

// A new list object
class List: Object {
    dynamic var listTitle = ""
    //dynamic var taskArray: [String] = [""]
    dynamic var taskCount = 1
}
