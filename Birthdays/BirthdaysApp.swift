//
//  BirthdaysApp.swift
//  Birthdays
//
//  Created by letvarx on 15.09.2021.
//

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
                    birthdayList.update()
                }
            }
        }
    }
}
