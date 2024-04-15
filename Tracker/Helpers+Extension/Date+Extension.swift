//
//  Date+Extension.swift
//  Tracker
//
//  Created by Артур Гайфуллин on 14.04.2024.
//

import UIKit

extension Date {
    func systemWeekend() -> Int {
        let systemWeekday = Calendar.current.component(.weekday, from: self)
        if Calendar.current.firstWeekday == 1 {
            switch systemWeekday {
            case 2 ... 7:
                return systemWeekday - 1
            default:
                return 7
            }
        } else {
            return systemWeekday
        }
    }
}
