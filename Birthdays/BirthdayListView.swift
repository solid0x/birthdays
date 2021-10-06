//
//  ContentView.swift
//  Birthdays
//
//  Created by letvarx on 15.09.2021.
//

import SwiftUI

struct BirthdayListView: View {
    @ObservedObject var birthdayList: BirthdayList
    
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
                            Section(header: Text("\(date.named)")) {
                                ForEach(birthdays) { birthday in
                                    BirthdayListRow(birthday: birthday)
                                }
                            }
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Button(action: {}) {
                        Image(systemName: "plus.circle.fill")
                        Text("New Birthday")
                    }.font(.headline)
                    Spacer()
                }
            }
            .navigationTitle("Birthdays")
        }
    }
}

struct BirthdayListRow: View {
    
    @State var birthday: Birthday
    
    var body: some View {
        HStack {
            Text(birthday.of).font(.headline)
            Spacer()
            if birthday.daysToNextDate == 0 {
                Image(systemName: "gift").foregroundColor(.blue)
            } else {
                VStack {
                    Text("\(birthday.daysToNextDate)").font(.headline)
                    Text("days").font(.caption)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        BirthdayListView(birthdayList: BirthdayList())
    }
}
