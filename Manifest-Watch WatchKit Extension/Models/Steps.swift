//
//  Steps.swift
//  Manifest-Watch WatchKit Extension
//
//  Created by Prashant Marathay on 11/10/21.
//

import Foundation


// MARK: - TaskAndActions
struct TaskAndActionsResponse: Codable {
    var result: [TaskAndActions]
    var message: String
}

//// MARK: - Result
//struct TaskAndActions: Codable {
//    var atUniqueID, atTitle, goalRoutineID: String
//    var atSequence: Int
//    var isAvailable, isComplete, isInProgress, isSublistAvailable: String
//    var isMustDo: String
//    var photo: String
//    var isTimed, datetimeCompleted, datetimeStarted, expectedCompletionTime: String
//    var availableStartTime, availableEndTime: String?
//
//    enum CodingKeys: String, CodingKey {
//        case atUniqueID = "at_unique_id"
//        case atTitle = "at_title"
//        case goalRoutineID = "goal_routine_id"
//        case atSequence = "at_sequence"
//        case isAvailable = "is_available"
//        case isComplete = "is_complete"
//        case isInProgress = "is_in_progress"
//        case isSublistAvailable = "is_sublist_available"
//        case isMustDo = "is_must_do"
//        case photo
//        case isTimed = "is_timed"
//        case datetimeCompleted = "datetime_completed"
//        case datetimeStarted = "datetime_started"
//        case expectedCompletionTime = "expected_completion_time"
//        case availableStartTime = "available_start_time"
//        case availableEndTime = "available_end_time"
//    }
//}


// MARK: - TaskAndActions
struct TaskAndActions: Codable {
    var atUniqueID, atTitle, goalRoutineID: String
    var atSequence: Int
    var isAvailable, isComplete, isInProgress, isSublistAvailable: String
    var isMustDo, photo, isTimed, datetimeStarted: String
    var datetimeCompleted, expectedCompletionTime, availableStartTime, availableEndTime: String
//    var isMustDo, atPhoto, isTimed, atDatetimeStarted: String
//    var atDatetimeCompleted, atExpectedCompletionTime, atAvailableStartTime, atAvailableEndTime: String

    enum CodingKeys: String, CodingKey {
        case atUniqueID = "at_unique_id"
        case atTitle = "at_title"
        case goalRoutineID = "goal_routine_id"
        case atSequence = "at_sequence"
        case isAvailable = "is_available"
        case isComplete = "is_complete"
        case isInProgress = "is_in_progress"
        case isSublistAvailable = "is_sublist_available"
        case isMustDo = "is_must_do"
        case photo = "at_photo"
//        case atPhoto = "at_photo"
        case isTimed = "is_timed"
        case datetimeStarted = "at_datetime_started"
        case datetimeCompleted = "at_datetime_completed"
        case expectedCompletionTime = "at_expected_completion_time"
        case availableStartTime = "at_available_start_time"
        case availableEndTime = "at_available_end_time"
//        case atDatetimeStarted = "at_datetime_started"
//        case atDatetimeCompleted = "at_datetime_completed"
//        case atExpectedCompletionTime = "at_expected_completion_time"
//        case atAvailableStartTime = "at_available_start_time"
//        case atAvailableEndTime = "at_available_end_time"
    }
}



// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Steps
struct StepsResponse: Codable {
    let result: [Steps]
    let message: String
}

// MARK: - Steps
struct Steps: Codable {
    let isUniqueID, isTitle, atID: String
    let isSequence: Int
    let isAvailable, isComplete, isInProgress, isTimed: String
    let isPhoto: String
    let isExpectedCompletionTime: String

    enum CodingKeys: String, CodingKey {
        case isUniqueID = "is_unique_id"
        case isTitle = "is_title"
        case atID = "at_id"
        case isSequence = "is_sequence"
        case isAvailable = "is_available"
        case isComplete = "is_complete"
        case isInProgress = "is_in_progress"
        case isTimed = "is_timed"
        case isPhoto = "is_photo"
        case isExpectedCompletionTime = "is_expected_completion_time"
    }
}
