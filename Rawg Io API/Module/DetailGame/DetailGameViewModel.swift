//
//  DetailGameViewModel.swift
//  Rawg Io API
//
//  Created by MAC on 21/08/23.
//

import Foundation


class DetailGameViewModel {
    
    var didGetGame: ((Status<GameDetailModel>.type) -> Void)? = nil
    var didFavGame: ((Status<Void?>.type) -> Void)? = nil
    var didGameIsFav: ((Status<GameModel?>.type) -> Void)? = nil
    
    private let gameRepository: GameRepositoryProtocol
    init(gameRepository: GameRepositoryProtocol) {
        self.gameRepository = gameRepository
    }
    
    func getGameDetail(id: Int) {
        gameRepository.getGameDetail(gameId: id) { result in
            self.didGetGame?(Status<GameDetailModel>.type.loading)
            switch result {
            case .success(let result):
                DispatchQueue.main.async {
                    self.didGetGame?(Status<GameDetailModel>.type.result(result))
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.didGetGame?(Status<GameDetailModel>.type.error(error.localizedDescription))
                }
            }
        }
    }
    
    func insertFavGame(gameModel: GameModel) {
        self.didGetGame?(Status<GameDetailModel>.type.loading)
        gameRepository.insertFavGame(
            gameModel: gameModel,
            completion: {
                //TODO: JIWO
                print("jiwo sucess 2")
                self.didFavGame?(Status<Void?>.type.result(nil))
            }
        )
    }
    
    func getFavGameById(gameId: Int) {
        gameRepository.getFavGamesById(id: gameId, completion: { result in
            self.didGameIsFav?(Status<GameModel?>.type.result(result))
        })
    }
    
}
