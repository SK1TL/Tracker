//
//  TrackerModel.swift
//  Tracker
//
//  Created by Артур Гайфуллин on 10.04.2024.
//

import Foundation

struct Tracker: Hashable {
    let id: UUID
    let title: String
    let emoji: Int
    let color: Int
    let schedule: [WeekDays]
}

struct TrackerCategory: Hashable {
    let id: UUID
    let name: String
    let items: [Tracker]
}

struct TrackerRecord: Hashable {
    let id: UUID
    let tracker: Tracker
    let dates: [Date]
    let days: Int
}
