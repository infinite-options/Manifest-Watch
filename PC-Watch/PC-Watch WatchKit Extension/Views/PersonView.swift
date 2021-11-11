//
//  PersonView.swift
//  PC-Watch WatchKit Extension
//
//  Created by Emma Allegrucci on 8/16/20.
//  Copyright © 2020 Infinite Options. All rights reserved.
//

import SwiftUI

struct PersonView: View {
    var person: ImportantPerson
    
    var body: some View {
        VStack(alignment: .center) {
            if self.person.havePic == "False" {
                Image(systemName: "person.circle")
                    .font(.system(size:100))
                    .foregroundColor(.yellow)
            }
            else {
                AsyncImage(
                    url: URL(string: self.person.pic)!,
                    placeholder: Image(systemName: "person.circle"))
            }
            Spacer()
            if self.person.phoneNumber != "" {
                HStack {
                    VStack {
                        Text(self.person.userName)
                            .font(.system(size: 20, design: .rounded))
                        Text(self.person.relationship)
                            .fontWeight(.light)
                            .font(.system(size: 15, design: .rounded))
                    }
                    Spacer()
                    Image(systemName: "phone.circle")
                        .font(.system(size:50))
                        .foregroundColor(.green)
                        .onTapGesture {
                            let number = "tel:" + self.person.phoneNumber
                            if let telURL = URL(string: number) {
                                let wkExtension = WKExtension.shared()
                                wkExtension.openSystemURL(telURL)
                            }
                        }
                }
            } else {
                Text(self.person.name)
                    .font(.system(size: 20, design: .rounded))
                Text(self.person.relationship)
                    .fontWeight(.light)
                    .font(.system(size: 15, design: .rounded))

            }
        }.navigationBarTitle(self.person.name)
    }
}
