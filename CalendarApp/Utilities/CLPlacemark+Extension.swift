//
//  CLPlacemark+Extension.swift
//  CalendarApp
//
//  Created by David Wright on 1/12/21.
//

import CoreLocation

extension CLPlacemark {
    var address: String? {
        var address = ""
        
        if let subThoroughfare = subThoroughfare, let thoroughfare = thoroughfare {
            address += "\(subThoroughfare) \(thoroughfare)"
        } else if let thoroughfare = thoroughfare {
            address += "\(thoroughfare)"
        }
        
        if let locality = locality, let administrativeArea = administrativeArea {
            if !address.isEmpty {
                address += ", "
            }
            address += "\(locality), \(administrativeArea)"
            
            if let postalCode = postalCode {
                address += "  \(postalCode)"
            }
        }
        
        return address == "" ? nil : address
    }
}
