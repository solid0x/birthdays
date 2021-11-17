//
//  SettingsView.swift
//  Birthdays
//
//  Created by letvarx on 15.11.2021.
//

import SwiftUI

struct SettingsView: View {
    
    @ObservedObject var settings: Settings = Settings.shared
    
    var body: some View {
        Form {
            Toggle("Notifications", isOn: settings.$notificationsEnabled)
            if settings.notificationsEnabled {
                DatePicker("Notify At", selection: settings.$notifyAt, displayedComponents: .hourAndMinute)
            }
        }
        .navigationTitle("Settings")
    }
}

struct SettingsView_Previews: PreviewProvider {
    
    static var previews: some View {
        NavigationView {
            SettingsView()
        }
    }
}
