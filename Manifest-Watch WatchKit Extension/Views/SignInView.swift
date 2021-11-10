//
//  SignInView.swift
//  Manifest-Watch WatchKit Extension
//
//  Created by Prashant Marathay on 11/9/21.
//  Copyright © 2021 Infinite Options. All rights reserved.
//

import SwiftUI


struct SignInView: View {
    
    
    
    
    
    
    
    
    
    @State private var emailId = "pmarathay@gmail.com"
    
    
    var body: some View {
        
        
        
        
        Text("Enter Email ")
            .fontWeight(.bold)
            .font(.system(size: 19, design: .rounded))
        
        
        Spacer()
        
        TextField("Email", text: self.$emailId)
            .textContentType(.username)
            .multilineTextAlignment(.center)
        
        
        
        
        
        
        Button (action: {}){
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
