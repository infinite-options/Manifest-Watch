//
//  LaunchScreenView.swift
//  Manifest-Watch WatchKit Extension
//
//  Created by Prashant Marathay on 11/9/21.
//  Copyright © 2021 Infinite Options. All rights reserved.
//

import SwiftUI

struct LaunchScreenView: View {
    
    
    
    
    
    var body: some View {
        
        Spacer()
        
        Image("Manifest 1024")
            .resizable()
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.white, lineWidth: 1))
            .frame(width: 40, height: 40)
        
        Text("Launch Screen")
        
        Spacer()
            
        NavigationLink(destination: SignInView()) {
            Text("Sign In")
                .foregroundColor(Color(Color.RGBColorSpace.sRGB, red: 200/255, green: 215/255, blue: 228/255, opacity: 1))
        }.navigationBarTitle("Welcome")
        
    }
}

struct LaunchScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreenView()
    }
}
