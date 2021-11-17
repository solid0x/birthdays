//
//  FirstLaunch.swift
//  Birthdays
//
//  Created by letvarx on 22.09.2021.
//

import SwiftUI

class FirstLaunch: ObservableObject {
    
    @AppStorage("launchedBefore") private static var launchedBefore = false
    
    @Published private(set) var passed = launchedBefore {
        didSet {
            FirstLaunch.launchedBefore = passed
        }
    }
    
    func requestContactsAccess(completionHandler: @escaping (Bool, Error?) -> Void) {
        ContactsViewer.requestAccess(completionHandler: completionHandler)
    }
    
    func requestNotificationsAccess(completionHandler: @escaping (Bool, Error?) -> Void) {
        Notifications.requestAccess(completionHandler: completionHandler)
    }
    
    func pass() {
        DispatchQueue.main.async {
            self.passed = true
        }
    }
}
