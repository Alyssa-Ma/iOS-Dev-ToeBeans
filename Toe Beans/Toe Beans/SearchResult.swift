//
//  SearchResult.swift
//  Toe Beans
//
//  Created by Alyssa Ma on 4/21/21.
//

import Foundation

struct ResultArray: Codable {
    let results = [SearchResult]()
}
//hold values from arr of results
struct SearchResult: Codable {
    let address: String?
    let location = [Coords]()
    let name: String?
}

class Coords: Codable {
    var lat: String?
    var lng: String? 
}
