//
//  AsyncSmallImage.swift
//  PC-Watch WatchKit Extension
//
//  Created by Emma Allegrucci on 7/10/20.
//  Copyright © 2020 Infinite Options. All rights reserved.
//

import SwiftUI

struct AsyncSmallImage<Placeholder: View>: View {
    @ObservedObject private var loader: ImageLoader
    private let placeholder: Placeholder?
    
    init(url: URL?, placeholder: Placeholder? = nil) {
        loader = ImageLoader(url: url)
        self.placeholder = placeholder
    }

    var body: some View {
        image
            .onAppear(perform: loader.load)
            .onDisappear(perform: loader.cancel)
    }
    
    private var image: some View {
        Group {
            if loader.image != nil {
                Image(uiImage: loader.image!)
                    .resizable()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                    .overlay(Circle()
                        .stroke(Color.white, lineWidth: 1))
//                Circle()
//                    .foregroundColor(Color.yellow.opacity(0.9))
//                    .frame(width: 40, height: 40)
//                    .overlay(Image(uiImage: loader.image!)
//                        .resizable()
//                        .frame(width:25, height:25)
//                        .padding(0))
//                    .overlay(Circle().stroke(Color.red, lineWidth: 1))
//                    .shadow(color: .yellow , radius: 4)
//                    .padding(EdgeInsets(top: 8, leading: 2, bottom: 8, trailing: 2))
            } else {
                placeholder
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                    .overlay(Circle()
                        .stroke(Color.white, lineWidth: 1))
            }
        }
    }
}
