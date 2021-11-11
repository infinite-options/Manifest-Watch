// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct ImportantPeopleResponse: Codable {
    let message: String
    let result: WelcomeResult
}

// MARK: - WelcomeResult
struct WelcomeResult: Codable {
    let message: String
    let code: Int
    let result: [ImportantPerson]
}

// MARK: - ResultElement
struct ImportantPerson: Codable {
    let userUid, userName, taPeopleID, email: String
    let havePic, important, name, phoneNumber: String
    let pic: String
    let relationship: String

    enum CodingKeys: String, CodingKey {
        case userUid = "user_uid"
        case userName = "user_name"
        case taPeopleID = "ta_people_id"
        case email
        case havePic = "have_pic"
        case important, name
        case phoneNumber = "phone_number"
        case pic, relationship
    }
}
