//
//  UserDay.swift
//  PC-Watch WatchKit Extension
//
//  Created by Harshit Trehan on 7/24/20.
//  Copyright © 2020 Infinite Options. All rights reserved.
//
//endpoint (email -> userID https://3s3sftsr90.execute-api.us-west-1.amazonaws.com/dev/api/v2/userLogin/
//user email iodevcalendar@gmail.com
//to get user email -> UserDayData.UserInfo?.fields.emailID


import Foundation
import SwiftUI

enum AuthState {
    case undefined, signedOut, signedIn, invalidEmail
}

class UserManager: ObservableObject {
    
    static let shared = UserManager()
    
    @Published var loadingUser = false
    
    @Published var User = ""
    
    //Stores the user information
    @Published var UserInfo: UserInfo?
    
    @Published var UserPhoto: UIImage?
    
    @Published var isUserSignedIn: AuthState = .undefined
    
    let manifestSuite = UserDefaults(suiteName: "manifestSuite")
    
    let manifestUserIdKey = "userIdentifier"
    let manifestUserName = "userName"
    let manifestUserPhoto = "userPhoto"
    
    @Published var UserDayData = [UserDayGoalEventList]()
    
    @Published var UserDayBlockData = [UserDayGoalEventList]()
    
    private init(){}
    
    func checkUserAuth(completion: @escaping (AuthState) -> ()) {
        guard let userId = manifestSuite?.string(forKey: manifestUserIdKey) else {
            print("User ID does not exist")
            self.isUserSignedIn = .undefined
            completion(.undefined)
            return
        }
        
        if userId == "" {
            print("Empty string found in User ID")
            self.isUserSignedIn = .undefined
            completion(.undefined)
            return
        }
        else {
            print("User ID Found \(userId)")
            self.isUserSignedIn = .signedIn
            self.User = userId
            completion(.signedIn)
            return
        }
    }
    struct Response: Codable{
        var result: String
    }
    
    func getUserFromEmail(email: String, completion: @escaping (Int) -> () ){
        let endPoint = "https://3s3sftsr90.execute-api.us-west-1.amazonaws.com/dev/api/v2/userLogin/"
        let urlString = endPoint + email
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Generic networking error: \(error)")
            }

