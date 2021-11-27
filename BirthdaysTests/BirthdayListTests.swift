//
//  BirthdayListTests.swift
//  BirthdaysTests
//
//  Created by letvarx on 24.11.2021.
//

import XCTest
@testable import Birthdays

class BirthdayListTests: XCTestCase {
    
    var birthdayStore: BirthdayStore_Mock!
    var birthdayList: BirthdayList!

    override func setUpWithError() throws {
        try super.setUpWithError()
        birthdayStore = BirthdayStore_Mock()
        birthdayList = BirthdayList(birthdayStore: birthdayStore)
    }

    override func tearDownWithError() throws {
        birthdayList = nil
        birthdayStore = nil
        try super.tearDownWithError()
    }

    func testListIsEmpty() {
        let isEmpty = birthdayList.isEmpty
        
        XCTAssertTrue(isEmpty)
    }
    
    func testAddBirthday() {
        birthdayList.add(date: .today, of: "Contact")
        
        let count = birthdayList.birthdays.count
        let addBirthdayCalled = birthdayStore.addBirthdayCalled
        
        XCTAssertEqual(count, 1)
        XCTAssertTrue(addBirthdayCalled, "Birthday store method not called")
    }
    
    func testListIsNotEmpty_OnBirthdayAdd() {
        birthdayList.add(date: .today, of: "Contact")
        
        let isEmpty = birthdayList.isEmpty
        
        XCTAssertFalse(isEmpty)
    }
    
    func testMaxId() {
        let maxId = birthdayList.maxId
        
        XCTAssertEqual(maxId, -1)
    }
    
    func testMaxId_OnBirthdayAdd() {
        birthdayList.add(date: .today, of: "Contact")
        
        let maxId = birthdayList.maxId
        
        XCTAssertEqual(maxId, 0)
    }
    
    func testSync() {
        birthdayList.sync()
        
        let count = birthdayList.birthdays.count
        let syncBirthdaysCalled = birthdayStore.syncBirthdaysCalled
        
        XCTAssertEqual(count, 0)
        XCTAssertTrue(syncBirthdaysCalled, "Birthday store method not called")
    }
    
    func testSync_OnBirthdayStoreChange() {
        let birthday = Birthday(id: 0, contactId: nil, date: .today, of: "Contact")
        birthdayStore.addBirthday(birthday)
        birthdayList.sync()
        
        let count = birthdayList.birthdays.count
        
        XCTAssertEqual(count, 1)
    }
    
    func testSave() {
        birthdayList.save()
        
        let count = birthdayList.birthdays.count
        let saveBirthdaysCalled = birthdayStore.saveBirthdaysCalled
        
        XCTAssertEqual(count, 0)
        XCTAssertTrue(saveBirthdaysCalled, "Birthday store method not called")
    }
    
    func testSave_OnBirthdayAdd() {
        birthdayList.add(date: .today, of: "Contact")
        birthdayList.save()
        
        let count = birthdayList.birthdays.count
        
        XCTAssertEqual(count, 1)
    }
    
    func testUpdateBirthday() {
        var birthday = Birthday(id: 0, contactId: nil, date: .today, of: "Contact")
        birthdayStore.addBirthday(birthday)
        birthdayList.sync()
        birthday.of = "Contact New"
        birthdayList.update(birthday)
        
        let updateBirthdayCalled = birthdayStore.updateBirthdayCalled
        
        XCTAssertTrue(updateBirthdayCalled, "Birthday store method not called")
    }
    
    func testDeleteBirthday() {
        birthdayList.add(date: .today, of: "Contact")
        let birthday = birthdayList.birthdays.first!
        birthdayList.delete(birthday)
        
        let count = birthdayList.birthdays.count
        let deleteBirthdayCalled = birthdayStore.deleteBirthdayCalled
        
        XCTAssertEqual(count, 0)
        XCTAssertTrue(deleteBirthdayCalled, "Birthday store method not called")
    }
}

class BirthdayStore_Mock: BirthdayStoring {
    
    var addBirthdayCalled = false
    var deleteBirthdayCalled = false
    var saveBirthdaysCalled = false
    var fetchBirthdaysCalled = false
    var syncBirthdaysCalled = false
    var updateBirthdayCalled = false
    
    private var birthdays = [Birthday]()
    
    func addBirthday(_ birthday: Birthday) {
        addBirthdayCalled = true
        birthdays.append(birthday)
    }
    
    func deleteBirthday(_ birthday: Birthday) {
        deleteBirthdayCalled = true
        birthdays.remove(birthday)
    }
    
    func saveBirthdays() {
        saveBirthdaysCalled = true
    }
    
    func fetchBirthdays() -> [Birthday] {
        fetchBirthdaysCalled = true
        return birthdays
    }
    
    func syncBirthdays() -> [Birthday] {
        syncBirthdaysCalled = true
        return birthdays
    }
    
    func updateBirthday(_ birthday: Birthday) {
        updateBirthdayCalled = true
        if let i = birthdays.firstIndex(where: { $0.id == birthday.id }) {
            birthdays[i] = birthday
        }
    }
}
