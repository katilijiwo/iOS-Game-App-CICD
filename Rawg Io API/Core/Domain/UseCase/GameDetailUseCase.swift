//
//  GameDetailUseCase.swift
//  Rawg Io API
//
//  Created by koinworks on 10/09/23.
//

import Foundation
import Combine

protocol GameDetailUseCaseProtocol {
    func getGameDetail(gameId: Int) -> AnyPublisher<GameDetailModel?, Error>
    func insertFavGame(gameModel: GameModel) -> AnyPublisher<Bool, Error>
    func updateFaveGame(gameModel: GameModel) -> AnyPublisher<Bool, Error>
    func deleteFavGame(gameId: Int) -> AnyPublisher<Bool, Error>
    func getFavGamesById(id: Int) -> AnyPublisher<GameModel?, Error>
    func getFavGames() -> AnyPublisher<[GameModel]?, Error>
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

extension GameDetailUseCase: GameDetailUseCaseProtocol {
    
    func getGameDetail(gameId: Int) -> AnyPublisher<GameDetailModel?, Error> {
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
