//
//  DishEntity.swift
//  RecipesApp
//
//  Created by Alex Zimin on 18/05/16.
//  Copyright © 2016 Alexander Zimin. All rights reserved.
//

import Foundation
import RealmSwift

class DishEntity: Object {
  dynamic var name: String = ""
  dynamic var dishDescription: String = ""
  dynamic var id: String = ""
  dynamic var imageName: String = ""
  
  dynamic var type: DishTypeEntity! = nil
  
  let ingredients = List<DishIngredientEntity>()
  let steps = List<CookingStepEntity>()
  
  override static func indexedProperties() -> [String] {
    return ["name"]
  }
  
  override static func primaryKey() -> String? {
    return "id"
  }
  
  dynamic var cookingTime: Int = 0
  
  var image: UIImage {
    return UIImage(named: imageName)!
  }
}