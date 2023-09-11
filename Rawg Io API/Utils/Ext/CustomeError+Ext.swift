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

enum DatabaseError: LocalizedError {
    
    case invalidInstance(_ msg: String? = nil)
    case requestFailed(_ msg: String? = nil)
    
    var errorDescription: String? {
        switch self {
        case .invalidInstance(let msg): return msg ?? "Database can't instance."
        case .requestFailed(let msg): return msg ?? "Your request failed."
        }
    }
    
}
