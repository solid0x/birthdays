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
    
    var maxId: Int32 {
        isEmpty ? -1 : birthdays.max { a, b in a.id < b.id }!.id
    }
    
    var hasAccessToContacts: Bool {
        ContactsViewer.authStatus == .authorized
    }
    
    init() {
        update()
    }
    
    func update() {
        birthdays = PersistenceController.shared.getAllBirthdays()
        
        if ContactsViewer.hasAccessToContacts {
            let contacts = ContactsViewer.getContacts()
            for contact in contacts {
                if let contactBirthday = contact.birthday {
                    if !birthdays.contains(contact) {
                        let birthday = Birthday(context: PersistenceController.shared.context)
                        birthday.id = maxId + 1
                        birthday.date = Date.from(contactBirthday)
                        birthday.of = Birthday.nameFor(contact)
                        birthdays.append(birthday)
                    }
                }
            }
        }
        
        PersistenceController.shared.save()
    }
}

extension Birthday {
    static func nameFor(_ contact: CNContact) -> String {
        "\(contact.givenName) \(contact.familyName)"
    }
    
    var nextDate: Date {
        var nextBirthday = Date.from(year: Date.today.year, month: date!.month, day: date!.day)
        if Date.today.after(nextBirthday) {
            nextBirthday = Date.from(year: Date.today.year + 1, month: date!.month, day: date!.day)
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

extension Array where Element : Birthday {
    func contains(_ contact: CNContact) -> Bool {
        let date = Date.from(contact.birthday!)
        let of = Birthday.nameFor(contact)
        return self.contains(where: { $0.date == date && $0.of == of })
    }
}

extension Calendar {
    func daysFromNow(to: Date) -> Int {
        dateComponents([.day], from: Date.today, to: to.startOfDay).day!
    }
}
