//
//  SearchController.swift
//  RecipesApp
//
//  Created by Alex Zimin on 29/05/16.
//  Copyright © 2016 Alexander Zimin. All rights reserved.
//

import Foundation
import RealmSwift
import PySwiftyRegex

enum SearchElementType {
  case RecipeAndCuisine
  case Ingredients
  case Time
  case Actions
  
  var title: String {
    switch self {
    case .Ingredients:
      return "Ингредиенты"
    case .RecipeAndCuisine:
      return "Рецепты и кухни"
    case .Time:
      return "Время приготовления"
    case .Actions:
      return "Действия"
    }
  }
}

struct SearchElement {
  
  var seachString: String = ""
  var internalRequest: String = ""
  var predicate: (filter: String, sorted: String?)
  var result: Results<DishEntity>
  var type: SearchElementType
  var isLike: Bool = true
  
  var dishes: Results<DishEntity> {
    return result
  }
  
  var ingredientsResults: List<IngredientEntity> {
    if type != .Ingredients {
      fatalError("Wrong method")
    }
    
    let list = List<IngredientEntity>()
    for dish in result {
      for ingredint in dish.ingredients {
        if ingredint.ingredient.name.lowercaseString.containsString(internalRequest.lowercaseString) {
          if !list.contains(ingredint.ingredient) {
            list.append(ingredint.ingredient)
          }
        }
      }
    }
    
    return list
  }
  
  var actionsResults: List<CookingActionEntity> {
    if type != .Actions {
      fatalError("Wrong method")
    }
    
    let list = List<CookingActionEntity>()
    for dish in result {
      for step in dish.steps {
        for action in step.actions {
          if action.name.lowercaseString.containsString(internalRequest.lowercaseString) {
            if !list.contains(action) {
              list.append(action)
            }
          }
        }
      }
    }
    
    return list
  }
  
  var resultCount: Int {
    switch type {
    case .Ingredients:
      return ingredientsResults.count
    case .Actions:
      return actionsResults.count
    default:
      return dishes.count
    }
  }
}

struct SearchStringElement {
  var seachString = ""
  var seachPredicates = [(filter: String, sorted: String?, isLike: Bool)]()
}

class SearchController {
  var seachResult = realmDataBase.objects(DishEntity).sorted("name")
  var seachStringElements = [SearchStringElement]()
  
  func addSearchElement(element: SearchStringElement) {
    seachStringElements.append(element)
    recalculateSeachController()
  }
  
  func removeLastSearchElement() {
    seachStringElements.removeLast()
    recalculateSeachController()
  }
  
  func recalculateSeachController() {
    var result = realmDataBase.objects(DishEntity)
    for seachStringElement in seachStringElements {
      let predicates = seachStringElement.seachPredicates
      var sorted: String?
      
      var requestString = ""
      for predicate in predicates {
        if let value = predicate.sorted {
          sorted = value
        }
        if predicate.isLike {
          requestString += "\(predicate.filter) OR"
        } else {
          requestString += "NOT (\(predicate.filter)) OR"
        }
        
      }
      let range = Range(requestString.endIndex.advancedBy(-3)..<requestString.endIndex)
      requestString.removeRange(range)
      
      result = result.filter(requestString)
      if let sort = sorted {
        result = result.sorted(sort)
      }
    }
    seachResult = result
  }
  
  private enum StringType {
    case Like
    case Diskile
    case Number
    case Basic
  }
  
  func searchWithString(searchString: String) -> [SearchElement] {
    var type = StringType.Basic
    var newString = searchString.lowercaseString
    
    let like = ["люблю", "хочу", "предпочитаю"]
    if newString.hasPrefix("не") || newString.hasPrefix("без") {
      type = .Diskile
    } else if like.map({ return newString.hasPrefix($0) }).contains(true) {
      type = .Like
    } else {
      let firstElement = newString.componentsSeparatedByString(" ").first ?? ""
      if Int(firstElement) != nil {
        type = .Number
      }
    }
    
    
    if type == .Basic {
      let ingredientsPredicteString = "ANY ingredients.ingredient.name CONTAINS[c] '\(newString)'"
      let ingredients = seachResult.filter(ingredientsPredicteString)
      let ingredientsSearch = SearchElement(seachString: searchString, internalRequest: newString, predicate: (ingredientsPredicteString, nil), result: ingredients, type: .Ingredients, isLike: true)
      
      let dishesPredicteString = "name CONTAINS[c] '\(newString)' OR type.name CONTAINS[c] '\(newString)'"
      let dishes = seachResult.filter(dishesPredicteString)
      let dishesSearch = SearchElement(seachString: searchString, internalRequest: newString, predicate: (dishesPredicteString, nil), result: dishes, type: .RecipeAndCuisine, isLike: true)
      
      if ingredients.count > 0 || dishes.count > 0 {
        return [dishesSearch, ingredientsSearch]
      } else {
        type = .Like
      }
    }
    
    if type == .Like || type == .Diskile {
      for word in like + ["не", "без"] {
        newString = newString.stringByReplacingOccurrencesOfString(word, withString: "")
      }
      while newString.hasPrefix(" ") {
        newString.removeAtIndex(newString.startIndex)
      }
      
      let ingredientsPredicteString = "ANY ingredients.ingredient.name CONTAINS[c] '\(newString)'"
      let ingredients = seachResult.filter(ingredientsPredicteString)
      let ingredientsSearch = SearchElement(seachString: searchString, internalRequest: newString, predicate: (ingredientsPredicteString, nil), result: ingredients, type: .Ingredients, isLike: type == .Like)
      
      let stepsPredicteString = "ANY steps.actions.name CONTAINS[c] '\(newString)'"
      let steps = seachResult.filter(stepsPredicteString)
      let stepsSearch = SearchElement(seachString: searchString, internalRequest: newString, predicate: (stepsPredicteString, nil), result: steps, type: .Actions, isLike: type == .Like)
      
      var result = [SearchElement]()
      
      if ingredients.count > 0 {
        result.append(ingredientsSearch)
      }
      
      if steps.count > 0 {
        result.append(stepsSearch)
      }
      
      return result
    }
    
    if type == .Number {
      let firstElement = newString.componentsSeparatedByString(" ").first ?? ""
      let value = Int(firstElement)!
      
      let dishes = seachResult.filter("cookingTime <= \(value)").sorted("cookingTime")
      let dishesSearch = SearchElement(seachString: searchString, internalRequest: newString, predicate: ("cookingTime <= \(value)", "cookingTime"), result: dishes, type: .Time, isLike: true)
      
      return [dishesSearch]
    }
    
    return []
  }
}