            if let data = data {
                do{
                    let finalRespData = try JSONDecoder().decode(getUserFromEmailResponse.self, from: data)
                    print("User ID: \(finalRespData)")
                    if(finalRespData.result != ""){
                        print("User found")
                        let GoalsEvents = NetworkManager.shared

                        DispatchQueue.main.async {
                            self.User = finalRespData.result
                            self.manifestSuite?.set(self.User, forKey: self.manifestUserIdKey)
                            GoalsEvents.updateDataModel {
                                print("Populated data model")
                                let fullName = (self.UserInfo?.userFirstName ?? "Name not found") + " " + (self.UserInfo?.userLastName ?? "")
                                self.manifestSuite?.set(fullName, forKey: self.manifestUserName)
                                self.UserDayData = []
                                self.UserDayBlockData = []
                                self.mergeSortedGoalsEvents(goals: GoalsEvents.data ?? [Value](), events: GoalsEvents.events ?? [Event]())

                                self.loadingUser = false

                                NotificationHandler().scheduleNotifications()
                                self.isUserSignedIn = .signedIn
                                completion(200)
                            }

                        }
                    }
                    else{
                        print("No user found!")
                        DispatchQueue.main.async{
                            self.loadingUser = false
                        }
                        completion(500)
                    }
                }
                catch let jsonParseError {
                    print("Error in parsing JSON response: \(jsonParseError)")
                }
            }
            else { return }
        }.resume()
    }
    
    func loadImage(){
        guard let urlString = self.UserInfo?.userPicture else{return}
        guard let url = URL(string: urlString) else {return}
        let data = try? Data(contentsOf: url)

        if let imageData = data {
            let image = UIImage(data: imageData)
            UserPhoto = image
        }
    }

    func signOutUser() {
        self.User = ""
        self.UserInfo = nil
        self.UserPhoto = nil
        self.isUserSignedIn = .signedOut
        self.UserDayData = [UserDayGoalEventList]()
        self.UserDayBlockData  = [UserDayGoalEventList]()
        self.manifestSuite?.set(self.User, forKey: self.manifestUserIdKey)
    }
    
    func mergeSortedGoalsEvents(goals: [Value]?, events: [Event]?) {
        var i=0
        var j=0
        var calendar = Calendar.current
        calendar.timeZone = .current
        
        let startInterval = Date()
        let endInterval = Date().addingTimeInterval(240*60)
        
        let startComp = calendar.dateComponents([.year, .month, .day], from: startInterval)
        let endComp = calendar.dateComponents([.year, .month, .day], from: endInterval)
        
        while i<events?.count ?? -1 && j<goals?.count ?? -1 {
            var eventStart = calendar.dateComponents([.hour, .minute, .second], from: ISO8601DateFormatter().date(from: (events![i].start?.dateTime)!)!)
            eventStart.year = startComp.year
            eventStart.month = startComp.month
            eventStart.day = startComp.day
            
            var goalStart = calendar.dateComponents([.hour, .minute, .second], from: DayDateObj.timeLeft.date(from: (goals![j].mapValue?.fields.startDayAndTime.stringValue)!)!)

            goalStart.year = startComp.year
            goalStart.month = startComp.month
            goalStart.day = startComp.day
            
            var goalEnd = calendar.dateComponents([.hour, .minute, .second], from: DayDateObj.timeLeft.date(from: (goals![j].mapValue?.fields.endDayAndTime.stringValue)!)!)
            goalEnd.year = endComp.year
            goalEnd.month = endComp.month
            goalEnd.day = endComp.day
               
            if calendar.date(from: eventStart)! <= calendar.date(from: goalStart)! {
                self.UserDayData.append(events![i])
                if self.eventWithinInterval(item: events![i], start: startInterval, end: endInterval) {
                    self.UserDayBlockData.append(events![i])
                }
                i += 1
            } else {
                if goals![j].mapValue!.fields.isDisplayedToday.booleanValue == true && goals![j].mapValue!.fields.isAvailable.booleanValue == true {
                    self.UserDayData.append(goals![j])
                    if self.goalWithinInterval(itemStart: calendar.date(from: goalStart)!, itemEnd: calendar.date(from: goalEnd)!, start: startInterval, end: endInterval) {
                        self.UserDayBlockData.append(goals![j])
                    }
                }
                j += 1
            }
        }
       
        while i<events?.count ?? -1 {
            self.UserDayData.append(events![i])
            if self.eventWithinInterval(item: events![i], start: startInterval, end: endInterval) {
                self.UserDayBlockData.append(events![i])
            }
            i += 1
        }
       
        while j<goals?.count ?? -1 {
            var goalStart = calendar.dateComponents([.hour, .minute, .second], from: DayDateObj.timeLeft.date(from: (goals![j].mapValue?.fields.startDayAndTime.stringValue)!)!)
            goalStart.year = startComp.year
            goalStart.month = startComp.month
            goalStart.day = startComp.day
                
            var goalEnd = calendar.dateComponents([.hour, .minute, .second], from: DayDateObj.timeLeft.date(from: (goals![j].mapValue?.fields.endDayAndTime.stringValue)!)!)
            goalEnd.year = endComp.year
            goalEnd.month = endComp.month
            goalEnd.day = endComp.day
            
            if goals![j].mapValue!.fields.isDisplayedToday.booleanValue == true && goals![j].mapValue!.fields.isAvailable.booleanValue == true {
                self.UserDayData.append(goals![j])
                if self.goalWithinInterval(itemStart: calendar.date(from: goalStart)!, itemEnd: calendar.date(from: goalEnd)!, start: startInterval, end: endInterval) {
                    self.UserDayBlockData.append(goals![j])
                }
           }
           j += 1
       }
    }
    
    private func isNow(item: Event) -> Bool {
        if DayDateObj.ISOFormatter.date(from: item.end!.dateTime)! < Date() {
            return false
        }
        return true
    }
    
    private func eventWithinInterval(item: Event, start: Date, end: Date) -> Bool {
        if DayDateObj.ISOFormatter.date(from: item.end!.dateTime)! < start ||
            DayDateObj.ISOFormatter.date(from: item.start!.dateTime)! > end {
            return false
        }
        return true
    }
    
    private func goalWithinInterval(itemStart: Date, itemEnd: Date, start: Date, end: Date) -> Bool {
        if itemEnd < start || itemStart > end {
            return false
        }
        return true
    }
}
