//
//  ImportantPeopleView.swift
//  PC-Watch WatchKit Extension
//
//  Created by Emma Allegrucci on 8/12/20.
//  Copyright © 2020 Infinite Options. All rights reserved.
//

import SwiftUI

struct PeopleView: View {
    var person: ImportantPerson

    var body: some View {
        NavigationLink(destination: PersonView(person: person)) {
            if self.person.havePic == "False" {
                Image(systemName: "person.circle")
                    .font(.system(size:40))
                    .foregroundColor(.yellow)
            }
            else {
                AsyncSmallImage(
                    url: URL(string: self.person.pic) ?? nil,
                    placeholder: Image(systemName: "person.circle"))
            }
        }.buttonStyle(PlainButtonStyle())
    }
}

struct ImportantPeopleView: View {
    @ObservedObject private var model = NetworkManager.shared
    @ObservedObject private var user = UserManager.shared

    var body: some View {
        VStack(alignment: .center) {
            if(self.user.isUserSignedIn != .signedIn || self.user.isUserSignedIn == .signedOut) {
                LaunchScreenView()
            } else if (self.model.importantPeople == nil){
                VStack {
                    Text("You do not have any important people yet.")
                        .fontWeight(.bold)
                        .font(.system(size: 20, design: .rounded))
                    Spacer()
                }.navigationBarTitle("Important People")
            } else {
                ScrollView([.vertical]) {
                    ForEach(NetworkManager.shared.peopleRow!) { row in
                        HStack(alignment: .center) {
                            ForEach(row.cells) { cell in
                                PeopleView(person: cell.person)
                            }
                        }
                    }
                }.navigationBarTitle("Important People")
            }
        }
    }
}

struct ImportantPeopleView_Previews: PreviewProvider {
    static var previews: some View {
        ImportantPeopleView()
    }
}
