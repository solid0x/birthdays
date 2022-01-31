import SwiftUI

@main
struct BirthdaysApp: App {
    
    @StateObject var firstLaunch = FirstLaunch()
    @StateObject var birthdayList = BirthdayList()
    
    var body: some Scene {
        WindowGroup {
            if firstLaunch.passed {
                BirthdayListView(birthdayList: birthdayList)
            } else {
                FirstLaunchView(firstLaunch: firstLaunch).onDisappear {
                    birthdayList.sync()
                }
            }
        }
    }
}
