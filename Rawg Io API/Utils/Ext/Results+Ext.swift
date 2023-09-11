//
//  Results+Ext.swift
//  Rawg Io API
//
//  Created by koinworks on 11/09/23.
//

import RealmSwift

extension Results {

  func toArray<T>(ofType: T.Type) -> [T] {
    var array = [T]()
    for index in 0 ..< count {
      if let result = self[index] as? T {
        array.append(result)
      }
    }
    return array
  }

}
