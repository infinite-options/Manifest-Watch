//
//  BackgroundServices.swift
//  PC-Watch WatchKit Extension
//
//  Created by Harshit Trehan on 7/6/20.
//  Copyright © 2020 Infinite Options. All rights reserved.
//

//Tutorial: https://blog.jayway.com/2020/02/10/show-fresh-content-background-refresh/

import Foundation
import Combine
import WatchKit
import ClockKit

class BackgroundService: NSObject {
    
    var backgroundTasKID = [-1, -1]
    static let shared = BackgroundService()
    let model = NetworkManager.shared
    let UserDayData = UserManager.shared
    
    // Store tasks in order to complete them when finished
    var pendingBackgroundTasks = [WKURLSessionRefreshBackgroundTask]()
    
    func updateContent() {
        let configuration = URLSessionConfiguration
            .background(withIdentifier: "complicationUpdate")
        configuration.sessionSendsLaunchEvents = true
        let session = URLSession(configuration: configuration,
                                 delegate: self, delegateQueue: nil)
        
        updateGoals(session: session) { backgroundGoalTask in
            self.updateEvents(session: session) { backroundEventTask in
                backgroundGoalTask.resume()
                backroundEventTask.resume()
            }
        }
    }
    
    func updateGoals( session: URLSession, completion: (URLSessionDownloadTask) -> ())  {
        let goalUrl = "https://firestore.googleapis.com/v1/projects/myspace-db/databases/(default)/documents/users/" + self.UserDayData.User
        guard let url = URL(string: goalUrl) else { return }
        let backgroundTask = session.downloadTask(with: url)
        backgroundTasKID[0] = backgroundTask.taskIdentifier
        completion(backgroundTask)
    }
    
    func updateEvents(session: URLSession, completion: (URLSessionDownloadTask) -> ()) {
        guard let url = URL(string: "https://us-central1-myspace-db.cloudfunctions.net/GetEventsForTheDay") else { return }
        
        //Get the components for today's date
        var currComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())

        //Set to 00:00:00 for 'start' of the day
        currComponents.hour = 0
        currComponents.minute = 0
        currComponents.second = 0
        let startDate = DayDateObj.ISOFormatter.string(from: Calendar.current.date(from: currComponents)!)
        
        //Set to 23:59:59 for 'end' of the day
        currComponents.hour = 23
        currComponents.minute = 59
        currComponents.second = 59
        let endDate = DayDateObj.ISOFormatter.string(from: Calendar.current.date(from: currComponents)!)
        
        //Create request the body
        let jsonData = getEventsBody(id: self.UserDayData.User,
                                     start: startDate,
                                     end: endDate)
        let finalJsonData = try? JSONEncoder().encode(jsonData)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = finalJsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let backgroundTask = session.downloadTask(with: request)
        backgroundTasKID[1] = backgroundTask.taskIdentifier
        completion(backgroundTask)
       
    }
    
    func handleDownload(_ backgroundTask: WKURLSessionRefreshBackgroundTask) {
        let configuration = URLSessionConfiguration
            .background(withIdentifier: backgroundTask.sessionIdentifier)
        
        let _ = URLSession(configuration: configuration,
                           delegate: self, delegateQueue: nil)
        
        pendingBackgroundTasks.append(backgroundTask)
    }
}

extension BackgroundService : URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didFinishDownloadingTo location: URL) {
        
        let group = DispatchGroup()
        
        if(downloadTask.taskIdentifier == backgroundTasKID[0]){
            group.enter()
            processGoalsFile(file: location) {
                group.leave()
            }
        }
        
        if(downloadTask.taskIdentifier == backgroundTasKID[1]){
            group.enter()
            processEventsFile(file: location) {
                group.leave()
            }
        }
        
        group.notify(queue: DispatchQueue.main) {
            UserManager.shared.mergeSortedGoalsEvents(goals: NetworkManager.shared.data ?? [Value](), events: NetworkManager.shared.events ?? [Event]())
            self.updateActiveComplication()
        }
        
        self.pendingBackgroundTasks.forEach {
            $0.setTaskCompletedWithSnapshot(false)
        }
    }
    
    func processGoalsFile(file: URL, completion: () -> ()){
        if let data = try? Data(contentsOf: file),
            let model = try? JSONDecoder().decode(Firebase.self, from: data) {
            DispatchQueue.main.async {
                NetworkManager.shared.data = model.fields.goalsRoutines.arrayValue.values
            }
            print("Processed goals successfully")
            completion()
        }
    }
    
    func processEventsFile(file: URL, completion: () -> ()){
        if let data = try? Data(contentsOf: file),
            let model = try? JSONDecoder().decode([Event].self, from: data) {
            DispatchQueue.main.async {
                NetworkManager.shared.events = model
            }
            print("Processed events successfully")
            completion()
        }
    }
    
    func updateActiveComplication(){
        print("Calling reloadTimeline")
        let complicationServer = CLKComplicationServer.sharedInstance()
        if let activeComplication = complicationServer.activeComplications {
            for complication in activeComplication {
                complicationServer.reloadTimeline(for: complication)
            }
        }
    }
}
