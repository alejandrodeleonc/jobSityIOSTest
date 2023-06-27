//
//  Show.swift
//  tvMazeApp
//
//  Created by Alejandro De León on 26/6/23.
//

import Foundation
struct Show: Codable {
    let score: Double
    let serie: Serie
    enum CodingKeys: String, CodingKey {
           case score
           case serie = "show"
       }
}
