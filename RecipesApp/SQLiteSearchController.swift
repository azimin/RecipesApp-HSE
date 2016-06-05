//
//  SQLiteSearchController.swift
//  RecipesApp
//
//  Created by Alex Zimin on 05/06/16.
//  Copyright © 2016 Alexander Zimin. All rights reserved.
//

import UIKit
import SQLite

class SQLiteSearchController {
  static func showDishes() -> [DishEntity] {
    let query = "SELECT dish.name FROM dish ORDER BY dish.name ASC"
    
    var result: [DishEntity] = []
    for row in try! SQLiteDataManager.dataBase.prepare(query) {
      result.append(DishEntity(value: row as! AnyObject))
    }
    
    return result
  }
  
  static func searchDish(searchString: String) -> [DishEntity] {
    let query = "SELECT dish.name FROM dish WHERE dish.name LIKE '%\(searchString)%'"
    
    var result: [DishEntity] = []
    for row in try! SQLiteDataManager.dataBase.prepare(query) {
      result.append(DishEntity(value: row as! AnyObject))
    }
    
    return result
  }
  
  
  static func searchDishByType(searchString: String) -> [DishEntity] {
    var query = "SELECT dish.name"
    query += "FROM dish JOIN type ON dish.type_id = type.type_id"
    query += "WHERE type.name LIKE '%\(searchString)%'"
    
    var result: [DishEntity] = []
    for row in try! SQLiteDataManager.dataBase.prepare(query) {
      result.append(DishEntity(value: row as! AnyObject))
    }
    
    return result
  }
  
  static func searchDishByIngredient(searchString: String) -> [DishEntity] {
    var query = "SELECT DISTINCT Dish.*"
    query += "FROM Ingredient"
    query += "INNER JOIN IngredientList ON IngredientList.ingredient_id = Ingredient.ingredient_id"
    query += "INNER JOIN Step ON IngredientList.step_id = Step.step_id"
    query += "INNER JOIN StepList ON StepList.step_id = Step.step_id"
    query += "INNER JOIN Dish ON StepList.dish_id = Dish.dish_id"
    query += "WHERE Ingredient.name LIKE '%\(searchString)%'"
    
    var result: [DishEntity] = []
    for row in try! SQLiteDataManager.dataBase.prepare(query) {
      result.append(DishEntity(value: row as! AnyObject))
    }
    
    return result
  }
  
  static func searchDishByTime(time: Int) -> [DishEntity] {
    var query = "SELECT Dish.*, sum_step_time"
    query += "FROM ("
    query += "SELECT * FROM ("
    query += "SELECT *, SUM(step_time) as sum_step_time"
    query += "FROM ("
    query += "SELECT Dish.* , Step.TIME as step_time"
    query += "FROM Step"
    query += "INNER JOIN StepList ON StepList.step_id = Step.step_id"
    query += "INNER JOIN Dish ON StepList.dish_id = Dish.dish_id"
    query += ") as dish_step_table"
    query += "GROUP BY dish_step_table.name"
    query += ")"
    query += "WHERE sum_step_time <= \(time)"
    query += ") as big_table JOIN Dish ON Dish.dish_id = big_table.dish_id"
    
    var result: [DishEntity] = []
    for row in try! SQLiteDataManager.dataBase.prepare(query) {
      result.append(DishEntity(value: row as! AnyObject))
    }
    
    return result
  }
  
  static func searchDishByAction(searchString: String) -> [DishEntity] {
    var query = "SELECT DISTINCT Dish.* FROM Action"
    query += "INNER JOIN ActionList ON ActionList.action_id = Action.action_id"
    query += "INNER JOIN Step ON Step.step_id = ActionList.step_id"
    query += "INNER JOIN StepList ON StepList.step_id = Step.step_id"
    query += "INNER JOIN Dish ON StepList.dish_id = Dish.dish_id"
    query += "WHERE Action.name LIKE '%\(searchString)%'"
    
    var result: [DishEntity] = []
    for row in try! SQLiteDataManager.dataBase.prepare(query) {
      result.append(DishEntity(value: row as! AnyObject))
    }
    
    return result
  }
  
