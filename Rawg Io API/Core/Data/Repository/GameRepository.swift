//
//  GameRepository.swift
//  Rawg Io API
//
//  Created by MAC on 19/08/23.
//

import Foundation

protocol GameRepositoryProtocol {
    func getListGame(result: @escaping (Result<[GameModel], Error>) -> Void)
    func getGameDetail(gameId: Int, result: @escaping (Result<GameDetailModel, Error>) -> Void)
    func insertFavGame(gameModel: GameModel, completion: @escaping() -> Void)
    func deleteFavGame(gameId: Int, completion: @escaping() -> Void)
    func updateFaveGame(gameModel: GameModel, completion: @escaping() -> Void)
    func getFavGamesById(id: Int, completion: @escaping (GameModel?) -> Void)
    func getFavGames(completion: @escaping ([GameModel]?) -> Void)
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
    
    func getListGame(result: @escaping (Result<[GameModel], Error>) -> Void) {
        self.remote.getGameList { remoteResponses in
            switch remoteResponses {
            case .success(let response):
                let resultList = mapGame(input: response)
                result(.success(resultList))
            case .failure(let error):
                result(.failure(error))
            }
        }
    }
    
    func getGameDetail(gameId: Int, result: @escaping (Result<GameDetailModel, Error>) -> Void) {
        self.remote.getGameDetail(gameId: gameId) { remoteResponses in
            switch remoteResponses {
            case .success(let response):
                let gameDetail = mapGameDetail(input: response)
                result(.success(gameDetail))
            case .failure(let error):
                result(.failure(error))
            }
        }
    }
    
    func insertFavGame(gameModel: GameModel, completion: @escaping() -> Void) {
        self.local.insertGame(
            gameEntity: mapGameEntity(input: gameModel),
            completion: {
                completion()
            }
        )
    }
    
    func updateFaveGame(gameModel: GameModel, completion: @escaping() -> Void) {
        self.local.updateGame(
            gameEntity: mapGameEntity(input: gameModel),
            completion: {
                completion()
            }
        )
    }
    
    func deleteFavGame(gameId: Int, completion: @escaping() -> Void) {
        self.local.deleteFavGame(
            gameId: gameId,
            completion: {
                completion()
            }
        )
    }
    
    func getFavGamesById(id: Int, completion: @escaping (GameModel?) -> Void) {
        self.local.getFavGamesById(id: id, completion: { result in
            let gameModel = mapGame(input: result)
            completion(gameModel)
        })
    }
    
    func getFavGames(completion: @escaping ([GameModel]?) -> Void) {
        self.local.getFavGames(completion: { result in
            let gameModel = mapGame(input: result)
            completion(gameModel)
        })
    }
}
