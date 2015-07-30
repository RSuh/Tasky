//
//  NSDate-Equatable.swift
//  Toodo
//
//  Created by Reginald Suh on 2015-07-30.
//  Copyright (c) 2015 ReginaldSuh. All rights reserved.
//

import Foundation

extension NSDate: Equatable {}
extension NSDate: Comparable {}

public func ==(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.timeIntervalSince1970 == rhs.timeIntervalSince1970
}

public func <(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.timeIntervalSince1970 < rhs.timeIntervalSince1970
}