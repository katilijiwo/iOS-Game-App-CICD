//
//  GameDetailUseCase.swift
//  Rawg Io API
//
//  Created by koinworks on 10/09/23.
//

import Foundation


protocol GameDetailUseCaseProtocol {
    func getGameDetail(gameId: Int, completion: @escaping (Result<GameDetailModel, Error>) -> Void)
    func insertFavGame(gameModel: GameModel, completion: @escaping() -> Void)
    func deleteFavGame(gameId: Int, completion: @escaping() -> Void)
    func updateFaveGame(gameModel: GameModel, completion: @escaping() -> Void)
    func getFavGamesById(id: Int, completion: @escaping (GameModel?) -> Void)
    func getFavGames(completion: @escaping ([GameModel]?) -> Void)
}

final class GameDetailUseCase: NSObject {
    
    typealias GameDetailUseCaseInstance = (GameRepositoryProtocol) -> GameDetailUseCase
    
    fileprivate let repository: GameRepositoryProtocol
    
    private init(repository: GameRepositoryProtocol) {
        self.repository = repository
    }
    
    static let sharedInstance: GameDetailUseCaseInstance = { repository  in
        return GameDetailUseCase(repository: repository)
    }
}

extension GameDetailUseCase: GameUseCaseProtocol {
    
    func getListGame(completion: @escaping (Result<[GameModel], Error>) -> Void) {
        repository.getListGame { result in
            completion(result)
        }
    }
    
    func getGameDetail(gameId: Int, completion: @escaping (Result<GameDetailModel, Error>) -> Void) {
        repository.getGameDetail(gameId: gameId) { remoteResponses in
            completion(remoteResponses)
        }
    }
    
    func insertFavGame(gameModel: GameModel, completion: @escaping() -> Void) {
        repository.insertFavGame(
            gameModel: gameModel,
            completion: {
                completion()
            }
        )
    }
    
    func updateFaveGame(gameModel: GameModel, completion: @escaping() -> Void) {
        repository.updateFaveGame(
            gameModel: gameModel,
            completion: {
                completion()
            }
        )
    }
    
    func deleteFavGame(gameId: Int, completion: @escaping() -> Void) {
        repository.deleteFavGame(
            gameId: gameId,
            completion: {
                completion()
            }
        )
    }
    
    func getFavGamesById(id: Int, completion: @escaping (GameModel?) -> Void) {
        repository.getFavGamesById(id: id, completion: { result in
            completion(result)
        })
    }
    
    func getFavGames(completion: @escaping ([GameModel]?) -> Void) {
        repository.getFavGames(completion: { result in
            completion(result)
        })
    }
}
