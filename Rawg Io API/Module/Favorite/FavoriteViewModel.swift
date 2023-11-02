//
//  FavoriteViewModel.swift
//  Rawg Io API
//
//  Created by koinworks on 08/09/23.
//

import Foundation
import Combine
import Core

class FavoriteViewModel {
    
    private var cancellables: Set<AnyCancellable> = []
    var didGetListFavGame: ((Status<[GameModel]?>.type) -> Void)? = nil
    
    private let gameDetailUseCase: GameDetailUseCase
    init(gameDetailUseCase: GameDetailUseCase) {
        self.gameDetailUseCase = gameDetailUseCase
    }

    func getFavGame() {
        self.didGetListFavGame?(Status<[GameModel]?>.type.loading)
        gameDetailUseCase.getFavGames()
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
              switch completion {
              case .failure:
                  DispatchQueue.main.async {
                      self.didGetListFavGame?(Status<[GameModel]?>.type.error(String(describing: completion)))
                  }
              case .finished:
                  break
              }
            }, receiveValue: { favGame in
                DispatchQueue.main.async {
                    self.didGetListFavGame?(Status<[GameModel]?>.type.result(favGame))
                }
            })
            .store(in: &cancellables)
    }
    
}
