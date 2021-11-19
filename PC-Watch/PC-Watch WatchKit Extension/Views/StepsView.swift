////
////  StepsView.swift
////  PC-Watch WatchKit Extension
////
////  Created by Harshit Trehan on 7/3/20.
////  Copyright © 2020 Infinite Options. All rights reserved.
////
//
//import SwiftUI
//
//struct StepView: View {
//    @ObservedObject private var model = FirebaseGoogleService.shared
//    
//    @ObservedObject private var user = UserDay.shared
//    
//    var fullDayArray: Bool
//    var step: ValueTask?
//    var index: Int?
//    var taskID: String?
//    var taskIndex: Int?
//    var goalOrRoutineID: String?
//    var goalOrRoutineIndex: Int?
//    var previousStepIsComplete: Bool?
//    @State private var showingAlert = false
//    
//    
//    @State var done = false
//    
//    var body: some View {
//        VStack {
//            Divider()
//            VStack {
//                HStack {
//                    if (self.done || (self.step!.mapValue.fields.isComplete!.booleanValue == true)) {
//                        AssetImage(urlName: self.step!.mapValue.fields.photo.stringValue, placeholder: Image("default-step"))
//                            .aspectRatio(contentMode: .fit)
//                            .opacity(0.60)
//                            .overlay(Image(systemName: "checkmark.circle")
//                                .font(.system(size:65))
//                                .padding(EdgeInsets(top: 12, leading: 0, bottom: 0, trailing: 0))
//                                .foregroundColor(.green))
//                    } else {
//                        AssetImage(urlName: self.step!.mapValue.fields.photo.stringValue, placeholder: Image("default-step"))
//                            .aspectRatio(contentMode: .fit)
//                    }
//                    VStack {
//                        Text(self.step!.mapValue.fields.title.stringValue)
//                            .frame(width: 110)
//                            .font(.system(size: 16, design: .rounded))
//                            .lineLimit(2)
//                        Text("Takes: " + self.step!.mapValue.fields.expectedCompletionTime!.stringValue)
//                            .frame(width: 110)
//                            .font(.system(size: 13))
//                    }
//                }
//                Spacer()
//                if(!self.done && (self.step!.mapValue.fields.isComplete!.booleanValue == false)){
//                    Button(action: {
//                        if self.previousStepIsComplete! == true {
//                            //Complete step
//                            self.model.completeInstructionOrStep(userId: self.user.User,
//                                                      routineId: self.goalOrRoutineID!,
//                                                      taskId: self.taskID!,
//                                                      routineNumber: -1,
//                                                      taskNumber: -1,
//                                                      stepNumber: self.index!)
//                            print("step complete")
//                            //update step in model
//                            self.model.taskSteps[self.taskID!]!![self.index!].mapValue.fields.isComplete!.booleanValue = true
//                            //decrement number of steps left for task
//                            self.model.taskStepsLeft[self.taskID!]! -= 1
//    //                        self.model.isMustDoSteps[self.taskID!]! -= 1
//                            if self.model.taskStepsLeft[self.taskID!]! == 0 /*|| self.model.isMustDoSteps[self.taskID!] == 0*/{
//                                print("task complete")
//                                //if task steps left == 0, task is complete so update data model
//                                self.model.goalsSubtasks[self.goalOrRoutineID!]!![self.taskIndex!].mapValue.fields.isComplete!.booleanValue = true
//                                //complete task
//                                self.model.completeActionOrTask(userId: self.user.User,
//                                                          routineId: self.goalOrRoutineID!,
//                                                          taskId: self.taskID!,
//                                                          routineNumber: -1,
//                                                          taskNumber: self.taskIndex!,
//                                                          stepNumber: -1)
//                                // decrement number of tasks left for goal
//                                self.model.goalSubtasksLeft[self.goalOrRoutineID!]! -= 1
//                                
//                                if self.model.goalsSubtasks[self.goalOrRoutineID!]!![self.taskIndex!].mapValue.fields.isMustDo!.booleanValue == true {
//                                    self.model.isMustDoTasks[self.goalOrRoutineID!]! -= 1
//                                }
//                                
//                                if self.model.goalSubtasksLeft[self.goalOrRoutineID!] == 0 || self.model.isMustDoTasks[self.goalOrRoutineID!] == 0{
//                                    print("goal complete")
//                                    //if goal has no tasks left, it is complete so update model
//                                    //self.model.data![self.goalOrRoutineIndex!].mapValue?.fields.isComplete!.booleanValue = true
//                                    
//                                    if self.fullDayArray {
//                                        self.user.UserDayData[self.goalOrRoutineIndex!].mapValue!.fields.isComplete!.booleanValue = true
//                                    }
//                                    else {
//                                        self.user.UserDayBlockData[self.goalOrRoutineIndex!].mapValue!.fields.isComplete!.booleanValue = true
//                                    }
//                                    
//                                    // complete goal
//                                    self.model.completeGoalOrRoutine(userId: self.user.User,
//                                                              routineId: self.goalOrRoutineID!,
//                                                              taskId: self.taskID!,
//                                                              routineNumber: self.goalOrRoutineIndex!,
//                                                              taskNumber: -1,
//                                                              stepNumber: -1)
//                                } else {
//                                    print("goal not complete yet")
//                                    // goal is not complete so is inprogress
//                                    //self.model.data![self.goalOrRoutineIndex!].mapValue?.fields.isInProgress!.booleanValue = true
//                                    
//                                    if self.fullDayArray {
//                                        self.user.UserDayData[self.goalOrRoutineIndex!].mapValue!.fields.isInProgress!.booleanValue = true
//                                    }
//                                    else {
//                                        self.user.UserDayBlockData[self.goalOrRoutineIndex!].mapValue!.fields.isInProgress!.booleanValue = true
//                                    }
//                                    
//                                    //start goal
//                                    self.model.startGoalOrRoutine(userId: self.user.User,
//                                                           routineId: self.goalOrRoutineID!,
//                                                           taskId: "NA",
//                                                           routineNumber: self.goalOrRoutineIndex!,
//                                                           taskNumber: -1,
//                                                           stepNumber: -1)
//                                }
//                            } else {
//                                print("task not complete yet")
//                                // task is not complete so set to in progress in model
//                                self.model.goalsSubtasks[self.goalOrRoutineID!]!![self.taskIndex!].mapValue.fields.isInProgress!.booleanValue = true
//                                // start task
//                                self.model.startActionOrTask(userId: self.user.User,
//                                                       routineId: self.goalOrRoutineID!,
//                                                       taskId: self.taskID!,
//                                                       routineNumber: -1,
//                                                       taskNumber: self.taskIndex!,
//                                                       stepNumber: -1)
//                                // set goal to in progress in model
//                                //self.model.data![self.goalOrRoutineIndex!].mapValue?.fields.isInProgress!.booleanValue = true
//                                
//                                if self.fullDayArray {
//                                    self.user.UserDayData[self.goalOrRoutineIndex!].mapValue!.fields.isInProgress!.booleanValue = true
//                                }
//                                else {
//                                    self.user.UserDayBlockData[self.goalOrRoutineIndex!].mapValue!.fields.isInProgress!.booleanValue = true
//                                }
//                                
//                                // start goal
//                                self.model.startGoalOrRoutine(userId: self.user.User,
//                                                       routineId: self.goalOrRoutineID!,
//                                                       taskId: "NA",
//                                                       routineNumber: self.goalOrRoutineIndex!,
//                                                       taskNumber: -1,
//                                                       stepNumber: -1)
//                            }
//                            print(self.model.taskSteps[self.taskID!]!![self.index!].mapValue.fields.isComplete!.booleanValue)
//                            self.done = true
//                        } else {
//                             self.showingAlert = true
//                        }
//                    }) {
//                        Text("Done?")
//                            .foregroundColor(.green)
//                    }
//                    .alert(isPresented: $showingAlert) {
//                        Alert(title: Text("You need to complete the previous step first."), dismissButton: Alert.Button.default(Text("Ok")))
//                    }
//                } else {
//                    Text("Completed")
//                        .overlay(RoundedRectangle(cornerSize: CGSize(width: 120, height: 30), style: .continuous)
//                            .stroke(Color.green, lineWidth: 1)
//                            .frame(width:120, height:25))
//                        .foregroundColor(.green)
//                        .foregroundColor(.green)
//                }
//            }
//        }
//    }
//}
//
//struct StepsView: View {
//    @ObservedObject private var model = FirebaseGoogleService.shared
//    //    @Binding var showTasks: Bool
//    @ObservedObject private var user = UserDay.shared
//    @Binding var showSteps: Bool
//    var goalID: String?
//    var goalOrRoutineIndex: Int?
//    var task: ValueTask?
//    var taskIndex: Int?
//    var fullDayArray: Bool
//    @State var done = false
//    
//    var body: some View {
//        GeometryReader { geo in
//            
//            VStack(alignment: .center) {
//                if (self.model.taskSteps[self.task!.mapValue.fields.id.stringValue] == nil) {
//                    if (self.done || (self.task!.mapValue.fields.isComplete!.booleanValue == true)){
//                        AssetImage(urlName: self.task!.mapValue.fields.photo.stringValue, placeholder: Image("default-task"))
//                            .aspectRatio(contentMode: .fit)
//                            .opacity(0.60)
//                            .overlay(Image(systemName: "checkmark.circle")
//                                .font(.system(size:65))
//                                .padding(EdgeInsets(top: 12, leading: 0, bottom: 0, trailing: 0))
//                                .foregroundColor(.green))
//                    } else {
//                        AssetImage(urlName: self.task!.mapValue.fields.photo.stringValue, placeholder: Image("default-task"))
//                            .aspectRatio(contentMode: .fit)
//                    }
//                    VStack {
//                        Text(self.task!.mapValue.fields.title.stringValue)
//                            .lineLimit(nil)
//                            .font(.system(size: 20, design: .rounded))
//                        Text("Takes " + self.task!.mapValue.fields.expectedCompletionTime!.stringValue)
//                            .fontWeight(.light)
//                            .font(.system(size: 15))
//                    }
//                    Spacer()
//                    if(!self.done && (self.task!.mapValue.fields.isComplete!.booleanValue == false)){
//                        Button(action: {
//                            // complete task
//                            self.model.completeActionOrTask(userId: self.user.User,
//                                                      routineId: self.goalID!,
//                                                      taskId: self.task!.mapValue.fields.id.stringValue,
//                                                      routineNumber: -1,
//                                                      taskNumber: self.taskIndex!,
//                                                      stepNumber: -1)
//                            print("task complete")
//                            // update task in model
//                            self.model.goalsSubtasks[self.goalID!]!![self.taskIndex!].mapValue.fields.isComplete?.booleanValue = true
//                            // decrement tasks left for goal
//                            self.model.goalSubtasksLeft[self.goalID!]! -= 1
//                            
//                            if self.model.goalsSubtasks[self.goalID!]!![self.taskIndex!].mapValue.fields.isMustDo!.booleanValue == true {
//                                self.model.isMustDoTasks[self.goalID!]! -= 1
//                            }
//                            
//                            if self.model.goalSubtasksLeft[self.goalID!] == 0 || self.model.isMustDoTasks[self.goalID!] == 0{
//                                print("goal complete")
//                                // if no tasks left, update model
//                                //self.model.data![self.goalOrRoutineIndex!].mapValue?.fields.isComplete!.booleanValue = true
//                                
//                                if self.fullDayArray {
//                                    self.user.UserDayData[self.goalOrRoutineIndex!].mapValue!.fields.isComplete!.booleanValue = true
//                                }
//                                else {
//                                    self.user.UserDayBlockData[self.goalOrRoutineIndex!].mapValue!.fields.isComplete!.booleanValue = true
//                                }
//                                
//                                // set goal to complete
//                                self.model.completeGoalOrRoutine(userId: self.user.User,
//                                                          routineId: self.goalID!,
//                                                          taskId: "NA",
//                                                          routineNumber: self.goalOrRoutineIndex!,
//                                                          taskNumber: -1,
//                                                          stepNumber: -1)
//                            } else {
//                                print("goal not complete yet")
//                                // goal is not complete so set to in progress, update model
//                                //self.model.data![self.goalOrRoutineIndex!].mapValue?.fields.isInProgress!.booleanValue = true
//                                
//                                if self.fullDayArray {
//                                    self.user.UserDayData[self.goalOrRoutineIndex!].mapValue!.fields.isInProgress!.booleanValue = true
//                                }
//                                else {
//                                    self.user.UserDayBlockData[self.goalOrRoutineIndex!].mapValue!.fields.isInProgress!.booleanValue = true
//                                }
//                                
//                                // start goal
//                                self.model.startGoalOrRoutine(userId: self.user.User,
//                                                       routineId: self.goalID!,
//                                                       taskId: "NA",
//                                                       routineNumber: self.goalOrRoutineIndex!,
//                                                       taskNumber: -1,
//                                                       stepNumber: -1)
//                            }
//                            self.done = true
//                            self.showSteps = false
//                        }) {
//                            Text("Done?").foregroundColor(.green)
//                        }
//                    } else {
//                        Text("Task Completed")
//                            .overlay(RoundedRectangle(cornerSize: CGSize(width: 120, height: 30), style: .continuous)
//                                .stroke(Color.green, lineWidth: 1)
//                                .frame(width:140, height:25))
//                            .foregroundColor(.green)
//                    }
//                }
//                else {
//                    ScrollView([.vertical]) {
//                        VStack(alignment: .center) {
//                            if (self.task!.mapValue.fields.isComplete!.booleanValue == true){
//                                AssetImage(urlName: self.task!.mapValue.fields.photo.stringValue, placeholder: Image("default-task"))
//                                    .aspectRatio(contentMode: .fit)
//                                    .opacity(0.60)
//                                    .overlay(Image(systemName: "checkmark.circle")
//                                        .font(.system(size:65))
//                                        .padding(EdgeInsets(top: 12, leading: 0, bottom: 0, trailing: 0))
//                                        .foregroundColor(.green))
//                            } else {
//                                AssetImage(urlName:self.task!.mapValue.fields.photo.stringValue, placeholder: Image("default-task"))
//                                    .aspectRatio(contentMode: .fit)
//                            }
//                            Text(self.task!.mapValue.fields.title.stringValue)
//                                .font(.system(size: 20, design: .rounded))
//                                .lineLimit(2)
//                                .fixedSize(horizontal: false, vertical: true)
//                                .padding(EdgeInsets(top: 8, leading: 2, bottom: 0, trailing: 2))
//                            Text("Takes " + self.task!.mapValue.fields.expectedCompletionTime!.stringValue)
//                                .fontWeight(.light)
//                                .font(.system(size: 15))
//                            Spacer()
//                            if(!self.done && (self.task!.mapValue.fields.isComplete!.booleanValue == false)){
//                                Button(action: {
//                                    // complete task
//                                    self.model.completeActionOrTask(userId: self.user.User,
//                                                              routineId: self.goalID!,
//                                                              taskId: self.task!.mapValue.fields.id.stringValue,
//                                                              routineNumber: -1,
//                                                              taskNumber: self.taskIndex!,
//                                                              stepNumber: -1)
//                                    print("task complete")
//                                    // update task in model
//                                    self.model.goalsSubtasks[self.goalID!]!![self.taskIndex!].mapValue.fields.isComplete?.booleanValue = true
//                                    // decrement tasks left for goal
//                                    self.model.goalSubtasksLeft[self.goalID!]! -= 1
//                                    
//                                    if self.model.goalsSubtasks[self.goalID!]!![self.taskIndex!].mapValue.fields.isMustDo!.booleanValue == true {
//                                        self.model.isMustDoTasks[self.goalID!]! -= 1
//                                    }
//                                    
//                                    if self.model.goalSubtasksLeft[self.goalID!] == 0 || self.model.isMustDoTasks[self.goalID!] == 0 {
//                                        print("goal complete")
//                                        // if no tasks left, update model
//                                        //self.model.data![self.goalOrRoutineIndex!].mapValue?.fields.isComplete!.booleanValue = true
//                                        
//                                        if self.fullDayArray {
//                                            self.user.UserDayData[self.goalOrRoutineIndex!].mapValue!.fields.isComplete!.booleanValue = true
//                                        }
//                                        else {
//                                            self.user.UserDayBlockData[self.goalOrRoutineIndex!].mapValue!.fields.isComplete!.booleanValue = true
//                                        }
//                                        
//                                        // set goal to complete
//                                        self.model.completeGoalOrRoutine(userId: self.user.User,
//                                                                  routineId: self.goalID!,
//                                                                  taskId: "NA",
//                                                                  routineNumber: self.goalOrRoutineIndex!,
//                                                                  taskNumber: -1,
//                                                                  stepNumber: -1)
//                                    } else {
//                                        print("goal not complete yet")
//                                        // goal is not complete so set to in progress, update model
//                                        //self.model.data![self.goalOrRoutineIndex!].mapValue?.fields.isInProgress!.booleanValue = true
//                                        
//                                        if self.fullDayArray {
//                                            self.user.UserDayData[self.goalOrRoutineIndex!].mapValue!.fields.isInProgress!.booleanValue = true
//                                        }
//                                        else {
//                                            self.user.UserDayBlockData[self.goalOrRoutineIndex!].mapValue!.fields.isInProgress!.booleanValue = true
//                                        }
//                                        
//                                        // start goal
//                                        self.model.startGoalOrRoutine(userId: self.user.User,
//                                                               routineId: self.goalID!,
//                                                               taskId: "NA",
//                                                               routineNumber: self.goalOrRoutineIndex!,
//                                                               taskNumber: -1,
//                                                               stepNumber: -1)
//                                    }
//                                    self.done = true
//                                    self.showSteps = false
//                                }) {
//                                    Text("Done?").foregroundColor(.green)
//                                }
//                            } else {
//                                Text("Task Completed")
//                                    .overlay(RoundedRectangle(cornerSize: CGSize(width: 120, height: 30), style: .continuous)
//                                        .stroke(Color.green, lineWidth: 1)
//                                        .frame(width:140, height:25))
//                                    .foregroundColor(.green)
//                            }
//                        }.padding(.bottom, 0)
//                        ForEach(Array(self.model.taskSteps[self.task!.mapValue.fields.id.stringValue]!!.enumerated()), id: \.offset) { index, item in
//                            VStack(alignment: .leading) {
//                                if item.mapValue.fields.isAvailable?.booleanValue ?? true {
//                                    StepView(fullDayArray: self.fullDayArray, step: item, index: index, taskID: self.task!.mapValue.fields.id.stringValue, taskIndex: self.taskIndex!, goalOrRoutineID: self.goalID!, goalOrRoutineIndex: self.goalOrRoutineIndex!, previousStepIsComplete: ((index == 0) ? true : self.model.taskSteps[self.task!.mapValue.fields.id.stringValue]!![index - 1].mapValue.fields.isComplete!.booleanValue))
//                                }
//                            }
//                        }
//                    }.frame(height: geo.size.height)
//                        .padding(0)
//                }
//            }.navigationBarTitle("Steps")
//        }
//    }
//}

