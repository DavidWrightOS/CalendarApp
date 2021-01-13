//
//  EditEvent+ItemType.swift
//  CalendarApp
//
//  Created by David Wright on 1/12/21.
//

import Foundation

// MARK: - ItemType

extension EditEventViewController {
    enum ItemType {
        case textField
        case location
        case allDaySwitch
        case date
        case repeats
        case travelTime
        case alert
        case attachment
        case textView
    }
}


// MARK: - AlertType

enum AlertType: Int, CaseIterable {
    case none, atTimeOfEvent, fiveMinutesBefore, tenMinutesBefore, fifteenMinutesBefore, thirtyMinutesBefore, oneHourBefore, twoHoursBefore, oneDayBefore, twoDaysBefore, oneWeekBefore
}

extension AlertType {
    
    static var displayNames = allCases.map { $0.displayName }
    
    var displayName: String? {
        switch self {
        case .none: return "None"
        case .atTimeOfEvent: return "At time of event"
        case .fiveMinutesBefore: return "5 minutes before"
        case .tenMinutesBefore: return "10 minutes before"
        case .fifteenMinutesBefore: return "15 minutes before"
        case .thirtyMinutesBefore: return "30 minutes before"
        case .oneHourBefore: return "1 hour before"
        case .twoHoursBefore: return "2 hours before"
        case .oneDayBefore: return "1 day before"
        case .twoDaysBefore: return "2 days before"
        case .oneWeekBefore: return "1 week before"
        }
    }
}


// MARK: - RepeatType

enum RepeatType: Int, CaseIterable {
    case never, everyDay, everyWeek, every2Weeks, everyMonth, everyYear, custom
}

extension RepeatType {
    
    static var displayNames = allCases.map { $0.displayName }
    
    var displayName: String? {
        switch self {
        case .never: return "Never"
        case .everyDay: return "Every Day"
        case .everyWeek: return "Every Week"
        case .every2Weeks: return "Every 2 Weeks"
        case .everyMonth: return "Every Month"
        case .everyYear: return "Every Year"
        case .custom: return "Custom"
        }
    }
}
