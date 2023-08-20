//
//  GameResponse.swift
//  Rawg Io API
//
//  Created by MAC on 19/08/23.
//

import Foundation

struct GameResponse: Decodable {
    private enum CodingKeys: String, CodingKey {
      case count = "count"
      case next = "next"
      case results = "results"
    }
    
    let count: CLong?
    let next: String?
    let results: [GameItemResponse]
}

struct GameItemResponse: Decodable {

    private enum CodingKeys: String, CodingKey {
      case id = "id"
      case name = "name"
      case released = "released"
      case backgroundImage = "background_image"
      case rating = "rating"
    }

    let id: Int?
    let name: String?
    let released: String?
    let backgroundImage: String?
    let rating: Double?
}