  static func getAllIngredients(dishName: String) -> [DishIngredientEntity] {
    var query = "SELECT Ingredient.name, SUM(IngredientList.quantity), IngredientList.measurement_way"
    query += "FROM (SELECT StepList.step_id"
    query += "FROM StepList JOIN Dish ON (Dish.dish_id = StepList.dish_id)"
    query += "WHERE Dish.name LIKE '%\(dishName)%') AS Steps"
    query += "JOIN IngredientList ON (IngredientList.step_id = Steps.step_id)"
    query += "JOIN Ingredient ON (IngredientList.ingredient_id = Ingredient.ingredient_id)"
    query += "GROUP BY Ingredient.ingredient_id HAVING COUNT(IngredientList.measurement_way) = 1"
    query += "ORDER BY Ingredient.name"
    
    var result: [DishIngredientEntity] = []
    for row in try! SQLiteDataManager.dataBase.prepare(query) {
      result.append(DishIngredientEntity(value: row as! AnyObject))
    }
    
    return result
  }
  
  
  static func getIngredientSteps(dishName: String) -> [CookingStepEntity] {
    var query = "SELECT StepList.step_order, Step.name, Step.time, Step.description "
    query += "FROM StepList"
    query += "JOIN Dish ON (Dish.dish_id = StepList.dish_id)"
    query += "JOIN Step ON (Step.step_id = StepList.step_id)"
    query += "WHERE Dish.name LIKE '%\(dishName)%'"
    query += "ORDER BY StepList.step_order"
    
    var result: [CookingStepEntity] = []
    for row in try! SQLiteDataManager.dataBase.prepare(query) {
      result.append(CookingStepEntity(value: row as! AnyObject))
    }
    
    return result
  }
  
  static func getIngredientsForStep(stepId: Int) -> [DishIngredientEntity] {
    var query = "SELECT Ingredient.name, IngredientList.quantity, IngredientList.measurement_way"
    query += "FROM IngredientList"
    query += "INNER JOIN Ingredient ON (IngredientList.ingredient_id = Ingredient.ingredient_id)"
    query += "WHERE IngredientList.step_id = \(stepId)"
    
    var result: [DishIngredientEntity] = []
    for row in try! SQLiteDataManager.dataBase.prepare(query) {
      result.append(DishIngredientEntity(value: row as! AnyObject))
    }
    
    return result
  }
  
  static func getAllActionsForStep(stepId: Int) -> [CookingActionEntity] {
    var query = "SELECT Action.name, Action.imge_uri"
    query += "FROM ActionList"
    query += "INNER JOIN Action ON (ActionList.action_id = Action.action_id)"
    query += "WHERE ActionList.step_id = \(stepId)"
    
    var result: [CookingActionEntity] = []
    for row in try! SQLiteDataManager.dataBase.prepare(query) {
      result.append(CookingActionEntity(value: row as! AnyObject))
    }
    
    return result
  }
  
  static func getDishType(dishId: Int) -> DishTypeEntity {
    var query = "SELECT Dish.name, TYPE.name"
    query += "FROM Dish JOIN TYPE ON (Dish.type_id = TYPE.type_id)"
    query += "WHERE Dish.dish_id = \(dishId)"
    
    let row = try! SQLiteDataManager.dataBase.prepare(query).dropFirst()
    return DishTypeEntity(value: row as! AnyObject)
  }
  
  static func getDishCookingTime(dishId: Int) -> Int {
    var query = "SELECT Dish.name, TYPE.name"
    query += "FROM Dish JOIN TYPE ON (Dish.type_id = TYPE.type_id)"
    query += "WHERE Dish.dish_id = \(dishId)"
    
    let value = SQLiteDataManager.dataBase.scalar(query) as! Int
    return value
  }
  
  static func getStepCookingTime(dishId: Int, stepId: Int) -> Int {
    var query = "SELECT Step.name, Step.TIME"
    query += "FROM Step JOIN StepList ON (StepList.step_id = Step.step_id)"
    query += "WHERE Step.step_id = \(stepId) AND StepList.dish_id = \(dishId)"
    
    let value = SQLiteDataManager.dataBase.scalar(query) as! Int
    return value
  }
}
