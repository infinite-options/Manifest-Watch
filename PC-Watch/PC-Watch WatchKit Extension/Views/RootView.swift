//
//  RootView.swift
//  PC-Watch WatchKit Extension
//
//  Created by Harshit Trehan on 8/9/20.
//  Copyright © 2020 Infinite Options. All rights reserved.
//

import SwiftUI


struct RootView: View {
    
    @ObservedObject var viewPick = ViewController.shared
    @ObservedObject var User = UserManager.shared
    
    var body: some View {
        ZStack {
            if self.User.isUserSignedIn == .signedIn {
                HomeView()
            }
            else if self.viewPick.showView == .showLaunch {
                LaunchScreenView()
            }
            else if self.viewPick.showView == .showSignin {
                SignInView()
            }
        }.onAppear {
            self.User.checkUserAuth { (authState) in
                print("Current Auth State: \(authState)")
            }
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
