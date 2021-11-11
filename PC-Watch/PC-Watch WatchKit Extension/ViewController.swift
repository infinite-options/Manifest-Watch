//
//  ViewController.swift
//  PC-Watch WatchKit Extension
//
//  Created by Harshit Trehan on 8/8/20.
//  Copyright © 2020 Infinite Options. All rights reserved.
//

import Foundation

enum ViewState {
    case showLaunch, showSignin, showAboutme
}

class ViewController: ObservableObject {
    static let shared = ViewController()
    
    private init(){}
    
    @Published var showView: ViewState = .showLaunch
}
