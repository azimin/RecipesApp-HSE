//
//  NSObjectExtension.swift
//  RecipesApp
//
//  Created by Alex Zimin on 28/05/16.
//  Copyright © 2016 Alexander Zimin. All rights reserved.
//

import Foundation

extension NSObject {
  var className: String {
    return String(self)
  }
}

extension String {
  func firstCharacterUpperCase() -> String {
    let lowercaseString = self.lowercaseString
    
    return lowercaseString.stringByReplacingCharactersInRange(lowercaseString.startIndex...lowercaseString.startIndex, withString: String(lowercaseString[lowercaseString.startIndex]).uppercaseString)
  }
}