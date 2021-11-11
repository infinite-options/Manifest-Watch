//
//  ExtensionDelegate.swift
//  PC-Watch WatchKit Extension
//
//  Created by Kyle Hoefer on 4/6/20.
//  Copyright © 2020 Infinite Options. All rights reserved.
//

import WatchKit
import UserNotifications

import FirebaseCore
import FirebaseMessaging

class ExtensionDelegate: NSObject, WKExtensionDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    
    func applicationDidFinishLaunching() {
        
        FirebaseApp.configure()
        let center = UNUserNotificationCenter.current()
        
        center.delegate = self
        center.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if granted {
                print("User granted permission. Registering for remote notifications now.")
                WKExtension.shared().registerForRemoteNotifications()
            }
            else {
                print("Permission not granted")
            }
        }
        Messaging.messaging().delegate = self
        
        
        //Create Actions
//        let yesAction = UNNotificationAction(identifier: "YES_ACTION",
//                                             title: "Yes",
//                                             options: UNNotificationActionOptions(rawValue: 0))
//        let noAction = UNNotificationAction(identifier: "NO_ACTION",
//                                            title: "No",
//                                            options: UNNotificationActionOptions(rawValue: 0))
        
        // Create categories
        let moodCategory = UNNotificationCategory(identifier: "moodCategory", actions: [], intentIdentifiers: [], options: [])
        
        let checkInCategory = UNNotificationCategory(identifier: "checkInCategory", actions: [], intentIdentifiers: [], options: [])
        
        // Add category to notification framework
        UNUserNotificationCenter.current().setNotificationCategories([moodCategory, checkInCategory])
    }
    
    func scheduleMoodNotification() {
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        let content = UNMutableNotificationContent()
        content.title = "Checking In"
        content.body = "How are you feeling?"
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = "moodCategory"
        let request = UNNotificationRequest(identifier: "moodNotification", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func scheduleCheckInNotification(title: String, time: String) {
        let timeToTimeInterval = time.convertToTimeInterval()/2.0
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeToTimeInterval, repeats: false)
        let content = UNMutableNotificationContent()
        content.title = "Checking In"
        content.body = "Are you still working on " + title + "?"
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = "checkInCategory"
        let request = UNNotificationRequest(identifier: "checkInCategory", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func applicationDidBecomeActive() {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        let UserModel = UserManager.shared
        let DataSource = NetworkManager.shared
        
        UserModel.checkUserAuth { (authState) in
            if authState == .signedIn {
                UserModel.User = UserModel.manifestSuite?.string(forKey: UserModel.manifestUserIdKey)! as! String
                DataSource.updateDataModel {
                    print("Populated data model")
                    DispatchQueue.main.async {
                        UserModel.UserDayData = []
                        UserModel.UserDayBlockData = []
                        UserModel.mergeSortedGoalsEvents(goals: DataSource.data ?? [Value](), events: DataSource.events ?? [Event]())
                        UserModel.loadingUser = false
                    }

                    NotificationHandler().scheduleNotifications()
                }
            }
        }
    }
    
    func applicationDidEnterBackground() {
        // Schedule a background refresh task to update the complications.
        scheduleBackgroundRefreshTasks()
    }
    
    func applicationWillResignActive() {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, etc.
    }
    
    func didRegisterForRemoteNotifications(withDeviceToken deviceToken: Data) {
        //Swizzling should be disabled in Messaging for watchOS, set APNS token manually.
        print("Registering done. Send token to FCM now.")
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func didFailToRegisterForRemoteNotificationsWithError(_ error: Error) {
        print("Error while registering for remote notifications: \n", error)
    }
    
    //MessagingDelegate
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
      print("Token:" + fcmToken)
    }

    func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
        //Sent when the system needs to launch the application in the background to process tasks. Tasks arrive in a set, so loop through and process each one.
        for task in backgroundTasks {
            // Use a switch statement to check the task type
            switch task {
            case let backgroundTask as WKApplicationRefreshBackgroundTask:
                // Be sure to complete the background task once you’re done.
                BackgroundService.shared.updateContent()
                scheduleBackgroundRefreshTasks()
                backgroundTask.setTaskCompletedWithSnapshot(false)
            case let snapshotTask as WKSnapshotRefreshBackgroundTask:
                // Snapshot tasks have a unique completion call, make sure to set your expiration date
                snapshotTask.setTaskCompleted(restoredDefaultState: true, estimatedSnapshotExpiration: Date.distantFuture, userInfo: nil)
            case let connectivityTask as WKWatchConnectivityRefreshBackgroundTask:
                // Be sure to complete the connectivity task once you’re done.
                connectivityTask.setTaskCompletedWithSnapshot(false)
            case let urlSessionTask as WKURLSessionRefreshBackgroundTask:
                // Be sure to complete the URL session task once you’re done.
                BackgroundService.shared.handleDownload(urlSessionTask)
                urlSessionTask.setTaskCompletedWithSnapshot(false)
            case let relevantShortcutTask as WKRelevantShortcutRefreshBackgroundTask:
                // Be sure to complete the relevant-shortcut task once you're done.
                relevantShortcutTask.setTaskCompletedWithSnapshot(false)
            case let intentDidRunTask as WKIntentDidRunRefreshBackgroundTask:
                // Be sure to complete the intent-did-run task once you're done.
                intentDidRunTask.setTaskCompletedWithSnapshot(false)
            default:
                // make sure to complete unhandled task types
                task.setTaskCompletedWithSnapshot(false)
            }
        }
    }
    
    //To show notifications when the app is in the foreground.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound, .badge])
    }
    
    func scheduleBackgroundRefreshTasks() {
        // Get the shared extension object.
        let watchExtension = WKExtension.shared()
        
        // If there is a complication on the watch face, the app should get at least four
        // updates an hour. So calculate a target date 5 minutes in the future.
        let targetDate = Date().addingTimeInterval(30.0 * 60.0)
        
        // Schedule the background refresh task.
        watchExtension.scheduleBackgroundRefresh(withPreferredDate: targetDate, userInfo: nil) { (error) in
            
            // Check for errors.
            if let error = error {
                print("*** A background refresh error occurred: \(error.localizedDescription) ***")
                return
            }
            
            print("*** Background Task Scheduled! ***")
        }
    }
}
