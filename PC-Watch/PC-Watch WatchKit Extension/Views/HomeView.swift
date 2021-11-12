//
//  HomeView.swift
//  PC-Watch WatchKit Extension
//
//  Created by Kyle Hoefer on 4/6/20.
//  Copyright © 2020 Infinite Options. All rights reserved.
//

import SwiftUI
import UIKit

//struct EventInfoView: View {
//    var item: Event?
//
//    var body: some View{
//        VStack(alignment: .leading) {
//            HStack(alignment: .center) {
//                VStack(alignment: .leading) {
//                    Text(DayDateObj.formatter.string(from: ISO8601DateFormatter().date(from: self.item!.start!.dateTime)!) + " - " + DayDateObj.formatter.string(from: ISO8601DateFormatter().date(from: self.item!.end!.dateTime)!))
//                        .fontWeight(.light)
//                        .fixedSize(horizontal: false, vertical: true)
//                        .font(.system(size: 12, design: .rounded))
//                        .foregroundColor(.black)
//                    Text(self.item!.summary!)
//                        .fontWeight(.bold)
//                        .foregroundColor(.black)
//                        .font(.system(size: 18, design: .rounded))
//                        .lineLimit(2)
//                }
//                Spacer()
//                if self.isNow(item: item!) {
//                    Image(systemName: "calendar")
//                        .font(.system(size:30))
//                        .imageScale(.small)
//                        .foregroundColor(.black)
//                } else {
//                    Image(systemName: "calendar")
//                        .font(.system(size:30))
//                        .imageScale(.small)
//                        .foregroundColor(.black)
//                        .opacity(0.5)
//                        .overlay(Image(systemName: "checkmark.circle")
//                            .font(.system(size:33))
//                            .padding(EdgeInsets(top: 2, leading: 0, bottom: 0, trailing: 0))
//                            .foregroundColor(.green))
//                }
//            }
//        }
//    }
//
//    private func isNow(item: Event) -> Bool {
//        if DayDateObj.ISOFormatter.date(from: item.end!.dateTime)! < Date() {
//            return false
//        }
//        return true
//    }
//}
//
//struct infoView: View {
//    var item: Value?
//    @ObservedObject var viewPick = ViewController.shared
//    @ObservedObject private var model = FirebaseGoogleService.shared
//
//    var body: some View {
//        VStack(alignment: .leading) {
//            HStack {
//                VStack(alignment: .leading) {
//                    Text(self.item!.mapValue!.fields.title.stringValue)
//                        .fontWeight(.bold)
//                        .font(.system(size: 18, design: .rounded))
//                        .foregroundColor(.black)
//                    (item!.mapValue!.fields.isPersistent.booleanValue ? Text("Starts at " + DayDateObj.formatter.string(from: DayDateObj.timeLeft.date(from: self.item!.mapValue!.fields.startDayAndTime.stringValue)!))
//                        .fontWeight(.light)
//                        .font(.system(size: 12, design: .rounded)) :
//                        Text("Takes me " + self.item!.mapValue!.fields.expectedCompletionTime.stringValue)
//                            .fontWeight(.light)
//                            .font(.system(size: 12, design: .rounded)))
//                        .foregroundColor(.black)
//                }
//                Spacer()
//                if ((self.item!.mapValue!.fields.isComplete?.booleanValue) == true){
//                    SmallAssetImage(urlName: self.item!.mapValue!.fields.photo.stringValue, placeholder: Image("default-goal"))
//                        .aspectRatio(contentMode: .fit)
//                        .opacity(0.40)
//                        .overlay(Image(systemName: "checkmark.circle")
//                            .font(.system(size:33))
//                            .padding(EdgeInsets(top: 2, leading: 0, bottom: 0, trailing: 0))
//                            .foregroundColor(.green))
//                } else if (self.item!.mapValue!.fields.isInProgress?.booleanValue == true) {
//                    SmallAssetImage(urlName: self.item!.mapValue!.fields.photo.stringValue, placeholder: Image("default-goal"))
//                        .aspectRatio(contentMode: .fit)
//                        .opacity(0.40)
//                        .overlay(Image(systemName: "arrow.2.circlepath.circle")
//                            .font(.system(size:33))
//                            .padding(EdgeInsets(top: 2, leading: 0, bottom: 0, trailing: 0))
//                            .foregroundColor(.yellow))
//                } else {
//                    SmallAssetImage(urlName: self.item!.mapValue!.fields.photo.stringValue, placeholder: Image("default-goal"))
//                        .aspectRatio(contentMode: .fit)
//                }
//            }
//        }
//    }
//}
//
//struct HomeView: View {
//    @ObservedObject private var model = UserDay.shared
//    var extensionDelegate = ExtensionDelegate()
//
//    @State var fullDay = false
//    @State var showLess = true
//
//    var body: some View {
//
//        GeometryReader { geo in
//            if (self.model.UserDayData.count == 0){
//                VStack(alignment: .center) {
//                    Text("You dont have anything on your schedule!")
//                    .fontWeight(.bold)
//                    .font(.system(size: 20, design: .rounded))
//                    Spacer()
//                }.frame(width: geo.size.width, height: geo.size.height, alignment: .center)
//                 .navigationBarTitle("My Day")
//            } else {
//                VStack {
//                    if (self.fullDay) {
//                        VStack(alignment: .leading) {
//                            List {
//                                ForEach(Array(self.model.UserDayData.enumerated()), id: \.offset) { index, item in
//                                    VStack(alignment: .leading) {
//                                        if self.isEvent(item: item) {
//                                            NavigationLink (destination: EventsView(event: (item as! Event))){
//                                                EventInfoView(item: (item as! Event))
//                                            }.frame(height: 80)
//                                        }
//                                        else {
//                                            NavigationLink(destination: TasksView(goalOrRoutine: (item as! Value), goalOrRoutineIndex: index, fullDayArray: true)) {
//                                                HStack {
//                                                    infoView(item: (item as! Value))
//                                                }.frame(height: 80)
////                                                 .onTapGesture {
////                                                   if self.hasNotStarted(item: item as! Value) {
////                                                      self.extensionDelegate.scheduleMoodNotification()
////                                                   }
////                                                 }
//                                            }
//                                        }
//                                    }.listRowPlatterColor((item is Event) ? Color(Color.RGBColorSpace.sRGB, red: 200/255, green: 215/255, blue: 228/255, opacity: 1) : Color.white)
//                                }
//                                Button(action: {
//                                    self.fullDay = false
//                                    self.showLess = true
//                                }) {
//                                    Text("Show less")
//                                        .foregroundColor(Color(Color.RGBColorSpace.sRGB, red: 200/255, green: 215/255, blue: 228/255, opacity: 1))
//                                        .frame(maxWidth: geo.size.width, alignment: .center)
//                                }
//                            }.listStyle(CarouselListStyle())
//                             .navigationBarTitle("My Day")
//                        }.padding(0)
//                    }
//                    if self.showLess {
//                        VStack(alignment: .leading) {
//                            List {
//                                ForEach(Array(self.model.UserDayBlockData.enumerated()), id: \.offset) { index, item in
//                                    VStack(alignment: .leading) {
//                                        if self.isEvent(item: item) {
//                                            NavigationLink (destination: EventsView(event: (item as! Event))){
//                                                EventInfoView(item: (item as! Event))
//                                            }.frame(height: 80)
//                                        }
//                                        else {
//                                            NavigationLink(destination: TasksView(goalOrRoutine: (item as! Value), goalOrRoutineIndex: index, fullDayArray: false)) {
//                                                HStack {
//                                                    infoView(item: (item as! Value))
//                                                }.frame(height: 80)
////                                                 .onTapGesture {
////                                                    if self.hasNotStarted(item: item as! Value) {
////                                                       self.extensionDelegate.scheduleMoodNotification()
////                                                    }
////                                                 }
//                                            }
//                                        }
//                                    }.listRowPlatterColor((item is Event) ? Color(Color.RGBColorSpace.sRGB, red: 200/255, green: 215/255, blue: 228/255, opacity: 1) : Color.white)
//                                }
//                                Button(action: {
//                                    self.fullDay = true
//                                    self.showLess = false
//                                }) {
//                                    Text("Show full day")
//                                        .foregroundColor(Color(Color.RGBColorSpace.sRGB, red: 200/255, green: 215/255, blue: 228/255, opacity: 1))
//                                }
//                            }.listStyle(CarouselListStyle())
//                             .navigationBarTitle("My Day")
//                        }.padding(0)
//                    }
//                }.navigationBarTitle("My Day")
//            }
//        }
//    }
//
//    private func isEvent(item: UserDayGoalEventList) -> Bool{
//        if item is Event {
//            return true
//        } else {
//            return false
//        }
//    }
//
//    private func hasNotStarted(item: Value) -> Bool{
//        if item.mapValue!.fields.isComplete!.booleanValue {
//            return false
//        } else if item.mapValue!.fields.isInProgress!.booleanValue {
//            return false
//        } else {
//            return true
//        }
//    }
//}

