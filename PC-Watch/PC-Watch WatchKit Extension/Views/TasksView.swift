//
//  TasksView.swift
//  PC-Watch WatchKit Extension
//
//  Created by Harshit Trehan on 7/3/20.
//  Copyright © 2020 Infinite Options. All rights reserved.
//

import SwiftUI
import UserNotifications

struct newTaskItem: View {
    var extensionDelegate = ExtensionDelegate()
    @State var showSteps: Bool = false
    var task: TaskAndActions?
    var index: Int?
    var goalOrRoutineIndex: Int?
    var goalOrRoutineID: String?
    var previousTaskIsComplete: String?
    var fullDayArray: Bool
    
    @State private var showingAlert = false
    
    @ObservedObject private var model = NetworkManager.shared
    @ObservedObject private var user = UserManager.shared
    
    @State var done = false
    
    var body: some View {
        VStack(alignment: .center) {
            Divider()
            HStack(alignment: .center) {
                VStack(alignment: .leading) {
                    Text(self.task!.atTitle)
                        .fontWeight(.bold)
                        .frame(width: 110)
                        .font(.system(size: 16, design: .rounded))
                        .lineLimit(2)
                    Text("Takes me " + self.task!.expectedCompletionTime)
                        .fontWeight(.light)
                        .frame(width: 110)
                        .font(.system(size: 12, design: .rounded))
                }
                if ( self.done || self.task!.isComplete.lowercased() == "true") {
                    AssetImage(urlName: self.task!.photo, placeholder: Image("default-step"))
                        .aspectRatio(contentMode: .fit)
                        .opacity(0.60)
                        .overlay(Image(systemName: "checkmark.circle")
                            .font(.system(size:55))
                            .padding(EdgeInsets(top: 12, leading: 0, bottom: 0, trailing: 0))
                            .foregroundColor(.green))
                } else {
                    AssetImage(urlName: self.task!.photo, placeholder: Image("default-step"))
                        .aspectRatio(contentMode: .fit)
                }
            }
            Spacer()
            if(!self.done && (self.task!.isComplete.lowercased() == "false")){
                Button(action: {
                    // complete task
                    if self.previousTaskIsComplete!.lowercased() == "true" {
                        self.model.completeActionOrTask(actionTaskId: self.task!.atUniqueID)
                        print("task complete")
                        // update task in model
                        self.model.goalsSubTasks[self.goalOrRoutineID!]!![self.index!].isComplete = "true"
                        // decrement tasks left for goal
                        self.model.goalSubtasksLeft[self.goalOrRoutineID!]! -= 1
                        if self.model.goalsSubTasks[self.goalOrRoutineID!]!![self.index!].isMustDo.lowercased() == "true" {
                            self.model.isMustDoTasks[self.goalOrRoutineID!]! -= 1
                        }
                        if self.model.goalSubtasksLeft[self.goalOrRoutineID!] == 0 || self.model.isMustDoTasks[self.goalOrRoutineID!] == 0{
                            print("goal complete")
                            // if no tasks left, update model
                            //self.model.data![self.goalOrRoutineIndex!].mapValue?.fields.isComplete!.booleanValue = true
                            self.model.goalsRoutinesData?[self.goalOrRoutineIndex!].isComplete = "True"
                            self.model.goalsRoutinesBlockData?[self.goalOrRoutineIndex!].isComplete = "True"
                            // set goal to complete
                            self.model.completeGoalOrRoutine(goalRoutineId: self.goalOrRoutineID!)

                            self.extensionDelegate.scheduleMoodNotification()
                        } else {
                            print("goal not complete yet")
                            self.model.goalsRoutinesData?[self.goalOrRoutineIndex!].isInProgress = "True"
                            self.model.goalsRoutinesBlockData?[self.goalOrRoutineIndex!].isInProgress = "True"
                            // start goal
                            self.model.startGoalOrRoutine(goalRoutineId: self.goalOrRoutineID!)
                        }
                        self.done = true
                        self.showSteps = false
                    } else {
                         self.showingAlert = true
                    }
                }) {
                    Text("Done?")
                        .fontWeight(.bold)
                        .font(.system(size: 16, design: .rounded))
                        .foregroundColor(.green)
                }.padding(2)
                 .alert(isPresented: $showingAlert) {
                    Alert(title: Text("You need to complete the previous task first."), dismissButton: Alert.Button.default(Text("Ok")))
                 }
            } else {
                RoundedRectangle(cornerSize: CGSize(width: 120, height: 30), style: .continuous)
                    .stroke(Color.green, lineWidth: 1)
                    .frame(width:140, height:25)
                    .overlay(Text("Task Completed")
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                        .font(.system(size: 16, design: .rounded)))
                    .padding(2)
            }
        }
    }
}

struct newTaskView: View{
    @ObservedObject private var model = NetworkManager.shared
    @ObservedObject private var user = UserManager.shared
    var goalOrRoutine: GoalRoutine?
    var goalOrRoutineIndex: Int?
    var fullDayArray: Bool
    var notificationCenter = NotificationCenter()
    var extensionDelegate = ExtensionDelegate()
    @State var done = false
    @State var started = false
    
