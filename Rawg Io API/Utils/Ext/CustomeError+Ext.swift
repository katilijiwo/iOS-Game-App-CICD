//
//  CustomeError+Ext.swift
//  Rawg Io API
//
//  Created by MAC on 19/08/23.
//

import Foundation

enum URLError: LocalizedError {

  case invalidResponse(String)
  case addressUnreachable(URL)
  
  var errorDescription: String? {
    switch self {
    case .invalidResponse(let msg): return msg
    case .addressUnreachable(let url): return "\(url.absoluteString) is unreachable."
    }
  }

}
