//
//  LocationManager.swift
//  Toe Beans
//
//  Created by Alyssa Ma on 5/1/21.
//

import Foundation
import CoreLocation

struct Location {
    let coordinates: CLLocationCoordinate2D?
}

class LocationManager: NSObject {
    static let shared = LocationManager()
    
    //geocode string location to coords
    public func findLocations(with query: String, completion: @escaping (([Location]) -> Void)) {
        let geoCoder = CLGeocoder()
        
        //handle error
        geoCoder.geocodeAddressString(query) {places, error in
            guard let places = places, error == nil else {
                completion([])
                return
            }
            
            let models: [Location] = places.compactMap({ place in
                var name = ""
                if let locationName = place.name {
                    name += locationName
                }
                
                if let adminRegion = place.administrativeArea {
                    name += ", \(adminRegion)"
                }
                
                if let locality = place.locality {
                    name += ", \(locality)"
                }
                if let country = place.country {
                    name += ", \(country)"
                }
                
                print("place string test \(place)")
                print("coord test \(place.location!.coordinate)")
                
                let result = Location(coordinates: place.location?.coordinate)
                return result
            })
            completion(models)
        }
    }
    
}
