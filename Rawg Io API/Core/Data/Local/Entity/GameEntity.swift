//
//  GameEntity.swift
//  Rawg Io API
//
//  Created by koinworks on 11/09/23.
//

import Foundation
import RealmSwift

class GameEntity: Object {
    @objc dynamic var gameId: Int = 0
    @objc dynamic var title: String = ""
    @objc dynamic var imageUrl: String = ""
    @objc dynamic var rating: Double = 0.0
    @objc dynamic var released: String = ""
    
    override static func primaryKey() -> String? {
      return "gameId"
    }
    
    override init() {
        
    }
    
    init(gameId: Int, title: String, imageUrl: String, rating: Double, released: String) {
        self.gameId = gameId
        self.title = title
        self.imageUrl = imageUrl
        self.rating = rating
        self.released = released
    }
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

func mapGameEntity(response: GameItemResponse) -> GameEntity {
    return GameEntity(
        gameId: response.id ?? 0,
        title: response.name ?? "",
        imageUrl: response.backgroundImage ?? "",
        rating: response.rating ?? 0.0,
        released: response.released ?? ""
    )
}


func mapGameEntity(responses: [GameItemResponse]) -> [GameEntity] {
    return responses.map { response in
          GameEntity(
            gameId: response.id ?? 0,
            title: response.name ?? "",
            imageUrl: response.backgroundImage ?? "",
            rating: response.rating ?? 0.0,
            released: response.released ?? ""
        )
    }
}

func mapGameEntity(detailResponse: GameDetailResponse) -> GameEntity {
    return GameEntity(
        gameId: detailResponse.id ?? 0,
        title: detailResponse.name ?? "",
        imageUrl: detailResponse.backgroundImage ?? "",
        rating: detailResponse.rating ?? 0.0,
        released: detailResponse.released ?? ""
    )
}
