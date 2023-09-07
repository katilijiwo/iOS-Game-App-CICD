//
//  GameModel.swift
//  Rawg Io API
//
//  Created by koinworks on 05/09/23.
//

import Foundation

struct GameEntity {
    var gameId: Int?
    var title: String?
    var imageUrl: String?
    var rating: Double?
    var released: String?
}

func mapGameEntity(input model: GameModel) -> GameEntity {
    return GameEntity(
        gameId: model.id ,
        title: model.title ,
        imageUrl: model.imageUrl ,
        rating: model.rating ,
        released: model.released
    )
}

