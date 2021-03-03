import Foundation
import UIKit

final class WorkCalendar {
    
    var currenDayNumber: Int {
        getCurrentDayNumber()
    }

    private let dateFormatter: DateFormatting
    private let calendar: Calendar
    
    init(dateFormatter: DateFormatting, calendar: Calendar) {
        self.dateFormatter = dateFormatter
        self.calendar = calendar
    }

    private func getCurrentDayNumber() -> Int {
        let currentDate = calendar.date(byAdding: .day, value: 0, to: Date())!
        let number = dateFormatter.string(from: currentDate, type: .shortDay) ?? ""
        return Int(number) ?? 1
    }
}
