//
//  Injection.swift
//  Rawg Io API
//
//  Created by MAC on 19/08/23.
//

import Foundation
import RealmSwift

final class Injection: NSObject {
    
    func provideRepository() -> GameRepositoryProtocol {
        let realm = try? Realm()
        let remote: RemoteDataSource = RemoteDataSource.sharedInstance
        let gameProvider: GameDbProvider = GameDbProvider.sharedInstance(realm)
        let favGameProvider: FavGameDbProvider = FavGameDbProvider.sharedInstance(realm)
        let local: LocalDataSource = LocalDataSource.sharedInstance(gameProvider, favGameProvider)
        return GameRepository.sharedInstance(remote, local)
    }
    
    func provideGameUseCase() -> GameUseCase {
        let repository = provideRepository()
        return GameUseCase.sharedInstance(repository)
    }
    
    func provideGameDetailUseCase() -> GameDetailUseCase {
        let repository = provideRepository()
        return GameDetailUseCase.sharedInstance(repository)
    }
    
}
