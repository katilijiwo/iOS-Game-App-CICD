//
//  NetworkUtil.swift
//  Rawg Io API
//
//  Created by MAC on 19/08/23.
//

import Foundation

struct Api {

  static let baseUrl = "https://api.rawg.io/api/"
  static let apiKey = "c15736ea9035449cb5ca48708dfa0efd"
}

protocol Endpoint {

  var url: String { get }

}

enum Endpoints {
  
  enum Gets: Endpoint {
    case listGame
    case detailGame(gameId: Int)

    public var url: String {
      switch self {
      case .listGame: return "\(Api.baseUrl)games?key=\(Api.apiKey)"
      case .detailGame(let gameId): return "\(Api.baseUrl)games/\(gameId)?key=\(Api.apiKey)"
      }
    }
      
  }
  
}
