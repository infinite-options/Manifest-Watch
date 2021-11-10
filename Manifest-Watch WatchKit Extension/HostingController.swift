//
//  HostingController.swift
//  Manifest-Watch WatchKit Extension
//
//  Created by Prashant Marathay on 11/9/21.
//

import WatchKit
import Foundation
import SwiftUI

class HostingController: WKHostingController<LaunchScreenView> {
    override var body: LaunchScreenView {
        return LaunchScreenView()
    }
}
