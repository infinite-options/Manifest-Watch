//
//  CheckingInView.swift
//  PC-Watch WatchKit Extension
//
//  Created by Emma Allegrucci on 9/9/20.
//  Copyright © 2020 Infinite Options. All rights reserved.
//

import SwiftUI

struct CheckingInView: View {
    var notificationController: NotificationController2
    var bodyText: String
    
    var body: some View {
        VStack(alignment: .center) {
            Text(bodyText).multilineTextAlignment(.center)
            HStack {
                Button(action: {
                    print("yes")
                    self.notificationController.performNotificationDefaultAction()
                }, label: {
                    Text("Yes")
                })
                Button(action: {
                    print("no")
                    self.notificationController.performNotificationDefaultAction()
                }, label: {
                    Text("No")
                })
            }
        }
    }
}
