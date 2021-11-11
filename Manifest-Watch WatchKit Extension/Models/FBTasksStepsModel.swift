//
//  FBTasksModel.swift
//  PC-Watch WatchKit Extension
//
//  Created by Harshit Trehan on 7/15/20.
//  Copyright © 2020 Infinite Options. All rights reserved.
//

import Foundation

//Tasks Fields:
struct FirebaseTask: Codable {
    var name: String?
    var createTime, updateTime: String?
    var fields: FirebaseTaskFields
}

struct FirebaseTaskFields: Codable {
    var actionsTasks: ActionsTasks
    //var completed: Status?
    var title: EmailID
    
    enum CodingKeys: String, CodingKey {
        case actionsTasks = "actions&tasks"
        //case completed
        case title
    }
}

//Step Fields:
struct FirebaseStep: Codable {
    var name: String?
    var createTime, updateTime: String?
    var fields: FirebaseStepFields
}

struct FirebaseStepFields: Codable {
    var instructionsSteps: ActionsTasks
    var expectedCompletionTime: EmailID?
    //var completed: HavePic
    var title: EmailID
    
    enum CodingKeys: String, CodingKey {
        case instructionsSteps = "instructions&steps"
        case expectedCompletionTime = "expected_completion_time"
        //case completed = "completed"
        case title
    }
}

// MARK: - ArrayValue
struct ActionsTasks: Codable {
    var arrayValue: ActionsTasksArrayValue
}

// MARK: - Value
struct ActionsTasksArrayValue: Codable {
    var values: [ValueTask]
}

// MARK: - MapValue
struct ValueTask: Codable {
    var mapValue: TaskValueMapValue
}

// MARK: - ValueMapValue
struct TaskValueMapValue: Codable {
    var fields: TaskFluffyFields
}

struct TaskFluffyFields: Codable {
    var availableStartTime, availableEndTime: EmailID
    var datetimeStarted, datetimeCompleted: EmailID
    var isAvailable, isComplete: HavePic?
    var expectedCompletionTime: EmailID?
    var isInProgress: HavePic?
    var isMustDo: HavePic?
    //var isSublistAvailable: HavePic
    var photo, id, title: EmailID
    
    enum CodingKeys: String, CodingKey {
        case isComplete = "is_complete"
        case availableStartTime = "available_start_time"
        case isAvailable = "is_available"
        case expectedCompletionTime = "expected_completion_time"
        case isInProgress = "is_in_progress"
        case isMustDo = "is_must_do"
        //case isSublistAvailable = "is_sublist_available"
        case availableEndTime = "available_end_time"
        case datetimeCompleted = "datetime_completed"
        case datetimeStarted = "datetime_started"
        case photo, id, title
    }
}
