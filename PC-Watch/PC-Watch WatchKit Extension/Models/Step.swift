//
//  Step.swift
//  PC-Watch WatchKit Extension
//
//  Created by Jonathan Ly on 11/11/21.
//  Copyright © 2021 Infinite Options. All rights reserved.
//

import Foundation

// MARK: - Steps
struct StepsResponse: Codable {
    let result: [Steps]
    let message: String
}

// MARK: - Steps
struct Steps: Codable {
    var isUniqueID, isTitle, atID: String
    var isSequence: Int
    var isAvailable, isComplete, isInProgress, isTimed: String
    var isPhoto: String
    var isExpectedCompletionTime: String

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
