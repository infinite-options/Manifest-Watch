//
//  NetworkManager.swift
//  Manifest-Watch WatchKit Extension
//
//  Created by Prashant Marathay on 11/9/21.
//  Copyright © 2021 Infinite Options. All rights reserved.
//

import Foundation
import SwiftUI

class NetworkManager: ObservableObject {
    
    static let shared = NetworkManager()
    let userManager = UserManager.shared
    
    //Stores important people
    @Published var importantPeople: [ImportantPerson]?
    @Published var peopleRow: [PeopleRow]?
    @Published var peopleEmailToNameDict = [String : String]()
    
    //Stores the goals and routines
    @Published var data: [Value]?
    
    //Stores the events
    @Published var events: [Event]?
    
    //New Variable to store goals and routines
    @Published var goalsRoutinesData: [GoalRoutine]?
    @Published var goalsRoutinesBlockData: [GoalRoutine]?
    
    //New Dictonary to store subTasks
    @Published var goalsSubTasks = [String: [TaskAndActions]?]()
    
    //Temporary variable to hold tasks
    private var tasks: [TaskAndActions]?
    
    let trueCase = "true"
    let falseCase = "false"
    
    //Key: Goal, Value: tasks
    @Published var goalsSubtasks = [String: [ValueTask]?]()
    //Key: Task, Value: steps
    @Published var taskSteps = [String: [ValueTask]?]()
    
    // Key: Goal, Value: # of tasks in Goal
    @Published var goalSubtasksLeft = [String: Int]()
    // Key: Task, Value: #
    @Published var taskStepsLeft = [String: Int]()
    
    @Published var isMustDoTasks = [String: Int]()
//    @Published var isMustDoSteps = [String: Int]()
    
    private init() {
        self.goalsRoutinesData = []
        self.goalsRoutinesBlockData = []
    }
    
