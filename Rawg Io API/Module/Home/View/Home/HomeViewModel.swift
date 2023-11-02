//
//  HomeViewModel.swift
//  Rawg Io API
//
//  Created by MAC on 19/08/23.
//

import Foundation
import Combine
import Core

class HomeViewModel {
    
    private var cancellables: Set<AnyCancellable> = []
    var didGetListGame: ((Status<[GameModel]>.type) -> Void)? = nil
    
    private let gameUseCase: GameUseCase
    init(gameUseCase: GameUseCase) {
        self.gameUseCase = gameUseCase
    }
    
    func getGames() {
        self.didGetListGame?(Status<[GameModel]>.type.loading)
        gameUseCase.getListGame()
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
              switch completion {
              case .failure:
                  DispatchQueue.main.async {
                      self.didGetListGame?(Status<[GameModel]>.type.error(String(describing: completion)))
                  }
              case .finished:
                  break
              }
            }, receiveValue: { game in
                DispatchQueue.main.async {
                    self.didGetListGame?(Status<[GameModel]>.type.result(game))
                }
            })
            .store(in: &cancellables)
    }
    
}
