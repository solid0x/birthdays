//
//  ContentView.swift
//  Birthdays
//
//  Created by letvarx on 15.09.2021.
//

import SwiftUI
import CoreData

struct BirthdayListView: View {
    
    @ObservedObject var birthdayList: BirthdayList
    
    var settingsView: some View {
        SettingsView().onDisappear(perform: birthdayList.scheduleNotifications)
    }
    
    var body: some View {
        NavigationView {
            Group {
                if birthdayList.isEmpty {
                    VStack {
                        HStack {
                            Image(systemName: "moon.stars.fill")
                            Text("No birthdays")
                        }.padding()
                        if !birthdayList.hasAccessToContacts {
                            Text("Allow access to Contacts in Settings")
                                .font(.subheadline)
                        }
                    }.foregroundColor(.gray)
                } else {
                    List {
                        ForEach(birthdayList.dateToBirthdays.range, id: \.self) { i in
                            let (date, birthdays) = birthdayList.dateToBirthdays[i]
                            Section(header: Text(LocalizedStringKey(date.named))) {
                                ForEach(birthdays) { birthday in
                                    let index = birthdayList.birthdays.firstIndex(of: birthday)!
                                    let binding = $birthdayList.birthdays[index]
                                    NavigationLink(destination: BirthdayDetails(for: binding)) {
                                        BirthdayRow(for: binding)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    NavigationLink(destination: settingsView) {
                        Image(systemName: "gearshape")
                    }
                    .font(.headline)
                }
                ToolbarItemGroup(placement: .bottomBar) {
                    NavigationLink(destination: BirthdayDetails()) {
                        Image(systemName: "plus.circle.fill")
                        Text("New Birthday")
                    }
                    .font(.headline)
                    Spacer()
                }
            }
            .navigationTitle("Birthdays")
        }
        .environmentObject(birthdayList)
    }
}

struct BirthdayRow: View {
    
    @Binding var birthday: Birthday
    
    init(for birthday: Binding<Birthday>) {
        _birthday = birthday
    }
    
    var body: some View {
        HStack {
            Text(birthday.of).font(.headline)
            Spacer()
            if birthday.daysToNearest == 0 {
                Image(systemName: "gift").foregroundColor(.blue)
            } else {
                VStack {
                    Text("\(birthday.daysToNearest)").font(.headline)
                    Text("days").font(.caption)
                }
            }
        }
    }
}

struct BirthdayDetails: View {
    
    @Environment(\.presentationMode) private var presentationMode
    @EnvironmentObject private var birthdayList: BirthdayList
    
    @State private var date: Date
    @State private var name: String
    @State private var deleteAlertPresented = false
    
    private let birthday: Binding<Birthday>?
    
    private var isNew: Bool { birthday == nil }
    private var isExisting: Bool { !isNew }
    
    init(date: Date = Date.today, name: String = "", birthday: Binding<Birthday>? = nil) {
        _date = State(initialValue: date)
        _name = State(initialValue: name)
        self.birthday = birthday
    }
    
    init(for birthday: Binding<Birthday>) {
        self.init(date: birthday.date.wrappedValue, name: birthday.of.wrappedValue, birthday: birthday)
    }
    
    var body: some View {
        Form {
            Section(header: Text("Birthday Details")) {
                TextField(LocalizedStringKey("Name"), text: $name)
                DatePicker("Date", selection: $date, displayedComponents: .date)
            }
            Button("Save", action: save).font(.headline)
            if isExisting {
                Button("Delete") {
                    deleteAlertPresented = true
                }
                .foregroundColor(.red)
                .alert(isPresented: $deleteAlertPresented) {
                    Alert(
                        title: Text("Are you sure?"),
                        message: Text("This birthday will be deleted"),
                        primaryButton: .destructive(Text("Delete"), action: delete),
                        secondaryButton: .cancel()
                    )
                }
            }
        }
        .navigationTitle(isNew ? "New Birthday" : "Edit Birthday")
    }
    
    private func save() {
        if let birthday = birthday {
            birthday.date.wrappedValue = date
            birthday.of.wrappedValue = name
            birthdayList.update(birthday.wrappedValue)
        } else {
            birthdayList.add(date: date, of: name)
        }
        birthdayList.save()
        dismissView()
    }
    
    private func delete() {
        birthdayList.delete(birthday!.wrappedValue)
        dismissView()
    }
    
    private func dismissView() {
        presentationMode.wrappedValue.dismiss()
    }
}

struct BirthdayListView_Previews: PreviewProvider {
    
    static let birthdayStore = BirthdayStore_Preview()
    
    static var previews: some View {
        let birthdayList = BirthdayList(birthdayStore: birthdayStore)
        let birthdayBinding = Binding.constant(Birthday(id: 0, contactId: nil, date: .today, of: "Contact #1"))
        
        ForEachLocale {
            BirthdayListView(birthdayList: birthdayList)
            NavigationView { BirthdayDetails() }
            NavigationView { BirthdayDetails(for: birthdayBinding) }
        }
    }
}

struct BirthdayStore_Preview {
    
    private static let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    private var entities = [
        newEntity(date: Date.today, of: "Contact #1"),
        newEntity(date: Date.tomorrow.nextDay, of: "Contact #2")
    ]
    
    private static func newEntity(date: Date, of: String) -> BirthdayEntity {
        let entity = BirthdayEntity(context: context)
        entity.id = Int32.random(in: 0...Int32.max)
        entity.date = date
        entity.of = of
        return entity
    }
}

extension BirthdayStore_Preview: BirthdayStoring {
    
    func addBirthday(_ birthday: Birthday) {}
    
    func deleteBirthday(_ birthday: Birthday) {}
    
    func saveBirthdays() {}
    
    func fetchBirthdays() -> [Birthday] {
        entities.toBirthdays()
    }
    
    func syncBirthdays() -> [Birthday] {
        entities.toBirthdays()
    }
    
    func updateBirthday(_ birthday: Birthday) {}
}
