//
//  ViewModelUtil.swift
//  Rawg Io API
//
//  Created by MAC on 19/08/23.
//

import Foundation

class Status<T> { // Declare T
    enum type {
        case loading
        case result(T)
        case error(String)
    }
}
