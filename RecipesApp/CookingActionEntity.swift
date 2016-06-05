//
//  CookingActionEntity.swift
//  RecipesApp
//
//  Created by Alex Zimin on 18/05/16.
//  Copyright © 2016 Alexander Zimin. All rights reserved.
//

import Foundation
import RealmSwift

class CookingActionEntity: Object {
  dynamic var name: String = ""
  dynamic var id: String = ""
  dynamic var imageName: String = ""
  
  override static func indexedProperties() -> [String] {
    return ["name"]
  }
  
  override static func primaryKey() -> String? {
    return "id"
  }
}