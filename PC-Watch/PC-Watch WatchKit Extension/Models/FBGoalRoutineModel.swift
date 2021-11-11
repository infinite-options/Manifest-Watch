// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//let firebase = try? newJSONDecoder().decode(Firebase.self, from: jsonData)

import Foundation

// MARK: - Firebase
struct Firebase: Codable {
    var name: String?
    var createTime, updateTime: String?
    var fields: FirebaseFields
}

// MARK: - FirebaseFields
struct FirebaseFields: Codable {
    var emailID, lastName, firstName: EmailID
    var aboutMe: AboutMe?
    var goalsRoutines: GoalsRoutines
    var googleAuthToken, googleRefreshToken: EmailID

    enum CodingKeys: String, CodingKey {
        case emailID = "email_id"
        case lastName = "last_name"
        case firstName = "first_name"
        case aboutMe = "about_me"
        case goalsRoutines = "goals&routines"
        case googleAuthToken = "google_auth_token"
        case googleRefreshToken = "google_refresh_token"
    }
}

// MARK: - AboutMe
struct AboutMe: Codable {
    var mapValue: AboutMeMapValue
}

// MARK: - AboutMeMapValue
struct AboutMeMapValue: Codable {
    var fields: PurpleFields
}

// MARK: - PurpleFields
struct PurpleFields: Codable {
    var havePic: HavePic
    var pic, messageDay, messageCard: EmailID

    enum CodingKeys: String, CodingKey {
        case havePic = "have_pic"
        case pic
        case messageDay = "message_day"
        case messageCard = "message_card"
    }
}

//// MARK: - People
//struct People: Codable {
//    var documents: [ImportantPerson]
//}
//
//struct ImportantPerson: Codable {
//    var fields: ImportantPersonFields
//}
//
//// MARK: - ImportantPersonValue
//struct ImportantPersonFields: Codable {
//    var email: EmailID?
//    var havePic: HavePic
//    var important: HavePic
//    var name: EmailID
//    var phoneNumber: EmailID?
//    var pic: EmailID?
//    var relationship: EmailID
//    var speakerId: EmailID?
//    var uniqueId: EmailID
//    
//    enum CodingKeys: String, CodingKey {
//        case havePic = "have_pic"
//        case email
//        case important
//        case name
//        case phoneNumber = "phone_number"
//        case pic
//        case relationship
//        case speakerId = "speaker_id"
//        case uniqueId = "unique_id"
//    }
//}

// MARK: - HavePic
struct HavePic: Codable {
    var booleanValue: Bool
}

// MARK: - EmailID
struct EmailID: Codable {
    var stringValue: String
}

// MARK: - GoalsRoutines
struct GoalsRoutines: Codable {
    var arrayValue: GoalsRoutinesArrayValue
}

// MARK: - ArrayValue
struct GoalsRoutinesArrayValue: Codable {
    var values: [Value]
}

// MARK: - Value
struct Value: Codable, UserDayGoalEventList {
    var mapValue: ValueMapValue?
    var start: DateTime?
    var end: DateTime?
    var summary: String?
    var description: String?
    var creator: Email?
    var id: String?
}

// MARK: - ValueMapValue
struct ValueMapValue: Codable {
    var fields: FluffyFields
}

// MARK: - FluffyFields
struct FluffyFields: Codable {
    var isSublistAvailable, isComplete: HavePic?
    var availableStartTime: EmailID
    var isPersistent: HavePic
    var datetimeCompleted, expectedCompletionTime: EmailID
    var isTimed: HavePic
    var isInProgress: HavePic?
    var datetimeStarted, audio, availableEndTime: EmailID
    var userNotifications: Notifications
    var id, title: EmailID
    var taNotifications: Notifications
    var photo: EmailID
    var isAvailable: HavePic
    var startDayAndTime: EmailID
    var endDayAndTime: EmailID
    var isDisplayedToday: HavePic

    enum CodingKeys: String, CodingKey {
        case isSublistAvailable = "is_sublist_available"
        case isComplete = "is_complete"
        case availableStartTime = "available_start_time"
        case isPersistent = "is_persistent"
        case datetimeCompleted = "datetime_completed"
        case expectedCompletionTime = "expected_completion_time"
        case isTimed = "is_timed"
        case isInProgress = "is_in_progress"
        case datetimeStarted = "datetime_started"
        case audio
        case availableEndTime = "available_end_time"
        case userNotifications = "user_notifications"
        case id, title
        case taNotifications = "ta_notifications"
        case photo
        case isAvailable = "is_available"
        case startDayAndTime = "start_day_and_time"
        case endDayAndTime = "end_day_and_time"
        case isDisplayedToday = "is_displayed_today"
    }
}

// MARK: - Notifications
struct Notifications: Codable {
    var mapValue: TaNotificationsMapValue
}

// MARK: - TaNotificationsMapValue
struct TaNotificationsMapValue: Codable {
    var fields: TentacledFields
}

// MARK: - TentacledFields
struct TentacledFields: Codable {
    var before, during, after: After
}

// MARK: - After
struct After: Codable {
    var mapValue: AfterMapValue
}

// MARK: - AfterMapValue
struct AfterMapValue: Codable {
    var fields: StickyFields
}

// MARK: - StickyFields
struct StickyFields: Codable {
    var message: EmailID
    var isSet, isEnabled: HavePic
    var time: EmailID
    var dateSet: EmailID?

    enum CodingKeys: String, CodingKey {
        case message
        case isSet = "is_set"
        case isEnabled = "is_enabled"
        case time
        case dateSet = "date_set"
    }
}

