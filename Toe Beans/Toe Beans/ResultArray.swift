//
//  ResultArray.swift
//  Toe Beans
//
//  Created by Alyssa Ma on 5/12/21.
//

import Foundation

struct ResultArray: Decodable {
    var results: [SearchRes]
}
//hold values from arr of results
struct SearchRes: Decodable {
    var address: String?
    var location: Coords
    var name: String?
}

struct Coords: Codable {
    var lat: Double?
    var lng: Double?
}
