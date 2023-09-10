//
//  GameUseCase.swift
//  Rawg Io API
//
//  Created by koinworks on 09/09/23.
//

import Foundation


protocol GameUseCaseProtocol {
    func getListGame(completion: @escaping (Result<[GameModel], Error>) -> Void) async
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
    
    func getListGame(completion: @escaping (Result<[GameModel], Error>) -> Void) {
        repository.getListGame { result in
            completion(result)
        }
    }
    
}

