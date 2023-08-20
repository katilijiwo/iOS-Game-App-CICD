//
//  Injection.swift
//  Rawg Io API
//
//  Created by MAC on 19/08/23.
//

import Foundation

final class Injection: NSObject {
    
    func provideRepository() -> GameRepositoryProtocol {
        
        let remote: RemoteDataSource = RemoteDataSource.sharedInstance
        
        return GameRepository.sharedInstance(remote)
    }
    
}
