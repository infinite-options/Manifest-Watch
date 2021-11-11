//
//  SignInView.swift
//  Manifest-Watch WatchKit Extension
//
//  Created by Prashant Marathay on 11/9/21.
//  Copyright © 2021 Infinite Options. All rights reserved.
//

import SwiftUI
//import UIKit

struct SignInView: View {
    @Environment(\.presentationMode) var presentationMode
    
    
    
    
    
    
    
    
    @State private var emailId = "pmarathay@gmail.com"   // initializes the emailId variable
    @ObservedObject var User = UserManager.shared        // initializes the User variable
    
    var body: some View {
        
        
        
        
        Text("Enter Email ")
            .fontWeight(.bold)
            .font(.system(size: 19, design: .rounded))
        
        
        Spacer()
        
        TextField("Email", text: self.$emailId)
            .textContentType(.username)
            .multilineTextAlignment(.center)
        
        if self.User.isUserSignedIn == .invalidEmail {
            Text("Incorrect Email")
                .foregroundColor(Color.red)
        }
        
    Button (action: {                       // when clicked ...
            self.User.loadingUser = true    // sets loadingUser to true
            print(self.emailId)             // prints entered email to the console
            
        self.User.getUserFromEmail(email: self.emailId) { (status) in  // this is a call to UserManager
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
        }
        
        
        
        
        
        
        .navigationBarTitle("Welcome")
        
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
