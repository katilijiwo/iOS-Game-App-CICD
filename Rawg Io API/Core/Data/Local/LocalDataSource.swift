//
//  LocalDataSource.swift
//  Rawg Io API
//
//  Created by koinworks on 05/09/23.
//

import Foundation
import Combine

protocol LocalDataSourceProtocol: AnyObject {
    func getGame() -> AnyPublisher<[GameEntity], Error>
    func getGameById(gameId: Int) -> AnyPublisher<[GameEntity], Error>
    func insertGame(gameEntity: GameEntity) -> AnyPublisher<Bool, Error>
    func updateGame(gameEntity: GameEntity) -> AnyPublisher<Bool, Error>
    func deleteGame(gameId: Int) -> AnyPublisher<Bool, Error>
    
    func getFavGames() -> AnyPublisher<[FavGameEntity], Error>
    func getFavGamesById(id: Int) -> AnyPublisher<FavGameEntity?, Error>
    func insertFavGame(favGameEntity: FavGameEntity) -> AnyPublisher<Bool, Error>
    func deleteFavGame(gameId: Int) -> AnyPublisher<Bool, Error>
}

class LocalDataSource: NSObject {
    typealias LocalDataSourceInstance = (GameDbProvider, FavGameDbProvider) -> LocalDataSource
    
    private let gameDbProvider: GameDbProvider
    private let favGameDbProvider: FavGameDbProvider
    
    init(gameDbProvider: GameDbProvider, favGameDbProvider: FavGameDbProvider) {
        self.gameDbProvider = gameDbProvider
        self.favGameDbProvider = favGameDbProvider
    }
    static let sharedInstance: LocalDataSourceInstance = { gameDbProvider, favGameDbProvider in
        return LocalDataSource(gameDbProvider: gameDbProvider, favGameDbProvider: favGameDbProvider)
    }
}

extension LocalDataSource: LocalDataSourceProtocol {
    
    //MARK: Game
    
    func getGame() -> AnyPublisher<[GameEntity], Error> {
        return gameDbProvider.getGame()
    }
    
    func getGameById(gameId: Int) -> AnyPublisher<[GameEntity], Error> {
        return gameDbProvider.getGameById(gameId: gameId)
    }
    
    func insertGame(gameEntity: GameEntity) -> AnyPublisher<Bool, Error> {
        return gameDbProvider.insertGame(gameEntity: gameEntity)
    }
    
    func updateGame(gameEntity: GameEntity) -> AnyPublisher<Bool, Error> {
        return gameDbProvider.updateGame(gameEntity: gameEntity)
    }
    
    func deleteGame(gameId: Int) -> AnyPublisher<Bool, Error> {
        return gameDbProvider.deleteGame(gameId: gameId)
    }
    
    //MARK: Fav Game
    
    func insertFavGame(favGameEntity: FavGameEntity) -> AnyPublisher<Bool, Error> {
        return favGameDbProvider.insertFavGame(favGameEntity: favGameEntity)
    }
    
    func updateFavGame(favGameEntity: FavGameEntity) -> AnyPublisher<Bool, Error> {
        return favGameDbProvider.updateFavGame(favGameEntity: favGameEntity)
    }
    
    func deleteFavGame(gameId: Int) -> AnyPublisher<Bool, Error> {
        return favGameDbProvider.deleteFavGame(gameId: gameId)
    }
    
    func getFavGames() -> AnyPublisher<[FavGameEntity], Error> {
        return favGameDbProvider.getFavGame()
    }
    
    func getFavGamesById(id: Int) -> AnyPublisher<FavGameEntity?, Error> {
        return favGameDbProvider.getFavGameById(gameId: id)
    }
}


