//
//  Date+Extension.swift
//  LotteryAPI
//
//  Created by Lee Wonsun on 2/24/25.
//

import Foundation

extension Date {
    
    var onlyDate: Date {
        let component = Calendar.current.dateComponents([.year, .month, .day], from: self)
        
        return Calendar.current.date(from: component) ?? Date()
    }
}
