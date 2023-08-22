//
//  Game.swift
//  Rawg Io API
//
//  Created by MAC on 19/08/23.
//

import Foundation

struct GameModel : Equatable, Identifiable {
    let id: Int
    let title: String
    let imageUrl: String
    let rating: Double
    let released: String
}

func mapGame(input response: [GameItemResponse]) -> [GameModel] {
  return response.map { result in
    return GameModel(
      id: result.id ?? 0,
      title: result.name ?? "",
      imageUrl: result.backgroundImage ?? "",
      rating: result.rating ?? 0.0,
      released: result.released ?? ""
    )
  }
}
