//
//  RemoteDataSource.swift
//  Rawg Io API
//
//  Created by MAC on 19/08/23.
//

import Foundation

protocol RemoteDataSourceProtocol: AnyObject {
    func getGameList(result: @escaping (Result<[GameItemResponse], URLError>) -> Void)
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
                //TODO: jiwo
                print("jiwo: " + String(describing: error))
                
                result(.failure(.invalidResponse(error.localizedDescription)))
            }
        }
        
        task.resume()
    }
    
}
