//
//  AttendeesView.swift
//  PC-Watch WatchKit Extension
//
//  Created by Emma Allegrucci on 7/24/20.
//  Copyright © 2020 Infinite Options. All rights reserved.
//

import SwiftUI


struct AttendeeView: View {
    var item: Attendent?
    @ObservedObject private var model = NetworkManager.shared
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    if isImportantPerson(email: item!.email!) {
                        Text(self.model.peopleEmailToNameDict[item!.email!]!)
                            .font(.system(size: 18, design: .rounded))
                    } else {
                        Text(item!.email!)
                            .font(.system(size: 18, design: .rounded))
                    }
                    Text(item!.responseStatus!)
                        .font(.system(size: 12, design: .rounded))
                }
                Spacer()
                Image(systemName: "person.circle")
                    .font(.system(size:44))
                    .foregroundColor(Color(Color.RGBColorSpace.sRGB, red: 200/255, green: 215/255, blue: 228/255, opacity: 1))
            }
            Divider()
        }
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

struct AtendeesView: View {
    var event: Event?
    
    var body: some View {
        ScrollView([.vertical]) {
            if event!.attendees == nil {
                VStack(alignment: .center) {
                    Text("No other atendees.")
                }
            } else {
                ForEach(self.event!.attendees!, id: \.email) { item in
                    AttendeeView(item: item)
                }
            }
        }.navigationBarTitle("Attendees")
    }
}
