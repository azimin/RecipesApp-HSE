//
//  DishIngredientEntity.swift
//  RecipesApp
//
//  Created by Alex Zimin on 18/05/16.
//  Copyright © 2016 Alexander Zimin. All rights reserved.
//

import Foundation
import RealmSwift

class DishIngredientEntity: Object {
  dynamic var ingredient: IngredientEntity!
  
  dynamic var measurementWayName: String = ""
  dynamic var measurementWayPortion: CGFloat = 0
  
  var measurementWayPortionString: String {
    if measurementWayPortion == CGFloat(Int(measurementWayPortion)) {
      return "\(Int(measurementWayPortion))"
    }
    return "\(measurementWayPortion)"
  }
  
  dynamic var id: String = ""
  
  override static func primaryKey() -> String? {
    return "id"
  }
  
  override static func indexedProperties() -> [String] {
    return ["measurementWayName"]
  }
}