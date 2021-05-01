//
//  SearchResult.swift
//  Toe Beans
//
//  Created by Alyssa Ma on 4/21/21.
//

import Foundation

//hold the latitude and longitude values
class GeoResul: Codable {
    var lat: String? = ""
    var lon: String? = ""
}

//hold results from api
class ResultArray: Codable {
    var resultCount = 0
    var results = [SearchResult]()
    
}

//search result for places nearby
class SearchResult: Codable {
    var name: String? = ""
    var address: String? = ""
    
    var location: String {
        return address ?? ""
    }
}