//import Foundation
//
//// MARK: - Firebase
//struct Firebase: Codable {
//    var name: String
//    var fields: FirebaseFields
//    var createTime, updateTime: String
//}
//
//// MARK: - FirebaseFields
//struct FirebaseFields: Codable {
//    var googleAuthToken, googleRefreshToken: EmailID
//    var photo: Photo
//    var emailID, lastName, firstName: EmailID
//    var aboutMe: AboutMe
//    var goalsRoutines: GoalsRoutines
//
//    enum CodingKeys: String, CodingKey {
//        case googleAuthToken = "google_auth_token"
//        case googleRefreshToken = "google_refresh_token"
//        case photo
//        case emailID = "email_id"
//        case lastName = "last_name"
//        case firstName = "first_name"
//        case aboutMe = "about_me"
//        case goalsRoutines = "goals&routines"
//    }
//}
//
//// MARK: - AboutMe
//struct AboutMe: Codable {
//    var mapValue: AboutMeMapValue
//}
//
//// MARK: - AboutMeMapValue
//struct AboutMeMapValue: Codable {
//    var fields: PurpleFields
//}
//
//
//// MARK: - PurpleFields
//struct PurpleFields: Codable {
//    var havePic: HavePic
//    var pic, messageDay, messageCard: EmailID
//
//    enum CodingKeys: String, CodingKey {
//        case havePic = "have_pic"
//        case pic
//        case messageDay = "message_day"
//        case messageCard = "message_card"
//    }
//}
//
//// MARK: - HavePic
//struct HavePic: Codable {
//    var booleanValue: Bool
//}
//
//// MARK: - EmailID
//struct EmailID: Codable {
//    var stringValue: String
//}
//
//// MARK: - GoalsRoutines
//struct GoalsRoutines: Codable {
//    var arrayValue: GoalsRoutinesArrayValue
//}
//
//// MARK: - GoalsRoutinesArrayValue
//struct GoalsRoutinesArrayValue: Codable {
//    var values: [Value]
//}
//
//// MARK: - PurpleValue
//struct Value: Codable {
//    var mapValue: PurpleMapValue
//}
//
//// MARK: - PurpleMapValue
//struct PurpleMapValue: Codable {
//    var fields: FluffyFields
//}
//
//// MARK: - FluffyFields
//struct FluffyFields: Codable {
//    var isTimed: HavePic?
//    var isInProgress: HavePic
//    var datetimeStarted, availableEndTime, audio: EmailID
//    var userNotifications: Notifications
//    var id: EmailID
//    var tags: Tags?
//    var title: EmailID
//    var taNotifications: Notifications
//    var photo: EmailID
//    var isAvailable, isSublistAvailable, isComplete, isPersistent: HavePic
//    var availableStartTime, datetimeCompleted, expectedCompletionTime: EmailID
//
//    enum CodingKeys: String, CodingKey {
//        case isTimed = "is_timed"
//        case isInProgress = "is_in_progress"
//        case datetimeStarted = "datetime_started"
//        case availableEndTime = "available_end_time"
//        case audio
//        case userNotifications = "user_notifications"
//        case id, tags, title
//        case taNotifications = "ta_notifications"
//        case photo
//        case isAvailable = "is_available"
//        case isSublistAvailable = "is_sublist_available"
//        case isComplete = "is_complete"
//        case isPersistent = "is_persistent"
//        case availableStartTime = "available_start_time"
//        case datetimeCompleted = "datetime_completed"
//        case expectedCompletionTime = "expected_completion_time"
//    }
//}
//
//// MARK: - Notifications
//struct Notifications: Codable {
//    var mapValue: TaNotificationsMapValue
//}
//
//// MARK: - TaNotificationsMapValue
//struct TaNotificationsMapValue: Codable {
//    var fields: TentacledFields
//}
//
//// MARK: - TentacledFields
//struct TentacledFields: Codable {
//    var before, during, after: After
//}
//
//// MARK: - After
//struct After: Codable {
//    var mapValue: AfterMapValue
//}
//
//// MARK: - AfterMapValue
//struct AfterMapValue: Codable {
//    var fields: StickyFields
//}
//
//// MARK: - StickyFields
//struct StickyFields: Codable {
//    var isEnabled: HavePic
//    var time, message: EmailID
//    var isSet: HavePic
//    var dateSet: EmailID?
//
//    enum CodingKeys: String, CodingKey {
//        case isEnabled = "is_enabled"
//        case time, message
//        case isSet = "is_set"
//        case dateSet = "date_set"
//    }
//}
//
//// MARK: - Tags
//struct Tags: Codable {
//    var arrayValue: TagsArrayValue
//}
//
//// MARK: - TagsArrayValue
//struct TagsArrayValue: Codable {
//    var values: [EmailID]
//}
//
//// MARK: - Photo
//struct Photo: Codable {
//    var arrayValue: PhotoArrayValue
//}
//
//// MARK: - PhotoArrayValue
//struct PhotoArrayValue: Codable {
//    var values: [FluffyValue]
//}
//
//// MARK: - FluffyValue
//struct FluffyValue: Codable {
//    var mapValue: FluffyMapValue
//}
//
//// MARK: - FluffyMapValue
//struct FluffyMapValue: Codable {
//    var fields: IndigoFields
//}
//
//// MARK: - IndigoFields
//struct IndigoFields: Codable {
//    var note, fieldsDescription, id: EmailID
//
//    enum CodingKeys: String, CodingKey {
//        case note
//        case fieldsDescription = "description"
//        case id
//    }
//}
//
