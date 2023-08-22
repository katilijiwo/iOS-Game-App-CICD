//
//  RemoteDataSource.swift
//  Rawg Io API
//
//  Created by MAC on 19/08/23.
//

import Foundation

protocol RemoteDataSourceProtocol: AnyObject {
    func getGameList(result: @escaping (Result<[GameItemResponse], URLError>) -> Void)
    func getGameDetail(gameId: Int, result: @escaping (Result<GameDetailResponse, URLError>) -> Void)
}

final class RemoteDataSource: NSObject {
    private override init() { }
    static let sharedInstance: RemoteDataSource =  RemoteDataSource()
}


extension RemoteDataSource: RemoteDataSourceProtocol {
    
    func getGameList(result: @escaping (Result<[GameItemResponse], URLError>) -> Void) {
        guard let url = URL(string: Endpoints.Gets.listGame.url) else { return }
        let task = URLSession.shared.dataTask(with: url) {data, response, err in
            if err != nil || data == nil {
                result(.failure(.addressUnreachable(url)))
                return
            }
            do {
                let decoder = JSONDecoder()
                let listGame = try decoder.decode(GameResponse.self, from: data!).results
                result(.success(listGame))
            } catch {
                result(.failure(.invalidResponse(error.localizedDescription)))
            }
        }
        task.resume()
    }
    
    func getGameDetail(gameId: Int, result: @escaping (Result<GameDetailResponse, URLError>) -> Void) {
        guard let url = URL(string: Endpoints.Gets.detailGame(gameId: gameId).url) else { return }
        let task = URLSession.shared.dataTask(with: url) {data, response, err in
            if err != nil || data == nil {
                result(.failure(.addressUnreachable(url)))
                return
            }
            do {
                let decoder = JSONDecoder()
                let game = try decoder.decode(GameDetailResponse.self, from: data!)
                result(.success(game))
            } catch {
                result(.failure(.invalidResponse(error.localizedDescription)))
            }
        }
        task.resume()
    }
    
}
