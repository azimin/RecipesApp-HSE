//
//  CookingDataParser.swift
//  RecipesApp
//
//  Created by Alex Zimin on 27/05/16.
//  Copyright © 2016 Alexander Zimin. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftCSV

class CookingDataParser {
  static func parseData() {
    enumerateCSVNamed("IngredientEntity") { (row) in
      let ingredient = IngredientEntity()
      ingredient.id = row["id"]!
      ingredient.name = row["name"]!
      
      writeFunction(block: { 
        realmDataBase.add(ingredient)
      })
    }
    
    enumerateCSVNamed("CookingActionEntity") { (row) in
      let cookingAction = CookingActionEntity()
      cookingAction.id = row["id"]!
      cookingAction.name = row["name"]!
      cookingAction.imageName = row["imageName"]!
      
      writeFunction(block: { 
        realmDataBase.add(cookingAction)
      })
    }
    
    
    
    enumerateCSVNamed("DishIngredientEntity") { (row) in
      let dishIngredient = DishIngredientEntity()
      
      dishIngredient.id = row["id"]!
      dishIngredient.measurementWayName = row["measurementWayName"]!
      dishIngredient.measurementWayPortion = CGFloat(Double(row["measurementWayPortion"]!)!)
      
      let ingredientId = row["ingredient"]!
      let ingredient = findObjectWithId(ingredientId, ofType: IngredientEntity.self)
      dishIngredient.ingredient = ingredient
      
      writeFunction(block: { 
        realmDataBase.add(dishIngredient)
      })
    }
    
    enumerateCSVNamed("CookingStepEntity") { (row) in
      let cookingStep = CookingStepEntity()
      
      cookingStep.id = row["id"]!
      cookingStep.name = row["name"]!
      cookingStep.stepDescription = row["stepDescription"]!
      cookingStep.time = Int(row["time"]!)!
      
      let ingredientsIds = stringToArray(row["ingredients"]!)
      let actionsIds = stringToArray(row["actions"]!)
      
      findObjectsWithIds(ingredientsIds, ofType: DishIngredientEntity.self, block: { (value) in
        cookingStep.ingredients.append(value)
      })
      
      findObjectsWithIds(actionsIds, ofType: CookingActionEntity.self, block: { (value) in
        cookingStep.actions.append(value)
      })
      
      writeFunction(block: { 
        realmDataBase.add(cookingStep)
      })
    }
    
    enumerateCSVNamed("DishTypeEntity") { (row) in
      let dishType = DishTypeEntity()
      dishType.id = row["id"]!
      dishType.name = row["name"]!
      dishType.dishTypeDescription = row["dishTypeDescription"]!
      
      writeFunction(block: { 
        realmDataBase.add(dishType)
      })
    }
    
    enumerateCSVNamed("DishEntity") { (row) in
      let dish = DishEntity()
      
      dish.id = row["id"]!
      dish.name = row["name"]!.lowercaseString
      dish.dishDescription = row["dishDescription"]!
      dish.imageName = row["imageName"]!
      
      let typeId = row["type"]!
      let ingredientsIds = stringToArray(row["ingredients"]!)
      let stepsIds = stringToArray(row["steps"]!)
      
      let type = findObjectWithId(typeId, ofType: DishTypeEntity.self)
      dish.type = type
      
      findObjectsWithIds(ingredientsIds, ofType: DishIngredientEntity.self, block: { (value) in
        dish.ingredients.append(value)
      })
      
      findObjectsWithIds(stepsIds, ofType: CookingStepEntity.self, block: { (value) in
        dish.steps.append(value)
      })
      
      dish.cookingTime = dish.steps.reduce(0) { (value, step) -> Int in
        return value + step.time
      }
      
      writeFunction(block: { 
        realmDataBase.add(dish)
      })
    }
    
    CookingDataIndexing.indexData()
  }
  
  private static func findObjectWithId<T: Object>(id: String, ofType type: T.Type) -> T {
    return realmDataBase.objects(type).filter("id = '\(id)'").first!
  }
  
  private static func findObjectsWithIds<T: Object>(ids: [String], ofType type: T.Type, block: (T) -> ()) {
    for id in ids {
      if id.characters.count > 0 {
        let object = findObjectWithId(id, ofType: type)
        block(object)
      }
    }
  }
  
  private static func stringToArray(string: String) -> [String] {
    var newString = string
    newString = newString.stringByReplacingOccurrencesOfString("[", withString: "")
    newString = newString.stringByReplacingOccurrencesOfString("]", withString: "")
    newString = newString.stringByReplacingOccurrencesOfString("\n", withString: "")
    newString = newString.stringByReplacingOccurrencesOfString(" ", withString: "")
    return newString.componentsSeparatedByString(",")
  }
  
  private static func enumerateCSVNamed(name: String, block: [String: String] -> ()) {
    let csvURL = NSBundle.mainBundle().URLForResource(name, withExtension: "csv")!
    let csv = try! CSV(url: csvURL, delimiter: ";")
    csv.enumerateAsDict(block)
  }
}