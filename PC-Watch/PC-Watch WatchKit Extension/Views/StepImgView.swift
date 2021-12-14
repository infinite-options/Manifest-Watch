//
//  StepImgView.swift
//  PC-Watch WatchKit Extension
//
//  Created by Jonathan Ly on 12/9/21.
//  Copyright © 2021 Infinite Options. All rights reserved.
//

import SwiftUI
import UserNotifications

struct StepImgView: View {
    @ObservedObject private var model = NetworkManager.shared
    @ObservedObject private var user = UserManager.shared
    var chosenStep: Steps?
    
    
    var body: some View {
        VStack{
            Text(chosenStep!.isTitle)
                .fontWeight(.bold)
                .font(.system(size: 20, design: .rounded))
//                .foregroundColor(.green)
//            Spacer()
            FullPageAsyncImage(
                url: URL(string: self.chosenStep!.isPhoto)!,
                placeholder: Image(systemName: "default-goal"))
                .padding(EdgeInsets(top: 2, leading: 0, bottom: 0, trailing: 0))
        }
    }
}

struct StepImgView_Previews: PreviewProvider {
    static var previews: some View {
        StepImgView()
    }
}
