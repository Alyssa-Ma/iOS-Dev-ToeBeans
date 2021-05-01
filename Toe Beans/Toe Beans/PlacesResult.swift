//
//  PlacesResult.swift
//  Toe Beans
//
//  Created by Alyssa Ma on 5/1/21.
//

import Foundation

//hold results from api arr
struct PlacesResult: Codable {
    var name: String? = ""
    var address: String? = ""
    
    var location: String {
        return address ?? ""
    }
}