import SwiftUI
import UserNotifications


struct stepInfoView: View {
    var item: TaskAndActions?
    @ObservedObject var viewPick = ViewController.shared
    @ObservedObject private var model = NetworkManager.shared
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading) {
                    Text(self.item!.atTitle)
                        .fontWeight(.bold)
                        .font(.system(size: 16, design: .rounded))
                        .foregroundColor(.white)
//                        .padding(EdgeInsets(top: 0, leading: -2, bottom: 0, trailing: -2))
//                    (item!.isPersistent.lowercased() == "true" ? Text("Starts at " + DayDateObj.formatter.string(from: DayDateObj.timeLeft.date(from: self.item!.startDayAndTime) ?? Date()))
//                        .fontWeight(.light)
////                        .padding(EdgeInsets(top: 0, leading: -2, bottom: 0, trailing: -2))
//                        .font(.system(size: 12, design: .rounded)) :
                        Text("Takes me " + self.item!.expectedCompletionTime)
                            .fontWeight(.light)
//                            .padding(EdgeInsets(top: 0, leading: -2, bottom: 0, trailing: -2))
                            .font(.system(size: 12, design: .rounded))
                        .foregroundColor(.white)
                }
                Spacer()
                if (self.item!.isComplete.lowercased() == "true"){
//                    Image("default-goal")
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .frame(width: 37, height: 37, alignment: .center)
//                        .opacity(0.4)
//                        .overlay(Image(systemName: "checkmark.circle")
//                                .font(.system(size:20))
//                                .padding(EdgeInsets(top: 2, leading: 0, bottom: 0, trailing: 0))
//                                .foregroundColor(.green))
                    AsyncImage(
                        url: URL(string: self.item!.photo)!,
                        placeholder: Image(systemName: "default-task"))
//                        .padding(EdgeInsets(top: 0, leading: -2, bottom: 0, trailing: -2))
                        .opacity(0.4)
                        .overlay(Image(systemName: "checkmark.circle")
                                .font(.system(size:20))
                                .padding(EdgeInsets(top: 2, leading: 0, bottom: 0, trailing: 0))
                                .foregroundColor(.green))
                    
//                    SmallAssetImage(urlName: self.item!.photo, placeholder: Image("default-goal"))
////                        .frame(width: 30, height: 30, alignment: .center)
////                        .clipped()
//                        .aspectRatio(contentMode: .fit)
//                        .padding()
//                        .opacity(0.40)
//                        .overlay(Image(systemName: "checkmark.circle")
//                            .font(.system(size:33))
//                            .padding(EdgeInsets(top: 2, leading: 0, bottom: 0, trailing: 0))
//                            .foregroundColor(.green))
                } else if (self.item!.isInProgress.lowercased() == "true") {
                        AsyncImage(
                            url: URL(string: self.item!.photo)!,
                            placeholder: Image(systemName: "default-task"))
//                            .padding(EdgeInsets(top: 0, leading: -2, bottom: 0, trailing: -2))
                            .opacity(0.40)
                            .overlay(Image(systemName: "arrow.2.circlepath.circle")
                                .font(.system(size:20))
                                .padding(EdgeInsets(top: 2, leading: 0, bottom: 0, trailing: 0))
                                .foregroundColor(.yellow))
                    
//                    SmallAssetImage(urlName: self.item!.photo, placeholder: Image("default-goal"))
//                      SmallAssetImage(urlName: "https://www.pngitem.com/pimgs/m/519-5194627_goal-clipart-hd-png-download.png", placeholder: Image("default-goal"))
//                        .aspectRatio(contentMode: .fit)
//                        .padding()
//                        .opacity(0.40)
//                        .overlay(Image(systemName: "arrow.2.circlepath.circle")
//                            .font(.system(size:33))
//                            .padding(EdgeInsets(top: 2, leading: 0, bottom: 0, trailing: 0))
//                            .foregroundColor(.yellow))
                } else {
//                    SmallAssetImage(urlName: self.item!.photo, placeholder: Image("default-goal"))
//                        .aspectRatio(contentMode: .fit)
//                        .padding()
                    AsyncImage(
                        url: URL(string: self.item!.photo)!,
                        placeholder: Image(systemName: "default-task"))
//                        .padding(EdgeInsets(top: 0, leading: -2, bottom: 0, trailing: -2))
                } //else
            } //hstack
        } //vstack
    } //body
} //info view

