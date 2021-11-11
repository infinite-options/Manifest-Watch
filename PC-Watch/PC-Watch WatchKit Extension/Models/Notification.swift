//
//  Notification.swift
//  PC-Watch WatchKit Extension
//
//  Created by Radomyr Bezghin on 9/28/20.
//  Copyright © 2020 Infinite Options. All rights reserved.
//

import Foundation

//struct Notification: Codable{
//
//}


// MARK: - Notification
struct Notification: Codable {
    let notificationID, userTaID, grAtID, beforeIsEnable: String
    let beforeIsSet, beforeMessage, beforeTime, duringIsEnable: String
    let duringIsSet, duringMessage, duringTime, afterIsEnable: String
    let afterIsSet, afterMessage, afterTime: String

    enum CodingKeys: String, CodingKey {
        case notificationID = "notification_id"
        case userTaID = "user_ta_id"
        case grAtID = "gr_at_id"
        case beforeIsEnable = "before_is_enable"
        case beforeIsSet = "before_is_set"
        case beforeMessage = "before_message"
        case beforeTime = "before_time"
        case duringIsEnable = "during_is_enable"
        case duringIsSet = "during_is_set"
        case duringMessage = "during_message"
        case duringTime = "during_time"
        case afterIsEnable = "after_is_enable"
        case afterIsSet = "after_is_set"
        case afterMessage = "after_message"
        case afterTime = "after_time"
    }
}
