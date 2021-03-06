import Foundation

extension Date {
    
    static var today: Date {
        return Date().startOfDay
    }
    
    static var tomorrow: Date {
        return Calendar.current.date(byAdding: DateComponents(day: 1), to: Date())!
    }
    
    static func from(year: Int, month: Int, day: Int) -> Date {
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        return Calendar.current.date(from: dateComponents)!
    }
    
    static func from(_ dateComponents: DateComponents) -> Date {
        return Calendar.current.date(from: dateComponents)!
    }
    
    var nextDay: Date {
        return Calendar.current.date(byAdding: DateComponents(day: 1), to: self)!
    }
    
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }
    
    var second: Int {
        self.get(.second)
    }
    
    var minute: Int {
        self.get(.minute)
    }
    
    var hour: Int {
        self.get(.hour)
    }
    
    var day: Int {
        self.get(.day)
    }
    
    var month: Int {
        self.get(.month)
    }
    
    var year: Int {
        self.get(.year)
    }
    
    var isToday: Bool {
        self.equals(Date.today)
    }
    
    var isTomorrow: Bool {
        let today = Date.today
        let tomorrow = Date.from(year: today.year, month: today.month, day: today.day + 1)
        return self.equals(tomorrow)
    }
    
    var named: String {
        if isToday {
            return "Today"
        } else if isTomorrow {
            return "Tomorrow"
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "d MMM y"
            return dateFormatter.string(from: self)
        }
    }
    
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
    
    func after(_ date: Date, granularity: Calendar.Component = .day) -> Bool {
        Calendar.current.compare(self, to: date, toGranularity: granularity) == .orderedDescending
    }
    
    func before(_ date: Date, granularity: Calendar.Component = .day) -> Bool {
        Calendar.current.compare(self, to: date, toGranularity: granularity) == .orderedAscending
    }
    
    func equals(_ date: Date, granularity: Calendar.Component = .day) -> Bool {
        Calendar.current.compare(self, to: date, toGranularity: granularity) == .orderedSame
    }
    
    func at(hour: Int, minute: Int = 0, second: Int = 0) -> Date? {
        Calendar.current.date(bySettingHour: hour, minute: minute, second: second, of: self)
    }
}
