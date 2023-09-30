//
//  GameDetailUseCase.swift
//  Rawg Io API
//
//  Created by koinworks on 10/09/23.
//

import Foundation
import Combine

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
    
    func getListGame() -> AnyPublisher<[GameModel], Error> {
        return repository.getListGame()
    }
    
    func getGameDetail(gameId: Int) -> AnyPublisher<GameDetailModel, Error> {
        return repository.getGameDetail(gameId: gameId)
    }
    
    func insertFavGame(gameModel: GameModel) -> AnyPublisher<Bool, Error> {
        return repository.insertFavGame(gameModel: gameModel)
    }
    
    func updateFaveGame(gameModel: GameModel) -> AnyPublisher<Bool, Error> {
        return repository.updateFaveGame(gameModel: gameModel)
    }
    
    func deleteFavGame(gameId: Int) -> AnyPublisher<Bool, Error> {
        return repository.deleteFavGame(gameId: gameId)
    }
    
    func getFavGamesById(id: Int) -> AnyPublisher<GameModel?, Error> {
        return repository.getFavGamesById(id: id)
    }
    
    func getFavGames() -> AnyPublisher<[GameModel]?, Error> {
        return repository.getFavGames()
    }
}
