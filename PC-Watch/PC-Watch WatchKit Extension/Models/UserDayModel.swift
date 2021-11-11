//
//  UserDayModel.swift
//  
//
//  Created by Harshit Trehan on 7/22/20.
//

import Foundation

protocol UserDayGoalEventList: Codable {
    var summary: String? { get set }
    var start: DateTime? { get set }
    var end: DateTime? { get set }
    var description: String? { get set }
    var creator: Email? { get set }
    var mapValue: ValueMapValue? { get set }
}
