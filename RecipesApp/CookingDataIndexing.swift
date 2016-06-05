//
//  CookingDataIndexing.swift
//  RecipesApp
//
//  Created by Alex Zimin on 27/05/16.
//  Copyright © 2016 Alexander Zimin. All rights reserved.
//

import Foundation
import CoreSpotlight
import RealmSwift
import MobileCoreServices

class CookingDataIndexing {
  static func indexData() {
    var searchableItems: [CSSearchableItem] = []
    let dishes = realmDataBase.objects(DishEntity)
    
    for dish in dishes {
      let attributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeItem as String)
      
      attributeSet.title = dish.name
      attributeSet.thumbnailData = UIImagePNGRepresentation(dish.image)
      
      let dateFormatter = NSDateFormatter()
      dateFormatter.timeStyle = .ShortStyle
      
      attributeSet.contentDescription = dish.dishDescription
      
      var keywords = dish.name.componentsSeparatedByString(" ")
      _ = dish.ingredients.map({ (ingredient) -> () in
        keywords.append(ingredient.ingredient.name)
      })
      
      attributeSet.keywords = keywords
      
      let item = CSSearchableItem(uniqueIdentifier: dish.id, domainIdentifier: "dishes", attributeSet: attributeSet)
      searchableItems.append(item)
    }
    
    CSSearchableIndex.defaultSearchableIndex().indexSearchableItems(searchableItems) { (error) -> Void in
      if error != nil {
        print(error?.localizedDescription)
      }
    }
  }
}