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

protocol FavGameDbProviderProtocol: AnyObject {

    func getFavGame() -> AnyPublisher<[FavGameEntity], Error>
    func getFavGameById(gameId: Int) -> AnyPublisher<FavGameEntity?, Error>
    func insertFavGame(favGameEntity: FavGameEntity) -> AnyPublisher<Bool, Error>
    func updateFavGame(favGameEntity: FavGameEntity) -> AnyPublisher<Bool, Error>
    func deleteFavGame(gameId: Int) -> AnyPublisher<Bool, Error>
}

final class FavGameDbProvider: NSObject {
    private let realm: Realm?
    
    private init(realm: Realm?) {
        self.realm = realm
    }
    
    static let sharedInstance: (Realm?) -> FavGameDbProvider = { realmDatabase in
        return FavGameDbProvider(realm: realmDatabase)
    }
}


extension FavGameDbProvider: FavGameDbProviderProtocol {
   
    func getFavGame() -> AnyPublisher<[FavGameEntity], Error> {
        return Future<[FavGameEntity], Error> { completion in
            if let realm = self.realm {
                let games: Results<FavGameEntity> = {
                    realm.objects(FavGameEntity.self)
                        .sorted(byKeyPath: "title", ascending: true)
                }()
                completion(.success(games.toArray(ofType: FavGameEntity.self)))
            } else {
                completion(.failure(DatabaseError.invalidInstance("Database can't instance.")))
            }
        }.eraseToAnyPublisher()
    }
    
    func getFavGameById(gameId: Int) -> AnyPublisher<FavGameEntity?, Error> {
        return Future<FavGameEntity?, Error> { completion in
            if let realm = self.realm {
                let games: Results<FavGameEntity> = {
                    realm.objects(FavGameEntity.self)
                        .sorted(byKeyPath: "title", ascending: true)
                        .where {
                            $0.gameId == gameId
                        }
                }()
                completion(.success(games.first ?? nil))
            } else {
                completion(.failure(DatabaseError.invalidInstance()))
            }
        }.eraseToAnyPublisher()
    }
    
    func insertFavGame(favGameEntity: FavGameEntity) -> AnyPublisher<Bool, Error> {
        return Future<Bool, Error> { completion in
            if let realm = self.realm {
                do {
                    try realm.write {
                        realm.add(favGameEntity)
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
    
    func updateFavGame(favGameEntity: FavGameEntity) -> AnyPublisher<Bool, Error> {
        return Future<Bool, Error> { completion in
            if let realm = self.realm {
                do {
                    let favGame = realm.objects(FavGameEntity.self).where {
                        $0.gameId == favGameEntity.gameId
                    }
                    if let game = favGame.first {
                        try realm.write {
                            game.title = favGameEntity.title
                            game.imageUrl = favGameEntity.imageUrl
                            game.rating = favGameEntity.rating
                            game.released = favGameEntity.released
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
    
    func deleteFavGame(gameId: Int) -> AnyPublisher<Bool, Error> {
        return Future<Bool, Error> { completion in
            if let realm = self.realm {
                do {
                    try realm.write {
                        let favGame = realm.objects(FavGameEntity.self).where {
                            $0.gameId == gameId
                        }
                        if let game = favGame.first {
                            realm.delete(game)
                            completion(.success(true))
                        } else {
                            completion(.failure(DatabaseError.requestFailed("data not found")))
                        }
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
