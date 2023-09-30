//
//  GameUseCase.swift
//  Rawg Io API
//
//  Created by koinworks on 09/09/23.
//

import Foundation
import Combine

protocol GameUseCaseProtocol {
    func getListGame() -> AnyPublisher<[GameModel], Error>
}

final class GameUseCase: NSObject {
    
    typealias HomeGameUseCaseInstance = (GameRepositoryProtocol) -> GameUseCase
    
    fileprivate let repository: GameRepositoryProtocol
    
    private init(repository: GameRepositoryProtocol) {
        self.repository = repository
    }
    
    static let sharedInstance: HomeGameUseCaseInstance = { repository  in
        return GameUseCase(repository: repository)
    }
}

extension GameUseCase: GameUseCaseProtocol {
    
    func getListGame() -> AnyPublisher<[GameModel], Error> {
        return repository.getListGame()
    }
    
}

