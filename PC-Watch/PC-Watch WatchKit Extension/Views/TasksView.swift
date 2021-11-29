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

struct checkTaskView: View {
    var task: TaskAndActions?
    var taskIndex: Int?
    var goal: GoalRoutine?
    var grIndex: Int?
    @ObservedObject var viewPick = ViewController.shared
    @ObservedObject private var model = NetworkManager.shared
    @State var checked = false
    
    var body: some View {
        HStack {
            Button {
                print("checkbox pressed")
                checked = !checked
//                self.model.completeGoalOrRoutine(goalRoutineId: self.goalOrRoutine!.grUniqueID)
//                self.model.goalsRoutinesData?[self.goalOrRoutineIndex!].isComplete = "True"
//                self.model.goalsRoutinesBlockData?[self.goalOrRoutineIndex!].isComplete = "True"
//                self.done = true
//
//                self.item?.isComplete = !self.item?.isComplete
//                self.item?.isInProgress = false
                
                //change the specific action
                if (self.model.goalsSubTasks[self.goal!.grUniqueID]??[taskIndex!].isComplete.lowercased() == "true")
                {
                    self.model.goalsSubTasks[self.goal!.grUniqueID]??[taskIndex!].isComplete = "False"
                    self.model.goalSubtasksLeft[self.goal!.grUniqueID]? += 1
                    if (self.model.goalsSubTasks[self.goal!.grUniqueID]??[taskIndex!].isMustDo.lowercased() == "true")
                    { self.model.isMustDoTasks[self.goal!.grUniqueID]? += 1 }
                    
                    self.model.resetActionOrTask(actionTaskId: task!.atUniqueID)
                }
                else
                {
                    self.model.goalsSubTasks[self.goal!.grUniqueID]??[taskIndex!].isComplete = "True"
                    self.model.goalSubtasksLeft[self.goal!.grUniqueID]? -= 1
                    if (self.model.goalsSubTasks[self.goal!.grUniqueID]??[taskIndex!].isMustDo.lowercased() == "true")
                    { self.model.isMustDoTasks[self.goal!.grUniqueID]? -= 1 }
                    
                    self.model.completeActionOrTask(actionTaskId: task!.atUniqueID)
                }
                
                self.model.goalsSubTasks[self.goal!.grUniqueID]??[taskIndex!].isInProgress = "False"
                
                if (self.model.goalSubtasksLeft[self.goal!.grUniqueID]! < (self.model.goalsSubTasks[self.goal!.grUniqueID]?!.count)! &&
                        self.model.goalSubtasksLeft[self.goal!.grUniqueID]! > 0)
                {
//                        self.goal?.isInProgress = "True"
                    self.model.goalsRoutinesData![self.grIndex!].isInProgress = "True"
                    self.model.goalsRoutinesBlockData![self.grIndex!].isInProgress = "True"
                    self.model.goalsRoutinesData![self.grIndex!].isComplete = "False"
                    self.model.goalsRoutinesBlockData![self.grIndex!].isComplete = "False"
                    
                    self.model.startGoalOrRoutine(goalRoutineId: self.goal!.grUniqueID)
                }
                else if (self.model.goalSubtasksLeft[self.goal!.grUniqueID]! == 0)
                {
                    self.model.goalsRoutinesData![self.grIndex!].isInProgress = "False"
                    self.model.goalsRoutinesBlockData![self.grIndex!].isInProgress = "False"
                    self.model.goalsRoutinesData![self.grIndex!].isComplete = "True"
                    self.model.goalsRoutinesBlockData![self.grIndex!].isComplete = "True"
                    
                    self.model.completeGoalOrRoutine(goalRoutineId: self.goal!.grUniqueID)
                }
                else
                {
                    self.model.goalsRoutinesData![self.grIndex!].isInProgress = "False"
                    self.model.goalsRoutinesBlockData![self.grIndex!].isInProgress = "False"
                    self.model.goalsRoutinesData![self.grIndex!].isComplete = "False"
                    self.model.goalsRoutinesBlockData![self.grIndex!].isComplete = "False"
                    
                    self.model.resetGoalOrRoutine(goalRoutineId: self.goal!.grUniqueID)
                }
//                isMustDoTasks
            }
            label: {
                if (self.model.goalsSubTasks[self.goal!.grUniqueID]??[taskIndex!].isComplete.lowercased() == "true") {
                    Image(systemName: "checkmark.circle")
                        .frame(width: 30, height: 30, alignment: .center)
                }
                else
                {
                    Image(systemName: "circle")
                        .frame(width: 30, height: 30, alignment: .center)
                }
            }
            .buttonStyle(PlainButtonStyle())
            .frame(width: 30, height: 30, alignment: .leading)
            
            if (self.task?.isSublistAvailable.lowercased() == "true")
            {
                NavigationLink(destination: newStepView(goalOrRoutine: (self.goal! as GoalRoutine), goalOrRoutineIndex: self.grIndex, chosenTask: self.task, taskIndex: self.taskIndex, fullDayArray: true)) {
                HStack {
                    
                    
                    HStack (spacing: 5) {
                        Spacer()
    //                    infoView(item: (self.item! as GoalRoutine))
                        VStack(alignment: .leading) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(self.task!.atTitle)
                                        .fontWeight(.bold)
                                        .font(.system(size: 16, design: .rounded))
                                        .foregroundColor(.white)
    //                                (item!.isPersistent.lowercased() == "true" ? Text("Starts at " + DayDateObj.formatter.string(from: DayDateObj.timeLeft.date(from: self.item!.availableStartTime) ?? Date()))
    //                                    .fontWeight(.light)
    //                                    .font(.system(size: 12, design: .rounded)) :
                                        Text("Takes me " + self.task!.expectedCompletionTime)
                                            .fontWeight(.light)
                                            .font(.system(size: 12, design: .rounded))
                                        .foregroundColor(.white)
                                }
                                Spacer()
                                if (self.task!.isComplete.lowercased() == "true"){
                                    AsyncImage(
                                        url: URL(string: self.task!.photo)!,
                                        placeholder: Image(systemName: "default-goal"))
                                        .opacity(0.4)
                                        .overlay(Image(systemName: "checkmark.circle")
                                                .font(.system(size:20))
                                                .padding(EdgeInsets(top: 2, leading: 0, bottom: 0, trailing: 0))
                                                .foregroundColor(.green))
                                    
                                } else if (self.task!.isInProgress.lowercased() == "true") {
                                        AsyncImage(
                                            url: URL(string: self.task!.photo)!,
                                            placeholder: Image(systemName: "default-goal"))
                                            .opacity(0.40)
                                            .overlay(Image(systemName: "arrow.2.circlepath.circle")
                                                .font(.system(size:20))
                                                .padding(EdgeInsets(top: 2, leading: 0, bottom: 0, trailing: 0))
                                                .foregroundColor(.yellow))
                                    
                                } else {
                                    AsyncImage(
                                        url: URL(string: self.task!.photo)!,
                                        placeholder: Image(systemName: "default-goal"))
                                } //else
                            } //hstack
                        } //vstack
                        
                        Spacer()
                    }.frame(height: 50)
                    .background(Color(#colorLiteral(red: 1, green: 0.7411764706, blue: 0.1529411765, alpha: 1)))
                    .cornerRadius(10)
                } //hstack
                } //navigationlink
                .buttonStyle(PlainButtonStyle())
            }
            else
            {
                HStack {
                    
                    
                    HStack (spacing: 5) {
                        Spacer()
    //                    infoView(item: (self.item! as GoalRoutine))
                        VStack(alignment: .leading) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(self.task!.atTitle)
                                        .fontWeight(.bold)
                                        .font(.system(size: 16, design: .rounded))
                                        .foregroundColor(.white)
    //                                (item!.isPersistent.lowercased() == "true" ? Text("Starts at " + DayDateObj.formatter.string(from: DayDateObj.timeLeft.date(from: self.item!.availableStartTime) ?? Date()))
    //                                    .fontWeight(.light)
    //                                    .font(.system(size: 12, design: .rounded)) :
                                        Text("Takes me " + self.task!.expectedCompletionTime)
                                            .fontWeight(.light)
                                            .font(.system(size: 12, design: .rounded))
                                        .foregroundColor(.white)
                                }
                                Spacer()
                                if (self.task!.isComplete.lowercased() == "true"){
                                    AsyncImage(
                                        url: URL(string: self.task!.photo)!,
                                        placeholder: Image(systemName: "default-goal"))
                                        .opacity(0.4)
                                        .overlay(Image(systemName: "checkmark.circle")
                                                .font(.system(size:20))
                                                .padding(EdgeInsets(top: 2, leading: 0, bottom: 0, trailing: 0))
                                                .foregroundColor(.green))
                                    
                                } else if (self.task!.isInProgress.lowercased() == "true") {
                                        AsyncImage(
                                            url: URL(string: self.task!.photo)!,
                                            placeholder: Image(systemName: "default-goal"))
                                            .opacity(0.40)
                                            .overlay(Image(systemName: "arrow.2.circlepath.circle")
                                                .font(.system(size:20))
                                                .padding(EdgeInsets(top: 2, leading: 0, bottom: 0, trailing: 0))
                                                .foregroundColor(.yellow))
                                    
                                } else {
                                    AsyncImage(
                                        url: URL(string: self.task!.photo)!,
                                        placeholder: Image(systemName: "default-goal"))
                                } //else
                            } //hstack
                        } //vstack
                        
                        Spacer()
                    }.frame(height: 50)
                    .background(Color(#colorLiteral(red: 1, green: 0.7411764706, blue: 0.1529411765, alpha: 1)))
                    .cornerRadius(10)
                } //hstack
                .onTapGesture {
                    checked = !checked
                    //change the specific action
                    if (self.model.goalsSubTasks[self.goal!.grUniqueID]??[taskIndex!].isComplete.lowercased() == "true")
                    {
                        self.model.goalsSubTasks[self.goal!.grUniqueID]??[taskIndex!].isComplete = "False"
                        self.model.goalSubtasksLeft[self.goal!.grUniqueID]? += 1
                        if (self.model.goalsSubTasks[self.goal!.grUniqueID]??[taskIndex!].isMustDo.lowercased() == "true")
                        { self.model.isMustDoTasks[self.goal!.grUniqueID]? += 1 }
                        
                        self.model.resetActionOrTask(actionTaskId: task!.atUniqueID)
//                        //no subtasks have been started for the goal
//                        if (self.model.goalSubtasksLeft[self.goal!.grUniqueID]! == self.model.goalsSubTasks[self.goal!.grUniqueID]!!.count)
//                        {
//
//                        }
                    }
                    else
                    {
                        self.model.goalsSubTasks[self.goal!.grUniqueID]??[taskIndex!].isComplete = "True"
                        self.model.goalSubtasksLeft[self.goal!.grUniqueID]? -= 1
                        if (self.model.goalsSubTasks[self.goal!.grUniqueID]??[taskIndex!].isMustDo.lowercased() == "true")
                        { self.model.isMustDoTasks[self.goal!.grUniqueID]? -= 1 }
                        
                        self.model.completeActionOrTask(actionTaskId: task!.atUniqueID)
                    }
                    
                    self.model.goalsSubTasks[self.goal!.grUniqueID]??[taskIndex!].isInProgress = "False"
                    
                    if (self.model.goalSubtasksLeft[self.goal!.grUniqueID]! < (self.model.goalsSubTasks[self.goal!.grUniqueID]?!.count)! &&
                            self.model.goalSubtasksLeft[self.goal!.grUniqueID]! > 0)
                    {
//                        self.goal?.isInProgress = "True"
                        self.model.goalsRoutinesData![self.grIndex!].isInProgress = "True"
                        self.model.goalsRoutinesBlockData![self.grIndex!].isInProgress = "True"
                        self.model.goalsRoutinesData![self.grIndex!].isComplete = "False"
                        self.model.goalsRoutinesBlockData![self.grIndex!].isComplete = "False"
                        
                        self.model.startGoalOrRoutine(goalRoutineId: self.goal!.grUniqueID)
                    }
                    else if (self.model.goalSubtasksLeft[self.goal!.grUniqueID]! == 0)
                    {
                        self.model.goalsRoutinesData![self.grIndex!].isInProgress = "False"
                        self.model.goalsRoutinesBlockData![self.grIndex!].isInProgress = "False"
                        self.model.goalsRoutinesData![self.grIndex!].isComplete = "True"
                        self.model.goalsRoutinesBlockData![self.grIndex!].isComplete = "True"
                        
                        self.model.completeGoalOrRoutine(goalRoutineId: self.goal!.grUniqueID)
                    }
                    else
                    {
                        self.model.goalsRoutinesData![self.grIndex!].isInProgress = "False"
                        self.model.goalsRoutinesBlockData![self.grIndex!].isInProgress = "False"
                        self.model.goalsRoutinesData![self.grIndex!].isComplete = "False"
                        self.model.goalsRoutinesBlockData![self.grIndex!].isComplete = "False"
                        
                        self.model.resetGoalOrRoutine(goalRoutineId: self.goal!.grUniqueID)
                    }
                }
                
            } //end of else
            
        } //vstack
    } //body
} //checktaskview

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
                    
                    //routines - red
                    if((self.done || (self.goalOrRoutine!.isComplete.lowercased() == "true") &&
                            self.goalOrRoutine!.isPersistent.lowercased() == "true")){
                        HStack (spacing: 5) {
                            Spacer()
                            infoView(item: (self.goalOrRoutine! as GoalRoutine))
                                .opacity(0.60)
//                                .overlay(Image(systemName: "checkmark.circle")
//                                    .font(.system(size:30))
//                                    .padding(EdgeInsets(top: 12, leading: 0, bottom: 0, trailing: 0))
//                                    .foregroundColor(.green))
                            Spacer()
                        }.frame(height: 50)
                        .background(Color(#colorLiteral(red: 0.9725490196, green: 0.4196078431, blue: 0.2862745098, alpha: 1)))
                        .cornerRadius(10)
                    }
                    //goals - yellow
                    else if(self.done || (self.goalOrRoutine!.isComplete.lowercased() == "true")){
                        HStack (spacing: 5) {
                            Spacer()
                            infoView(item: (self.goalOrRoutine! as GoalRoutine))
                                .opacity(0.60)
//                                .overlay(Image(systemName: "checkmark.circle")
//                                    .font(.system(size:30))
//                                    .padding(EdgeInsets(top: 12, leading: 0, bottom: 0, trailing: 0))
//                                    .foregroundColor(.green))
                            Spacer()
                        }.frame(height: 50)
                        .background(Color(#colorLiteral(red: 1, green: 0.7411764706, blue: 0.1529411765, alpha: 1)))
                        .cornerRadius(10)
                    }
                    //routines - red
                    else if (self.goalOrRoutine!.isPersistent.lowercased() == "true"){
                        HStack (spacing: 5) {
                            Spacer()
                            infoView(item: (self.goalOrRoutine! as GoalRoutine))
                            Spacer()
                        }.frame(height: 50)
                        .background(Color(#colorLiteral(red: 0.9725490196, green: 0.4196078431, blue: 0.2862745098, alpha: 1)))
                        .cornerRadius(10)
                    }
                    //goals - yellow
                    else{
                        HStack (spacing: 5) {
                            Spacer()
                            infoView(item: (self.goalOrRoutine! as GoalRoutine))
                            Spacer()
                        }.frame(height: 50)
                        .background(Color(#colorLiteral(red: 1, green: 0.7411764706, blue: 0.1529411765, alpha: 1)))
                        .cornerRadius(10)
                    }
                    
                    
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
                            Text("All Done?")
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
                        //routines - red
                        if((self.done || (self.goalOrRoutine!.isComplete.lowercased() == "true") &&
                                self.goalOrRoutine!.isPersistent.lowercased() == "true")){
                            HStack (spacing: 5) {
                                Spacer()
                                infoView(item: (self.goalOrRoutine! as GoalRoutine))
                                    .opacity(0.60)
//                                    .overlay(Image(systemName: "checkmark.circle")
//                                        .font(.system(size:30))
//                                        .padding(EdgeInsets(top: 12, leading: 0, bottom: 0, trailing: 0))
//                                        .foregroundColor(.green))
                                Spacer()
                            }.frame(height: 50)
                            .background(Color(#colorLiteral(red: 0.9725490196, green: 0.4196078431, blue: 0.2862745098, alpha: 1)))
                            .cornerRadius(10)
                        }
                        //goals - yellow
                        else if(self.done || (self.goalOrRoutine!.isComplete.lowercased() == "true")){
                            HStack (spacing: 5) {
                                Spacer()
                                infoView(item: (self.goalOrRoutine! as GoalRoutine))
                                    .opacity(0.60)
//                                    .overlay(Image(systemName: "checkmark.circle")
//                                        .font(.system(size:30))
//                                        .padding(EdgeInsets(top: 12, leading: 0, bottom: 0, trailing: 0))
//                                        .foregroundColor(.green))
                                Spacer()
                            }.frame(height: 50)
                            .background(Color(#colorLiteral(red: 1, green: 0.7411764706, blue: 0.1529411765, alpha: 1)))
                            .cornerRadius(10)
                        }
                        //routines - red
                        else if (self.goalOrRoutine!.isPersistent.lowercased() == "true"){
                            HStack (spacing: 5) {
                                Spacer()
                                infoView(item: (self.goalOrRoutine! as GoalRoutine))
                                Spacer()
                            }.frame(height: 50)
                            .background(Color(#colorLiteral(red: 0.9725490196, green: 0.4196078431, blue: 0.2862745098, alpha: 1)))
                            .cornerRadius(10)
                        }
                        //goals - yellow
                        else{
                            HStack (spacing: 5) {
                                Spacer()
                                infoView(item: (self.goalOrRoutine! as GoalRoutine))
                                Spacer()
                            }.frame(height: 50)
                            .background(Color(#colorLiteral(red: 1, green: 0.7411764706, blue: 0.1529411765, alpha: 1)))
                            .cornerRadius(10)
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
                    .background(Color.clear)
                    
                    
                    //new ui
                    ForEach(Array((self.model.goalsSubTasks[self.goalOrRoutine!.grUniqueID]!?.enumerated())!), id: \.offset){ index, item in
                        HStack {
                            checkTaskView(task: (item as TaskAndActions), taskIndex: index, goal: goalOrRoutine, grIndex: self.goalOrRoutineIndex)
                        }
                    }

                    
                }.frame(height: geo.size.height)
                .padding(0)
                .navigationBarTitle("Goals")
            }
        }.onAppear()
    }
}
