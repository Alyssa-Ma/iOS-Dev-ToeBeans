//
//  BusinessResult.swift
//  Toe Beans
//
//  Created by Alyssa Ma on 5/15/21.
//

import Foundation

struct BusinessArray: Decodable {
    var businesses: [BusinessResult]
}
//hold values from arr of results
struct BusinessResult: Decodable {
    var rating: Int?
    var price: String?
    var phone: String?
    var id: String?
}

