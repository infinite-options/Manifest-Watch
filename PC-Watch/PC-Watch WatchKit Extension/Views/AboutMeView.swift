//
//  AboutMeView.swift
//  PC-Watch WatchKit Extension
//
//  Created by Harshit Trehan on 8/9/20.
//  Copyright © 2020 Infinite Options. All rights reserved.
//

import SwiftUI

struct AboutMeView: View {
    @ObservedObject var User = UserManager.shared
    @ObservedObject var model = NetworkManager.shared
    
    let fullName = UserDefaults(suiteName: "manifestSuite")?.string(forKey: "userName")
    
    var body: some View {
        GeometryReader { geo in
            if self.User.isUserSignedIn == .signedIn {
                ScrollView([.vertical]) {
                    Spacer()
                    VStack {
                        if self.User.UserPhoto == nil {
                            Image(systemName: "person.circle")
                                .font(.system(size:50))
                                .foregroundColor(Color.white)
                        }
                        else{
                            Image(uiImage: self.User.UserPhoto ?? UIImage())
                                .resizable()
                                .frame(width: 80, height: 80)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.white, lineWidth: 1))
                        }
                        if self.fullName != nil {
                            Text("\(self.fullName!)")
                                .fontWeight(.bold)
                                .font(.system(size: 19, design: .rounded))
                        }
                        NavigationLink(destination: SignInView()) {
                            Text("Sign Out")
                                .foregroundColor(Color(Color.RGBColorSpace.sRGB, red: 200/255, green: 215/255, blue: 228/255, opacity: 1))
                                .onTapGesture {
                                    self.User.signOutUser()
                                }
                        }
                    }
                }.navigationBarTitle("About Me")
            } else {
                LaunchScreenView()
            }
        }
    }
}