    func updateDataModel(completion: @escaping () -> ()) {
        
        let group = DispatchGroup()
        var userInfo: UserInfo?
        
        group.enter()
        getGoalsAndRoutines(){ data in
            print("GR Endpoint Return: \(data)")
            self.goalsRoutinesData = data
            self.goalsRoutinesData?.sort(by: self.sortGoalsAndRoutines)
            
            //Add some lines to merge goal and events data
            // TODO: Radomyr
            
            //Differentiate between block and full data here
            self.goalsRoutinesBlockData = self.goalsRoutinesData
            
            if let goalRoutine = data{
                for goal in goalRoutine{
                    group.enter()
                    self.getTasks(goalID: goal.grUniqueID){temp in
                        self.tasks = temp
                        if self.tasks?.count != 0{
                            //Create a dictonary for SubTasks, SubTasksLeft and isMustDoTasks
                            self.goalsSubTasks[goal.grUniqueID] = self.tasks
                            self.goalSubtasksLeft[goal.grUniqueID] = self.tasks?.count
                            self.isMustDoTasks[goal.grUniqueID] = 0
                            for task in self.tasks!{
                                if(task.isComplete.lowercased() == self.trueCase){
                                    self.goalSubtasksLeft[goal.grUniqueID]! -= 1
                                }
                                if(task.isMustDo.lowercased() == self.trueCase){
                                    self.isMustDoTasks[goal.grUniqueID]! += 1
                                }
                            }
                        }
                    }
                    group.leave()
                }
            }
            group.leave()
        }
        
        group.enter()
        getUserInfo { (data) in
            userInfo = data
            group.leave()
        }
        group.wait()
        
        guard let info = userInfo else {return}
        self.userManager.UserInfo = info
        if let imageURLString = info.userPicture {
            getUserProfilePhoto(url: imageURLString) { (image) in
                self.userManager.UserPhoto = image
            }
        }
        getImportantPeople { (importantPeople) in
            self.importantPeople = importantPeople
            print("Got important people from Firebase. Now getting other firebase data.")
            if self.importantPeople != nil {
                for person in self.importantPeople! {
                    if person.email != nil {
                        self.peopleEmailToNameDict[person.email] = person.name
                    }
                }
                self.peopleRow = PeopleRow.populate(people: self.importantPeople!)
            }
        }

        completion()
    }
    func sortGoalsAndRoutines(this: GoalRoutine, that: GoalRoutine) -> Bool {
        var calendar = Calendar.current
        calendar.timeZone = .current
        
        let thisStart = calendar.dateComponents([.hour, .minute, .second], from: DayDateObj.timeLeft.date(from: (this.startDayAndTime)) ?? Date())
        let thatStart = calendar.dateComponents([.hour, .minute, .second], from: DayDateObj.timeLeft.date(from: (that.startDayAndTime)) ?? Date())
        
        return calendar.date(from: thisStart)! < calendar.date(from: thatStart)!
    }
    func getImportantPeople(completion: @escaping ([ImportantPerson]?) -> ()) {
        var peopleUrl = "https://3s3sftsr90.execute-api.us-west-1.amazonaws.com/dev/api/v2/listPeople/"
        peopleUrl.append(self.userManager.User)
        guard let url = URL(string: peopleUrl) else { return }
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print("Generic networking error: \(error)")
            }
            if let data = data {
                do {
                    let data = try JSONDecoder().decode(ImportantPeopleResponse.self, from: data)
                    DispatchQueue.main.async {
                        completion(data.result.result)
                    }
                }
                catch _ {
                    print("couldn't retrieve people")
                    completion(nil)
                }
            }
        }
        .resume()
    }
    
    /// returns optinal info about the current user
    func getUserInfo(completion: @escaping (UserInfo?) -> ()){
        var aboutmeUrl = "https://3s3sftsr90.execute-api.us-west-1.amazonaws.com/dev/api/v2/aboutme/"
        aboutmeUrl.append(self.userManager.User)
        guard let url = URL(string: aboutmeUrl) else { return }
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print("Generic networking error: \(error)")
            }
            if let data = data {
                do {
                    let data = try JSONDecoder().decode(UserInfoResponse.self, from: data)
                    completion(data.result[0])
                }
                catch _ {
                    print("Error in parsing UserInfo data")
                    completion(nil)
                }
            }
        }
        .resume()
    }

    /// returns optional   message: String and  result: [GoalRoutine]
    func getGoalsAndRoutines(completion: @escaping ([GoalRoutine]?) -> ()) {
        var goalUrl = "https://3s3sftsr90.execute-api.us-west-1.amazonaws.com/dev/api/v2/getgoalsandroutines/"
        goalUrl.append(self.userManager.User)
        print(goalUrl)
        guard let url = URL(string: goalUrl) else { return }
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print("Generic networking error: \(error)")
            }
            if let data = data {
//                print("In Func Endpoint Return: \(data)")
                print("JSON String: \(String(data: data, encoding: .utf8))")
                do {
                    let data = try JSONDecoder().decode(GoalsAndRoutinesResponse.self, from: data)
                    completion(data.result)
                }
                catch _ {
                    print("Error in parsing Goals data")
                    completion(nil)
                }
            }
        }
        .resume()
    }
    func getUserProfilePhoto(url: String, completion: @escaping (UIImage) -> () ) {
        guard let photoUrl = URL(string: url) else { return }
        URLSession.shared.dataTask(with: photoUrl) { (data, _, error) in
            if let error = error {
                print("Error in downlaoding profile image: \(error)")
                return
            }
            if let data = data {
                print("Image Download done.")
                DispatchQueue.main.async {
                    //self.UserDayData.manifestSuite?.set(data, forKey: self.UserDayData.manifestUserPhoto)
                    completion( UIImage(data: data)! )
                }
            }
        }.resume()
    }
    func getTasks(goalID: String, completion: @escaping ([TaskAndActions]?) -> ()) {
        let TaskUrl = "https://3s3sftsr90.execute-api.us-west-1.amazonaws.com/dev/api/v2/actionsTasks/" + goalID
        //print(TaskUrl)
        guard let url = URL(string: TaskUrl) else { return }
        
            URLSession.shared.dataTask(with: url) { (data, _, error) in
                if let error = error {
                    print("Generic networking error: \(error)")
                }
                
                if let data = data {
                    do {
                        let data = try JSONDecoder().decode(TaskAndActionsResponse.self, from: data)
                        DispatchQueue.main.async {
                            completion(data.result)
                        }
                    }
                    catch _ {
                        print("No tasks for goal: \(goalID)")
                        completion(nil)
                    }
                }
            }
        .resume()
    }
    func startGoalOrRoutine(goalRoutineId: String) {
        print("Inside start goal or routine")
        
        guard let url = URL(string: "https://3s3sftsr90.execute-api.us-west-1.amazonaws.com/dev/api/v2/udpateGRWatchMobile") else { return }
        let defaultDateTimeStarted = createTimeStamp()
        let isInProgress = self.trueCase
        let isComplete = self.falseCase
        
        
        let jsonData = GoalRoutinePost(id: goalRoutineId, datetimeCompleted: "", datetimeStarted: defaultDateTimeStarted, isInProgress: isInProgress, isComplete: isComplete)
        
        let finalJsonData = try? JSONEncoder().encode(jsonData)
        
        print(finalJsonData!)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = finalJsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        URLSession.shared.dataTask(with: request){ (data, _ , error) in
            if let error = error {
                print("Generic networking error: \(error)")
            }

            if let data = data {
                do{
                    let finalRespData = try JSONDecoder().decode(GoalRoutinePostResp.self, from: data)
                    print(finalRespData)
                }
                catch let jsonParseError {
                    print("Error in parsing JSON response: \(jsonParseError)")
                }
            }
            else { return }
        }.resume()
    }
    func completeGoalOrRoutine(goalRoutineId: String) {
        print("Inside complete goal or routine")
        
        guard let url = URL(string: "https://3s3sftsr90.execute-api.us-west-1.amazonaws.com/dev/api/v2/udpateGRWatchMobile") else { return }
        let defaultDateTimeCompleted = createTimeStamp()
        let isInProgress = self.falseCase
        let isComplete = self.trueCase
        
        
        let jsonData = GoalRoutinePost(id: goalRoutineId, datetimeCompleted: defaultDateTimeCompleted, datetimeStarted: "", isInProgress: isInProgress, isComplete: isComplete)
        
        let finalJsonData = try? JSONEncoder().encode(jsonData)
        
        print(finalJsonData!)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = finalJsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        URLSession.shared.dataTask(with: request){ (data, _ , error) in
            if let error = error {
                print("Generic networking error: \(error)")
            }

            if let data = data {
                do{
                    let finalRespData = try JSONDecoder().decode(GoalRoutinePostResp.self, from: data)
                    print(finalRespData)
                }
                catch let jsonParseError {
                    print("Error in parsing JSON response: \(jsonParseError)")
                }
            }
            else { return }
        }.resume()
    }
    func completeActionOrTask(actionTaskId: String) {
        print("Inside complete action or task")
        
        guard let url = URL(string: "https://3s3sftsr90.execute-api.us-west-1.amazonaws.com/dev/api/v2/updateATWatchMobile") else { return }
        let defaultDateTimeCompleted = createTimeStamp()
        let isInProgress = self.falseCase
        let isComplete = self.trueCase
        
        
        let jsonData = ActionTaskPost(id: actionTaskId, datetimeCompleted: defaultDateTimeCompleted, datetimeStarted: "", isInProgress: isInProgress, isComplete: isComplete)
        
        let finalJsonData = try? JSONEncoder().encode(jsonData)
        
        print(finalJsonData!)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = finalJsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        URLSession.shared.dataTask(with: request){ (data, _ , error) in
            if let error = error {
                print("Generic networking error: \(error)")
            }

            if let data = data {
                do{
                    let finalRespData = try JSONDecoder().decode(ActionTaskPostResp.self, from: data)
                    print(finalRespData)
                }
                catch let jsonParseError {
                    print("Error in parsing JSON response: \(jsonParseError)")
                }
            }
            else { return }
        }.resume()
    }
    func createTimeStamp() -> String{
        //Useful linkg for datetime formatting -> https://www.datetimeformatter.com/how-to-format-date-time-in-swift/
        
        //Data format example = "Thu, 01 Jan 2004 00:00:00 GMT"
        let formatter3 = DateFormatter()
        formatter3.dateFormat = "E, d MMM y hh:mm a zzz"
        let today = Date()
        let temp = formatter3.string(from: today)
        print(temp)
        return temp
    }
}
