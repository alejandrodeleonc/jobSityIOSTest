// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let serie = try? JSONDecoder().decode(Serie.self, from: jsonData)

import Foundation

// MARK: - SerieElement
struct Serie: Codable {
    let id: Int
    let url: String
    let name: String
    let genres: [String]
    let status: Status
    let runtime, averageRuntime: Int?
    let premiered, ended: String?
    let rating: Rating
    let image: Image
    let summary: String

}


// MARK: - Image
struct Image: Codable {
    let medium, original: String
}

// MARK: - Rating
struct Rating: Codable {
    let average: Double?
}


enum Status: String, Codable {
    case ended = "Ended"
    case running = "Running"
    case toBeDetermined = "To Be Determined"
}


typealias serie = [Serie]
