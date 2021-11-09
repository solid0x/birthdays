//
//  ContactsViewer.swift
//  Birthdays
//
//  Created by letvarx on 22.09.2021.
//

import Contacts

class ContactsViewer {
    
    private init() {}
    
    static var authStatus: CNAuthorizationStatus {
        CNContactStore.authorizationStatus(for: .contacts)
    }
    
    static var hasAccessToContacts: Bool {
        authStatus == .authorized
    }
    
    static func getContacts() -> [CNContact] {
        var contacts = [CNContact]()
        
        let keysToFetch = [CNContactIdentifierKey, CNContactGivenNameKey, CNContactFamilyNameKey, CNContactBirthdayKey] as [CNKeyDescriptor]
        let request = CNContactFetchRequest(keysToFetch: keysToFetch)
        let store = CNContactStore()
        
        try! store.enumerateContacts(with: request) { contact, _ in
            contacts.append(contact)
        }
        
        return contacts
    }
    
    static func requestAccess(completionHandler: @escaping (Bool, Error?) -> Void) {
        let store = CNContactStore()
        store.requestAccess(for: .contacts, completionHandler: completionHandler)
    }
}
