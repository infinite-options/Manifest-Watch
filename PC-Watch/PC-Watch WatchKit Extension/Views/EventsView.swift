//
//  EventsView.swift
//  PC-Watch WatchKit Extension
//
//  Created by Harshit Trehan on 7/24/20.
//  Copyright © 2020 Infinite Options. All rights reserved.
//

import SwiftUI
import SwiftSoup

struct EventsView: View {
    var event: Event?
    @ObservedObject private var model = NetworkManager.shared
    
    var body: some View {
        GeometryReader { geo in
            ScrollView([.vertical]) {
                VStack(alignment: .center) {
                    HStack {
                        Text(self.event!.summary!)
                            .fontWeight(.bold)
                            .foregroundColor(Color(Color.RGBColorSpace.sRGB, red: 200/255, green: 215/255, blue: 228/255, opacity: 1))
                            .font(.system(size: 20, design: .rounded))
                            .fixedSize(horizontal: false, vertical: true)
                        Spacer()
                        Image(systemName: "calendar")
                            .font(.system(size:30))
                            .imageScale(.small)
                            .foregroundColor(Color(Color.RGBColorSpace.sRGB, red: 200/255, green: 215/255, blue: 228/255, opacity: 1))
                    }
                    VStack(alignment: .leading) {
                        Text(DayDateObj.formatter.string(from: ISO8601DateFormatter().date(from: self.event!.start!.dateTime)!) + " - " + DayDateObj.formatter.string(from: ISO8601DateFormatter().date(from: self.event!.end!.dateTime)!))
                                .fontWeight(.light)
                                .font(.system(size: 15, design: .rounded))
                        Divider()
                        if self.isImportantPerson(email: self.event!.creator!.email) {
                            Text("Created by " + self.model.peopleEmailToNameDict[self.event!.creator!.email]!)
                                .fontWeight(.light)
                                .font(.system(size: 15, design: .rounded))
                        } else {
                            Text("Created by " + self.event!.creator!.email)
                                .fontWeight(.light)
                                .font(.system(size: 15, design: .rounded))
                        }
                        
                        Divider()
                        if self.event!.description != nil {
                            Text("Description: " + self.event!.description!)
                                .fontWeight(.light)
                                .font(.system(size: 15, design: .rounded))
                        }
                        else{
                            Text("No description available.")
                                .fontWeight(.light)
                                .font(.system(size: 15, design: .rounded))
                        }
                    }
                    Divider()
                    NavigationLink(destination: AtendeesView(event: self.event)) {
                        Text("Attendees")
                            .foregroundColor(Color(Color.RGBColorSpace.sRGB, red: 200/255, green: 215/255, blue: 228/255, opacity: 1))
                    }
                }.frame(maxWidth: geo.size.width, alignment: .leading)
            }
        }.navigationBarTitle("Event")
    }
    
    func isImportantPerson(email: String) -> Bool {
        if let _ = self.model.peopleEmailToNameDict[email] {
            print("is important true")
            return true
        } else {
            print("is important false")
            return false
        }
    }
}

struct EventsView_Previews: PreviewProvider {
    static var previews: some View {
        EventsView()
    }
}