struct checkStepView: View {
    var task: TaskAndActions?
    var taskIndex: Int?
    var goal: GoalRoutine?
    var step: Steps?
    var stepIndex: Int?
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
                if (self.model.actionSteps[self.task!.atUniqueID]??[stepIndex!].isComplete.lowercased() == "true")
                {
                    self.model.actionSteps[self.task!.atUniqueID]??[stepIndex!].isComplete = "False"
                    self.model.taskStepsLeft[self.task!.atUniqueID]? += 1
                    
                    self.model.resetStep(step: self.step!)
                }
                else
                {
                    self.model.actionSteps[self.task!.atUniqueID]??[stepIndex!].isComplete = "True"
                    self.model.taskStepsLeft[self.task!.atUniqueID]? -= 1
                    
                    self.model.completeStep(step: self.step!)
                }
                
                self.model.actionSteps[self.task!.atUniqueID]??[stepIndex!].isInProgress = "False"
                
                if (self.model.taskStepsLeft[self.task!.atUniqueID]! < (self.model.actionSteps[self.task!.atUniqueID]?!.count)! &&
                        self.model.taskStepsLeft[self.task!.atUniqueID]! > 0)
                {
//                        self.goal?.isInProgress = "True"
                    self.model.goalsSubTasks[self.goal!.grUniqueID]!![self.taskIndex!].isInProgress = "True"
                    self.model.goalsSubTasks[self.goal!.grUniqueID]!![self.taskIndex!].isComplete = "False"
                    
                    self.model.startActionOrTask(actionTaskId: task!.atUniqueID)
                }
                else if (self.model.taskStepsLeft[self.task!.atUniqueID]! == 0)
                {
                    
                    self.model.goalsSubTasks[self.goal!.grUniqueID]!![self.taskIndex!].isInProgress = "False"
                    self.model.goalsSubTasks[self.goal!.grUniqueID]!![self.taskIndex!].isComplete = "True"
                    
                    self.model.completeActionOrTask(actionTaskId: task!.atUniqueID)
                }
                else
                {
                    self.model.goalsSubTasks[self.goal!.grUniqueID]!![self.taskIndex!].isInProgress = "False"
                    self.model.goalsSubTasks[self.goal!.grUniqueID]!![self.taskIndex!].isComplete = "False"
                    
                    self.model.resetActionOrTask(actionTaskId: task!.atUniqueID)
                }
//                isMustDoTasks
            }
            label: {
                if (checked) {
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
            
            HStack {
                
                
                HStack (spacing: 5) {
                    Spacer()
//                    infoView(item: (self.item! as GoalRoutine))
                    VStack(alignment: .leading) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(self.step!.isTitle)
                                    .fontWeight(.bold)
                                    .font(.system(size: 16, design: .rounded))
                                    .foregroundColor(.white)
//                                (item!.isPersistent.lowercased() == "true" ? Text("Starts at " + DayDateObj.formatter.string(from: DayDateObj.timeLeft.date(from: self.item!.availableStartTime) ?? Date()))
//                                    .fontWeight(.light)
//                                    .font(.system(size: 12, design: .rounded)) :
                                    Text("Takes me " + self.step!.isExpectedCompletionTime)
                                        .fontWeight(.light)
                                        .font(.system(size: 12, design: .rounded))
                                    .foregroundColor(.white)
                            }
                            Spacer()
                            if (self.step!.isComplete.lowercased() == "true"){
                                AsyncImage(
                                    url: URL(string: self.step!.isPhoto)!,
                                    placeholder: Image(systemName: "default-goal"))
                                    .opacity(0.4)
                                    .overlay(Image(systemName: "checkmark.circle")
                                            .font(.system(size:20))
                                            .padding(EdgeInsets(top: 2, leading: 0, bottom: 0, trailing: 0))
                                            .foregroundColor(.green))
                                
                            } else if (self.step!.isInProgress.lowercased() == "true") {
                                    AsyncImage(
                                        url: URL(string: self.step!.isPhoto)!,
                                        placeholder: Image(systemName: "default-goal"))
                                        .opacity(0.40)
                                        .overlay(Image(systemName: "arrow.2.circlepath.circle")
                                            .font(.system(size:20))
                                            .padding(EdgeInsets(top: 2, leading: 0, bottom: 0, trailing: 0))
                                            .foregroundColor(.yellow))
                                
                            } else {
                                AsyncImage(
                                    url: URL(string: self.step!.isPhoto)!,
                                    placeholder: Image(systemName: "default-goal"))
                            } //else
                        } //hstack
                    } //vstack
                    
                    Spacer()
                }.frame(height: 50)
                .background(Color(#colorLiteral(red: 0.3647058824, green: 0.6078431373, blue: 0.8980392157, alpha: 1)))
                .cornerRadius(10)
            } //hstack
            .onTapGesture {
                checked = !checked
                
                //change the specific action
                if (self.model.actionSteps[self.task!.atUniqueID]??[stepIndex!].isComplete.lowercased() == "true")
                {
                    self.model.actionSteps[self.task!.atUniqueID]??[stepIndex!].isComplete = "False"
                    self.model.taskStepsLeft[self.task!.atUniqueID]? += 1
                    
                    self.model.resetStep(step: self.step!)
                }
                else
                {
                    self.model.actionSteps[self.task!.atUniqueID]??[stepIndex!].isComplete = "True"
                    self.model.taskStepsLeft[self.task!.atUniqueID]? -= 1
                    
                    self.model.completeStep(step: self.step!)
                }
                
                print("steps left: \(self.model.taskStepsLeft[self.task!.atUniqueID]!)")
                
                self.model.actionSteps[self.task!.atUniqueID]??[stepIndex!].isInProgress = "False"
                
                if (self.model.taskStepsLeft[self.task!.atUniqueID]! < (self.model.actionSteps[self.task!.atUniqueID]?!.count)! &&
                        self.model.taskStepsLeft[self.task!.atUniqueID]! > 0)
                {
//                        self.goal?.isInProgress = "True"
                    self.model.goalsSubTasks[self.goal!.grUniqueID]!![self.taskIndex!].isInProgress = "True"
                    self.model.goalsSubTasks[self.goal!.grUniqueID]!![self.taskIndex!].isComplete = "False"
                    
                    self.model.startActionOrTask(actionTaskId: task!.atUniqueID)
                }
                else if (self.model.taskStepsLeft[self.task!.atUniqueID]! == 0)
                {
                    print("no steps left")
                    self.model.goalsSubTasks[self.goal!.grUniqueID]!![self.taskIndex!].isInProgress = "False"
                    self.model.goalsSubTasks[self.goal!.grUniqueID]!![self.taskIndex!].isComplete = "True"
                    
                    self.model.completeActionOrTask(actionTaskId: task!.atUniqueID)
                }
                else
                {
                    self.model.goalsSubTasks[self.goal!.grUniqueID]!![self.taskIndex!].isInProgress = "False"
                    self.model.goalsSubTasks[self.goal!.grUniqueID]!![self.taskIndex!].isComplete = "False"
                    
                    self.model.resetActionOrTask(actionTaskId: task!.atUniqueID)
                }
            }
            
        } //vstack
    } //body
} //checktaskview


