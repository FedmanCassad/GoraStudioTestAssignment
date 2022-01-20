//
//  User.swift
//  GoraStudioTestAssignment
//
//  Created by Vladimir Banushkin on 19.01.2022.
//

import Foundation

struct User: Decodable {
    var id: Int
    var name: String
}

struct Album: Decodable {
    var userId: Int
    var id: Int
    var title: String
}

struct Photo: Decodable {
    var title: String
    var id: Int
    var albumId: Int
    var url: URL
}
