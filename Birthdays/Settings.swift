//
//  Settings.swift
//  Birthdays
//
//  Created by letvarx on 15.11.2021.
//

import SwiftUI

class Settings: ObservableObject {
    
    static let shared = Settings()
    
    private init() {}
    
    @AppStorage("notificationsEnabled") var notificationsEnabled = true
    @AppStorage("notifyAt") var notifyAt = Date.today.at(hour: 9)!
}

extension Date: RawRepresentable {
    
    private static let formatter = ISO8601DateFormatter()
    
    public var rawValue: String {
        Date.formatter.string(from: self)
    }
    
    public init?(rawValue: String) {
        if let date = Date.formatter.date(from: rawValue) {
            self = date
        } else {
            return nil
        }
    }
}
