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
}

final class GameRepository: NSObject {
    
    typealias GameInstance = (RemoteDataSource) -> GameRepository
    
    fileprivate let remote: RemoteDataSource
    
    private init(remote: RemoteDataSource) {
        self.remote = remote
    }
    
    static let sharedInstance: GameInstance = { remoteRepo in
        return GameRepository(remote: remoteRepo)
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
}
