//
//  BirthdaysViewModel.swift
//  Birthdays
//
//  Created by letvarx on 16.09.2021.
//

import SwiftUI
import CoreData
import Contacts

class BirthdayList: ObservableObject {
    
    @Published var birthdays = [Birthday]()
    
    private var birthdayStore: BirthdayStoring
    
    var dateToBirthdays: [(Date, [Birthday])] {
        var result: [Date: [Birthday]] = [:]
        for birthday in birthdays {
            if result[birthday.nextDate] == nil {
                result[birthday.nextDate] = [birthday]
            } else {
                result[birthday.nextDate]!.append(birthday)
            }
        }
        return result.sorted(by: { $0.key < $1.key })
    }
    
    var isEmpty: Bool {
        birthdays.isEmpty
    }
    
    var maxId: Int {
        isEmpty ? -1 : birthdays.maxId!
    }
    
    var hasAccessToContacts: Bool {
        ContactsViewer.authStatus == .authorized
    }
    
    init(birthdayStore: BirthdayStoring = BirthdayStore.shared) {
        self.birthdayStore = birthdayStore
        sync()
    }
    
    func sync() {
        birthdays = birthdayStore.syncBirthdays()
    }
    
    func save() {
        birthdayStore.saveBirthdays()
    }
    
    func update(_ birthday: Birthday) {
        birthdayStore.updateBirthday(birthday)
    }
    
    func add(date: Date, of: String) {
        let birthday = Birthday(id: maxId+1, contactId: nil, date: date, of: of)
        birthdayStore.addBirthday(birthday)
        birthdays.append(birthday)
    }
    
    func delete(_ birthday: Birthday) {
        birthdays.remove(birthday)
        birthdayStore.deleteBirthday(birthday)
    }
}

extension Birthday {
    
    var nextDate: Date {
        var nextBirthday = Date.from(year: Date.today.year, month: date.month, day: date.day)
        if Date.today.after(nextBirthday) {
            nextBirthday = Date.from(year: Date.today.year + 1, month: date.month, day: date.day)
        }
        return nextBirthday
    }
    
    var daysToNextDate: Int {
        return Calendar.current.daysFromNow(to: nextDate)
    }
    
    var passed: Bool {
        return true
    }
}

extension Array {
    
    var range: Range<Int> {
        return 0..<self.endIndex
    }
}

extension Array where Element: Identifiable {
    
    mutating func remove(_ element: Element) {
        self = filter { $0.id != element.id }
    }
}

extension Calendar {
    
    func daysFromNow(to: Date) -> Int {
        dateComponents([.day], from: Date.today, to: to.startOfDay).day!
    }
}
