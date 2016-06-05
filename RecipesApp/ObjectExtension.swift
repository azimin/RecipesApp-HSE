//
//  ObjectExtension.swift
//  Juicy Bubble
//
//  Created by Alex Zimin on 26/10/15.
//  Copyright © 2015 Alex Zimin. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

protocol ObjectSingletone: class {
  init()
}

extension ObjectSingletone where Self: Object {
  static var value: Self {
    let object = realmDataBase.objects(Self).first
    if let value = object {
      return value
    } else {
      let value = Self()
      
      realmDataBase.writeFunction({ () -> Void in
        realmDataBase.add(value)
      })
      
      return value
    }
  }
}

extension Object {
  func firstSave() -> Self {
    realmDataBase.writeFunction { () -> Void in
      realmDataBase.add(self)
    }
    return self
  }
}

class RLMArraySwift<T: RLMObject> : RLMArray {
  class func itemType() -> String {
    return "\(T.self)"
  }
}

extension Results {
  func toArray() -> [T] {
    return self.map{$0}
  }
}

extension RealmSwift.List {
  func toArray() -> [T] {
    return self.map{$0}
  }
}

class RealmInt: Object, IntegerLiteralConvertible {
  dynamic var value: Int = 0
  
  func toInt() -> Int {
    return value
  }
  
  convenience required init(integerLiteral value: Int) {
    self.init()
    self.value = value
  }
}

extension Int {
  func toRealmInt() -> RealmInt {
    let realmInt = RealmInt(integerLiteral: self)
    return realmInt.firstSave()
  }
}