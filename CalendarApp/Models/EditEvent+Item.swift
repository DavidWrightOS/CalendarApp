//
//  EditEvent+Item.swift
//  CalendarApp
//
//  Created by David Wright on 1/12/21.
//

import CoreLocation

// MARK: - Section

extension EditEventViewController {
    enum Section: CaseIterable {
        case section1
        case section2
        case section3
        case section4
        case section5
    }
}


// MARK: - Item

extension EditEventViewController {
    
    struct Item: Hashable {
        
        // MARK: Properties
        
        let type: ItemType
        let text: String?
        let detailText: String?
        let placeholder: String?
        
        private let identifier: UUID
        
        // MARK: Initializers
        
        init(type: ItemType, text: String? = nil, detailText: String? = nil, placeholder: String? = nil) {
            self.type = type
            self.text = text
            self.detailText = detailText
            self.placeholder = placeholder
            self.identifier = UUID()
        }
        
        init(placemark: CLPlacemark, placeholder: String = "Location") {
            let text = placemark.name ?? placemark.thoroughfare
            self.init(type: .location, text: text, detailText: placemark.address, placeholder: placeholder)
        }
        
        init(date: Date, text: String, placeholder: String = "None") {
            let detailText = EditEventViewController.dateFormatter.string(from: date)
            self.init(type: .date, text: text, detailText: detailText, placeholder: placeholder)
        }
        
        init(alertType: AlertType, text: String = "Alert", placeholder: String = "None") {
            self.init(type: .alert, text: text, detailText: alertType.displayName, placeholder: placeholder)
        }
        
        init(repeatType: AlertType, text: String = "Alert", placeholder: String = "None") {
            self.init(type: .alert, text: text, detailText: repeatType.displayName, placeholder: placeholder)
        }
        
        // MARK: Helpers
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(self.identifier)
        }
    }
}
