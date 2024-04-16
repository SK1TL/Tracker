//
//  Date+Extension.swift
//  Tracker
//
//  Created by Артур Гайфуллин on 14.04.2024.
//

import UIKit

extension Date {
    func weekDay() -> Int {
        let systemWeekDay = Calendar.current.component(.weekday, from: self)
        if Calendar.current.firstWeekday == 1 {
            switch systemWeekDay {
            case 2 ... 7:
                return systemWeekDay - 1
            default:
                return 7
            }
        } else {
            return systemWeekDay
        }
    }
}
