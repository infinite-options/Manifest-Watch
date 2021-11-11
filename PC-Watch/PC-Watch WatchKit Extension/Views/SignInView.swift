//
//  SwiftUIView.swift
//  PC-Watch WatchKit Extension
//
//  Created by Emma Allegrucci on 8/4/20.
//  Copyright © 2020 Infinite Options. All rights reserved.
//

import SwiftUI
import UIKit

struct SignInView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewPick = ViewController.shared
    
    // Account Details
    // iodevcalendar@gmail.com      //100-000027
    // annamaneni.v@husky.neu.edu   //100-000028
    // vishal8694@gmail.com         //100-000029
    //pmarathay@gmail.com           //100-000040
    
    @State private var emailId = "pmarathay@gmail.com"
    @ObservedObject var User = UserManager.shared
    
    var body: some View {

        GeometryReader { geo in
            ScrollView([.vertical]){
                VStack{
                    Text("Enter Email")
                        .fontWeight(.bold)
                        .font(.system(size: 19, design: .rounded))
                        .padding(.bottom, 25)
                    
                    Spacer()
                    
                    TextField("Email", text: self.$emailId)
                        .textContentType(.username)
                        .multilineTextAlignment(.center)
                    
                    if self.User.isUserSignedIn == .invalidEmail {
                        Text("Incorrect Email")
                            .foregroundColor(Color.red)
                    }
                    
                    Button(action: {
                        self.User.loadingUser = true
                        print(self.emailId)
                        
                        self.User.getUserFromEmail(email: self.emailId) { (status) in
                            if status == 200 {
                                print("Signed in. User ID: \(self.User.User)")
                                self.presentationMode.wrappedValue.dismiss()
                            }
                            else {
                                DispatchQueue.main.async {
                                    self.User.isUserSignedIn = .invalidEmail
                                }
                            }
                        }
                    }){
                        Text("Done")
                    }.sheet(isPresented: self.$User.loadingUser) {
                        LoadingView()
                    }
                        
                    .disabled(self.emailId.isEmpty)
                    .accentColor(self.emailId.isEmpty ? Color.red : Color.green)
                }.edgesIgnoringSafeArea([.leading, .trailing, .bottom])
                .navigationBarTitle("Sign In")
                .navigationBarBackButtonHidden(false)
            }
        }
    }
}

#if DEBUG
struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
#endif
