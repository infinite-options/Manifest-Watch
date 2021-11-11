//
//  EventsModel.swift
//  PC-Watch WatchKit Extension
//
//  Created by Harshit Trehan on 7/22/20.
//  Copyright © 2020 Infinite Options. All rights reserved.
//

import Foundation

struct Event: Codable, UserDayGoalEventList {
    var summary: String?
    var start: DateTime?
    var end: DateTime?
    var id: String?
    var mapValue: ValueMapValue?
    var description: String?
    // TODO: creator name instead of email?
    var creator: Email?
    var attendees: [Attendent]?
}

struct Attendent: Codable, Hashable {
//    var displayName: String?
    var email: String?
    var responseStatus: String?
}

struct DateTime: Codable {
    var dateTime: String
}

struct Email: Codable {
    var email: String
}