//New Code for RDS

struct EventInfoView: View {
    var item: Event?

    var body: some View{
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                VStack(alignment: .leading) {
                    Text(DayDateObj.formatter.string(from: ISO8601DateFormatter().date(from: self.item!.start!.dateTime)!) + " - " + DayDateObj.formatter.string(from: ISO8601DateFormatter().date(from: self.item!.end!.dateTime)!))
                        .fontWeight(.light)
                        .fixedSize(horizontal: false, vertical: true)
                        .font(.system(size: 12, design: .rounded))
                        .foregroundColor(.black)
                    Text(self.item!.summary!)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .font(.system(size: 18, design: .rounded))
                        .lineLimit(2)
                }
                Spacer()
                if self.isNow(item: item!) {
                    Image(systemName: "calendar")
                        .font(.system(size:30))
                        .imageScale(.small)
                        .foregroundColor(.black)
                } else {
                    Image(systemName: "calendar")
                        .font(.system(size:30))
                        .imageScale(.small)
                        .foregroundColor(.black)
                        .opacity(0.5)
                        .overlay(Image(systemName: "checkmark.circle")
                            .font(.system(size:33))
                            .padding(EdgeInsets(top: 2, leading: 0, bottom: 0, trailing: 0))
                            .foregroundColor(.green))
                }
                
            }
        }
    }

    private func isNow(item: Event) -> Bool {
        if DayDateObj.ISOFormatter.date(from: item.end!.dateTime)! < Date() {
            return false
        }
        return true
    }
}
  
