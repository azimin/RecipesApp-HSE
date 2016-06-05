//
//  IngredientEntity.swift
//  RecipesApp
//
//  Created by Alex Zimin on 18/05/16.
//  Copyright © 2016 Alexander Zimin. All rights reserved.
//

import Foundation
import RealmSwift

class IngredientEntity: Object {
  dynamic var name: String = ""
  dynamic var id: String = ""
  
  override static func indexedProperties() -> [String] {
    return ["name"]
  }
  
  override static func primaryKey() -> String? {
    return "id"
  }
}