//
//  RealmExtension.swift
//  Hitch
//
//  Created by Alex Zimin on 14/11/15.
//  Copyright © 2015 Triagne glow. All rights reserved.
//

import Foundation
import RealmSwift

public func writeFunction(realm: Realm = realmDataBase, block: (() -> Void)) {
  if realm.inWriteTransaction {
    block()
  } else {
    do {
      try realm.write(block)
    } catch { }
  }
}

extension Realm {
  public func writeFunction(block: (() -> Void)) {
    if realmDataBase.inWriteTransaction {
      block()
    } else {
      do {
        try write(block)
      } catch { }
    }
  }
}

extension List where T: RealmInt {
  func toIntArray() -> [Int] {
    return self.map({ (value) -> Int in
      value.toInt()
    })
  }
}