//
//  RemoteDataSource.swift
//  Rawg Io API
//
//  Created by MAC on 19/08/23.
//

import Foundation
import Alamofire
import Combine

protocol RemoteDataSourceProtocol: AnyObject {
    func getGameList() -> AnyPublisher<[GameItemResponse], Error>
    func getGameDetail(gameId: Int) -> AnyPublisher<GameDetailResponse, Error>
}

final class RemoteDataSource: NSObject {
    private override init() { }
    static let sharedInstance: RemoteDataSource =  RemoteDataSource()
}


extension RemoteDataSource: RemoteDataSourceProtocol {
    
    func getGameList() -> AnyPublisher<[GameItemResponse], Error> {
        return Future<[GameItemResponse], Error> { completion in
            if let url = URL(string: Endpoints.Gets.listGame.url) {
              AF.request(url)
                .validate()
                .responseDecodable(of: GameResponse.self) { response in
                  switch response.result {
                  case .success(let value):
                      completion(.success(value.results))
                  case .failure(let error):
                      completion(.failure(URLError.invalidResponse(error.localizedDescription)))
                  }
                }
            }
          }.eraseToAnyPublisher()
    }
    
    func getGameDetail(gameId: Int) -> AnyPublisher<GameDetailResponse, Error> {
        return Future<GameDetailResponse, Error> { completion in
            if let url = URL(string: Endpoints.Gets.detailGame(gameId: gameId).url) {
              AF.request(url)
                .validate()
                .responseDecodable(of: GameDetailResponse.self) { response in
                  switch response.result {
                  case .success(let value):
                      completion(.success(value))
                  case .failure(let error):
                      completion(.failure(URLError.invalidResponse(error.localizedDescription)))
                  }
                }
            }
          }.eraseToAnyPublisher()
    }
    
}
