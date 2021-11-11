//
//  NotificationHandler.swift
//  PC-Watch WatchKit Extension
//
//  Created by Harshit Trehan on 7/2/20.
//  Copyright © 2020 Infinite Options. All rights reserved.
//

import Foundation
import UserNotifications

class NotificationHandler : NSObject, UNUserNotificationCenterDelegate {
    
    let center = UNUserNotificationCenter.current()
    let content = UNMutableNotificationContent()
    let DataModel = UserManager.shared
    var calendar = Calendar.current
    
    func scheduleNotifications(){
        
        if DataModel.UserDayData.count > 0 {
            for item in DataModel.UserDayData {
                if isEvent(item: item) {
                    setNotificationEvent(event: item as! Event)
                }
                else {
                    //User - Before
                    if (item.mapValue!.fields.userNotifications.mapValue.fields.before.mapValue.fields.isEnabled.booleanValue){
                        setNotificationGoalRoutine(
                            message: item.mapValue!.fields.userNotifications.mapValue.fields.before.mapValue.fields.message.stringValue,
                            time:  item.mapValue!.fields.userNotifications.mapValue.fields.before.mapValue.fields.time.stringValue,
                            title: item.mapValue!.fields.title.stringValue,
                            startOrEndTime: item.mapValue!.fields.startDayAndTime.stringValue,
                            id: item.mapValue!.fields.id.stringValue,
                            tag: 0)
                    }
                    //User - During
                    if (item.mapValue!.fields.userNotifications.mapValue.fields.during.mapValue.fields.isEnabled.booleanValue){
                        setNotificationGoalRoutine(
                            message: item.mapValue!.fields.userNotifications.mapValue.fields.during.mapValue.fields.message.stringValue,
                            time:  item.mapValue!.fields.userNotifications.mapValue.fields.during.mapValue.fields.time.stringValue,
                            title: item.mapValue!.fields.title.stringValue,
                            startOrEndTime: item.mapValue!.fields.startDayAndTime.stringValue,
                            id: item.mapValue!.fields.id.stringValue,
                            tag: 1)
                    }
                    //User - After
                    if (item.mapValue!.fields.userNotifications.mapValue.fields.after.mapValue.fields.isEnabled.booleanValue){
                        setNotificationGoalRoutine(
                            message: item.mapValue!.fields.userNotifications.mapValue.fields.after.mapValue.fields.message.stringValue,
                            time:  item.mapValue!.fields.userNotifications.mapValue.fields.after.mapValue.fields.time.stringValue,
                            title: item.mapValue!.fields.title.stringValue,
                            startOrEndTime: item.mapValue!.fields.endDayAndTime.stringValue,
                            id: item.mapValue!.fields.id.stringValue,
                            tag: 2)
                    }
                    
                }
            }
        }
    }
    
    private func isEvent(item: UserDayGoalEventList) -> Bool{
        if item is Event {
            return true
        } else {
            return false
        }
    }
        
    func setNotificationEvent(event: Event){
        let eventStart = ISO8601DateFormatter().date(from: (event.start?.dateTime)!)
        let notificTriggerDate = calendar.date(byAdding: .minute, value: -15, to: eventStart!)!
        if(notificTriggerDate > Date()) {
            let identifier = event.id!
            content.title = event.summary ?? "Upcoming event"
            content.body = "Starts in 15 minutes"
            content.sound = UNNotificationSound.default
            
            checkPendingNotifications(identifier: identifier) { (flag) in
                
                if !flag {
                    print("Notification already exists... Exiting!")
                    return
                }
                else {
                    let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: notificTriggerDate)
                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                    let request = UNNotificationRequest(identifier: identifier, content: self.content, trigger: trigger)
                    
                    self.center.add(request) { (err) in
                        if let error = err {
                            print(error.localizedDescription)
                        }
                        else {
                            print("successful notification")
                        }
                    }
                }
            }
        }
    }
    func setNotificationGoalRoutine(message: String, time: String, title: String, startOrEndTime: String, id: String, tag: Int) {

        let start = DayDateObj.timeLeft.date(from: startOrEndTime)
        let timeComp = time.components(separatedBy: ":")
        let minutes = Int(timeComp[1])!
        var identifier = id
        
        var notificTriggerDate = Date()
        
        //0 - Before (StartTime - TimeBeforeStart)
        if tag == 0{
            notificTriggerDate = Calendar.current.date(byAdding: .minute, value: -minutes, to: start!)!
            print(notificTriggerDate)
            identifier.append(" - before")
            content.title = "About to start! \(title)"
            content.body = message
        }
        // 1 - During (TimeAfterStart + StartTime)
        else if tag == 1
        {
            notificTriggerDate = Calendar.current.date(byAdding: .minute, value: minutes, to: start!)!
            print(notificTriggerDate)
            identifier.append(" - during")
            content.title = "Currently going on: \(title)"
            content.body = message
        }
        //2 - After (EndTime + TimeAfterEnd)
        else if tag == 2{
            notificTriggerDate = Calendar.current.date(byAdding: .minute, value: minutes, to: start!)!
            print(notificTriggerDate)
            identifier.append(" - after")
            content.title = "Just finished: \(title)"
            content.body = message
        }
        
        content.sound = UNNotificationSound.default
        
        if (notificTriggerDate > Date() || title != "") {
            print("Current request: \(title) + \(identifier) + \(notificTriggerDate)")
            
            checkPendingNotifications(/*notificDate: notificTriggerDate,*/ identifier: identifier) { (flag) in
                if !(flag) {
                    print("Notification already exists... Exiting!")
                    return
                }
                else {

                    let dateComponents = Calendar.current.dateComponents([.hour, .minute, .second], from: notificTriggerDate)
                    var currentDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
                    currentDate.hour = dateComponents.hour
                    currentDate.minute = dateComponents.minute
                    currentDate.second = dateComponents.second
                    let trigger = UNCalendarNotificationTrigger(dateMatching: currentDate, repeats: false)
                    let request = UNNotificationRequest(identifier: identifier, content: self.content, trigger: trigger)
                    
                    self.center.add(request) { (err) in
                        if let error = err {
                            print(error.localizedDescription)
                        }
                        else {
                            print("successful notification")
                        }
                    }
                }
            }
        }
    }
    
    func checkPendingNotifications(/*notificDate: Date,*/ identifier: String, completion: @escaping (Bool) -> ()){
        center.getPendingNotificationRequests { (notifications) in
            print("Count: \(notifications.count)")
           
            for item in notifications {
                /*if let trigger = item.trigger as? UNCalendarNotificationTrigger,
                    let nextTriggerDate = trigger.nextTriggerDate() {
                        print("Next trigger date:: \(nextTriggerDate)")
                }*/
                if item.identifier == identifier {
                    completion(false)
                }
            }
        }
        completion(true)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound, .badge])
    }
}
