//
//  RDSPostModels.swift
//  PC-Watch WatchKit Extension
//
//  Created by Karan Daryani on 14/10/20.
//  Copyright © 2020 Infinite Options. All rights reserved.
//

import Foundation

// MARK: - GoalRoutinePost
struct GoalRoutinePost: Codable {
    var id, datetimeCompleted, datetimeStarted, isInProgress: String
    var isComplete: String

    enum CodingKeys: String, CodingKey {
        case id
        case datetimeCompleted = "datetime_completed"
        case datetimeStarted = "datetime_started"
        case isInProgress = "is_in_progress"
        case isComplete = "is_complete"
    }
}

// MARK: - GoalRoutinePostResp
struct GoalRoutinePostResp: Codable {
    var message: String
}

// MARK: - ActionTaskPost
struct ActionTaskPost: Codable {
    var id, datetimeCompleted, datetimeStarted, isInProgress: String
    var isComplete: String

    enum CodingKeys: String, CodingKey {
        case id
        case datetimeCompleted = "datetime_completed"
        case datetimeStarted = "datetime_started"
        case isInProgress = "is_in_progress"
        case isComplete = "is_complete"
    }
}

// MARK: - ActionTaskPostResp
struct ActionTaskPostResp: Codable {
    var message: String
}

//title:Anu Step 1
//photo:
//photo_url:https://....
//type:
//is_complete:false
//is_available:true
//is_in_progress:false
//audio:
//is_timed:false
//expected_completion_time:01:00:00
//is_id:500-000022
//is_sequence:1

// MARK: - InstrStepPost
struct InstrStepPost: Codable {
    var id, datetimeCompleted, datetimeStarted, isInProgress: String
    var isComplete: String

    enum CodingKeys: String, CodingKey {
        case id
        case datetimeCompleted = "datetime_completed"
        case datetimeStarted = "datetime_started"
        case isInProgress = "is_in_progress"
        case isComplete = "is_complete"
    }
}

// MARK: - InstrStepPostResp
struct InstrStepPostResp: Codable {
    var message: String
}
