//
//  GameModel.swift
//  Rawg Io API
//
//  Created by koinworks on 05/09/23.
//

import Foundation
import RealmSwift

class FavGameEntity: Object {
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

func mapFavGameEntity(input model: GameModel) -> FavGameEntity {
    return FavGameEntity(
        gameId: model.id ,
        title: model.title ,
        imageUrl: model.imageUrl ,
        rating: model.rating ,
        released: model.released
    )
}

