//
//  CookingStepEntity.swift
//  RecipesApp
//
//  Created by Alex Zimin on 18/05/16.
//  Copyright © 2016 Alexander Zimin. All rights reserved.
//

import Foundation
import RealmSwift

class CookingStepEntity: Object {
  dynamic var name: String = ""
  dynamic var stepDescription: String = ""
  dynamic var id: String = ""
  
  dynamic var time: Int = 0
  
  let actions = List<CookingActionEntity>()
  let ingredients = List<DishIngredientEntity>()
  
  override static func indexedProperties() -> [String] {
    return ["name"]
  }
  
  override static func primaryKey() -> String? {
    return "id"
  }
}