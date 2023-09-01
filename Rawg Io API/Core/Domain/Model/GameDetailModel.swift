//
//  GameDetailModel.swift
//  Rawg Io API
//
//  Created by MAC on 22/08/23.
//

import Foundation

struct GameDetailModel {
    let name: String
    let description: String
    let rating: Double
    let released: String
    let esrbRating: String
    let metacriticPlatforms: [MetricPlatformModel]?
    let platforms: [PlatformModel]?
    let bgImage: String
}

struct MetricPlatformModel {
    let metascore: Int
    let url: String
}

struct PlatformModel {
    let name: String
}


func mapGameDetail(input response: GameDetailResponse) -> GameDetailModel {    
  return GameDetailModel(
    name: response.name ?? "",
    description: response.description ?? "",
    rating: response.rating ?? 0.0,
    released: response.released ?? "",
    esrbRating: response.esrbRating?.name ?? "",
    metacriticPlatforms: response.metacriticPlatforms?.map { result in
        MetricPlatformModel(
            metascore: result.metascore ?? 0,
            url: result.url ?? ""
        )
    },
    platforms: response.platforms?.map { result in
        return PlatformModel(
            name: result.platform?.name ?? ""
        )
    },
    bgImage: response.backgroundImage ?? ""
  )
}
