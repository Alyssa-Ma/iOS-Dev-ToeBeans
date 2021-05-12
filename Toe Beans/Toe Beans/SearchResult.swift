//
//  SearchResult.swift
//  Toe Beans
//
//  Created by Alyssa Ma on 4/21/21.
//

import Foundation

//hold array of results
class ResultArray: Codable {
    var results = [SearchResult]()
}

//hold values from arr of results
class SearchResult: Codable {
    var address: String? = ""
    var location = [Coords]()
    var name: String? = ""
}

class Coords: Codable {
    var lat: String? = ""
    var lng: String? = ""
}
