import Foundation

// MARK: - GoalsandRoutine
struct GoalsAndRoutinesResponse: Codable {
    var message: String
    var result: [GoalRoutine]
}

// MARK: - Result
//struct GoalRoutine: Codable {
//    var grUniqueID, grTitle, userID, isAvailable: String
//    var isComplete, isInProgress, isDisplayedToday, isPersistent: String
//    var isSublistAvailable, isTimed: String
//    var photo: String
//    var startDayAndTime, endDayAndTime: String
//    var datetimeStarted, datetimeCompleted: String
//    var expectedCompletionTime: String
//
//    enum CodingKeys: String, CodingKey {
//        case grUniqueID = "gr_unique_id"
//        case grTitle = "gr_title"
//        case userID = "user_id"
//        case isAvailable = "is_available"
//        case isComplete = "is_complete"
//        case isInProgress = "is_in_progress"
//        case isDisplayedToday = "is_displayed_today"
//        case isPersistent = "is_persistent"
//        case isSublistAvailable = "is_sublist_available"
//        case isTimed = "is_timed"
//        case photo
//        case startDayAndTime = "start_day_and_time"
//        case endDayAndTime = "end_day_and_time"
//        case datetimeStarted = "datetime_started"
//        case datetimeCompleted = "datetime_completed"
//        case expectedCompletionTime = "expected_completion_time"
//    }
//}
// MARK: - Result
struct GoalRoutine: Codable {
    var grUniqueID, grTitle, userID, isAvailable: String
    var isComplete, isInProgress, isDisplayedToday, isPersistent: String
    var isSublistAvailable, isTimed: String
    var photo: String
//    var grPhoto: String
//    var grStartDayAndTime, grEndDayAndTime, resultRepeat, repeatType: String
    var startDayAndTime, endDayAndTime, resultRepeat, repeatType: String
    var repeatEndsOn: String
    var repeatOccurences, repeatEvery: Int
    var repeatFrequency, repeatWeekDays, datetimeStarted, datetimeCompleted: String
    var expectedCompletionTime: String
    var grCompleted: JSONNull?
//    var repeatFrequency, repeatWeekDays, grDatetimeStarted, grDatetimeCompleted: String
//    var grExpectedCompletionTime: String
//    var grCompleted: String
    var status: String
    var notifications: [Notification]

    enum CodingKeys: String, CodingKey {
        case grUniqueID = "gr_unique_id"
        case grTitle = "gr_title"
        case userID = "user_id"
        case isAvailable = "is_available"
        case isComplete = "is_complete"
        case isInProgress = "is_in_progress"
        case isDisplayedToday = "is_displayed_today"
        case isPersistent = "is_persistent"
        case isSublistAvailable = "is_sublist_available"
        case isTimed = "is_timed"
        case photo = "gr_photo"
//        case grPhoto = "gr_photo"
        case startDayAndTime = "gr_start_day_and_time"
        case endDayAndTime = "gr_end_day_and_time"
//        case grStartDayAndTime = "gr_start_day_and_time"
//        case grEndDayAndTime = "gr_end_day_and_time"
        case resultRepeat = "repeat"
        case repeatType = "repeat_type"
        case repeatEndsOn = "repeat_ends_on"
        case repeatOccurences = "repeat_occurences"
        case repeatEvery = "repeat_every"
        case repeatFrequency = "repeat_frequency"
        case repeatWeekDays = "repeat_week_days"
        case datetimeStarted = "gr_datetime_started"
        case datetimeCompleted = "gr_datetime_completed"
        case expectedCompletionTime = "gr_expected_completion_time"
//        case grDatetimeStarted = "gr_datetime_started"
//        case grDatetimeCompleted = "gr_datetime_completed"
//        case grExpectedCompletionTime = "gr_expected_completion_time"
        case grCompleted = "gr_completed"
        case status, notifications
    }
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