struct infoView: View {
    var item: GoalRoutine?
    @ObservedObject var viewPick = ViewController.shared
    @ObservedObject private var model = NetworkManager.shared
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading) {
                    Text(self.item!.grTitle)
                        .fontWeight(.bold)
                        .font(.system(size: 16, design: .rounded))
                        .foregroundColor(.white)
//                        .padding(EdgeInsets(top: 0, leading: -2, bottom: 0, trailing: -2))
                    (item!.isPersistent.lowercased() == "true" ? Text("Starts at " + DayDateObj.formatter.string(from: DayDateObj.timeLeft.date(from: self.item!.startDayAndTime) ?? Date()))
                        .fontWeight(.light)
//                        .padding(EdgeInsets(top: 0, leading: -2, bottom: 0, trailing: -2))
                        .font(.system(size: 12, design: .rounded)) :
                        Text("Takes me " + self.item!.expectedCompletionTime)
                            .fontWeight(.light)
//                            .padding(EdgeInsets(top: 0, leading: -2, bottom: 0, trailing: -2))
                            .font(.system(size: 12, design: .rounded)))
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
                        placeholder: Image(systemName: "default-goal"))
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
                            placeholder: Image(systemName: "default-goal"))
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
                        placeholder: Image(systemName: "default-goal"))
//                        .padding(EdgeInsets(top: 0, leading: -2, bottom: 0, trailing: -2))
                } //else
            } //hstack
        } //vstack
    } //body
} //info view

struct HomeView: View {
    
    @ObservedObject private var userManager = UserManager.shared
    @ObservedObject private var networkManager = NetworkManager.shared

    var extensionDelegate = ExtensionDelegate()

    @State var fullDay = false
    @State var showLess = true
//    @State var shouldMoveToTasks: [Bool] = Array(repeating: false, count: networkManager.goalsRoutinesData?.count)

