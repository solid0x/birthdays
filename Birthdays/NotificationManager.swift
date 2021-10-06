//
//  NotificationManager.swift
//  Birthdays
//
//  Created by letvarx on 30.09.2021.
//

import UserNotifications

class NotificationManager {
    private init() {}
    
    static func requestAccess(completionHandler: @escaping (Bool, Error?) -> Void) {
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: completionHandler)
    }
    
    static func send(title: String, subtitle: String, sound: UNNotificationSound = .default, timeInterval: TimeInterval = 5) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.sound = sound
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
}
