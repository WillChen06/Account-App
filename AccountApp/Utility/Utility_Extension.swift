//
//  Utility_Extension.swift
//  AccountApp
//
//  Created by Kuan-Chung Chen on 2017/12/20.
//  Copyright © 2017年 william. All rights reserved.
//

import Foundation

enum Interval {
    case year
    case month
    case week
    case day
}

extension Sequence {
    func group<GroupingType: Hashable>(by key: (Iterator.Element) -> GroupingType) -> [[Iterator.Element]] {
        var groups: [GroupingType: [Iterator.Element]] = [:]
        var groupsOrder: [GroupingType] = []
        forEach { element in
            let key = key(element)
            if case nil = groups[key]?.append(element) {
                groups[key] = [element]
                groupsOrder.append(key)
            }
        }
        return groupsOrder.map { groups[$0]! }
    }
}

extension Double {
    var toPercentage: String? {
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .percent
        pFormatter.maximumFractionDigits = 1
        pFormatter.multiplier = 1
        pFormatter.percentSymbol = " %"
        return pFormatter.string(from: self * 100 as NSNumber)
    }
}

