//
//  LoadingView.swift
//  PC-Watch WatchKit Extension
//
//  Created by Harshit Trehan on 8/9/20.
//  Copyright © 2020 Infinite Options. All rights reserved.
//

import SwiftUI

struct LoadingView: View {
    @State var isLoading = false
    @ObservedObject var User = UserManager.shared
    
    var body: some View {
        VStack{
//            Image(systemName: "arrow.2.circlepath.circle.fill")
//                .resizable()
//                .frame(width: 64, height: 64)
//                .rotationEffect(.degrees(spin ? 360 : 0))
//                .animation(Animation.linear.repeatForever(autoreverses: false).speed(0.4))
//                .onAppear(){
//                    self.spin.toggle()
//            }
            ZStack{
                Circle()
                    .stroke(Color.white, lineWidth: 4)
                    .frame(width: 55, height: 55)
                
                Image("App Icon")
                    .resizable()
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 1))
                    .frame(width: 53, height: 53)
                
                Circle()
                    .trim(from: 0, to: 0.2)
                    .stroke(Color.green, lineWidth: 4)
                    .frame(width: 55, height: 55)
                    .rotationEffect(Angle(degrees: self.isLoading ? 360 : 0))
                    .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
                    .onAppear() {
                        self.isLoading = true
                        if (!self.User.loadingUser) {
                            self.isLoading = false
                        }
                }
            }
            
            Text("Authenticating and")
                .fontWeight(.bold)
                .font(.system(size: 19, design: .rounded))
                .padding(.top, 20)
            Text("fetching data")
                .fontWeight(.bold)
                .font(.system(size: 19, design: .rounded))
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