struct newStepView: View{
    @ObservedObject private var model = NetworkManager.shared
    @ObservedObject private var user = UserManager.shared
    var goalOrRoutine: GoalRoutine?
    var goalOrRoutineIndex: Int?
    var chosenTask: TaskAndActions?
    var taskIndex: Int?
    var fullDayArray: Bool
    var notificationCenter = NotificationCenter()
    var extensionDelegate = ExtensionDelegate()
    @State var done = false
    @State var started = false
    
    var body: some View {
        GeometryReader{ geo in
            if(self.model.actionSteps[self.chosenTask!.atUniqueID] == nil){
                VStack(alignment: .center){
                    
                    //routines - red
                    if((self.chosenTask!.isComplete.lowercased() == "true")){
                        HStack (spacing: 5) {
                            Spacer()
                            stepInfoView(item: (self.chosenTask! as TaskAndActions?))
                                .opacity(0.60)
                                .overlay(Image(systemName: "checkmark.circle")
                                    .font(.system(size:30))
                                    .padding(EdgeInsets(top: 12, leading: 0, bottom: 0, trailing: 0))
                                    .foregroundColor(.green))
                            Spacer()
                        }.frame(height: 50)
                        .background(Color(#colorLiteral(red: 1, green: 0.7411764706, blue: 0.1529411765, alpha: 1)))
                        .cornerRadius(10)
                    }
                    //goals - yellow
                    else{
                        HStack (spacing: 5) {
                            Spacer()
                            stepInfoView(item: (self.chosenTask! as TaskAndActions?))
                            Spacer()
                        }.frame(height: 50)
                        .background(Color(#colorLiteral(red: 1, green: 0.7411764706, blue: 0.1529411765, alpha: 1)))
                        .cornerRadius(10)
                    }
                    
                    
                    Spacer()
                    if(!self.done && (self.chosenTask!.isComplete.lowercased() == "false")){
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
                        if((self.done || (self.chosenTask!.isComplete.lowercased() == "true"))){
                            HStack (spacing: 5) {
                                Spacer()
                                stepInfoView(item: (self.chosenTask! as TaskAndActions?))
                                    .opacity(0.60)
                                    .overlay(Image(systemName: "checkmark.circle")
                                        .font(.system(size:30))
                                        .padding(EdgeInsets(top: 12, leading: 0, bottom: 0, trailing: 0))
                                        .foregroundColor(.green))
                                Spacer()
                            }.frame(height: 50)
                            .background(Color(#colorLiteral(red: 0.9725490196, green: 0.4196078431, blue: 0.2862745098, alpha: 1)))
                            .cornerRadius(10)
                        }
                        //goals - yellow
                        else if(self.done || (self.chosenTask!.isComplete.lowercased() == "true")){
                            HStack (spacing: 5) {
                                Spacer()
                                stepInfoView(item: (self.chosenTask! as TaskAndActions?))
                                    .opacity(0.60)
                                    .overlay(Image(systemName: "checkmark.circle")
                                        .font(.system(size:30))
                                        .padding(EdgeInsets(top: 12, leading: 0, bottom: 0, trailing: 0))
                                        .foregroundColor(.green))
                                Spacer()
                            }.frame(height: 50)
                            .background(Color(#colorLiteral(red: 1, green: 0.7411764706, blue: 0.1529411765, alpha: 1)))
                            .cornerRadius(10)
                        }
                        //goals - yellow
                        else{
                            HStack (spacing: 5) {
                                Spacer()
                                stepInfoView(item: (self.chosenTask! as TaskAndActions?))
                                Spacer()
                            }.frame(height: 50)
                            .background(Color(#colorLiteral(red: 1, green: 0.7411764706, blue: 0.1529411765, alpha: 1)))
                            .cornerRadius(10)
                        }
                        
                        
                        Spacer()
                        if(!self.done && self.chosenTask!.isComplete.lowercased() == "true"){
                            RoundedRectangle(cornerSize: CGSize(width: 120, height: 30), style: .continuous)
                                .stroke(Color.green, lineWidth: 1)
                                .frame(width:140, height:25)
                                .overlay(Text("Task Completed")
                                    .fontWeight(.bold)
                                    .foregroundColor(.green)
                                    .font(.system(size: 16, design: .rounded)))
                                .padding(2)
                        } else {
                            if(!self.started && self.chosenTask!.isInProgress.lowercased() == "false"){                       //if it is not started show a start button
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
                    ForEach(Array((self.model.actionSteps[self.chosenTask!.atUniqueID]!?.enumerated())!), id: \.offset){ index, item in
                        HStack {
                            checkStepView(task: (self.chosenTask! as TaskAndActions?), taskIndex: self.taskIndex, goal: goalOrRoutine, step: item, stepIndex: index)
                        }
                    }

                    
                }.frame(height: geo.size.height)
                .padding(0)
                .navigationBarTitle(self.chosenTask!.atTitle)
            }
        }.onAppear()
    }
}
