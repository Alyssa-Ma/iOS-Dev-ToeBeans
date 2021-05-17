//
//  ResultArray.swift
//  Toe Beans
//
//  Created by Alyssa Ma on 5/12/21.
//

import Foundation

//based on format of the api
struct ResultArray: Decodable {
    var results: [SearchRes]
}
//hold values from arr of results
struct SearchRes: Decodable {
    var address: String?
    var location: Coords
    var name: String?
    var phoneNumber: String?
    var website: String?
    var distance: Int?
}

struct Coords: Decodable {
    var lat: Double?
    var lng: Double?
}

