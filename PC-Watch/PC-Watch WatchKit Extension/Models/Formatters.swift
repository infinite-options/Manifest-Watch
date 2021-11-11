//
//  Formatters.swift
//  PC-Watch WatchKit Extension
//
//  Created by Harshit Trehan on 6/30/20.
//  Copyright © 2020 Infinite Options. All rights reserved.
//

import Foundation


extension String {
    func convertToTimeInterval() -> TimeInterval {
        guard self != "" else {
            return 0
        }

        var interval:Double = 0

        let parts = self.components(separatedBy: ":")
        for (index, part) in parts.reversed().enumerated() {
            interval += (Double(part) ?? 0) * pow(Double(60), Double(index))
        }

        return interval
    }
}

var DayDateObj = DayDate()

class DayDate {
    var dueDate = Date()
    let weekday = Calendar.current.component(.weekday, from: Date())
    var day = ["","SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]
    
    let taskDateFormat: DateFormatter = {
        let format = DateFormatter()
        format.dateStyle = .medium
        format.locale = Locale(identifier: "en_US")
        format.setLocalizedDateFormatFromTemplate("d")
        return format
    }()
    
    let timeLeft: DateFormatter = {
        let format = DateFormatter()
        format.dateFormat = "M/dd/yyy, h:mm:ss a"
        return format
    }()
    
    let goalStartUTC: DateFormatter = {
        let format = DateFormatter()
        format.dateFormat = "M/dd/yyy, h:mm:ss a"
        return format
    }()
    
    let formatter: DateFormatter = {
        let format = DateFormatter()
        format.dateFormat = "h:mm a"
        return format
    }()

    let durationFormatter: DateFormatter = {
        let format = DateFormatter()
        format.dateFormat = "h:mm"
        return format
    }()
    
    let ISOFormatter: ISO8601DateFormatter = {
        let format = ISO8601DateFormatter()
        format.timeZone = .current
        return format
    }()
    
}
