//
//  GameRepository.swift
//  Rawg Io API
//
//  Created by MAC on 19/08/23.
//

import Foundation
import Combine

protocol GameRepositoryProtocol {
    func getListGame() -> AnyPublisher<[GameModel], Error>
    func getGameDetail(gameId: Int) -> AnyPublisher<GameDetailModel?, Error>
    func insertFavGame(gameModel: GameModel) -> AnyPublisher<Bool, Error>
    func deleteFavGame(gameId: Int) -> AnyPublisher<Bool, Error>
    func updateFaveGame(gameModel: GameModel) -> AnyPublisher<Bool, Error>
    func getFavGamesById(id: Int) -> AnyPublisher<GameModel?, Error>
    func getFavGames() -> AnyPublisher<[GameModel]?, Error>
}

final class GameRepository: NSObject {
    
    typealias GameInstance = (RemoteDataSource, LocalDataSource) -> GameRepository
    
    fileprivate let remote: RemoteDataSource
    fileprivate let local: LocalDataSource
    
    private init(remote: RemoteDataSource, local: LocalDataSource) {
        self.remote = remote
        self.local = local
    }
    
    static let sharedInstance: GameInstance = { remote, local in
        return GameRepository(remote: remote, local: local)
    }
}

extension GameRepository: GameRepositoryProtocol {
    
    func getListGame() -> AnyPublisher<[GameModel], Error> {
        return self.local.getGame()
            .flatMap { result -> AnyPublisher<[GameModel], Error> in
                if result.isEmpty {
                    return self.remote.getGameList()
                        .map {
                            mapGameEntity(responses: $0)
                        }
                        .map {
                            $0.forEach { entity in
                                self.local.insertGame(gameEntity: entity)
                            }
                        }
                        .flatMap {
                            self.local.getGame()
                        }
                        .map {
                            mapGame(entity: $0) ?? []
                        }
                        .eraseToAnyPublisher()
                } else {
                    return self.local.getGame()
                        .map {
                            mapGame(entity: $0) ?? []
                        }
                        .eraseToAnyPublisher()
                }
            }.eraseToAnyPublisher()
    }
    
    func getGameDetail(gameId: Int) -> AnyPublisher<GameDetailModel?, Error> {
        return self.local.getGameDetail(gameId: gameId)
            .flatMap { result -> AnyPublisher<GameDetailModel?, Error> in
                if result == nil {
                    return self.remote.getGameDetail(gameId: gameId)
                        .map {
                            mapGameDetailEntity(input: $0)
                        }
                        .map {
                            self.local.insertGameDetail(gameDetailEntity: $0)
                        }
                        .flatMap {
                            self.local.getGameDetail(gameId: gameId)
                        }
                        .map {
                            mapGameDetail(entity: $0) ?? nil
                        }
                        .eraseToAnyPublisher()
                } else {
                    return self.local.getGameDetail(gameId: gameId)
                        .map {
                            mapGameDetail(entity: $0) ?? nil
                        }
                        .eraseToAnyPublisher()
                }
            }.eraseToAnyPublisher()
    }
    
    func insertFavGame(gameModel: GameModel) -> AnyPublisher<Bool, Error> {
        let favGameEntity = mapFavGameEntity(input: gameModel)
        return self.local.insertFavGame(favGameEntity: favGameEntity)
    }
    
    func updateFaveGame(gameModel: GameModel) -> AnyPublisher<Bool, Error> {
        let favGameEntity = mapFavGameEntity(input: gameModel)
        return self.local.updateFavGame(favGameEntity: favGameEntity)
    }
    
    func deleteFavGame(gameId: Int) -> AnyPublisher<Bool, Error> {
        return self.local.deleteFavGame(gameId: gameId)
    }
    
    func getFavGamesById(id: Int) -> AnyPublisher<GameModel?, Error> {
        return self.local.getFavGamesById(id: id)
            .map {
                mapGame(favGamEntity: $0)
            }
            .eraseToAnyPublisher()
    }
    
    func getFavGames() -> AnyPublisher<[GameModel]?, Error> {
        return self.local.getFavGames()
            .map {
                mapGame(favGamEntity: $0)
            }
            .eraseToAnyPublisher()
    }
}
