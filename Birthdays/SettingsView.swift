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
        ForEachLocale { 
            NavigationView {
                SettingsView()
            }
        }
    }
}
