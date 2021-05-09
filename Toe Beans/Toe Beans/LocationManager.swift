//
//  LocationManager.swift
//  Toe Beans
//
//  Created by Alyssa Ma on 5/1/21.
//

import Foundation
import CoreLocation

struct Location {
    let coordinates: CLLocationCoordinate2D
}
class LocationManager: NSObject {
    static let shared = LocationManager()
    
    let manager = CLLocationManager()
    
    public func findLocations(with query: String, completion: @escaping (([Location]) -> Void)) {
        
    }
}
