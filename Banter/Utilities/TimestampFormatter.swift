//
//  TimestampFormatter.swift
//  Banter
//
//  Created by RAHUL RANA on 12/02/26.
//

import Foundation

struct TimestampFormatter {

    static func smartFormat(milliseconds: Int64) -> String {
        let date = Date(timeIntervalSince1970: Double(milliseconds) / 1000.0)
        let now = Date()
        let calendar = Calendar.current
        let seconds = Int(now.timeIntervalSince(date))

        if seconds < 60 {
            return "Just now"
        } else if seconds < 3600 {
            let minutes = seconds / 60
            return "\(minutes)m ago"
        } else if calendar.isDateInToday(date) {
            let hours = seconds / 3600
            return "\(hours)h ago"
        } else if calendar.isDateInYesterday(date) {
            return "Yesterday"
        } else if let daysDiff = calendar.dateComponents([.day], from: date, to: now).day, daysDiff < 7 {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE"
            return formatter.string(from: date)
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d"
            return formatter.string(from: date)
        }
    }

    static func messageTime(milliseconds: Int64) -> String {
        let date = Date(timeIntervalSince1970: Double(milliseconds) / 1000.0)
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: date)
    }
}
