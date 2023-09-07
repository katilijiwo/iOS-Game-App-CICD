//
//  GameProvider.swift
//  Rawg Io API
//
//  Created by koinworks on 05/09/23.
//

import CoreData
import UIKit


class GameDbProvider {
    
    private final let CONTAINER = "Game"
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.CONTAINER)
        container.loadPersistentStores { _, error in
            guard error == nil else {
                fatalError("Unresolved error \(error!)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = false
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.shouldDeleteInaccessibleFaults = true
        container.viewContext.undoManager = nil
        return container
    }()
    
    private func newTaskContext() -> NSManagedObjectContext {
        let taskContext = persistentContainer.newBackgroundContext()
        taskContext.undoManager = nil
        taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return taskContext
    }
    
    func getAllGame(completion: @escaping(_ games: [GameEntity]) -> Void) {
        let taskContext = newTaskContext()
        taskContext.perform {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: self.CONTAINER)
            do {
                let results = try taskContext.fetch(fetchRequest)
                var games: [GameEntity] = []
                for result in results {
                    games.append(GameEntity(
                        gameId: result.value(forKeyPath: "gameId") as? Int,
                        title: result.value(forKeyPath: "title") as? String,
                        imageUrl: result.value(forKeyPath: "imageUrl") as? String,
                        rating: result.value(forKeyPath: "rating") as? Double,
                        released: result.value(forKeyPath: "released") as? String
                    ))
                }
                completion(games)
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
    }
    
    func getGameById(gameId: Int, completion: @escaping(_ games: GameEntity?) -> Void) {
        let taskContext = newTaskContext()
        taskContext.perform {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: self.CONTAINER)
            do {
                let results = try taskContext.fetch(fetchRequest)
                var games: GameEntity? = nil
                for result in results {
                    let id = result.value(forKeyPath: "gameId") as? Int
                    if(id == gameId) {
                        games = GameEntity(
                            gameId: result.value(forKeyPath: "gameId") as? Int,
                            title: result.value(forKeyPath: "title") as? String,
                            imageUrl: result.value(forKeyPath: "imageUrl") as? String,
                            rating: result.value(forKeyPath: "rating") as? Double,
                            released: result.value(forKeyPath: "released") as? String
                        )
                    }
                }
                completion(games)
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
    }
    
    func insertGame(
        gameEntity: GameEntity,
        completion: @escaping() -> Void
    ) {
        let taskContext = newTaskContext()
        taskContext.performAndWait {
            if let entity = NSEntityDescription.entity(forEntityName: self.CONTAINER, in: taskContext) {
                do {
                    let game = NSManagedObject(entity: entity, insertInto: taskContext)
                    game.setValue(gameEntity.gameId, forKeyPath: "gameId")
                    game.setValue(gameEntity.title, forKeyPath: "title")
                    game.setValue(gameEntity.imageUrl, forKeyPath: "imageUrl")
                    game.setValue(gameEntity.rating, forKeyPath: "rating")
                    game.setValue(gameEntity.released, forKeyPath: "released")
                    try taskContext.save()
                    //TODO JIWO:
                    print("jiwo success")
                    completion()
                } catch let error as NSError {
                    //TODO JIWO:
                    print("jiwo Could not save. \(error), \(error.userInfo)")
                }
            }
        }
    }
    
    func updateGame(
        gameEntity: GameEntity,
        completion: @escaping() -> Void
    ) {
        let taskContext = newTaskContext()
        taskContext.perform {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: self.CONTAINER)
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(format: "gameId == \(String(describing: gameEntity.gameId))")
            if let result = try? taskContext.fetch(fetchRequest), let game = result.first as? Games {
                do {
                    game.setValue(gameEntity.title, forKeyPath: "title")
                    game.setValue(gameEntity.imageUrl, forKeyPath: "imageUrl")
                    game.setValue(gameEntity.rating, forKeyPath: "rating")
                    game.setValue(gameEntity.released, forKeyPath: "released")
                    try taskContext.save()
                    completion()
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
            }
        }
    }
    
    func deleteGame(gameId: Int, completion: @escaping() -> Void) {
        let taskContext = newTaskContext()
        taskContext.perform {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: self.CONTAINER)
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(format: "gameId == \(gameId)")
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            batchDeleteRequest.resultType = .resultTypeCount
            if let batchDeleteResult = try? taskContext.execute(batchDeleteRequest) as? NSBatchDeleteResult {
                if batchDeleteResult.result != nil {
                    completion()
                }
            }
        }
    }
    
}

extension GameDbProvider {
    
    private func getMaxId(completion: @escaping(_ maxId: Int) -> Void) {
        let taskContext = newTaskContext()
        taskContext.performAndWait {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: self.CONTAINER)
            let sortDescriptor = NSSortDescriptor(key: "id", ascending: false)
            fetchRequest.sortDescriptors = [sortDescriptor]
            fetchRequest.fetchLimit = 1
            do {
                let lastGames = try taskContext.fetch(fetchRequest)
                if let game = lastGames.first, let position = game.value(forKeyPath: "id") as? Int {
                    completion(position)
                } else {
                    completion(0)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
}
