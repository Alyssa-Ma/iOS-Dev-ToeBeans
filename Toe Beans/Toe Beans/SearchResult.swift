//
//  SearchResult.swift
//  Toe Beans
//
//  Created by Alyssa Ma on 4/21/21.
//

import Foundation

//hold api result of places found
struct SearchResult: Decodable {
    let name: String
    let address: String
    let location: String
}
