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

func mapGame(entity: [GameEntity]?) -> [GameModel]? {
    guard entity != nil else { return nil }
    return entity!.map { result in
         GameModel(
            id: result.gameId,
            title: result.title,
            imageUrl: result.imageUrl,
            rating: result.rating,
            released: result.released
        )
    }
}

func mapGame(input entity: GameEntity?) -> GameModel? {
    guard entity != nil else { return nil }
    return GameModel(
        id: entity?.gameId ?? 0,
        title: entity?.title ?? "",
        imageUrl: entity?.imageUrl ?? "",
        rating: entity?.rating ?? 0.0,
        released: entity?.released ?? ""
    )
}

func mapGame(favGamEntity entity: [FavGameEntity]?) -> [GameModel]? {
    guard entity != nil else { return nil }
    return entity!.map { result in
        GameModel(
            id: result.gameId ?? 0,
            title: result.title ?? "",
            imageUrl: result.imageUrl ?? "",
            rating: result.rating ?? 0.0,
            released: result.released ?? ""
        )
    }
}

func mapGame(favGamEntity entity: FavGameEntity?) -> GameModel? {
    guard entity != nil else { return nil }
    return GameModel(
        id: entity?.gameId ?? 0,
        title: entity?.title ?? "",
        imageUrl: entity?.imageUrl ?? "",
        rating: entity?.rating ?? 0.0,
        released: entity?.released ?? ""
    )
}
