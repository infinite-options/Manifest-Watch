//
//  UrlToAsset.swift
//  PC-Watch WatchKit Extension
//
//  Created by Emma Allegrucci on 7/20/20.
//  Copyright © 2020 Infinite Options. All rights reserved.
//

import Foundation
import SwiftUI

struct AssetImage<Placeholder: View>: View {
    let urlName: String
    private let placeholder: Placeholder?
    
    init(urlName: String, placeholder: Placeholder? = nil) {
        self.urlName = urlName
        self.placeholder = placeholder
    }

    var body: some View {
        image
    }
    
    private var image: some View {
        Group {
            if photoUrlToAssetImage[urlName] != nil {
                Circle()
                    .foregroundColor(Color(Color.RGBColorSpace.sRGB, red: 200/255, green: 215/255, blue: 228/255, opacity: 1))
                    .frame(width: 50, height: 50) //50
                    .overlay(Image(photoUrlToAssetImage[urlName]!)
                        .resizable()
                        .frame(width:30, height:30) //30
                        .padding(0))
                    .overlay(Circle().stroke(Color.white, lineWidth: 1))
                    .shadow(color: Color(Color.RGBColorSpace.sRGB, red: 200/255, green: 215/255, blue: 228/255, opacity: 1) , radius: 4)
                    .padding(EdgeInsets(top: 8, leading: 2, bottom: 0, trailing: 2))
            } else {
                Circle()
                    .foregroundColor(Color(Color.RGBColorSpace.sRGB, red: 200/255, green: 215/255, blue: 228/255, opacity: 1))
                    .frame(width: 50, height: 50)
                    .overlay(placeholder)
                    .overlay(Circle().stroke(Color.white, lineWidth: 1))
                    .shadow(color: Color(Color.RGBColorSpace.sRGB, red: 200/255, green: 215/255, blue: 228/255, opacity: 1) , radius: 4)
                    .padding(EdgeInsets(top: 8, leading: 2, bottom: 0, trailing: 2))
            }
        }
    }
}

struct SmallAssetImage<Placeholder: View>: View {
    let urlName: String
    private let placeholder: Placeholder?
    
    init(urlName: String, placeholder: Placeholder? = nil) {
        self.urlName = urlName
        self.placeholder = placeholder
    }

    var body: some View {
        smallImage
    }
    
    private var smallImage: some View {
        Group {
            if photoUrlToAssetImage[urlName] != nil && photoUrlToAssetImage[urlName] != "" {
                Circle()
                    .foregroundColor(Color(Color.RGBColorSpace.sRGB, red: 200/255, green: 215/255, blue: 228/255, opacity: 1))
                    .frame(width: 30, height: 30) //30
                    .clipped()
                    .overlay(Image(photoUrlToAssetImage[urlName]!)
                        .resizable()
                        .frame(width:22, height:22) //22
                        .padding(0))
                    .overlay(Circle().stroke(Color.white, lineWidth: 1))
                    .shadow(color: Color(Color.RGBColorSpace.sRGB, red: 200/255, green: 215/255, blue: 228/255, opacity: 1) , radius: 4)
                    .padding(EdgeInsets(top: 15, leading: 10, bottom: 15, trailing: 10)) //8,2,8,2
            } else {
                Circle()
                    .foregroundColor(Color(Color.RGBColorSpace.sRGB, red: 200/255, green: 215/255, blue: 228/255, opacity: 1))
                    .frame(width: 30, height: 30) //30
                    .clipped()
                    .overlay(placeholder)
                        .frame(width: 15, height: 15) //new
                    .overlay(Circle().stroke(Color.white, lineWidth: 1))
                    .shadow(color: Color(Color.RGBColorSpace.sRGB, red: 200/255, green: 215/255, blue: 228/255, opacity: 1) , radius: 4)
                    .padding(EdgeInsets(top: 15, leading: 10, bottom: 15, trailing: 10)) //8,2,8,2
            }
        }
    }
}
