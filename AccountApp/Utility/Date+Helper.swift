//
//  Date+Helper.swift
//  AccountApp
//
//  Created by Chen Kuan Chung on 2018/02/15.
//  Copyright © 2018年 william. All rights reserved.
//

import Foundation

extension Date {
    func addYear(add: Int) -> Date {
        return Calendar.current.date(byAdding: .year, value: add, to: self)!
    }
    
    func addMonth(add: Int) -> Date {
        return Calendar.current.date(byAdding: .month, value: add, to: self)!
    }
    
    func addDay(add: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: add, to: self)!
    }
    func create(year: Int, month: Int, day: Int) -> Date {
        var dateComponets = DateComponents()
        dateComponets.year = year
        dateComponets.month = month
        dateComponets.day = day
        
        return Calendar(identifier: .gregorian).date(from: dateComponets)!
    }
    
    func toString(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    var startOfDay: Date? {
        return Calendar.current.startOfDay(for: self)
    }
    
    var startOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        let calendar = Calendar.current
        let component = calendar.dateComponents([.weekday], from: self)
        if component.weekday == 1 {
            return self.addDay(add: -6)
        }
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 1, to: sunday)
    }
    
    var endOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        let calendar = Calendar.current
        let component = calendar.dateComponents([.weekday], from: self)
        if component.weekday == 1 {
            return self
        }
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 7, to: sunday)
    }
    
    var startOfMonth: Date? {
        let calendar = Calendar.current
        let componets = calendar.dateComponents([.year, .month], from: self)
        return calendar.date(from: componets)
    }
    
    var endOfMonth: Date? {
        let calendar = Calendar.current
        var compoent2 = DateComponents()
        compoent2.month = 1
        compoent2.day = -1
        return calendar.date(byAdding: compoent2, to: startOfMonth!)
    }
    
    var startOfYear: Date? {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: self)
        var dateComponets = DateComponents()
        dateComponets.year = year
        dateComponets.month = 1
        dateComponets.day = 1
        return Calendar(identifier: .gregorian).date(from: dateComponets)
    }
    
    var endOfYear: Date? {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: self)
        var dateComponets = DateComponents()
        dateComponets.year = year
        dateComponets.month = 12
        dateComponets.day = 31
        return Calendar(identifier: .gregorian).date(from: dateComponets)
    }
    
}