    var body: some View {
        GeometryReader{ geo in
            if(self.model.goalsSubTasks[self.goalOrRoutine!.grUniqueID] == nil){
                VStack(alignment: .center){
                    if(self.done || (self.goalOrRoutine!.isComplete.lowercased() == "true")){
                        AssetImage(urlName: self.goalOrRoutine!.photo, placeholder: Image("default-goal"))
                            .aspectRatio(contentMode: .fit)
                            .opacity(0.60)
                            .overlay(Image(systemName: "checkmark.circle")
                                .font(.system(size:55))
                                .padding(EdgeInsets(top: 12, leading: 0, bottom: 0, trailing: 0))
                                .foregroundColor(.green))
                    } else {
                        AssetImage(urlName: self.goalOrRoutine!.photo, placeholder: Image("default-goal"))
                            .aspectRatio(contentMode: .fit)
                    }
                    Text(self.goalOrRoutine!.grTitle)
                        .fontWeight(.bold)
                        .lineLimit(nil)
                        .padding()
                        .font(.system(size: 18, design: .rounded))
                    Text("Takes me " + self.goalOrRoutine!.expectedCompletionTime)
                        .fontWeight(.light)
                        .font(.system(size: 12, design: .rounded))
                    Spacer()
                    if(!self.done && (self.goalOrRoutine!.isComplete.lowercased() == "false")){
                        Button(action: {
                            print("done button clicked")
                            self.model.completeGoalOrRoutine(goalRoutineId: self.goalOrRoutine!.grUniqueID)
                            self.model.goalsRoutinesData?[self.goalOrRoutineIndex!].isComplete = "True"
                            self.model.goalsRoutinesBlockData?[self.goalOrRoutineIndex!].isComplete = "True"
                            self.done = true
                            self.extensionDelegate.scheduleMoodNotification()
                        }) {
                            Text("Done?")
                                .fontWeight(.bold)
                                .font(.system(size: 16, design: .rounded))
                                .foregroundColor(.green)
                        }.padding(2)
                    } else {
                        RoundedRectangle(cornerSize: CGSize(width: 120, height: 30), style: .continuous)
                            .stroke(Color.green, lineWidth: 1)
                            .overlay(Text("Goal Completed")
                                .fontWeight(.bold)
                                .foregroundColor(.green)
                                .font(.system(size: 16, design: .rounded)))
                            .padding(2)
                    }
                }
            } else {
                ScrollView([.vertical]){
                    VStack(alignment: .center){
                        if (self.done || self.goalOrRoutine!.isComplete.lowercased() == "true"){
                            AssetImage(urlName: self.goalOrRoutine!.photo, placeholder: Image("default-task"))
                                .aspectRatio(contentMode: .fit)
                                .opacity(0.60)
                                .overlay(Image(systemName: "checkmark.circle")
                                    .font(.system(size:65))
                                    .padding(EdgeInsets(top: 12, leading: 0, bottom: 0, trailing: 0))
                                    .foregroundColor(.green))
                        } else {
                            AssetImage(urlName: self.goalOrRoutine!.photo, placeholder: Image("default-task"))
                                .aspectRatio(contentMode: .fit)
                        }
                        VStack{
                            Text(self.goalOrRoutine!.grTitle)
                                .fontWeight(.bold)
                                .lineLimit(nil)
                                .font(.system(size: 18, design: .rounded))
                            Text("Takes me " + self.goalOrRoutine!.expectedCompletionTime)
                                .fontWeight(.light)
                                .font(.system(size: 12, design: .rounded))
                        }
                        Spacer()
                        if(!self.done && self.goalOrRoutine!.isComplete.lowercased() == "true"){
                            RoundedRectangle(cornerSize: CGSize(width: 120, height: 30), style: .continuous)
                                .stroke(Color.green, lineWidth: 1)
                                .frame(width:140, height:25)
                                .overlay(Text("Task Completed")
                                    .fontWeight(.bold)
                                    .foregroundColor(.green)
                                    .font(.system(size: 16, design: .rounded)))
                                .padding(2)
                        } else {
                            if(!self.started && self.goalOrRoutine!.isInProgress.lowercased() == "false"){                       //if it is not started show a start button
                                Button(action: {
                                    self.started = true
                                    self.model.goalsRoutinesData?[self.goalOrRoutineIndex!].isInProgress = "True"
                                    self.model.goalsRoutinesBlockData?[self.goalOrRoutineIndex!].isInProgress = "True"
                                    // start goal
                                    self.model.startGoalOrRoutine(goalRoutineId: self.goalOrRoutine!.grUniqueID)
                                }) {
                                    Text("Start")
                                        .fontWeight(.bold)
                                        .foregroundColor(.yellow)
                                        .font(.system(size: 16, design: .rounded))
                                }
                            } else {                                                                                //if it is started show a Started Text
                                RoundedRectangle(cornerSize: CGSize(width: 120, height: 30), style: .continuous)
                                    .stroke(Color.yellow, lineWidth: 1)
                                    .frame(width:140, height:25)
                                    .overlay(Text("Started")
                                        .fontWeight(.bold)
                                        .foregroundColor(.yellow)
                                        .font(.system(size: 16, design: .rounded)))
                                    .padding(2)
                            }
                        }
                    }.padding(.bottom, 0)
                    ForEach(Array((self.model.goalsSubTasks[self.goalOrRoutine!.grUniqueID]!?.enumerated())!), id: \.offset){ index, item in
                        VStack(alignment: .leading){
                            if(item.isAvailable.lowercased() == "true"){
                                newTaskItem(task: item, index: index , goalOrRoutineIndex: self.goalOrRoutineIndex!, goalOrRoutineID: self.goalOrRoutine?.grUniqueID, previousTaskIsComplete: ((index == 0) ? "True" : self.model.goalsSubTasks[self.goalOrRoutine!.grUniqueID]!![index-1].isComplete), fullDayArray: self.fullDayArray)
                            }
                        }
                    }
                }.frame(height: geo.size.height)
                .padding(0)
                .navigationBarTitle("Steps")
            }
        }.onAppear()
    }
}
