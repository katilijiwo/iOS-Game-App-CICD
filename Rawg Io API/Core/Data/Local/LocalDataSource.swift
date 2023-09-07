//
//  LocalDataSource.swift
//  Rawg Io API
//
//  Created by koinworks on 05/09/23.
//

import Foundation

protocol LocalDataSourceProtocol: AnyObject {
    func getFavGames(id: Int, completion: @escaping ([GameEntity]) -> Void)
    func getFavGamesById(id: Int, completion: @escaping (GameEntity?) -> Void)
    func insertGame(gameEntity: GameEntity, completion: @escaping() -> Void)
    func deleteFavGame(gameId: Int, completion: @escaping() -> Void)
}

class LocalDataSource: NSObject {
    private let provider: GameDbProvider
    init(provider: GameDbProvider) {
        self.provider = provider
    }
}

extension LocalDataSource: LocalDataSourceProtocol {
    
    func getFavGames(id: Int, completion: @escaping ([GameEntity]) -> Void) {
        provider.getAllGame { result in
            print(result)
        }
    }
    
    func getFavGamesById(id: Int, completion: @escaping (GameEntity?) -> Void) {
        provider.getGameById(gameId: id, completion: { result in
            completion(result)
        })
    }
    
    func insertGame(gameEntity: GameEntity, completion: @escaping() -> Void) {
        provider.insertGame(
            gameEntity: gameEntity,
            completion: {
                DispatchQueue.main.async {
                    completion()
                }
            }
        )
    }
    
    func deleteFavGame(gameId: Int, completion: @escaping() -> Void) {
        provider.deleteGame(gameId: gameId, completion: {
            DispatchQueue.main.async {
                completion()
            }
        })
    }
}