    var body: some View {
        GeometryReader { geo in
            if (self.networkManager.goalsRoutinesData?.count == 0){
                VStack(alignment: .center) {
                    Text("You dont have anything on your schedule!")
                        .fontWeight(.bold)
                        .font(.system(size: 20, design: .rounded))
                    Spacer()
                }.frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                    .navigationBarTitle("My Day")
            } else {
                VStack (spacing: 20) {
                    if (self.fullDay) {
                        VStack(alignment: .leading, spacing: 20) {
                            List {
                                ForEach(Array(((self.networkManager.goalsRoutinesData!.enumerated()))), id: \.offset){ index, item in
                                    VStack(alignment: .leading, spacing: 20){
//                                        var chosenLink = networkManager.moveToActions[(item as GoalRoutine).grUniqueID]
                                        NavigationLink(destination: newTaskView(goalOrRoutine: (item as GoalRoutine), goalOrRoutineIndex: index, fullDayArray: true).onAppear{
                                                        print("navigating to task pg with \(self.networkManager.actionSteps.count) actions w steps")
                                                        self.networkManager.getSteps(grUID: (item as GoalRoutine).grUniqueID) }){
//                                            HStack (spacing: 20) {
//                                                infoView(item: (item as GoalRoutine))
//                                            }.frame(height: 50)
                                            
                                            //routines are persistent - red
                                            if ((item as GoalRoutine).isPersistent.lowercased() == "true")
                                            {
//                                                self.setCurrentColor(color: Color.red)
                                                HStack (spacing: 5) {
                                                    Spacer()
                                                    infoView(item: (item as GoalRoutine))
                                                    Spacer()
                                                }.frame(height: 50)
                                                .background(Color(#colorLiteral(red: 0.9725490196, green: 0.4196078431, blue: 0.2862745098, alpha: 1)))
                                                .padding(EdgeInsets(top: -1, leading: -3, bottom: -1, trailing: -3))
                                            }
                                            //goals are not persistent - yellow
                                            else
                                            {
                                                HStack (spacing: 5) {
                                                    Spacer()
                                                    infoView(item: (item as GoalRoutine))
                                                    Spacer()
                                                }.frame(height: 50)
                                                .background(Color(#colorLiteral(red: 1, green: 0.7411764706, blue: 0.1529411765, alpha: 1)))
                                                .padding(EdgeInsets(top: -1, leading: -3, bottom: -1, trailing: -3))
                                            }
                                        
                                        }

                                    }
                                    .cornerRadius(10)
//                                    .onTapGesture{
////                                        self.shouldMoveToTasks = true
//                                        self.networkManager.getSteps(grUID: (item as GoalRoutine).grUniqueID)
//                                        NavigationLink(destination: newTaskView(goalOrRoutine: (item as GoalRoutine), goalOrRoutineIndex: index, fullDayArray: true)){}
//                                    }
                                }
                                .listRowPlatterColor(Color.clear)
//                                .listRowInsets(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
                                Button(action: {
                                    self.fullDay = false
                                    self.showLess = true
                                }) {
                                    Text("Show less")
                                        .foregroundColor(Color(Color.RGBColorSpace.sRGB, red: 200/255, green: 215/255, blue: 228/255, opacity: 1))
                                        .frame(maxWidth: geo.size.width, alignment: .center)
                                }
                            }
                            .listStyle(CarouselListStyle())
                            .navigationBarTitle("My Day")
                            .listRowBackground(Color.clear)
                        }
                        .padding(0)
                    }
                    if self.showLess {
                        VStack(alignment: .leading, spacing: 20) {
                            List {
                                ForEach(Array((((self.networkManager.goalsRoutinesBlockData!.enumerated())))), id: \.offset){ index, item in
                                    VStack(alignment: .leading, spacing: 20){
                                        NavigationLink(destination: newTaskView(goalOrRoutine: (item as GoalRoutine), goalOrRoutineIndex: index, fullDayArray: true).onAppear{
                                                        print("navigating to task pg with \(self.networkManager.actionSteps.count) actions w steps")
                                                        self.networkManager.getSteps(grUID: (item as GoalRoutine).grUniqueID) }){
//                                            HStack (spacing: 20) {
//                                                infoView(item: (item as GoalRoutine))
//                                            }.frame(height: 50)
                                            
                                            //routines are persistent - red
                                            if ((item as GoalRoutine).isPersistent.lowercased() == "true")
                                            {
//                                                self.setCurrentColor(color: Color.red)
                                                HStack (spacing: 5) {
                                                    Spacer()
                                                    infoView(item: (item as GoalRoutine))
                                                    Spacer()
                                                }.frame(height: 50)
                                                .background(Color(#colorLiteral(red: 0.9725490196, green: 0.4196078431, blue: 0.2862745098, alpha: 1)))
                                                .padding(EdgeInsets(top: -1, leading: -3, bottom: -1, trailing: -3))
                                            }
                                            //goals are not persistent - yellow
                                            else
                                            {
                                                HStack (spacing: 5) {
                                                    Spacer()
                                                    infoView(item: (item as GoalRoutine))
                                                    Spacer()
                                                }.frame(height: 50)
                                                .background(Color(#colorLiteral(red: 1, green: 0.7411764706, blue: 0.1529411765, alpha: 1)))
                                                .padding(EdgeInsets(top: -1, leading: -3, bottom: -1, trailing: -3))
                                            }
                                        
                                        }

                                    }
                                    .cornerRadius(10)
                                }
                                .listRowPlatterColor(Color.clear)
                                
                                Button(action: {
                                    self.fullDay = true
                                    self.showLess = false
                                })
                                {
                                    Text("Show full day")
                                        .foregroundColor(Color(Color.RGBColorSpace.sRGB, red: 200/255, green: 215/255, blue: 228/255, opacity: 1))
                                }
                                .frame(width: 200, height: 40, alignment: .center)
                                .clipped()
                            }
                            .listStyle(CarouselListStyle())
                            .navigationBarTitle("My Day")
                        }.padding(0)
                    }
                }
                .navigationBarTitle("My Day")
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

    private func hasNotStarted(item: Value) -> Bool{
        if item.mapValue!.fields.isComplete!.booleanValue {
            return false
        } else if item.mapValue!.fields.isInProgress!.booleanValue {
            return false
        } else {
            return true
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        EventInfoView()
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
