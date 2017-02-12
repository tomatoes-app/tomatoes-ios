//
//  LocalNotification.swift
//  tomatoes-ios
//
//  Created by Giorgia Marenda on 2/11/17.
//  Copyright © 2017 Giorgia Marenda. All rights reserved.
//

import UserNotifications

class LocalNotification {
    
    class func scheduleNotification(title: String, timeInterval: TimeInterval) {
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = title
        content.sound = UNNotificationSound(named: "ringing.m4a")
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        let request = UNNotificationRequest(identifier: "tomatoes", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    class func cancelNotification() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
}
