//
//  GameProvider.swift
//  Rawg Io API
//
//  Created by koinworks on 05/09/23.
//

import CoreData
import UIKit
import RealmSwift
import Combine

protocol GameDbProviderProtocol: AnyObject {

    func getGame() -> AnyPublisher<[GameEntity], Error>
    func getFavGame() -> AnyPublisher<[GameEntity], Error>
    func getGameById(gameId: Int) -> AnyPublisher<[GameEntity], Error>
    func insertGame(gameEntity: GameEntity) -> AnyPublisher<Bool, Error>
    func updateGame(gameEntity: GameEntity) -> AnyPublisher<Bool, Error>
    func deleteGame(gameId: Int) -> AnyPublisher<Bool, Error>
}

final class GameDbProvider: NSObject {
    private let realm: Realm?
    
    private init(realm: Realm?) {
        self.realm = realm
    }
    
    static let sharedInstance: (Realm?) -> GameDbProvider = { realmDatabase in
        return GameDbProvider(realm: realmDatabase)
    }
}


extension GameDbProvider: GameDbProviderProtocol {
    
    func getGame() -> AnyPublisher<[GameEntity], Error> {
        return Future<[GameEntity], Error> { completion in
            if let realm = self.realm {
                let categories: Results<GameEntity> = {
                    realm.objects(GameEntity.self)
                        .sorted(byKeyPath: "title", ascending: true)
                }()
                completion(.success(categories.toArray(ofType: GameEntity.self)))
            } else {
                completion(.failure(DatabaseError.invalidInstance("Database can't instance.")))
            }
        }.eraseToAnyPublisher()
    }
    
    func getFavGame() -> AnyPublisher<[GameEntity], Error> {
        return Future<[GameEntity], Error> { completion in
            if let realm = self.realm {
                let categories: Results<GameEntity> = {
                    realm.objects(GameEntity.self)
                        .sorted(byKeyPath: "title", ascending: true)
                }()
                completion(.success(categories.toArray(ofType: GameEntity.self)))
            } else {
                completion(.failure(DatabaseError.invalidInstance("Database can't instance.")))
            }
        }.eraseToAnyPublisher()
    }
    
    func getGameById(gameId: Int) -> AnyPublisher<[GameEntity], Error> {
        return Future<[GameEntity], Error> { completion in
            if let realm = self.realm {
                let categories: Results<GameEntity> = {
                    realm.objects(GameEntity.self)
                        .sorted(byKeyPath: "title", ascending: true)
                        .where {
                            $0.gameId == gameId
                        }
                }()
                completion(.success(categories.toArray(ofType: GameEntity.self)))
            } else {
                completion(.failure(DatabaseError.invalidInstance()))
            }
        }.eraseToAnyPublisher()
    }
    
    func insertGame(gameEntity: GameEntity) -> AnyPublisher<Bool, Error> {
        return Future<Bool, Error> { completion in
            if let realm = self.realm {
                do {
                    try realm.write {
                        realm.add(gameEntity)
                        completion(.success(true))
                    }
                } catch let err {
                    completion(.failure(DatabaseError.requestFailed(err.localizedDescription)))
                }
            } else {
                completion(.failure(DatabaseError.invalidInstance()))
            }
        }.eraseToAnyPublisher()
    }
    
    func updateGame(gameEntity: GameEntity) -> AnyPublisher<Bool, Error> {
        return Future<Bool, Error> { completion in
            if let realm = self.realm {
                do {
                    let favGame = realm.objects(GameEntity.self).where {
                        $0.gameId == gameEntity.gameId
                    }
                    if let game = favGame.first {
                        try realm.write {
                            game.title = gameEntity.title
                            game.imageUrl = gameEntity.imageUrl
                            game.rating = gameEntity.rating
                            game.released = gameEntity.released
                        }
                        completion(.success(true))
                    } else {
                        completion(.failure(DatabaseError.requestFailed("data not found")))
                    }
                } catch let err {
                    completion(.failure(DatabaseError.requestFailed(err.localizedDescription)))
                }
            } else {
                completion(.failure(DatabaseError.invalidInstance()))
            }
        }.eraseToAnyPublisher()
    }
    
    func deleteGame(gameId: Int) -> AnyPublisher<Bool, Error> {
        return Future<Bool, Error> { completion in
            if let realm = self.realm {
                do {
                    let favGame = realm.objects(GameEntity.self).where {
                        $0.gameId == gameId
                    }
                    if let game = favGame.first {
                        try realm.delete(game)
                        completion(.success(true))
                    } else {
                        completion(.failure(DatabaseError.requestFailed("data not found")))
                    }
                } catch let err {
                    completion(.failure(DatabaseError.requestFailed(err.localizedDescription)))
                }
            } else {
                completion(.failure(DatabaseError.invalidInstance()))
            }
        }.eraseToAnyPublisher()
    }
    
}
