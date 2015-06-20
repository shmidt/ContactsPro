import Foundation

extension NSDate: Comparable {}

public func <=(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs == rhs || lhs < rhs
}

public func >=(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs == rhs || lhs > rhs
}

public func >(lhs: NSDate, rhs: NSDate) -> Bool {
    let result = lhs.compare(rhs)
    return result == NSComparisonResult.OrderedDescending
}

/**
 This method is not required by the Comparable protocol but Xcode 6 beta 3
 would not compile without it.
*/
public func <(lhs: NSDate, rhs: NSDate) -> Bool {
    let result = lhs.compare(rhs)
    return result == NSComparisonResult.OrderedAscending
}

public func ==(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.isEqualToDate(rhs)
}

/**
 Operators for incrementing dates.
*/

func +(date: NSDate, interval: NSTimeInterval) -> NSDate {
    return date.dateByAddingTimeInterval(interval)
}

func +=(inout date: NSDate, interval: NSTimeInterval) {
    date = date + interval
}

func -(date: NSDate, interval: NSTimeInterval) -> NSDate {
    return date.dateByAddingTimeInterval(-interval)
}

func -=(inout date: NSDate, interval: NSTimeInterval) {
    date = date - interval
}