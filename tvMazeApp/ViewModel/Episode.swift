//
//  Episode.swift
//  tvMazeApp
//
//  Created by Alejandro De León on 25/6/23.
//

import Foundation

struct Episode: Codable {
    let id: Int
    let url: String
    let name: String
    let season: Int
    let number: Int
    let type: String
    let airdate: String
    let airtime: String
    let airstamp: String
    let runtime: Int
    let rating: Rating
    let image: Image
    let summary: String
    let embedded: Embedded
    var showInfo: Bool = false
    private enum CodingKeys: String, CodingKey {
           case id, url, name, season, number, type, airdate, airtime, airstamp, runtime, rating, image, summary
           case embedded = "_embedded"
       }
}


struct Embedded: Codable {
    let guestcast: [Guest]
}

struct Guest: Codable {
    let person: Person
    let character: Character
    let voice: Bool
}

struct Character: Codable {
    let id: Int
    let name: String
    let image: Image?
}

struct Person: Codable {
    let id: Int
    let name: String
    let birthday: String?
    let image: Image?
}
