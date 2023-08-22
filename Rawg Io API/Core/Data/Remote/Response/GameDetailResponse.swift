//
//  GameDetailResponse.swift
//  Rawg Io API
//
//  Created by MAC on 22/08/23.
//

import Foundation

struct GameDetailResponse: Decodable {
    
    private enum CodingKeys: String, CodingKey {
      case id = "id"
      case name = "name"
      case description = "description"
      case rating = "rating"
      case released = "released"
      case esrbRating = "esrb_rating"
      case metacriticPlatforms = "metacritic_platforms"
      case platforms = "platforms"
      case backgroundImage = "background_image"
    }
    
    let id: Int?
    let name: String?
    let description: String?
    let rating: Double?
    let released: String?
    let esrbRating: EsrbRatingResponse?
    let metacriticPlatforms: [MetricPlatformResponse]?
    let platforms: [PlatformResponse]?
    let backgroundImage: String?
}

struct EsrbRatingResponse: Decodable {
    private enum CodingKeys: String, CodingKey {
      case name = "name"
    }
    
    let name: String?
}

struct MetricPlatformResponse: Decodable {
    private enum CodingKeys: String, CodingKey {
      case metascore = "metascore"
      case url = "url"
    }
    
    let metascore: Int?
    let url: String?
}

struct PlatformResponse: Decodable {
    private enum CodingKeys: String, CodingKey {
      case name = "name"
    }
    
    let name: String?
}
