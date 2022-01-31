import Foundation
import CoreData
import Contacts

protocol BirthdayStoring {
    func addBirthday(_ birthday: Birthday)
    func deleteBirthday(_ birthday: Birthday)
    func saveBirthdays()
    func fetchBirthdays() -> [Birthday]
    func syncBirthdays() -> [Birthday]
    func updateBirthday(_ birthday: Birthday)
}

struct Birthday: Identifiable, Equatable {
    let id: Int
    let contactId: String?
    var date: Date
    var of: String
}

extension Birthday {
    
    static func from(_ birthdayEntity: BirthdayEntity) -> Birthday {
        return Birthday(
            id: Int(birthdayEntity.id),
            contactId: birthdayEntity.contactId,
            date: birthdayEntity.date!,
            of: birthdayEntity.of!
        )
    }
}

class BirthdayStore: BirthdayStoring {
    
    static let shared = BirthdayStore()
    
    private var persistenceController = PersistenceController.shared
    private var persistenceContext: NSManagedObjectContext {
        persistenceController.context
    }
    
    private init() {}
    
    func addBirthday(_ birthday: Birthday) {
        let entity = BirthdayEntity(context: persistenceContext)
        entity.id = Int32(birthday.id)
        entity.date = birthday.date
        entity.of = birthday.of
    }
    
    func deleteBirthday(_ birthday: Birthday) {
        let entity = fetchEntity(withId: birthday.id)!
        persistenceContext.delete(entity)
    }
    
    func saveBirthdays() {
        persistenceController.save()
    }
    
    func fetchBirthdays() -> [Birthday] {
        return fetchEntities().toBirthdays()
    }
    
    func syncBirthdays() -> [Birthday] {
        let entities = fetchEntities()
        var entitiesUpdated = [BirthdayEntity]()
        var maxId = entities.maxId ?? -1
        
        if ContactsViewer.hasAccessToContacts {
            let contacts = ContactsViewer.getContacts()
            
            for entity in entities {
                if entity.contactId != nil && !contacts.hasContact(for: entity) {
                    delete(entity)
                } else {
                    entitiesUpdated.append(entity)
                }
            }
            
            for contact in contacts {
                if contact.birthday != nil && !entitiesUpdated.hasEntity(for: contact) {
                    maxId += 1
                    let entity = BirthdayEntity.from(contact, withId: maxId, onContext: persistenceContext)
                    entitiesUpdated.append(entity)
                }
            }
            
            saveEntities()
        } else {
            Log.info("Birthdays sync skipped: no access to contacts.")
        }
        
        return entitiesUpdated.toBirthdays()
    }
    
    func updateBirthday(_ birthday: Birthday) {
        let entity = fetchEntity(withId: birthday.id)!
        entity.date = birthday.date
        entity.of = birthday.of
    }
    
    private func fetchEntity(withId id: Int) -> BirthdayEntity? {
        let request = BirthdayEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == \(id)")
        request.fetchLimit = 1
        do {
            return try persistenceContext.fetch(request).first
        } catch {
            Log.error("Error occured while fetching birthday with id=\(id): \(error.localizedDescription)")
            return nil
        }
    }
    
    private func fetchEntities() -> [BirthdayEntity] {
        let request = BirthdayEntity.fetchRequest()
        do {
            return try persistenceContext.fetch(request)
        } catch {
            Log.error("Error occured while fetching birthday entities: \(error.localizedDescription)")
            return []
        }
    }
    
    private func delete(_ birthdayEntity: BirthdayEntity) {
        persistenceContext.delete(birthdayEntity)
    }
    
    private func saveEntities() {
        persistenceController.save()
    }
}

extension BirthdayEntity {
    
    static func from(_ contact: CNContact, withId id: Int32, onContext context: NSManagedObjectContext) -> BirthdayEntity {
        let entity = BirthdayEntity(context: context)
        entity.id = id
        entity.contactId = contact.identifier
        entity.date = Date.from(contact.birthday!)
        entity.of = contact.fullName
        return entity
    }
}

extension CNContact {
    
    var fullName: String {
        "\(givenName) \(familyName)"
    }
}

extension Array where Element: CNContact {
    
    func hasContact(for birthday: BirthdayEntity) -> Bool {
        contains { $0.identifier == birthday.contactId }
    }
}

extension Array where Element: BirthdayEntity {
    
    func toBirthdays() -> [Birthday] {
        map { Birthday.from($0) }
    }
    
    func hasEntity(for contact: CNContact) -> Bool {
        return contains { $0.contactId == contact.identifier }
    }
}

extension Array where Element: Identifiable, Element.ID: SignedInteger {
    
    var maxId: Element.ID? {
        isEmpty ? nil : self.max { $0.id < $1.id }!.id
    }
}
