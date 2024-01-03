//
//  Source.swift
//  rick and morty
//
//  Created by Қадыр Маратұлы on 31.12.2023.
//
import Foundation

struct Episode: Decodable {
    var id: Int
    var episode: String
    var name: String
    var characters: [String]
    var character: Character?
    
}

struct Character: Decodable {
    var id: Int
    var name: String
    var status: String
    var species: String
    var origin: Origin?
    var location: Location?
    var type: String
    var gender: String
    var image: String
}

struct Location: Decodable {
    var name: String
    var url: String
}

struct Origin: Decodable {
    var name: String
    var url: String
}
