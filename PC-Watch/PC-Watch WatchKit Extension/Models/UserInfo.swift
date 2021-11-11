//
//  User.swift
//  PC-Watch WatchKit Extension
//
//  Created by Radomyr Bezghin on 9/30/20.
//  Copyright © 2020 Infinite Options. All rights reserved.
//

import Foundation
///Keeps track of all data that is associated with user in the app
struct User: Codable {
    var info: UserInfo
}
///After decoding json
struct UserInfoResponse: Codable {
    let result: [UserInfo]
    let message: String
}
///Actual useful data after decoding json. Stores all the information about the user
struct UserInfo: Codable {
    let userHavePic, messageCard, messageDay: String?
    let userPicture: String?
    let userFirstName, userLastName, userEmailID, eveningTime: String?
    let morningTime, afternoonTime, nightTime, dayEnd: String?
    let dayStart, timeZone, taPeopleID, emailID: String?
    let peopleName, havePic: String?
    let picture: String?
    let important, userUniqueID, relationType: String?

    enum CodingKeys: String, CodingKey {
        case userHavePic = "user_have_pic"
        case messageCard = "message_card"
        case messageDay = "message_day"
        case userPicture = "user_picture"
        case userFirstName = "user_first_name"
        case userLastName = "user_last_name"
        case userEmailID = "user_email_id"
        case eveningTime = "evening_time"
        case morningTime = "morning_time"
        case afternoonTime = "afternoon_time"
        case nightTime = "night_time"
        case dayEnd = "day_end"
        case dayStart = "day_start"
        case timeZone = "time_zone"
        case taPeopleID = "ta_people_id"
        case emailID = "email_id"
        case peopleName = "people_name"
        case havePic = "have_pic"
        case picture, important
        case userUniqueID = "user_unique_id"
        case relationType = "relation_type"
    }
}
