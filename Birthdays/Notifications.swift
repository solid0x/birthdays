import UserNotifications

class Notifications {
    
    private static var notificationCenter: UNUserNotificationCenter {
        UNUserNotificationCenter.current()
    }
    
    private init() {}
    
    static func requestAccess(completionHandler: @escaping (Bool, Error?) -> Void) {
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        
        notificationCenter.requestAuthorization(options: authOptions, completionHandler: completionHandler)
    }
    
    static func send(title: String, subtitle: String, sound: UNNotificationSound = .default, timeInterval: TimeInterval = 5) {
        let content = UNMutableNotificationContent(title: title, subtitle: subtitle, sound: sound)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        notificationCenter.add(request)
    }
    
    static func schedule(title: String, subtitle: String, sound: UNNotificationSound = .default, dateMatching: DateComponents) {
        let content = UNMutableNotificationContent(title: title, subtitle: subtitle, sound: sound)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateMatching, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        notificationCenter.add(request)
    }
    
    static func removeAllPendingRequests() {
        notificationCenter.removeAllPendingNotificationRequests()
    }
}

extension UNMutableNotificationContent {
    
    convenience init(title: String, subtitle: String, sound: UNNotificationSound) {
        self.init()
        self.title = title
        self.subtitle = subtitle
        self.sound = sound
    }
}
