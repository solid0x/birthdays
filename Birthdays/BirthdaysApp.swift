//
//  BirthdaysApp.swift
//  Birthdays
//
//  Created by letvarx on 15.09.2021.
//

import SwiftUI

@main
struct BirthdaysApp: App {
    
    @Environment(\.scenePhase) var scenePhase
    
    @StateObject var firstLaunch = FirstLaunch()
    @StateObject var birthdayList = BirthdayList()
    
    private var persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            if firstLaunch.passed {
                BirthdayListView(birthdayList: birthdayList)
            } else {
                FirstLaunchView(firstLaunch: firstLaunch).onDisappear {
                    birthdayList.sync()
                }
            }
        }.onChange(of: scenePhase) { _ in
            persistenceController.save()
        }
    }
}
