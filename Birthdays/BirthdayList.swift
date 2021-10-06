//
//  BirthdaysViewModel.swift
//  Birthdays
//
//  Created by letvarx on 16.09.2021.
//

import SwiftUI

class BirthdayList: ObservableObject {
    @Published var birthdays = [Birthday]()
    
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
    
    var hasAccessToContacts: Bool {
        ContactsViewer.authStatus == .authorized
    }
    
    init() {
        update()
    }
    
    func update() {
        if ContactsViewer.hasAccessToContacts {
            let contacts = ContactsViewer.getContacts()
            for contact in contacts {
                if let contactBirthday = contact.birthday {
                    let birthday = Birthday(id: birthdays.count, date: Date.from(contactBirthday), of: "\(contact.givenName) \(contact.familyName)")
                    birthdays.append(birthday)
                }
            }
        }
    }
}

struct Birthday: Identifiable {
    var id: Int
    var date: Date
    var of: String
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

extension Calendar {
    func daysFromNow(to: Date) -> Int {
        dateComponents([.day], from: Date.today, to: to.startOfDay).day!
    }
}
