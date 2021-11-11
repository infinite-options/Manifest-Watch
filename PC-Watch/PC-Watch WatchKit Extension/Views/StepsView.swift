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
